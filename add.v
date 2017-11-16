module add(first, second, carryOut, sum);
	input[7:0] first, second;
	output [7:0] sum;
	output carryOut;

	assign{carryOut, sum} = first+second;
endmodule
