// Finite State Machine Factorization
// Defining states for
`define SWIDTH 2
`define S_off         2'b00
`define S_ready       2'b01
`define S_run         2'b10
`define S_run_error   2'b11


// define time intervals
// load 4 for 5-cycle interval 4 to 0.
// load 3 for 4-cycle interval 3 to 0.
//`define T_WIDTH 3
//`define T_ON  3'd4
//`define T_OFF 3'd3

// defines for pulse counter
// load with 3 for four pulses
`define C_WIDTH 2
`define C_COUNT 3

//----------------------------------------------------------------------
// Flash module
//----------------------------------------------------------------------
module Flash(clk, rst, in, out) ;
  input clk, rst, in ; // in triggers start of flash sequence
  output [1:0] out ;	       // out drives LED
  reg [1:0] out ;                       // output
  wire [`SWIDTH-1:0] state, next ; // current state
  reg  [`SWIDTH-1:0] next1  ;      // next state without reset
  reg  tload, tsel ;               // timer inputs
  wire done ;                      // timer output

  // instantiate state register
  DFF #(`SWIDTH) state_reg(clk, next, state) ;

  // instantiate timer
  // Timer1 timer(clk, rst, tload, tsel, done) ;

  always @(*) begin
    case(state)
      `S_off:   {error, next1} =
                {outOverflow, on ? `S_ready : `S_off } ;
      `S_ready: {error, next1} =
                {outOverflow, load ? `S_run : `S_ready } ;
      `S_run:   {error, next1} =
                {outOverflow, outOverflow ? `S_run_error : `S_run } ;
      `S_run_error:   {error, next1} =
                      {outOverflow, `S_ready } ;
      default:  {error, next1} =
                {outOverflow, on ? `S_ready : `S_off } ;
    endcase
  end

  assign next = rst ? `S_ready : next1 ;
endmodule

//------------------------------------------
module DFF(clk,in,out);
// DFF module
//---------------------------------------------
  parameter n=1;//width
  input clk;
  input [n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;

  always @(posedge clk)
  out = in;
 endmodule
//-------------------------------------------------------------

//----------------------------------------------------------------------
// Timer1 - count down timer
//   tload - loads timer
//   tsel  - selects between `T_ON and `T_OFF for time interval in cycle
//           when tload is asserted
//   done - signals when selected time interval has completed.
//----------------------------------------------------------------------
module Timer1(clk, rst, tload, tsel, done) ;
  parameter n=`T_WIDTH ;
  input clk, rst, tload, tsel ;
  output done ;
  wire [n-1:0] count ;
  reg  [n-1:0] next_count ;

  // state register
  DFF #(n) state(clk, next_count, count) ;

  // signal done
  assign done = ~(|count) ;

  // next count logic
  always@(*) begin
    casex({rst, tload, tsel, done})
      4'b1xxx: next_count = `T_WIDTH'b0 ;
      4'b011x: next_count = `T_ON ;
      4'b010x: next_count = `T_OFF ;
      4'b00x0: next_count = count - 1'b1 ;
      4'b00x1: next_count = count ;
      default: next_count = count ;
    endcase
  end
endmodule
//-------------------------------------------------------------
module TestFlash ;
  reg clk, rst, in ;
  wire out ;

  Flash f(clk, rst, in, out) ;

  // clock and display
  initial
    forever
      begin
        #5 clk = 0 ;
        $display("%b %b", in, out) ;
        #5 clk = 1 ;
      end

  // inputs
  initial begin
    #5 rst = 1 ; in = 0 ;
    #10 rst = 0 ;
    #10 in = 1 ;
    #10 in = 0 ;
    #320 in = 1 ;
    #10 in = 0 ;
    #320 $stop ;
  end
endmodule
//----------------------------------------------------------
