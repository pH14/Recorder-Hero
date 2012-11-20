`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:10:25 11/20/2012
// Design Name:   counter
// Module Name:   /afs/athena.mit.edu/user/p/w/pwh/Desktop/6.111/Recorder-Hero/src/pwh_lab/rh_video_display/counter_tb.v
// Project Name:  rh_video_display
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module counter_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [26:0] count_to;

	// Outputs
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	counter uut (
		.clk(clk), 
		.reset(reset), 
		.count_to(count_to), 
		.ready(ready)
	);

	always #1 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		count_to = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		count_to = 15;
		
		#2;
		
		reset = 0;
		
		#50;
		
		reset = 1;
		count_to = 5;
		
		#2;
		
		reset = 0;
	end
      
endmodule

