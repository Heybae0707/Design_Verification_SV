class generator;
  transaction trans;
  mailbox gen2dri;
  event e;
  int i=1;
  function new (mailbox gen2dri, event e);
    this.gen2dri=gen2dri;
    this.e=e;
  endfunction
  
  task run();
    repeat(2) begin
      trans = new();
      assert(trans.randomize()) else $fatal("error");
      $display("============Lan %0d==========",i);
      i++;
      trans.display();
      gen2dri.put(trans);
      @(e);
    end
    $finish;
  endtask
endclass