module two_ram_port_verilog (
    input wire clk,
    input wire wea, web,  // Write enables for port A and port B
    input wire [1:0] addra, addrb, // Address inputs for port A and port B (2-bit address for 4 locations)
    input wire [3:0] dina, dinb, // Data inputs for port A and port B (4-bit data)
    output reg [3:0] douta, doutb // Data outputs for port A and port B (4-bit data)
);
    // Flip-Flops for memory cells (4-Bit data)
     reg [3:0] mem0, mem1, mem2, mem3;


    // Write logic using multiplexer
    always @(posedge clk) begin
        if (wea && web &&(addra==addrb)) begin  
            case (addra)
                2'b00: mem0 <= dina;
                2'b01: mem1 <= dina;
                2'b10: mem2 <= dina;
                2'b11: mem3 <= dina;
            endcase
        end
		else begin
		if (wea) begin
            case (addra)
                2'b00: mem0 <= dina;
                2'b01: mem1 <= dina;
                2'b10: mem2 <= dina;
                2'b11: mem3 <= dina;
            endcase
        end
        if (web) begin
            case (addrb)
                2'b00: mem0 <= dinb;
                2'b01: mem1 <= dinb;
                2'b10: mem2 <= dinb;
                2'b11: mem3 <= dinb;
            endcase
        end
		end
		end

    // Port A read logic
    always @(*) begin
        case (addra)
            2'b00: douta = mem0;
            2'b01: douta = mem1;
            2'b10: douta = mem2;
            2'b11: douta = mem3;
        endcase
    end

    // Port B read logic
    always @(*) begin
        case (addrb)
            2'b00: doutb = mem0;
            2'b01: doutb = mem1;
            2'b10: doutb = mem2;
            2'b11: doutb = mem3;
        endcase
    end
endmodule
