interface traffic_if (input logic clk);
  logic reset;           // Tín hiệu reset
  logic [1:0] light_ns;  // Đèn Bắc-Nam (00: Red, 01: Green, 10: Yellow)
  modport dut (input clk, reset, output light_ns);     // Modport cho DUT
endinterface
