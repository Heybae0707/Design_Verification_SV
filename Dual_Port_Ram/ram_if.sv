interface ram_if (
    input logic clk
);
    logic wea, web;          // Write enables
    logic [1:0] addra, addrb; // Địa chỉ Port A và Port B
    logic [3:0] dina, dinb;   // Dữ liệu đầu vào Port A và Port B
    logic [3:0] douta, doutb; // Dữ liệu đầu ra Port A và Port B

    // Modport cho DUT
    modport DUT (
        input clk, wea, web, addra, addrb, dina, dinb,
        output douta, doutb
    );

    // Modport cho Testbench
    modport TB (
        input clk, douta, doutb,
        output wea, web, addra, addrb, dina, dinb
    );
endinterface