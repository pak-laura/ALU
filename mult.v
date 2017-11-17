module Mult(first, second, errorWire, outWire);
	input [7:0] first, second;
	output [7:0] outWire;
	output errorWire;


	//partial products
	wire [7:0] pp0 = first & {8{second[0]}}; //x1
	wire [7:0] pp1 = first & {8{second[1]}}; //x2
	wire [7:0] pp2 = first & {8{second[2]}}; //x4
	wire [7:0] pp3 = first & {8{second[3]}}; //x8
	wire [7:0] pp4 = first & {8{second[4]}}; //x16
	wire [7:0] pp5 = first & {8{second[5]}}; //x32
	wire [7:0] pp6 = first & {8{second[6]}}; //x64
	wire [7:0] pp7 = first & {8{second[7]}}; //x128

	//sum up partial products
	wire addOut1, addOut2, addOut3, addOut4, addOut5, addOut6, addOut7;
	wire [7:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7;
	FAdder #(8) fa1(pp1, {1'b0,pp0[7:1]}, 1'b0, addOut1, sum1);
	FAdder #(8) fa2(pp2, {addOut1,sum1[7:1]}, 1'b0, addOut2, sum2);
	FAdder #(8) fa3(pp3, {addOut2,sum2[7:1]}, 1'b0, addOut3, sum3);
	FAdder #(8) fa4(pp4, {addOut3,sum3[7:1]}, 1'b0, addOut4, sum4);
	FAdder #(8) fa5(pp5, {addOut4,sum4[7:1]}, 1'b0, addOut5, sum5);
	FAdder #(8) fa6(pp6, {addOut5,sum5[7:1]}, 1'b0, addOut6, sum6);
	FAdder #(8) fa7(pp7, {addOut6,sum6[7:1]}, 1'b0, addOut7, sum7);

	//result
	wire[7:0] outWire = {sum7[0], sum6[0], sum5[0], sum4[0], sum3[0], sum2[0],sum1[0], pp0[0]};
	wire errorWire = {addOut7, sum7[7:1]} ? 1:0;
	//wire [15:0] outWire = {addOut7, sum7, sum6[0], sum5[0], sum4[0], sum3[0], sum2[0],sum1[0],pp0[0]};
endmodule
