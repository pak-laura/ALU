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
	/////////////////////////////////////////
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

				casex (out_sel, currState, nextState)
				11'b10000000000 : $display("    %b (%d)|    %b (%d)|   %b(Mult)|    	 %b(Off)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b10000000001 : $display("    %b (%d)|    %b (%d)|   %b(Mult)|    	 %b(Off)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b10000000100 : $display("    %b (%d)|    %b (%d)|   %b(Mult)|    	 %b(Ready)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b10000000110 : $display("    %b (%d)|    %b (%d)|   %b(Mult)|    	 %b(Ready)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b10000001010 : $display("    %b (%d)|    %b (%d)|   %b(Mult)|    	 %b(Running)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b10000001011 : $display("    %b (%d)|    %b (%d)|   %b(Mult)|    	 %b(Running)|	   %b (%d)| 	 %b(Running w/ error)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b10000001101 : $display("    %b (%d)|    %b (%d)|   %b(Mult)|    	 %b(Running w/ error)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
			//end mult, start sub	
				11'b01000000000 : $display("    %b (%d)|    %b (%d)|   %b(Sub)|    	 %b(Off)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b01000000001 : $display("    %b (%d)|    %b (%d)|   %b(Sub)|    	 %b(Off)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b01000000100 : $display("    %b (%d)|    %b (%d)|   %b(Sub)|    	 %b(Ready)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b01000000110 : $display("    %b (%d)|    %b (%d)|   %b(Sub)|    	 %b(Ready)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b01000001010 : $display("    %b (%d)|    %b (%d)|   %b(Sub)|    	 %b(Running)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b01000001011 : $display("    %b (%d)|    %b (%d)|   %b(Sub)|    	 %b(Running)|	   %b (%d)| 	 %b(Running w/ error)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b01000001101 : $display("    %b (%d)|    %b (%d)|   %b(Sub)|    	 %b(Running w/ error)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				//end sub start add
				11'b00100000000 : $display("    %b (%d)|    %b (%d)|   %b(Add)|    	 %b(Off)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00100000001 : $display("    %b (%d)|    %b (%d)|   %b(Add)|    	 %b(Off)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00100000100 : $display("    %b (%d)|    %b (%d)|   %b(Add)|    	 %b(Ready)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00100000110 : $display("    %b (%d)|    %b (%d)|   %b(Add)|    	 %b(Ready)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00100001010 : $display("    %b (%d)|    %b (%d)|   %b(Add)|    	 %b(Running)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00100001011 : $display("    %b (%d)|    %b (%d)|   %b(Add)|    	 %b(Running)|	   %b (%d)| 	 %b(Running w/ error)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00100001101 : $display("    %b (%d)|    %b (%d)|   %b(Add)|    	 %b(Running w/ error)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				//end add, start NOT
				11'b00010000000 : $display("    %b (%d)|    %b (%d)|   %b(NOT)|    	 %b(Off)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00010000001 : $display("    %b (%d)|    %b (%d)|   %b(NOT)|    	 %b(Off)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00010000100 : $display("    %b (%d)|    %b (%d)|   %b(NOT)|    	 %b(Ready)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00010000110 : $display("    %b (%d)|    %b (%d)|   %b(NOT)|    	 %b(Ready)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00010001010 : $display("    %b (%d)|    %b (%d)|   %b(NOT)|    	 %b(Running)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00010001011 : $display("    %b (%d)|    %b (%d)|   %b(NOT)|    	 %b(Running)|	   %b (%d)| 	 %b(Running w/ error)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00010001101 : $display("    %b (%d)|    %b (%d)|   %b(NOT)|    	 %b(Running w/ error)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
			//end NOT, start XOR
				11'b00001000000 : $display("    %b (%d)|    %b (%d)|   %b(XOR)|    	 %b(Off)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00001000001 : $display("    %b (%d)|    %b (%d)|   %b(XOR)|    	 %b(Off)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00001000100 : $display("    %b (%d)|    %b (%d)|   %b(XOR)|    	 %b(Ready)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00001000110 : $display("    %b (%d)|    %b (%d)|   %b(XOR)|    	 %b(Ready)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00001001010 : $display("    %b (%d)|    %b (%d)|   %b(XOR)|    	 %b(Running)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00001001011 : $display("    %b (%d)|    %b (%d)|   %b(XOR)|    	 %b(Running)|	   %b (%d)| 	 %b(Running w/ error)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00001001101 : $display("    %b (%d)|    %b (%d)|   %b(XOR)|    	 %b(Running w/ error)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
			//end XOR, start OR
				11'b00000100000 : $display("    %b (%d)|    %b (%d)|   %b(OR)|    	 %b(Off)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000100001 : $display("    %b (%d)|    %b (%d)|   %b(OR)|    	 %b(Off)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000100100 : $display("    %b (%d)|    %b (%d)|   %b(OR)|    	 %b(Ready)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000100110 : $display("    %b (%d)|    %b (%d)|   %b(OR)|    	 %b(Ready)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000101010 : $display("    %b (%d)|    %b (%d)|   %b(OR)|    	 %b(Running)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000101011 : $display("    %b (%d)|    %b (%d)|   %b(OR)|    	 %b(Running)|	   %b (%d)| 	 %b(Running w/ error)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000101101 : $display("    %b (%d)|    %b (%d)|   %b(OR)|    	 %b(Running w/ error)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				//end OR, start AND
				11'b00000010000 : $display("    %b (%d)|    %b (%d)|   %b(AND)|    	 %b(Off)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000010001 : $display("    %b (%d)|    %b (%d)|   %b(AND)|    	 %b(Off)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000010100 : $display("    %b (%d)|    %b (%d)|   %b(AND)|    	 %b(Ready)|	   %b (%d)| 	 %b(Off)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000010110 : $display("    %b (%d)|    %b (%d)|   %b(AND)|    	 %b(Ready)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000011010 : $display("    %b (%d)|    %b (%d)|   %b(AND)|    	 %b(Running)|	   %b (%d)| 	 %b(Running)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000011011 : $display("    %b (%d)|    %b (%d)|   %b(AND)|    	 %b(Running)|	   %b (%d)| 	 %b(Running w/ error)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
				11'b00000011101 : $display("    %b (%d)|    %b (%d)|   %b(AND)|    	 %b(Running w/ error)|	   %b (%d)| 	 %b(Ready)",final1, final1, final2, final2, out_sel, currState, out, out, nextState);
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
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00001001; num2 = 8'b00001010; out_sel = 7'b0010000;	//9 + 10
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b11000001; num2 = 8'b10000110; out_sel = 7'b0100000;	//193 - 134 
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00110010; num2 = 8'b00011001; out_sel = 7'b0010000;	// 50 + 25
			#20
			
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00110010; num2 = 8'b00011001; out_sel = 7'b0001000;	// 50 NOT 25
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b10000001; num2 = 8'b00000011; out_sel = 7'b0001000;	// 129 NOT 3 = NOT 129 = 126
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00110010; num2 = 8'b00011001; out_sel = 7'b0000100;	// 50 XOR 25
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00110010; num2 = 8'b00011001; out_sel = 7'b0000010;	// 50 OR 25
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00110010; num2 = 8'b00011001; out_sel = 7'b0000001;	// 50 AND 25
			#20
			
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00011110; num2 = 8'b00011110; out_sel = 7'b0000001;	// 30 AND 30
			#20
			
			#20
			/*rst = 1;*/ 
			on = 1'b1; in_sel = 3'b100; num1 = 8'b00011110; num2 = 8'b10000000; out_sel = 7'b0010000;	// 30 XOR 128 but reset is on
			#20
			
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b11100000; num2 = 8'b01111111; out_sel = 7'b0100000;	// 224 - 127
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b01111000; num2 = 8'b00000001; out_sel = 7'b0000001;	// 120 AND 1
			#20
			
			#20
			/*rst = 0;*/ 
			on = 1'b1; in_sel = 3'b010; num1 = 8'b00001000; num2 = 8'b00001010; out_sel = 7'b0000100;	// 8 XOR 10
			#20
		
		//	#20
			/*rst = 0;*/ 
		//	on = 1'b1; in_sel = 3'b010; num1 = 8'b01111000; num2 = 8'b00000001; out_sel = 7'b0000001;	// 120 AND 1
		//	#20
			
		
		//	#20
			/*rst = 0;*/ 
		//	on = 1'b1; in_sel = 3'b010; num1 = 8'b01111000; num2 = 8'b00000001; out_sel = 7'b0000001;	// 120 AND 1
		//	#20
			
		/*	#20
			/*rst = 0;*/ 
		//	on = 1'b1; in_sel = 3'b010; num1 = 8'b01111000; num2 = 8'b00000001; out_sel = 7'b0000001;	// 120 AND 1
		//	#20
			
		//	#20
			/*rst = 0;*/ 
		//	on = 1'b1; in_sel = 3'b010; num1 = 8'b01111000; num2 = 8'b00000001; out_sel = 7'b0000001;	// 120 AND 1
		//	#20
			
		//	#20
			/*rst = 0;*/ 
		//	on = 1'b1; in_sel = 3'b010; num1 = 8'b01111000; num2 = 8'b00000001; out_sel = 7'b0000001;	// 120 AND 1
		//	#20
			
		//	#20
			/*rst = 0;*/ 
		//	on = 1'b1; in_sel = 3'b010; num1 = 8'b01111000; num2 = 8'b00000001; out_sel = 7'b0000001;	// 120 AND 1
		//	#20
			
			#20			//ending time MUST KEEP
			
			
			$stop;
		
		end
		
		initial begin
			#1000
			$finish;
		end
endmodule
