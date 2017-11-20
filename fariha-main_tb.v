//to get the last to output, need to have an extra #20 after that line
//LAST THING
	//cant figure out how to get the output of the previous, the thing actually being used to calculate, how to output that???
	//need to test all other types of values using all the other funcoitns
	//laura working on the fsm 
module TestBench;

	reg clk, on, rst;
	reg [2:0] in_sel;	//persist, load, reset
	//reg [7:0] previous;
	reg [6:0] out_sel;	//which operation to do, comes out of the last mux
	reg [7:0] num1, num2;
	wire [7:0] out, final1, final2; //output value
	wire [1:0] currState, nextState;
	
	

	main myMain(clk, on, /*rst,*/ in_sel, num1, num2, final1, final2, out_sel, out, currState, nextState);

	/*always @* begin
		if(in_sel == 1)
			begin
				assign previous = out;
			end
	end
	*/
	
	initial begin
		clk = 1; #10 clk = 0;
		$display("	Num1	  	  Num2	            Operation|     Current State|     Output|	    Next State");
		$display("------------------------------------------------------------------------------------------------");
		
		forever
			begin
				#10 clk = 0;
				#10 clk = 1;
				#20
		/*	if(in_sel == 1)
				begin
					$display("    %b (%d)|    %b (%d)|   %b|    	 %b|	   %b (%d)| 	 %b",previous, previous, final2, final2, out_sel, currState, out, out, nextState);
				end
		*/		

				case (out_sel)
				7'b1000000 : $display("    %b (%d)|    %b (%d)|   %b(Mult)|    	 %b|	   %b (%d)| 	 %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				7'b0100000 : $display("    %b (%d)|    %b (%d)|   %b(Sub)|    	 %b|	   %b (%d)| 	 %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				7'b0010000 : $display("    %b (%d)|    %b (%d)|   %b(Add)|    	 %b|	   %b (%d)| 	 %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				7'b0001000 : $display("    %b (%d)|    %b (%d)|   %b(NOT)|    	 %b|	   %b (%d)| 	 %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				7'b0000100 : $display("    %b (%d)|    %b (%d)|   %b(XOR)|    	 %b|	   %b (%d)| 	 %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				7'b0000010 : $display("    %b (%d)|    %b (%d)|   %b(OR)|    	 %b|	   %b (%d)| 	 %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				7'b0000001 : $display("    %b (%d)|    %b (%d)|   %b(AND)|    	 %b|	   %b (%d)| 	 %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				endcase
				
					//$display("    %b (%d)|    %b (%d)|   %b|    	 %b|	   %b (%d)| 	 %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				
			end
		end

		
		initial begin		//reset is part of in_selector
			#20
			/*rst=0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00000001; num2 = 8'b00000010; out_sel = 7'b1000000;	//1 x 2
			#20
			
			#20;
			/*rst =1;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00000011; num2 = 8'b00000010; out_sel = 7'b1000000;	//3 x 2
			#20;

			#20;
			/*rst =0*/
			on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b1000000;		//overflow
			#20;
			
			#20;
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00000001; num2 = 8'b00000011; out_sel = 7'b1000000;		//1 x 3
			#20;

			
			#20;
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b1000000;	//2 x 4
			#20

			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b0100000;	//2 - 4
			
			#20
			
			#20
			/*rst = 1;*/ 
			on = 1'b1; in_sel = 3'b100; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b0100000;	//2 - 4
			
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00000100; num2 = 8'b00001000; out_sel = 7'b0010000;	//4 + 8
			
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00000100; num2 = 8'b00001000; out_sel = 7'b1000000;	//4 * 8
			#20
			
			
			
			#20			//ending time MUST KEEP
			
			
			$stop;
		
		end
		
		initial begin
			#1000
			$finish;
		end
endmodule
