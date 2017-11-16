module sub(first, second, diff);
	input[7:0] first, second;
	output [7:0] diff;

	assign{diff} = first-second;
endmodule
