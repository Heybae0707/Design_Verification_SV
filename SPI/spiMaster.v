module spiMaster(
	input wire clk, //System clock
	input wire reset, 
	input wire [15:0] dataIn, //Transfer to MOSI
	output wire spi_CS,
	output wire spi_sclk, //clock master
	output wire spiData,
	output [4:0] counter
);
reg MOSI;
reg [4:0] count;
reg cs;
reg sclk;
reg [2:0] state;

always @(posedge clk or posedge reset)
	if(reset)
	begin
		MOSI <=16'b0;
		count <= 5'd16;
		cs <=1'b1;
		sclk <=1'b0;
	end
	else
	begin
	case(state)
		0: begin
			sclk <=1'b0;
			cs <=1'b1;
			state<=3'b1;
		end
		1:begin
			sclk <=1'b0;
			cs <=1'b0;
			MOSI<=dataIn[count-1];
			count<=count-1;
			state<=2;
		end
		2:begin
			sclk <=1'b1;
			if(count>0)
				state<=1;
			else 
			begin
				count<=16;
				state<=0;
			end
		end
		default: state<=0;
		endcase
	end
assign spi_CS=cs;
assign spi_sclk=sclk;
assign spiData=MOSI;
assign counter=count;
endmodule

//5ns to choose default case
//10ns to 
//20ns to create clock of master base on state x 16 bit =320ns
