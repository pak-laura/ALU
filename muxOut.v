module MuxOut(logAnd, logOr, logXor, logNot, addSub, mult, sel, outWire);
	parameter k =7; //k = # inputs. can override in instantiation
	//override when called like MuxOut #(k_override_num) Instance_of_MuxOut(logAdd_thing, logOr_thing,...);
	input [k-1:0] logAnd, logOr, logXor, logNot, addSub, mult; //inputs
	input [5:0] sel; //1-hot select
	output[k-1:0] outWire;
	wire [k-1:0] outWire = ({k{s[0]}} & logAnd) |
										({k{s[1]}} & logOr) |
										({k{s[2]}} & logXor) |
										({k{s[3]}} & logNot) |
										({k{s[4]}} & addSub) |
										({k{s[5]}} & mult);
endmodule
									
