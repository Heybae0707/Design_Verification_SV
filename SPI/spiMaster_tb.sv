// Định nghĩa interface cho SPI Master

// Module testbench
module spiMaster_tb;
    // Tín hiệu
    logic clk;
    bit [5:0] count_repeat;//delay_input
    // Khởi tạo interface
    spi_if spi_if_inst (.clk(clk));

    // Khởi tạo DUT (Device Under Test)
    spiMaster dut (
        .clk(spi_if_inst.clk),
        .reset(spi_if_inst.reset),
        .dataIn(spi_if_inst.dataIn),
        .spi_CS(spi_if_inst.spi_CS),
        .spi_sclk(spi_if_inst.spi_sclk),
        .spiData(spi_if_inst.spiData),
        .counter(spi_if_inst.counter)
    );

    // Tạo xung clock (chu kỳ 10ns -> 100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ clock 5ns
    end

    // Class để tạo dữ liệu ngẫu nhiên
    class SpiTest;
        rand bit [15:0] rand_dataIn;

        
        constraint data_c {
            rand_dataIn dist {0:/20, [1:16'hFFFE]:/60, 16'hFFFF:/20};
        }

        function void inKetQua();
            $display("dataIn = %0h", rand_dataIn);
        endfunction
    endclass

    // Quy trình kiểm tra
    initial begin
        SpiTest test;
        test = new();
        count_repeat=34;
        spi_if_inst.reset = 1'b1;
        spi_if_inst.dataIn = 16'b0; 
        repeat (2) @(posedge clk); // Chờ 2 chu kỳ clock
        spi_if_inst.reset = 1'b0; // Tắt reset
        #20;
        // Chạy 5 trường hợp
        repeat (5) begin
            assert(test.randomize()) else $fatal("Tạo dữ liệu ngẫu nhiên thất bại!");
            test.inKetQua();
            spi_if_inst.dataIn = test.rand_dataIn; 
            repeat (count_repeat) @(posedge clk);
            count_repeat=33;
            // Hiển thị kết quả đầu ra
            $display("[%0t]: spi_CS=%b | spi_sclk=%b | spiData=%b | counter=%0d",
                     $time, spi_if_inst.spi_CS, spi_if_inst.spi_sclk,
                     spi_if_inst.spiData, spi_if_inst.counter);
        end

        // Kết thúc mô phỏng
        #100;
        $finish;
    end

    // Theo dõi đầu ra
    initial begin
        $monitor("[%0t] spi_CS=%b, spi_sclk=%b, spiData=%b, counter=%0d",
                 $time, spi_if_inst.spi_CS, spi_if_inst.spi_sclk,
                 spi_if_inst.spiData, spi_if_inst.counter);
    end

endmodule
