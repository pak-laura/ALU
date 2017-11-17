module DFF2(x,y);
	input x;
	output [1:0] y;
	assign y = 1 << x ;
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

module Mux2(a1, a0, s, b);
	parameter k = 4;
	input [k-1:0] a1, a0; // inputs
	input [2-1:0] s; // one-hot select
	output[k-1:0] b;
		assign b = ({k{s[1]}} & a1) |
				   ({k{s[0]}} & a0) ;
endmodule // Mux2
 
module Mux4(a3, a2, a1, a0, s, b) ;
  parameter k = 1 ;
  input [k-1:0] a3, a2, a1, a0 ;  // inputs
  input [3:0]   s ; // one-hot select
  output[k-1:0] b ;
   assign b = ({k{s[3]}} & a3) | 
              ({k{s[2]}} & a2) | 
              ({k{s[1]}} & a1) |
              ({k{s[0]}} & a0) ;
endmodule // Mux4 



module Sat_Count(clk, rst, up, down, load, max, in, out) ;
  parameter n = 4 ;
  input clk, rst, up, down, load, max ;
  input [n-1:0] in ;
  output [n-1:0] out ;
  
  wire [n-1:0] next, outpm1, outup, outdown ;
  wire [n-1:0] maxC;
  wire [n-1:0] mux2Outpt;
  wire [1:0] getMax;
  
  reg [n-1:0] next, outpm1, outup, outdown ;
  
  DFF2 maxDDF2 (max, getMax) ; 
  Mux2 #(n) muxSat (in, maxC, getMax, mux2Outpt);
  DFF #(n) maxcount(clk, mux2Outpt, maxC) ;
 

		
		
			
 
  
  assign outup = (maxC > out) ? out + {{n-1{down}},1'b1} : maxC;
  assign outdown = ( 0 < out) ? out + {{n-1{down}},1'b1} : 0;
  assign outpm1 = ({down} > 0) ? {outdown} : {outup};
  
  DFF #(n) count(clk,next,out);
  Mux4 #(n) mux(out, in, outpm1, 
		{n{1'b0}},//A ZERO
                {(~rst & ~up & ~down & ~load),//ALL OFF
                 (~rst & load),//LOAD
                 (~rst & (up | down)),//UP OR DOWN
                   rst}, //RESET
                  next) ;//OUTPUT
endmodule

//==================================
module TestBench ;
  parameter n=4;
  reg clk, rst;
  reg up,down,load,max ;
  reg [n-1:0] in;
  wire [n-1:0] out;
  
  
 Sat_Count test(clk,rst,up,down,load,max,in,out);


  initial begin
  
    clk = 1 ; #5 clk = 0 ;
	    $display("Clock|Reset|Up|Down|Load|Max|    In|MaxCounter| Out");
	    $display("-----+-----+--+----+----+---+------+----------+-----");
    forever
      begin
	   
        $display("    %b|    %b| %b|   %b|   %b|  %b|  %b|      %b|%b",clk,rst, up,down,load,max, in,test.maxC,out);
        #5 clk = 1 ; 
	
		#5 clk = 0 ;
      end
    end

  // input stimuli
  initial begin
	rst = 0 ; up=0; down=0; load=0;max =0; in=4'b0000;
	#10 up=0;down=0;load=0;max=0;in=4'b0000; 
	#10 up=0;down=0;load=0;max=0;in=4'b1000; 
	#10 up=0;down=0;load=0;max=1;in=4'b1000; 
	#50 up=0;down=0;load=0;max=0;in=4'b0000; 
	#10 up=0;down=0;load=1;max=0;in=4'b0000; 
	#10 up=0;down=0;load=0;max=0;in=4'b0000; 
	#10 up=1;down=0;load=0;max=0;in=4'b0000; 
	#100 up=0;down=0;load=0;max=0;in=4'b0000; 
	#10 up=0;down=1;load=0;max=0;in=4'b0000; 
	#100
	$stop ; 
  end
endmodule
















  