module TestBench;

	reg clk;
	reg [2:0] in_sel;	//persist, load, reset
	reg [5:0] out_sel;	//which operation to do, comes out of the last mux
	reg [7:0] num1, num2;
	wire [7:0] out; //output value
	wire [1:0] currState, nextState;

	main myMain(in_sel, num1, num2, out_sel, out, currState, nextState);

	initial begin
	
    clk = 1 ; #5 clk = 0 ;
	    $display("Num1|Num2|Operation|Current|Output|Next State);		
	    $display("-----------------------------------+----------+-----");
    forever
      begin
	   
	      $display("    %b|    %b| %b|   %b|   %b|  %b|  %b|      %b|%b",num1, num2, out_sel, currState, out, nextState);
        #5 clk = 1 ; 
	
		#5 clk = 0 ;
      end
    end
	
		in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010;
		//in_sel is selector for mux1/mux2
		//not sure what this is used for	#0
			
			#100
		
		

	end
	
endmodule
