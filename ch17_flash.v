/*******************************************************************************
Copyright (c) 2012, Stanford University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
   must display the following acknowledgement:
   This product includes software developed at Stanford University.
4. Neither the name of Stanford Univerity nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY STANFORD UNIVERSITY ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************/

//Modules for Section 17.1, includes testbenches
// define states for flash1
`define SWIDTH 3
`define S_OFF 3'b000
`define S_A   3'b001
`define S_B   3'b010
`define S_C   3'b011
`define S_D   3'b100
`define S_E   3'b101

// define time intervals
// load 5 for 6-cycle interval 5 to 0.
`define T_WIDTH 3
`define T_ON  3'd5
`define T_OFF 3'd3

// defines for pulse counter
// load with 3 for four pulses
`define C_WIDTH 2
`define C_COUNT 3

// defines for doubly factored states
`define XWIDTH 2
`define X_OFF   2'b00
`define X_FLASH 2'b01
`define X_SPACE 2'b10

//----------------------------------------------------------------------
// Flash module
//----------------------------------------------------------------------
module Flash(clk, rst, in, out) ;
  input clk, rst, in ; // in triggers start of flash sequence
  output out ;	       // out drives LED
  reg  out ;                       // output
  wire [`SWIDTH-1:0] state, next ; // current state
  reg  [`SWIDTH-1:0] next1  ;      // next state without reset
  reg  tload, tsel ;               // timer inputs
  wire done ;                      // timer output

  // instantiate state register
  DFF #(`SWIDTH) state_reg(clk, next, state) ;

  // instantiate timer
  Timer1 timer(clk, rst, tload, tsel, done) ;

  always @(*) begin
    case(state)
      `S_OFF: {out, tload, tsel, next1} =
              {1'b0, 1'b1, 1'b1, in ? `S_A : `S_OFF } ;
      `S_A:   {out, tload, tsel, next1} =
              {1'b1, done, 1'b0, done ? `S_B : `S_A } ;
      `S_B:   {out, tload, tsel, next1} =
              {1'b0, done, 1'b1, done ? `S_C : `S_B } ;
      `S_C:   {out, tload, tsel, next1} =
              {1'b1, done, 1'b0, done ? `S_D : `S_C } ;
      `S_D:   {out, tload, tsel, next1} =
              {1'b0, done, 1'b1, done ? `S_E : `S_D } ;
      `S_E:   {out, tload, tsel, next1} =
              {1'b1, done, 1'b1, done ? `S_OFF : `S_E } ;
      default:{out, tload, tsel, next1} =
              {1'b1, done, 1'b1, done ? `S_OFF : `S_E } ;
    endcase
  end

  assign next = rst ? `S_OFF : next1 ;
endmodule


module DFF(clk,in,out);
  parameter n=1;//width
  input clk;
  input [n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;

  always @(posedge clk)
  out = in;
 endmodule

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

module Counter1(clk, rst, cload, cdec, cdone) ;
  parameter n=`C_WIDTH ;
  input clk, rst, cload, cdec ;
  output cdone ;
  wire [n-1:0] count ;
  reg  [n-1:0] next_count ;
  wire cdone ;

  // state register
  DFF #(n) state(clk, next_count, count) ;

  // signal done
  assign cdone = ~(|count) ;

  // next count logic
  always@(*) begin
    casex({rst, cload, cdec, cdone})
      4'b1xxx: next_count = `C_WIDTH'b0 ;
      4'b01xx: next_count = `C_COUNT ;
      4'b0010: next_count = count - 1'b1 ;
      4'b00x1: next_count = count ;
      default: next_count = count ;
    endcase
  end
endmodule
//----------------------------------------------------------------------
module Flash2(clk, rst, in, out) ;
  input clk, rst, in ; // in triggers start of flash sequence
  output out ;	       // out drives LED
  reg  out ;                       // output
  wire [`XWIDTH-1:0] state, next ; // current state
  reg  [`XWIDTH-1:0] next1  ;      // next state without reset
  reg  tload, tsel, cload, cdec ;  // timer and counter inputs
  wire tdone, cdone ;              // timer and counter outputs

  // instantiate state register
  DFF #(`XWIDTH) state_reg(clk, next, state) ;

  // instantiate timer and counter
  Timer1   timer(clk, rst, tload, tsel, tdone) ;
  Counter1 counter(clk, rst, cload, cdec, cdone) ;

  always @(*) begin
    case(state)
      `X_OFF:  {out, tload, tsel, cload, cdec, next1} =
               {1'b0, 1'b1, 1'b1, 1'b1, 1'b0,
                in ? `X_FLASH : `X_OFF } ;
      `X_FLASH:{out, tload, tsel, cload, cdec, next1} =
               {1'b1, tdone, 1'b0, 1'b0, 1'b0,
                tdone ? (cdone ? `X_OFF : `X_SPACE) : `X_FLASH } ;
      `X_SPACE:{out, tload, tsel, cload, cdec, next1} =
               {1'b0, tdone, 1'b1, 1'b0, tdone,
                tdone ? `X_FLASH : `X_SPACE } ;
      default:{out, tload, tsel, cload, cdec, next1} =
               {1'b0, tdone, 1'b1, 1'b0, tdone,
                tdone ? `X_FLASH : `X_SPACE } ;
    endcase
  end

  assign next = rst ? `X_OFF : next1 ;
endmodule
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------
module TestFlash2 ;
  reg clk, rst, in ;
  wire out ;

  Flash2 f(clk, rst, in, out) ;

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
    #400 in = 1 ;
    //#10 in = 0 ;
    //#320
    $stop ;
  end
endmodule
//----------------------------------------------------------------------
