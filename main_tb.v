module TestBench;

	reg [2:0]in_sel;
	reg [5:0] out_sel;
	reg [7:0] num1, num2;
	wire [7:0] out;

	main myMain(in_sel, num1, num2, out_sel);

	initial begin
		in_sel = 3'b010; num1 = 8'b01010111; num2 = 8'b00011010;
			#0
		#10 
