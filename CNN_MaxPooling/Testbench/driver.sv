class driver;
  transaction trans;
  mailbox gen2dri;
  virtual intf vif;
  
  function new (mailbox gen2dri,virtual intf vif);
    this.gen2dri=gen2dri;
    this.vif=vif;
  endfunction
  
  task run();
    forever begin
      gen2dri.get(trans);
     // $display("Driver received from generator");
     // $display("Driver starts sending to interface");
      vif.rst_n<=trans.rst_n;
      vif.valid_in<=trans.valid_in;
      vif.in_data <= trans.in_data;
      vif.valid_in <=trans.valid_in;
      @(posedge vif.clk);
    end
  endtask
endclass