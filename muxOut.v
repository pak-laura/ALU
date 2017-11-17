module MuxOut(logAnd, logOr, logXor, logNot, add, sub, mult, sel, outWire);
	parameter k =7; //k = # inputs. can override in instantiation
	//override when called like MuxOut #(k_override_num) Instance_of_MuxOut(logAdd_thing, logOr_thing,...);
	input [7:0] logAnd, logOr, logXor, logNot, add, sub, mult; //inputs
	input [k-1:0] sel; //1-hot select
	output[7:0] outWire;
	wire [7:0] outWire = ({k{sel[0]}} & logAnd) |
				({k{sel[1]}} & logOr) |
				({k{sel[2]}} & logXor) |
				({k{sel[3]}} & logNot) |
				({k{sel[4]}} & add) |
				({k{sel[5]}} & sub) |
				({k{sel[6]}} & mult);
endmodule
									
