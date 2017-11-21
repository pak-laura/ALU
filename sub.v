module sub(first, second, diff, error);
	input[7:0] first, second;
	output [7:0] diff;
	output error;
	reg x;

	assign{diff} = first-second;
	always @(*) begin
		if (second > first)
			x=1;
		else
			x=0;
	end

	assign error = x;

endmodule
