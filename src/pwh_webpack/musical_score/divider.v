`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:30 10/09/2012 
// Design Name: 
// Module Name:    divider 
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
module divider
	(input clk,
    input reset,
	 input load_tempo,
	 input [31:0] count_to_input,
	 output eighth_note_enable
    );
	 
	reg [31:0] count_to;
	reg [31:0] current_cycle = 0;
	
	// Count up to parameterized value and reset,
	// output 1 once per cycle
	always @(posedge clk) begin
		if (reset) begin
			current_cycle <= 0;
			count_to <= 0;
		end else if (load_tempo) begin
			current_cycle <= 0;
			count_to <= count_to_input;
		end else begin
			current_cycle <= current_cycle + 1;
		end
		
		if (current_cycle == count_to)
			current_cycle <= 0;
	end
	
	assign eighth_note_enable = (current_cycle == count_to-1) ? 1 : 0;
endmodule