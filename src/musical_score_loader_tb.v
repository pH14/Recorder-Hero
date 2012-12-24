`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:06:52 11/26/2012
// Design Name:   musical_score_loader
// Module Name:   /afs/athena.mit.edu/user/p/w/pwh/Desktop/6.111/Recorder-Hero/src/pwh_lab/rh_video_display/musical_score_loader_tb.v
// Project Name:  rh_video_display
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: musical_score_loader
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module musical_score_loader_tb;

	// Inputs
	reg clk;
	reg song_id;

	// Outputs
	wire [63:0] next_notes_out;

	// Instantiate the Unit Under Test (UUT)
	musical_score_loader uut (
		.clk(clk), 
		.song_id(song_id), 
		.next_notes_out(next_notes_out)
	);

	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		song_id = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#100;

	end
      
endmodule

