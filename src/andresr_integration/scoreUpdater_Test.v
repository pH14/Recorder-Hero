`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:15:28 11/20/2012
// Design Name:   scoreUpdater
// Module Name:   /afs/athena.mit.edu/user/a/n/andresr/6.111work/fft_display/fft_display/scoreUpdater_Test.v
// Project Name:  fft_display
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: scoreUpdater
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module scoreUpdater_Test;

	// Inputs
	reg clk;
	reg [3:1] currentNote;
	reg A;
	reg A;

	// Instantiate the Unit Under Test (UUT)
	scoreUpdater uut (
		.clk(clk), 
		.currentNote(currentNote), 
		.A(A), 
		.A(A)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		currentNote = 0;
		A = 0;
		A = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

