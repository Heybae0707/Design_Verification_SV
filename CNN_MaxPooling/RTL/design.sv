// Code your design here
// max_pool2d.sv
// ----------------------------------------------------------------------------
// MaxPool2D: sequential comparison over KERNEL×KERNEL window.
// ----------------------------------------------------------------------------
module max_pool2d #(
  parameter int CH      = 1,
  parameter int IN_H    = 8,
  parameter int IN_W    = 8,
  parameter int KERNEL  =  2,
  parameter int STRIDE  =  2,
  parameter int PADDING =  0,
  parameter int INT_W   =  8,
  parameter int FRAC_W  = 16,

  localparam int DW    = INT_W + FRAC_W,
  localparam int OUT_H = (IN_H + 2*PADDING - KERNEL)/STRIDE + 1,
  localparam int OUT_W = (IN_W + 2*PADDING - KERNEL)/STRIDE + 1
) (
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  valid_in,
  input  logic signed [DW-1:0]  in_data  [CH][IN_H][IN_W],
  output logic                  valid_out,
  output logic signed [DW-1:0]  out_data [CH][OUT_H][OUT_W]
);

  // FSM state
  typedef enum logic [1:0] {M_IDLE, M_CALC, M_DONE} st_t;
  st_t state;

  // Indices & max value
  int c, oh, ow;
  logic signed [DW-1:0] maxv;

  // Local coords
  int r, c0;

  // valid pipeline
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)      valid_out <= 1'b0;
    else             valid_out <= (state == M_DONE);
  end

  // Main FSM: reset → compute → output → repeat
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= M_IDLE;
      c     <= 0; oh <= 0; ow <= 0;
      // zero outputs
      for (int ch = 0; ch < CH; ch++)
        for (int y = 0; y < OUT_H; y++)
          for (int x = 0; x < OUT_W; x++)
            out_data[ch][y][x] <= '0;
    end else begin
      case (state)
        M_IDLE: if (valid_in) state <= M_CALC;

        M_CALC: begin
          // start with lowest possible value
          maxv = -(1 << (DW-1));

          // scan window
          for (int ih = 0; ih < KERNEL; ih++) begin
            for (int iw = 0; iw < KERNEL; iw++) begin
              r  = oh*STRIDE + ih - PADDING;
              c0 = ow*STRIDE + iw - PADDING;
              if (r>=0 && r<IN_H && c0>=0 && c0<IN_W) begin
                maxv = (in_data[c][r][c0] > maxv)
                       ? in_data[c][r][c0] : maxv;
              end
            end
          end

          // write result
          out_data[c][oh][ow] <= maxv;

          // advance indices
          if (ow < OUT_W-1) begin
            ow <= ow + 1;
          end else begin
            ow <= 0;
            if (oh < OUT_H-1) begin
              oh <= oh + 1;
            end else begin
              oh <= 0;
              if (c < CH-1) begin
                c <= c + 1;
              end else begin
                state <= M_DONE;
              end
            end
          end
        end

        M_DONE: if (valid_in) state <= M_CALC;
      endcase
    end
  end

endmodule
