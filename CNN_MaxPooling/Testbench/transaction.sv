class transaction;
  rand bit rst_n;
  rand bit valid_in;
  randc logic signed [23:0] in_data [1][8][8];
  bit valid_out;
  logic signed [24-1:0]  out_data [1][4][4];
  constraint reset_inValid {valid_in ==1;}
  constraint reset {rst_n ==1;}
  constraint inData { 
    foreach(in_data[c,h,w]) {
      in_data[c][h][w] >=0;
      in_data[c][h][w] <100;
    }
  }
      
      //==============Covergroup==============
    
      
      //======================================
  function void display();
    $display("Input data");
    $display("reset = %0d, valid_in = %0d", rst_n,valid_in);
    for(int i=0;i<8;i++) begin
      for(int j=0;j<8;j++) begin
        if (in_data[0][i][j] % 10 ==in_data[0][i][j])
          $write("%0d  ",in_data[0][i][j]);
        else
          $write("%0d ",in_data[0][i][j]);
      end
      $display("");
    end
    $display("");
  endfunction
  
  function void display2();
    $display("reset = %0d, valid_in = %0d", rst_n,valid_in);
  endfunction
  
endclass