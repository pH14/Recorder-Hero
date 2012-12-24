`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:53:45 11/19/2012 
// Design Name: 
// Module Name:    note_y_table 
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
module note_y_table(
    input clk,
    input [3:0] note,
    output [9:0] y_pos
    );

	reg [9:0] y_pos = 0;
	always @(*) begin
		case(note)
			4'b0000: 0;
			4'b0001: 
			default: 4'b0000;
	end

endmodule
