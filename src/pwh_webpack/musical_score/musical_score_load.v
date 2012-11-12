`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:34:43 11/10/2012 
// Design Name: 
// Module Name:    musical_score_load 
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
module musical_score_load(
    input clk,
    input reset,
    input [1:0] song_id,
    output [63:0] next_notes
    );
	 
	 parameter [10:0] SONG_LENGTH = 75;
	 wire [75:0] test_song = 76'b000000000000000000_00001001_0001001000110011001100110101010101010101001100110;
	 
	 reg [1:0] last_song;
	 
	 reg [3:0] next_output[15:0];
	 reg start_song;
	 reg load_tempo = 1'b0;
	 reg [25:0] tempo;
	 
	 reg [10:0] location_in_song = SONG_LENGTH - 26;
	 
	 reg [3:0] notes[15:0];
	 
	 wire song_changed = last_song == song_id ? 1 : 0;
	 wire eighth_note_enable = 0;
	 
	 divider eighth_note_divider(.clk(clk),
										  .reset(reset),
										  .load_tempo(load_tempo),
										  .count_to_input(tempo),
										  .eighth_note_enable(eighth_note_enable));
	
	always @(posedge clk) begin
		if (reset || song_changed) begin
			tempo <= test_song[SONG_LENGTH:SONG_LENGTH-26];
			load_tempo <= 1;
		end else if (eighth_note_enable) begin
			notes[15] <= notes[14];
			notes[0] <= 4'b0000;//test_song[location_in_song:location_in_song-4];
			location_in_song <= location_in_song - 4;
		end else begin
			load_tempo <= 0;
		end
	end
	
	assign next_notes[15:0] = { notes[15], notes[14], notes[13], notes[12], notes[11], notes[10],
										 notes[9], notes[8], notes[7], notes[6], notes[5], notes[4], notes[3],
										 notes[2], notes[1], notes[0] };
endmodule
