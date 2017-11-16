module main(clk, in_selector, num1, num2, out_selector)	//4 different inputs: 2 different numbers, 
													//and 1 input selecter bit for the input mux, 1 output selecter bit for the output mux
			
	// Defining states for FSM
	`define SWIDTH 2
	`define S_off       2'b00
	`define S_ready     2'b01
	`define S_run       2'b10
	`define S_run_error 2'b11
	
	input [2:0] in_selector; //persist, load, reset
	input reg[7:0] num1;
	input reg[7:0] num2;
	input [6:0] out_selector; //and, or, not, xor, add, sub, mult
	input clk;
	wire [7:0] outputVal;
	wire [7:0] outM1;
	wire [7:0] outM2;
	wire [7:0] outDFF1;
	wire [7:0] outDFF2;
	wire [7:0] outAnd;
	wire [7:0] outOr;
	wire [7:0] outNot;
	wire [7:0] outXor;
	wire [7:0] outMult;
	wire outOverflow;
	wire carryOutToNowhere;
	wire [7:0] sum;
	wire [7:0] diff;
	
	output outputVal;
	
	MuxFF #(8) mux_1(outputVal, num1, 8'b00000000, in_selector, outM1);
	MuxFF #(8) mux_2(num2, num2, 8'b00000000, in_selector, outM2);
	
	DFF #(8) accumulator_dff(clk, outM1, outDFF1);
	DFF #(8) input_dff(clk, outM2, outDFF2);
	
	ANDgate andGate(outDFF1, outDFF2, outAnd);
	ORgate andGate(outDFF1, outDFF2, outOr);
	NOTgate andGate(outDFF1, outNot);
	XORgate andGate(outDFF1, outDFF2, outXor);
	
	Mult multed(outDFF1, outDFF2, outOverflow, outMult);
	add myAdd(outDFF1, outDFF2, carryOutToNowhere, sum);
	sub mySub(outDFF1, outDFF2, diff);
	
	MuxOut output_mux(outAnd, outOr, outXor, outNot, add, sub, outMult, out_selector, outputVal);
	
	always @(*) begin
		case(state)
			`S_off:   {error, next1} = {outOverflow, on ? `S_ready : `S_off } ;
			`S_ready: {error, next1} = {outOverflow, load ? `S_run : `S_ready } ;
			`S_run:   {error, next1} = {outOverflow, outOverflow ? `S_run_error : `S_run } ;
			`S_run_error:   {error, next1} = {outOverflow, `S_ready } ;
			default:  {error, next1} = {outOverflow, on ? `S_ready : `S_off } ;
    		endcase
	end
	
	assign next = rst ? `S_ready : next1 ;

	
	
endmodule






