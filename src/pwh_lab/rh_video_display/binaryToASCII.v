`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Andres Romero 
// 
// Create Date:    14:24:01 12/08/2012 
// Design Name:    
// Module Name:    binaryToASCII 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module binaryCounterASCII(
    input clk,
    input reset,
    input score,
    output [47:0] asciiScore
    );

	reg[4:0] ones = 0;
	reg[4:0] tens = 0;
	reg[4:0] hundreds = 0;
	reg[4:0] thousands = 0;
	reg[4:0] tenthousands = 0;
	reg[4:0] hundredthousands = 0;

	//Counters for each digit up to the 6th digit, can count up to whatever ascii value desired.
	always @(posedge clk)begin
		if (reset) begin
			ones <= 0;
			tens <= 0;
			hundreds <= 0;
			thousands <= 0;
			tenthousands <= 0;
			hundredthousands <= 0;
		end
	
		if (score) begin
			ones <= ones + 1;
			if (ones + 1 == 4'd10) begin
				ones <= 0;
				tens <= tens + 1;
			end
			if (tens + 1 == 4'd10) begin
				tens <= 0;
				hundreds <= hundreds + 1;
			end
			if (hundreds + 1 == 4'd10) begin
				hundreds <= 0;
				thousands <= thousands + 1;
			end
			if (thousands + 1 == 4'd10) begin
				thousands <= 0;
				tenthousands <= tenthousands + 1;
			end
			if (tenthousands + 1 == 4'd10) begin
				tenthousands <= 0;
				hundredthousands <= hundredthousands + 1;
			end
		end
	end

	//Assign output
	assign asciiScore = {8'b00110000 + hundredthousands,
								 8'b00110000 + tenthousands,
								 8'b00110000 + thousands,
								 8'b00110000 + hundreds,
								 8'b00110000 + tens,
								 8'b00110000 + ones};
endmodule
