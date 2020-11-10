module xclk(clk,HREF,VS,incoming_data,xclk,pclk,captured,vga_clk);
		
		input clk;
		input wire HREF,VS,pclk;
		
		output reg vga_clk;
		
		input [7:0] incoming_data;
		output reg [15:0] captured ;
		
		output wire xclk;

		integer publish=0;
		integer clock_counter=0;
		

		assign xclk=clk;

		
		always@(posedge xclk)
		begin
				if(clock_counter==0)
				begin
						clock_counter<=clock_counter+1;
						vga_clk<=0;
				end
				
				else if(clock_counter==1)
				begin
						clock_counter<=0;
						vga_clk<=1;
				
				end
		
		
		end

			always@(posedge pclk)
				begin		
		
						if(HREF==1)
						begin
								if(publish==0)
								begin
								
										captured[15:8]<=incoming_data[7:0];
										publish <= publish + 1;
										
										
								end
								else if(publish==1)
								begin
										captured[7:0]<=incoming_data[7:0];
										publish=0;

								end
				end
		end
		
		endmodule