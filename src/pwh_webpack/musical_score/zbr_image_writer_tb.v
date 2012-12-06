`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:12:52 12/06/2012
// Design Name:   zbt_image_writer
// Module Name:   /afs/athena.mit.edu/user/p/w/pwh/rh2/src/pwh_lab/rh_video_display/zbt_image_writer_tb.v
// Project Name:  rh_video_display
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: zbt_image_writer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module zbt_image_writer_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] image_data;
	reg new_input;

	// Outputs
	wire new_output;
	wire [35:0] image_data_zbt;

	// Instantiate the Unit Under Test (UUT)
	zbt_image_writer uut (
		.clk(clk), 
		.reset(reset), 
		.image_data(image_data), 
		.new_input(new_input), 
		.new_output(new_output), 
		.image_data_zbt(image_data_zbt)
	);
	
	always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		image_data = 0;
		new_input = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		new_input = 1;
		image_data = 8'hAA;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hBB;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hCC;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hDD;
		
		#10;
		new_input = 0;
		
		#50;
		new_input = 1;
		image_data = 8'hDD;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hCC;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hBB;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hAA;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hAB;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hAB;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hDC;
		
		#10;
		new_input = 0;
		
		#10;
		new_input = 1;
		image_data = 8'hDC;
		
		#10;
		new_input = 0;

	end
      
endmodule

