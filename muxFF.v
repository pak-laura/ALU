module MuxFF(keep_val, load, clear, sel, outWire);
	parameter k= 8; //# of inputs, can override in instantiation
	input [k-1:0] keep_val, load, clear; //inputs
	input [2:0] sel; //1-hot select
	output [k-1:0] outWire;
	wire [k-1:0] outWire = ({k{sel[0]}} & keep_val) |
				({k{sel[1]}} & load) |
				({k{sel[2]}} & clear);
endmodule
