module traffic_light (traffic_if.dut tif);
  typedef enum logic [1:0] {RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10} state_t;
  state_t ns_state;
  logic [3:0] counter;

  always_ff @(posedge tif.clk or posedge tif.reset) begin
    if (tif.reset) begin
      ns_state <= RED;
      counter <= 0;
    end else begin
      counter <= counter + 1;
      case (ns_state)
        RED: begin
          if (counter == 4'd8) begin
            ns_state <= GREEN;
            counter <= 0;
          end
        end
        GREEN: begin
          if (counter == 4'd6) begin
            ns_state <= YELLOW;
            counter <= 0;
          end
        end
        YELLOW: begin
          if (counter == 4'd2) begin
            ns_state <= RED;
            counter <= 0;
          end
        end
      endcase
    end
  end

  assign tif.light_ns = ns_state;
endmodule
