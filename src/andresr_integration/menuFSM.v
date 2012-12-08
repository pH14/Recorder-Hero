`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:05 11/27/2012 
// Design Name: 
// Module Name:    menuFSM 
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
module menuFSM(
    input up,
    input down,
    input enter,
    input reset,
	 input done,
    input clk,
    output [2:0] menuState,
    output reset_comp,
	 output song
    );

	reg[2:0] state;
	reg[1:0] song = 0;
	reg reset_reg = 0;
	reg[1:0] song_reg;
	parameter[2:0] songOne = 3'b000;
	parameter[3:0] songTwo = 3'b001;
	parameter[3:0] inGame = 3'b111;
	
	always @(posedge clk) begin
		if (reset) state <= songOne;
		else if (enter & (state != inGame)) begin
			state <= inGame;
			song_reg <= state[1:0];
			reset_reg <= 1;
		end
		else
			reset_comp <= 0;
			case(state)
				songOne: state <= down ? songTwo: songOne;
				songTwo: state <=  up ? songOne: songTwo;
				inGame: state <= done ? songOne: inGame;
				default: state <= songOne;
			endcase
		end
	end
	
	assign menuState = state;
	assign reset_comp = reset_reg;
	assign song = song_reg;
	
endmodule
