module vga_controller(clk,rst,VSYNC,HSYNC,R,G,B,vga_clk,pclk,rx,HREF,VS);

	input clk,rst;
	
	input pclk,vga_clk;
	input HREF,VS;
	input wire [15:0] rx;
	reg [6:0] addr;
	reg [15:0] data;

	
	output reg VSYNC,HSYNC;  //Sync pulses
	output reg [3:0] R;
	output reg [3:0] G;
	output reg [3:0] B;				//RGB Color

	initial
	begin

			VSYNC<=0;
			HSYNC<=0;

	end

	always@(posedge vga_clk)
	begin	
				data<=rx;
	end
	
	always @(posedge vga_clk)
	begin

									//COMMON VISIBLE AREA BOTH V AND H ACTIVE
						if(HREF==1 && VS==0) 
						begin
								R[3:0]<=rx[11:8];
								G[3:0]<=rx[7:4];
								B[3:0]<=rx[3:0];
								
								HSYNC<=1;
								VSYNC<=0;
									
						end
						else if(HREF==0 && VS==1) 
						begin
								R[3:0]<=0;
								G[3:0]<=0;
								B[3:0]<=0;
								HSYNC<=0;
								VSYNC<=1;


						end
			
					else if(HREF==0 && VS==0)
					begin
				
								R[3:0]<=4'hzzzz;
								G[3:0]<=4'hzzzz;
								B[3:0]<=4'hzzzz;
								HSYNC<=0;
								VSYNC<=0;
					end


		end


	endmodule