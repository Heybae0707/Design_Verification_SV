module tb_dual_ram;
    // Tín hiệu
    logic clk;

    // Khởi tạo interface
    ram_if ram_if_inst (.clk(clk));

    // Khởi tạo DUT (Device Under Test)
    two_ram_port_verilog dut (
        .clk(ram_if_inst.clk),
        .wea(ram_if_inst.wea),
        .web(ram_if_inst.web),
        .addra(ram_if_inst.addra),
        .addrb(ram_if_inst.addrb),
        .dina(ram_if_inst.dina),
        .dinb(ram_if_inst.dinb),
        .douta(ram_if_inst.douta),
        .doutb(ram_if_inst.doutb)
    );

    // Tạo xung clock (chu kỳ 10ns -> 100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ clock 10ns
    end

    // Class để tạo dữ liệu ngẫu nhiên
    class RamTest;
        rand bit wea, web;           // Random write enables
        rand bit [1:0] addra, addrb; // Random addresses
        rand bit [3:0] dina, dinb;   // Random data inputs cho Port A và Port B

        // Ràng buộc để tăng tính thú vị trong kiểm tra
        constraint addr_c {
            addra dist {2'b00:/25, 2'b01:/25, 2'b10:/25, 2'b11:/25}; // Phân bố đều địa chỉ
            addrb dist {2'b00:/25, 2'b01:/25, 2'b10:/25, 2'b11:/25};
        }
        constraint we_c {
            wea dist {0:/40, 1:/60}; // 60% khả năng ghi cho Port A
            web dist {0:/40, 1:/60}; // 60% khả năng ghi cho Port B
        }
        // Không ràng buộc cụ thể cho dina, dinb để chúng hoàn toàn ngẫu nhiên từ 0 đến 15 (4-bit)

        function void inKetQua();
            $display("wea=%b, web=%b, addra=%0b, addrb=%0b, dina=%0h, dinb=%0h",
                     wea, web, addra, addrb, dina, dinb);
        endfunction
    endclass

    // Quy trình kiểm tra
    initial begin
        RamTest test;
        test = new();

        // Reset ban đầu
        ram_if_inst.wea = 0;
        ram_if_inst.web = 0;
        ram_if_inst.addra = 0;
        ram_if_inst.addrb = 0;
        ram_if_inst.dina = 0;
        ram_if_inst.dinb = 0;

		
        // Chạy 10 trường hợp kiểm tra ngẫu nhiên
        repeat (5) begin
            assert(test.randomize()) else $fatal("Tạo dữ liệu ngẫu nhiên thất bại!");
            test.inKetQua(); // In dữ liệu ngẫu nhiên để kiểm tra

            // Gán dữ liệu ngẫu nhiên với blocking assignments
            ram_if_inst.wea = test.wea;
            ram_if_inst.web = test.web;
            ram_if_inst.addra = test.addra;
            ram_if_inst.addrb = test.addrb;
            ram_if_inst.dina = test.dina; // Gán giá trị ngẫu nhiên cho dina
            ram_if_inst.dinb = test.dinb; // Gán giá trị ngẫu nhiên cho dinb

            // Chờ 1 chu kỳ clock để ghi và đọc
            @(posedge clk);

            // Hiển thị kết quả đầu ra
            $display("Thời gian=%0t | douta=%0h | doutb=%0h",
                     $time, ram_if_inst.douta, ram_if_inst.doutb);
            #5; // Chờ thêm để quan sát
        end
		
        // Kết thúc mô phỏng
		#15; //We=We=1, Adda=Addb=2'b11;
		ram_if_inst.wea = 1;
        ram_if_inst.web = 1;
        ram_if_inst.addra = 2'b11;
        ram_if_inst.addrb = 2'b11;
        ram_if_inst.dina = 4'b0000;
        ram_if_inst.dinb = 4'b0110;
        #50;
        $finish;
    end

    // Theo dõi đầu ra
    initial begin
        $monitor("Thời gian=%0t | wea=%b | web=%b | addra=%0b | addrb=%0b | dina=%0h | dinb=%0h | douta=%0h | doutb=%0h",
                 $time, ram_if_inst.wea, ram_if_inst.web, ram_if_inst.addra,
                 ram_if_inst.addrb, ram_if_inst.dina, ram_if_inst.dinb,
                 ram_if_inst.douta, ram_if_inst.doutb);
    end

endmodule