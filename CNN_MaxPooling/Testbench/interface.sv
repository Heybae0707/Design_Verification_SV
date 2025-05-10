interface intf();
  logic                  clk;
  logic                  rst_n;
  logic                  valid_in;
  logic signed [24-1:0]  in_data  [1][8][8];
  logic                  valid_out;
  logic signed [24-1:0]  out_data [1][4][4];
endinterface