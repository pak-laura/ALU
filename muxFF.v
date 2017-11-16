module MuxFF(keep_val, load, clear, sel, outWire);
	parameter k= 3; //# of inputs, can override in instantiation
	input [k-1:0] keep_val, load, clear; //inputs
	input [2:0] sel; //1-hot select
	output [k-1:0] outWire;
	wire [k-1:0] outWire = ({k{s[0]}} & keep_val) |
													({k{s[1]}} & load) |
													({k{s[2]}} & clear);
endmodule
