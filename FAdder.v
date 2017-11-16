//multi-bit adder
module FAdder(first, second, carryIn, carryOut, sum);
	parameter n=8;
	input [n-1:0] first, second;
	input carryIn;
	output [n-1:0] sum;
	output carryOut;

	assign {carryOut, sum} = first + second + carryIn;
endmodule
