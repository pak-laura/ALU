//write a testbench to test each

module ANDgate (a, b, y);
	input [7:0] a, b;
	output [7:0] y;

	assign y = a & b;

endmodule
/////////////////////////////////////////////////////////////////////

module ORgate (a, b, y);
	input [7:0] a, b;
	output [7:0] y;
	
	assign y = a | b;
endmodule

//////////////////////////////////////////////////////////////////////

module NOTgate (a, y);
	input[7:0] a;
	output [7:0] y;
	
	assign y = ~a;
endmodule

//////////////////////////////////////////////////////////////////////

module XORgate (a, b, y);
	input [7:0] a, b;
	output [7:0] y;
	
	assign y = a ^ b;
endmodule