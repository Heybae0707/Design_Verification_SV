class scoreboard;
  transaction trans;
  mailbox mo2scb;
  event e;
  logic signed [24-1:0]  out_expect [1][4][4];
  function new(mailbox mo2scb,event e);
    this.mo2scb=mo2scb;
    this.e=e;
  endfunction
  
  task run();
    forever begin
      mo2scb.get(trans);
      display();
    end
  endtask
  
  task display();
    if(trans.valid_out==1) begin
      expect_data();
      $display("Data from DUT");
      for(int i=0;i<4;i++) begin
        $display("");
        for(int j=0;j<4;j++) begin
          $write("%0d ",trans.out_data[0][i][j]);
        end
      end
      $display ("\n-----START CHECK BETWEEN GEN AND SCB------");
      for(int i=0;i<4;i++) begin
        for(int j=0;j<4;j++) begin
          if(trans.out_data[0][i][j] != out_expect[0][i][j])
             $error("Not match! Finish");
        end
      end
      $display("-----SUCCESS! NEXT----\n\n");       
      ->e;
    end
  endtask
   function void expect_data();
    int IN_H=8, IN_W=8;
    logic signed [24-1:0] maxv;
    int KERNEL  =  2;
    int STRIDE  =  2;
    int PADDING=0;
    int r,c0;
    for (int oh = 0; oh < 4; oh++) begin
      for (int ow = 0; ow < 4; ow++) begin
       		maxv = -(1 << (24-1)); 
               // Scan window
           for (int ih = 0; ih < KERNEL; ih++) begin
                for (int iw = 0; iw < KERNEL; iw++) begin
                    r  = oh*STRIDE + ih - PADDING;
                    c0 = ow*STRIDE + iw - PADDING;
                   if (r >= 0 && r < IN_H && c0 >= 0 && c0 < IN_W) begin
                     maxv = (trans.in_data[0][r][c0] > maxv) ? trans.in_data[0][r][c0] : maxv;
                   end
                 end
             end
        out_expect[0][oh][ow] = maxv;
       
       end
    end
   endfunction
endclass