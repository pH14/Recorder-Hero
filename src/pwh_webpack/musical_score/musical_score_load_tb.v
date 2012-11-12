`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:26:49 11/10/2012
// Design Name:   musical_score_load
// Module Name:   Z:/Dropbox/School/MIT 12-13/6.111/Recorder-Hero/src/pwh_webpack/musical_score/musical_score_load_tb.v
// Project Name:  musical_score
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: musical_score_load
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module musical_score_load_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [1:0] song_id;

	// Outputs
	wire [63:0] next_notes;

	// Instantiate the Unit Under Test (UUT)
	musical_score_load uut (
		.clk(clk), 
		.reset(reset), 
		.song_id(song_id), 
		.next_notes(next_notes)
	);
	
	always #1 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		song_id = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		
		#10;
		
		reset = 0;
		
		#10;
		
		song_id = 0;
		
		#2;
		
		song_id = 1;
		
		#5;
		
		#500;
	end
      
endmodule

