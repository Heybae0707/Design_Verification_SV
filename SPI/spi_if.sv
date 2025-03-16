interface spi_if (
    input logic clk
);
    logic reset;
    logic [15:0] dataIn;
    logic spi_CS;
    logic spi_sclk;
    logic spiData;
    logic [4:0] counter;

    // Modport cho DUT
    modport DUT (
        input clk, reset, dataIn,
        output spi_CS, spi_sclk, spiData, counter
    );
endinterface
