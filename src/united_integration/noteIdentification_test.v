`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:06:33 12/05/2012
// Design Name:   noteIdentification
// Module Name:   /afs/athena.mit.edu/user/a/n/andresr/6.111work/fft_display/fft_display/noteIdentification_test.v
// Project Name:  fft_display
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: noteIdentification
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module noteIdentification_test;

	// Inputs
	reg reset;
	reg clk;
	reg ready;
	reg [15:0] from_ac97_data;

	// Outputs
	wire [3:0] note;
	wire readVal;

	// Instantiate the Unit Under Test (UUT)
	noteIdentification uut (
		.reset(reset), 
		.clk(clk), 
		.ready(ready), 
		.from_ac97_data(from_ac97_data), 
		.note(note), 
		.readVal(readVal)
	);

	always #1 clk = !clk;
	always #50 ready = !ready;

	initial begin
		// Initialize Inputs
		reset = 0;
		clk = 0;
		ready = 0;
		from_ac97_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
      from_ac97_data = 16'b0001110011001110;
		// Add stimulus here

	end
      
endmodule

