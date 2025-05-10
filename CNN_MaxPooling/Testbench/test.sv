
`include "environment.sv"

program test(intf ifft);
  environment env;
  
  initial begin
    env = new(ifft);
    env.test_run();
  end
endprogram