module DFF(clk, in, out);
	parameter n=8; //bits held
	input clk;
	input [n-1:0] in;
	output [n-1:0] out;
	reg [n-1:0] out;

	always@(posedge clk)
		out = in;
endmodule
