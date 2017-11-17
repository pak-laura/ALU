// Defining states for FSM
	`define S_off       2'b00
	`define S_ready     2'b01
	`define S_run       2'b10
	`define S_run_error 2'b11

module main(clk, on, rst, in_selector, num1, num2, final1, final2, out_selector, outputVal, state, next);	//5 inputs: 2 different numbers, 
//1 input selecter bit for the input mux, clock, and a 1 bit on/off indicator. 3 outputs: value, current state, next state
	
	input wire [2:0] in_selector; //persist, load, reset
	input [7:0] num1;
	input [7:0] num2;
	input [6:0] out_selector; //and, or, not, xor, add, sub, mult
	input clk, rst, on;
	output [7:0] outputVal, final1, final2;
	output [1:0] state, next;
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
	reg error, load; //for the FSM?
  	reg  [1:0] next1  ;      // next state without reset
	
	assign final1 = rst ? 8'b00000000 : num1;
	assign final2 = rst ? 8'b00000000 : num2;
	
	MuxFF #(8) mux_1(outputVal, final1, 8'b00000000, in_selector, outM1);
	MuxFF #(8) mux_2(num2, final2, 8'b00000000, in_selector, outM2);
	
	DFF #(8) accumulator_dff(clk, outM1, outDFF1);
	DFF #(8) input_dff(clk, outM2, outDFF2);
	
	ANDgate andGate(outDFF1, outDFF2, outAnd);
	ORgate orGate(outDFF1, outDFF2, outOr);
	NOTgate notGate(outDFF1, outNot);
	XORgate xorGate(outDFF1, outDFF2, outXor);
	
	Mult multed(outDFF1, outDFF2, outOverflow, outMult);
	add myAdd(outDFF1, outDFF2, carryOutToNowhere, sum);
	sub mySub(outDFF1, outDFF2, diff);
	
	MuxOut output_mux(outAnd, outOr, outXor, outNot, sum, diff, outMult, out_selector, outputVal);
	
	assign state = next;
	
	always @(*) begin
		case(in_selector)
			100: load = 0;
			010: load = 1;
			001: load = 0;
		endcase
		case(state)
			`S_off:   {next1} = {on ? `S_ready : `S_off } ;
				
			`S_ready: {next1} = {load ? `S_run : `S_ready } ;
			`S_run:   {next1} = {outOverflow ? `S_run_error : `S_run } ;
			`S_run_error:   {next1} = {`S_ready } ;
			//default:  {next1} = {on ? `S_ready : `S_off } ;
    		endcase
	end
	
	/*always @(*) begin
		case(state)
			`S_off:   {error, next1} = {outOverflow, on ? `S_ready : `S_off } ;
				
			`S_ready: {error, next1} = {outOverflow, load ? `S_run : `S_ready } ;
			`S_run:   {error, next1} = {outOverflow, outOverflow ? `S_run_error : `S_run } ;
			`S_run_error:   {error, next1} = {outOverflow, `S_ready } ;
			default:  {error, next1} = {outOverflow, on ? `S_ready : `S_off } ;
    		endcase
	end*/
	
	
	assign next = rst ? `S_ready : next1 ;

	
	
endmodule






