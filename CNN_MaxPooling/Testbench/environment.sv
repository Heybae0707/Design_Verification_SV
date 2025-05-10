`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  generator gen;
  driver dri;
  monitor mo;
  scoreboard scb;
  event e;
  mailbox gen2dri, mo2scb;
  virtual intf vif;
  function new(virtual intf vif);
    this.vif=vif;
    
    gen2dri=new();
    mo2scb=new();
    gen = new(gen2dri,e);
    dri = new(gen2dri,vif);
    mo = new(vif, mo2scb);
    scb = new(mo2scb,e);
  endfunction
  
  task test_run();
    fork 
      gen.run();
      dri.run();
      mo.run();
      scb.run();
    join
    $display("=============DONE==============");
  endtask
endclass