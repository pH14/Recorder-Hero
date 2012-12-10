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
	 input[17:0] binaryIn,
	 input[47:0] asciiIn,
    output [2:0] menuState,
    output resetComp,
	 output [1:0] song,
	 output [47:0] highScore
    );

	reg[2:0] state;
	reg reset_reg = 0;
	reg[1:0] song_reg;
	
	reg previous_button = 0;
	
	parameter[2:0] songOne = 3'b000;
	parameter[2:0] songTwo = 3'b001;
	parameter[2:0] songThree = 3'b010;
	parameter[2:0] songFour = 3'b011;
	parameter[3:0] inGame = 3'b111;
	
	reg[17:0] binaryHighScore1 = 0;
	reg[47:0] asciiHighScore1 = {6{8'b00110000}};
	
	reg[17:0] binaryHighScore2 = 0;
	reg[47:0] asciiHighScore2 = {6{8'b00110000}};
	
	reg[17:0] binaryHighScore3 = 0;
	reg[47:0] asciiHighScore3 = {6{8'b00110000}};
	
	reg[17:0] binaryHighScore4 = 0;
	reg[47:0] asciiHighScore4 = {6{8'b00110000}};
	
	
	reg[47:0] highScoreReg = {6{8'b00110000}};
	
	always @(posedge clk) begin
		//Resetting
		if (reset) state <= songOne;
		//If you pressed enter from the menu, load the correct current high score
		else if (enter && (state != inGame)) begin
			case(state[1:0])
				2'b00: highScoreReg <= asciiHighScore1;
				2'b01: highScoreReg <= asciiHighScore2;
				2'b10: highScoreReg <= asciiHighScore3;
				2'b11: highScoreReg <= asciiHighScore4;
				default:;
			endcase
			// Set the correct state as well as current song, and output a reset to the necessary components
			state <= inGame;
			song_reg <= state[1:0];
			reset_reg <= 1;
		end
		else begin
			reset_reg <= 0;
			// Update the current high score for the song if it is higher than the previous one once the song is done
			if (done &&(state == inGame)) begin
				case(song_reg)
					2'b00: begin
						if (binaryIn > binaryHighScore1) begin
							asciiHighScore1 <= asciiIn;
							binaryHighScore1 <= binaryIn;
						end
					end
					2'b01: begin
						if (binaryIn > binaryHighScore2) begin
							asciiHighScore2 <= asciiIn;
							binaryHighScore2 <= binaryIn;
						end
					end
					2'b10: begin
						if (binaryIn > binaryHighScore3) begin
							asciiHighScore3 <= asciiIn;
							binaryHighScore3 <= binaryIn;
						end
					end
					2'b11: begin
						if (binaryIn > binaryHighScore4) begin
							asciiHighScore4 <= asciiIn;
							binaryHighScore4 <= binaryIn;
						end
					end					
					default:;
				endcase
				//Also go back to the menu
				state <= songOne;
			end
			//Make sure a button wasn't just pressed
			if (!previous_button) begin
				//Update the current state depending on the button pressed
				case(state)
					songOne: state <= down ? songTwo: songOne;
					songTwo: state <=  up ? songOne: down? songThree: songTwo;
					songThree: state <= up ? songTwo: down ? songFour: songThree;
					songFour: state <= up ? songThree: songFour;
					inGame: state <= done ? songOne: inGame;
					default: state <= songOne;
				endcase
				//Stop it from reaching this case until both buttons are depressed
				previous_button <= 1;
			end
			//Both buttons are depressed, allow it to change states again
			if (!down & !up) previous_button <= 0;
		end
	end
	
	assign highScore = highScoreReg;
	assign menuState = state;
	assign resetComp = reset_reg;
	assign song = song_reg;
	
endmodule
