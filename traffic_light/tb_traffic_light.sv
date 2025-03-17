module tb_traffic_light;
  logic clk;

  // Khởi tạo clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Khai báo interface
  traffic_if tif (.clk(clk));

  // Kết nối DUT
  traffic_light dut (
    tif.dut
  );

  // Class để tạo dữ liệu ngẫu nhiên
  class TrafficStimulus;
    rand bit reset;
    constraint reset_prob { reset dist {0:/90, 1:/10}; } // Reset có xác suất 20%
  endclass

  // Testbench logic
  initial begin
	  TrafficStimulus stim;
	  stim = new();
	  $display("Starting Traffic Light Testbench");

	  tif.reset = 1;
	  repeat (2) @(posedge clk);
	  tif.reset = 0;

	  repeat (50) begin
		if (!stim.randomize()) begin
		  $display("Randomization failed");
		  $finish;
		end
		tif.reset = stim.reset;

		@(posedge clk);
		$display("Time=%0t | Reset=%b | NS Light=%b", 
				 $time, tif.reset, tif.light_ns);
	  end

	  #10;
	  $display("Testbench completed");
	  $finish;
  end

endmodule
