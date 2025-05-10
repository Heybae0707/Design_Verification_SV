`include "test.sv"
`include "interface.sv"

module tb;
  intf vif();
  test tst (vif);
  max_pool2d mp2(.clk(vif.clk), .rst_n(vif.rst_n), .valid_in(vif.valid_in),
             .in_data(vif.in_data), .valid_out(vif.valid_out), .out_data(vif.out_data));
  initial begin
    vif.clk = 0;
    forever #3 vif.clk=~vif.clk;
  end
  initial begin
    vif.rst_n =0;
    #5 vif.rst_n=1;
  end
    covergroup cg;
        option.per_instance = 1;	
      coverpoint vif.valid_in {bins valid ={1};
                              option.at_least=18;} //valid_in
      ST_T: coverpoint mp2.state {
        //bins 	     fsmps[] = {[0:2]};
        illegal_bins ilb     = {3};
        bins trans_0_to_1 = (0 => 1); 
        bins trans_1_to_2 = (1 => 2); 
        bins trans_2_to_1 = (2 => 1); 
      }
      FRE_MDONE: coverpoint mp2.state{
        bins calc_count = {1}; option.at_least = 16;
      }
      FRE_3STATE: coverpoint mp2.state{
        bins state_count = {[0:2]}; //count_state_1 +2+3
        option.at_least=18;
      }
    endgroup: cg
  
  cg cg_h;
  initial begin
    cg_h = new();
    forever begin
    //while(cg_h.get_coverage() < 100) begin
    	@(posedge vif.clk)
    	cg_h.sample();
    end
  end
  initial begin
   $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule