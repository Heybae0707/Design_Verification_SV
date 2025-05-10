class monitor;
  transaction trans;
  mailbox mo2scb;
  virtual intf vif;
  
  function new (virtual intf vif, mailbox mo2scb);
    this.vif=vif;
    this.mo2scb=mo2scb;
  endfunction
  
  task receive();
    forever begin
      @(posedge vif.clk);
      trans = new();
      trans.rst_n=vif.rst_n;
      trans.valid_in=vif.valid_in;
      trans.in_data=vif.in_data ;
      trans.valid_in=vif.valid_in;
      trans.valid_out=vif.valid_out;
      trans.out_data=vif.out_data;
      mo2scb.put(trans);
   //   display();
   //   $display("Monitor received from interface");
    end
  endtask
  task display();
    $display("reset = %0d, valid_in = %0d", trans.rst_n, trans.valid_in);
  endtask
  
  task run();
    receive();
  endtask
endclass