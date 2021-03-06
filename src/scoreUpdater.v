`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:57 11/20/2012 
// Design Name: 
// Module Name:    scoreUpdater 
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
module scoreUpdater(
    input clk,
    input [3:0] currentNote,
	 input [3:0] correctNote,
    input reset,
    output hit,
    output score,
    output [3:0] notePlayed,
	 output [17:0] binaryOut
    );

	// Hex representation of notes
	parameter[3:0] Z = 4'b0000;
	parameter[3:0] C = 4'b0001;
	parameter[3:0] Cs = 4'b0010;
	parameter[3:0] D = 4'b0011;
	parameter[3:0] Ds = 4'b0100;
	parameter[3:0] E	= 4'b0101;
	parameter[3:0] F = 4'b0110;
	parameter[3:0] Fs = 4'b0111;
	parameter[3:0] G = 4'b1000;
	parameter[3:0] Gs = 4'b1001;
	parameter[3:0] A = 4'b1010;
	parameter[3:0] As = 4'b1011;
	parameter[3:0] B = 4'b1100;
	parameter[3:0] Chigh = 4'b1101;
	parameter[3:0] Dhigh = 4'b1110;

	reg hitReg = 0;
	reg scoreReg = 0;
	reg[16:0] scoreCount = 0;
	reg[3:0] notePlayedReg;
	reg[17:0] binaryScoreReg;
	
	
	always @(posedge clk) begin
		//Stop saying it was a hit if last clock was a hit
		if (hitReg) begin 
			hitReg <= 0;
		end
		//Stop saying to up the score in ascii if last clock said so
		if (scoreReg) scoreReg <= 0;
		//If the counter reached max value, output one on the score for ascii, add one to the binary representation for high score purposes
		if (&scoreCount) begin
			scoreReg <= 1;
			binaryScoreReg <= binaryScoreReg + 1;
		end
		
		if(reset) begin
			scoreReg <= 0;
			scoreCount <= 0 ;
			binaryScoreReg <= 0;
		end
		
		//Bug reproduced off by one hex values from note identification, this is the fix
		notePlayedReg <= currentNote - 1;
		if (currentNote == C) begin
			notePlayedReg <= B;
			if (correctNote == B) begin
				hitReg <= 1;
				scoreCount <= scoreCount + 1;
			end
		end
		else if ((currentNote - 4'd1) == correctNote) begin
			hitReg <= 1;
			scoreCount <= scoreCount + 1;
		end
		
		//Seperately check Chigh and Dhigh, the higher octave versions
		else if (correctNote == Chigh) begin
			if (currentNote == Cs)begin
				hitReg <= 1;
				scoreCount <= scoreCount + 1;
			end
		end
		else if (correctNote == Dhigh) begin
			if (currentNote == Ds)begin
				hitReg <= 1;
				scoreCount <= scoreCount + 1;
			end
		end
	end
	
	assign binaryOut = binaryScoreReg;
	assign hit = hitReg;
	assign score = scoreReg;
	assign notePlayed = notePlayedReg;

endmodule
