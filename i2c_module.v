module i2c_ov7670(clk,SCLK,SDA);
		
		input clk;
		inout reg SDA;
		output SCLK;
			
		localparam OP_CODE=0;			//READ-WRITE
		localparam OP_STAND_BY=0;
		localparam OP_START=1;
		localparam OP_ADDRESS=2;
		localparam OP_ACK_FIRST=3;
		localparam OP_REG=4;
		localparam OP_ACK_SECOND=5;
		localparam OP_DATA=6;
		localparam OP_ACK_THIRD=7;
		
		localparam number_of_operations=4;
		localparam OP_BEFORE_STOP=8;
		localparam OP_STOP=9;

		reg [6:0] slave_address;
		reg [5:0] state; //3 bit state/.

		reg [7:0] INTERNAL_REG;
		reg [7:0] INTERNAL_DATA;

		reg [4:0] op_counter;
		integer count;

		integer clock_counter;		//CLOCK DIVIDER
		reg clk_enable;
		reg sclk_enable;
		
		initial
		begin

		slave_address<=7'h21;//7'h21

		clock_counter<=0;
		sclk_enable<=0;
		clk_enable<=0;

		op_counter<=0;
		state<=OP_STAND_BY;
		
		count<=6;

		end

		always@(posedge clk)
		begin
				if(clock_counter==124)
				begin

					clk_enable<=~clk_enable;
					clock_counter<=0;
				end

				else
				begin
					clock_counter<=clock_counter+1;

				end
		end

		always @ (negedge clk_enable)
		begin
				if((state==OP_START) || (state==OP_STAND_BY) || (state==OP_STOP))
				begin
				sclk_enable<=0;
				end
				
				else
				begin
				
				sclk_enable<=1;
				
				end
		end

		assign SCLK = (sclk_enable==0) ? 1: ~clk_enable;



		always @(posedge clk_enable)
		begin

					case(op_counter)

							0:
						begin
								INTERNAL_REG <= 8'h12;
								INTERNAL_DATA <= 8'h80;

						end
						
							1:
						begin
								INTERNAL_REG <= 8'h12;
								INTERNAL_DATA <= 8'h80;
							
								
						end
						
					
						2:
						begin
						
								INTERNAL_REG <= 8'h8C;
								INTERNAL_DATA <= 8'h02;
						end
						
						3:
						begin
						
								INTERNAL_REG <= 8'h40;
								INTERNAL_DATA <= 8'h10;
						end
						
						4:
						begin
						
								INTERNAL_REG <= 8'h72;
								INTERNAL_DATA <= 8'h22;
						end
						
						5:
						begin
						
								INTERNAL_REG <= 8'h73;
								INTERNAL_DATA <= 8'hF2;
						end
						
						6:
						begin
						
								INTERNAL_REG <= 8'h17;
								INTERNAL_DATA <= 8'h16;
						end
						
						7:
						begin
						
								INTERNAL_REG <= 8'h18;
								INTERNAL_DATA <= 8'h04;
						end
						
						8:
						begin
						
								INTERNAL_REG <= 8'h32;
								INTERNAL_DATA <= 8'hA4;
						end
						
						9:
						begin
						
								INTERNAL_REG <= 8'h19;
								INTERNAL_DATA <= 8'h02;
						end
						
						10:
						begin
						
								INTERNAL_REG <= 8'h7A;
								INTERNAL_DATA <= 8'h1A;
						end
						
						11:
						begin
						
								INTERNAL_REG <= 8'h03;
								INTERNAL_DATA <= 8'h0A;
						end
						
						12:
						begin
						
								INTERNAL_REG <= 8'h0C;
								INTERNAL_DATA <= 8'h04;
						end
						
						13:
						begin
						
								INTERNAL_REG <= 8'h12;
								INTERNAL_DATA <= 8'h00;
						end
						
						14:
						begin
						
								INTERNAL_REG <= 8'h8C;
								INTERNAL_DATA <= 8'h00;
						end
						
						15:
						begin
						
								INTERNAL_REG <= 8'h40;
								INTERNAL_DATA <= 8'h00;
						end
						
						16:
						begin
						
								INTERNAL_REG <= 8'h04;
								INTERNAL_DATA <= 8'h0C;
						end
						
						17:
						begin
						
								INTERNAL_REG <= 8'h14;
								INTERNAL_DATA <= 8'h6A;
						end
						
						18:
						begin
						
								INTERNAL_REG <= 8'h4F;
								INTERNAL_DATA <= 8'h80;
						end
						
						19:
						begin
						
								INTERNAL_REG <= 8'h05;
								INTERNAL_DATA <= 8'h80;
						end
						
						20:
						begin
						
								INTERNAL_REG <= 8'h51;
								INTERNAL_DATA <= 8'h00;
						end
						
						21:
						begin
						
								INTERNAL_REG <= 8'h52;
								INTERNAL_DATA <= 8'h22;
						end
						
						22:
						begin
						
								INTERNAL_REG <= 8'h53;
								INTERNAL_DATA <= 8'h5E;
						end
					
						23:
						begin
						
								INTERNAL_REG <= 8'h54;
								INTERNAL_DATA <= 8'h80;
						end
						
						24:
						begin
						
								INTERNAL_REG <= 8'h3D;
								INTERNAL_DATA <= 8'h40;
						end
					endcase
		end



		always@(posedge clk_enable)
		begin		
				
				case(state)
				
						OP_STAND_BY:		//STAND BY MODE
						begin

								SDA<=1;
								state<=OP_START;
						end
							
						OP_START:		//START CONDITION
						begin
						
								SDA<=0;
								state<= OP_ADDRESS;
					
						end
				
				
						OP_ADDRESS:
						begin
								if(count>=0 )
								begin
							
									SDA <= slave_address[count];  //SLAVE_ADDRESS
									count<=count-1;
							
								end
				
								else
								begin

										SDA<=0;  		
										state<= OP_ACK_FIRST;
								end
						end
				

						OP_ACK_FIRST:
						begin	
								
										//ACK
										SDA<=1'bz;
										count<=7;
										state<=OP_REG;
							
						end
				
					
						OP_REG:
						begin
								if(count>=0)
								begin
										
										SDA <= INTERNAL_REG[count];  // INTERNAL REGISTER_ADDRESS
										count<=count-1;
							
								end
						
								else
								begin
										SDA<=1'bz;   //ACK
										count<=7;
										state<=OP_DATA;  
												
							
								end
						end
				
						OP_DATA:
						begin
									if(count>=0)
									begin
												SDA <= INTERNAL_DATA[count]; 
												count<=count-1;
									end
								
									else
									begin
									
												//ACK
												SDA<=1'bz;
												state<=OP_BEFORE_STOP;  
												count<=6;
									
									end
						end
				
						OP_BEFORE_STOP:
						begin
									if(op_counter< number_of_operations)
									begin
												SDA<=0;
												state<=OP_STAND_BY;
												op_counter<=op_counter+1;

									
									
									end
									
									else
									begin
													SDA<=0;
													state<=OP_STOP;
				
									end
						
						end

				
							OP_STOP:
							begin		
									
									SDA<=1; //STOP
							end
		endcase
		end

		
		endmodule