module TestBench;

	reg clk, on, rst;
	reg [2:0] in_sel;	//persist, load, reset
	reg [6:0] out_sel;	//which operation to do, comes out of the last mux
	reg [7:0] num1, num2;
	wire [7:0] out, final1, final2; //output value
	wire [1:0] currState, nextState;

	main myMain(clk, on, /*rst,*/ in_sel, num1, num2, final1, final2, out_sel, out, currState, nextState);

	initial begin
		clk = 1; #5 clk = 0;
		$display("Num1|Num2|Operation|Current State|Output|Next State");
		$display("-----------------------------------+----------+-----");
		
		forever
			begin
				#10 clk = 1;
				#10 clk = 0;
				$display("    %b (%d)|    %b (%d)|   %b|    %b|   %b (%d)|  %b",final1, final1, final2, final2, out_sel, currState, out, out, nextState);

			end
		end
		
		initial begin
			#20;
			/*rst=0;*/ on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b1000000;
			#20;
			/*rst =1;*/ on = 1'b1; in_sel = 3'b100; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b1000000;
			#20;
			#20;
			#20;
			on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b1000000;
			#20;
			#20;
			on = 1'b1; in_sel = 3'b001; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b1000000;
			#20;
			#20;
			on = 1'b1; in_sel = 3'b001; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b1000000;
			#20;
			#20;
			/*rst = 0;*/ on = 1'b1; in_sel = 3'b010; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b1000000;
			#10 on = 1'b1; in_sel = 3'b010; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b1000000;
			#10;
			#10 on = 1'b1; in_sel = 3'b010; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b1000000;
			#10;
			#10 on = 1'b1; in_sel = 3'b010; num1 = 8'b00000010; num2 = 8'b00000100; out_sel = 7'b1000000;
			#10;
			/*#15 on = 1'b1; in_sel = 3'b010; num1 = 8'b00000111; num2 = 8'b00000010; out_sel = 7'b1000000;
			#15 on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b0100000;
			#15 on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b0010000;
			#15 on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b0001000;
			#15 on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b0000100;
			#15 on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b0000010;
			#15 on = 1'b1; in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010; out_sel = 7'b0000001;
			#15*/
			
			$stop;
		
	end
endmodule

