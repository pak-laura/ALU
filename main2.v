//try
// Defining states for FSM
	`define S_off       2'b00
	`define S_ready     2'b01
	`define S_run       2'b10
	`define S_run_error 2'b11

module main(clk, on, /*rst,*/ in_selector, num1, num2, /*final1, final2,*/outM1, outM2, out_selector, outputVal, state, next);	//5 inputs: 2 different numbers, 
//1 input selecter bit for the input mux, clock, and a 1 bit on/off indicator. 3 outputs: value, current state, next state
	
	input wire [2:0] in_selector; //persist, load, reset
	input [7:0] num1;
	input [7:0] num2;
	input [6:0] out_selector; //and, or, not, xor, add, sub, mult
	input clk, /*rst,*/ on;
	output [7:0] outputVal, outM1, outM2;//, final1, final2;
	output [1:0] state, next;
	//wire [7:0] outM1;
	//wire [7:0] outM2;
	wire [7:0] outDFF1;
	wire [7:0] outDFF2;
	wire [7:0] outAnd;
	wire [7:0] outOr;
	wire [7:0] outNot;
	wire [7:0] outXor;
	wire [7:0] outMult;
	wire outOverflow, subOverflow;
	wire carryOutToNowhere; 
	wire [7:0] sum;
	wire [7:0] diff;
 	reg  [1:0] next1  ;      // next state without reset
	reg [1:0] x; //for reset
	reg errMult, errSub;
	

	MuxFF #(8) mux_1(outputVal, num1, 8'b00000000, in_selector, outM1); //changed from 2nd final to num
	MuxFF #(8) mux_2(num2, num2, 8'b00000000, in_selector, outM2);
	
	DFF #(8) accumulator_dff(clk, outM1, outDFF1);
	DFF #(8) input_dff(clk, outM2, outDFF2);
	
	ANDgate andGate(outDFF1, outDFF2, outAnd);
	ORgate orGate(outDFF1, outDFF2, outOr);
	NOTgate notGate(outDFF1, outNot);
	XORgate xorGate(outDFF1, outDFF2, outXor);
	
	Mult multed(outDFF1, outDFF2, outOverflow, outMult);
	add myAdd(outDFF1, outDFF2, carryOutToNowhere, sum);
	sub mySub(outDFF1, outDFF2, diff, subOverflow);
	
	MuxOut output_mux(outAnd, outOr, outXor, outNot, sum, diff, outMult, out_selector, outputVal);
	
	DFF #(2) state_reg(clk, next, state); //reg for state
	

	always @(*) begin
		if(out_selector == 7'b1000000)
			errMult = outOverflow;
		else
			errMult = 0;
		if(out_selector == 7'b0100000)
			errSub = subOverflow;
		else
			errSub = 0;
		
		casex({on, in_selector, errMult,errSub, state})
			{6'b0xxxxx,`S_off}:   next1 = `S_off ;
			{6'b1xxxxx,`S_off}:   next1 = `S_ready ;
			{6'b100xxx,`S_ready}:   next1 = `S_ready ;
			{6'b1x1xxx,`S_ready}:   next1 = `S_run ;
			{6'b1xxx00,`S_run}:   next1 = `S_run ;
			{6'b1xxxx1,`S_run}:   next1 = `S_run_error ;
			{6'b1xxx1x,`S_run}:   next1 = `S_run_error ;
			/*{6'b1xxxxx,`S_run_error}:   next1 = `S_ready ;*/
			{6'b1xxx00,`S_run_error}:   next1 = `S_run ;
			{6'b1xxx1x,`S_run_error}:   next1 = `S_run_error ;
			{6'b1xxxx1,`S_run_error}:   next1 = `S_run_error ;
   	endcase
		if(in_selector == 3'b001)
			x = `S_ready;
		else
			x = next1;
	end
	

	assign next = x ;
	
endmodule
