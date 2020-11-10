module top(clk, SDA,SCLK,HREF,VS,pclk,incoming_data,R,G,B,VSYNC,HSYNC,xclk);
	
	input clk;
	
	output SCLK;
	inout SDA;
	
	output [3:0] R;
	output [3:0] G;
	output [3:0] B;				//VGA
	output HSYNC,VSYNC;
	
	output xclk;
	input VS,HREF;
	input pclk;					//OV7670
	input [7:0] incoming_data;
	
	wire [15:0] tx;
	wire v_clk;
	
	i2c_ov7670 i2c( .clk(clk), .SDA(SDA),.SCLK(SCLK));
	xclk k(.clk(clk), .VS(VS), .HREF(HREF), .xclk(xclk), .pclk(pclk), .incoming_data(incoming_data), .captured(tx), .vga_clk(v_clk));
		vga_controller v(.clk(clk), .R(R), .G(G), .B(B),.HSYNC(HSYNC),.VSYNC(VSYNC), .vga_clk(v_clk), .rx(tx), .pclk(pclk),.HREF(HREF), .VS(VS));
	
	endmodule