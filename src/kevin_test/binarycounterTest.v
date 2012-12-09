`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:59:55 12/08/2012
// Design Name:   binaryCounterASCII
// Module Name:   /afs/athena.mit.edu/user/a/n/andresr/6.111work/fft_display/fft_display/binarycounterTest.v
// Project Name:  fft_display
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: binaryCounterASCII
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module binarycounterTest;

	// Inputs
	reg clk;
	reg reset;
	reg score;

	// Outputs
	wire [47:0] asciiScore;

	// Instantiate the Unit Under Test (UUT)
	binaryCounterASCII uut (
		.clk(clk), 
		.reset(reset), 
		.score(score), 
		.asciiScore(asciiScore)
	);


	always #5 clk = !clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		score = 0;

		// Wait 100 ns for global reset to finish
		#100;
      score = 1;
		// Add stimulus here

	end
      
endmodule

