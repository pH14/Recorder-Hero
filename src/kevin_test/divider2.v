`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:29 04/30/2008 
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
module divider2(clock, reset, clock_48khz);
    input clock, reset;
    output reg clock_48khz;
	 reg [11:0] counter;

always @ (posedge clock)
if (reset) counter <= 0;
else begin
	counter <= (counter == 2248) ? 0 : counter  + 1;  // 27mhz / 48Khz = 562.5
	clock_48khz <= (counter == 2248);
	end
	
endmodule

