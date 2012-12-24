`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:06:53 11/20/2012 
// Design Name: 
// Module Name:    counter 
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
module counter(
    input clk,
    input reset,
    input [26:0] count_to,
    output ready
    );
	 
	 reg [26:0] count;
	 reg [26:0] goal;
	 reg enable = 0;
	 
	 always @(posedge clk) begin
		if (reset) begin
			count <= 0;
			goal <= count_to;
		end else begin
			count <= count + 1;
			if (count == goal) begin
				count <= 0;
			end
		end
	 end

	assign ready = (count == goal);
endmodule
