`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:40:51 11/26/2012 
// Design Name: 
// Module Name:    musical_score_loader 
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
module musical_score_loader(
    input clk,
    input reset,
    input [1:0] song_id,
    output [25:0] tempo_out,
    output [63:0] next_notes_out,
    output song_done
    );
	
	reg [7:0] read_addr = 0;
	reg [3:0] next_notes[15:0];
	reg [25:0] tempo;
	reg song_has_ended = 1;

	wire [3:0] next_note_lotr;
	wire [3:0] next_note_ss;
	wire [3:0] next_note_saints;
	wire [3:0] next_note_greensleeves;
	
	// Load each song in
	song_scales ss(.clka(clk), .addra(read_addr), .douta(next_note_ss));
	lotr_song lotr(.clka(clk), .addra(read_addr), .douta(next_note_lotr));
	when_the_saints wts(.clka(clk), .addra(read_addr), .douta(next_note_saints));
	greensleeves gs(.clka(clk), .addra(read_addr), . douta(next_note_greensleeves));
	
	
	// Counter will produce the song's beat
	wire tempo_beat;
	counter c(.clk(clk),
		  .reset(reset),
		  .count_to(tempo),
		  .ready(tempo_beat));
	
	// Each song's tempo stored here. The tempos are put into the counter,
	// the beat will be how long it takes for the clock to count to that value
	always @(*) begin
		case(song_id)
			2'b00: tempo = 26'b00_1111_0111_1111_0100_1001_0000;
			2'b01: tempo = 26'b00_1111_0111_1111_0100_1001_0000;
			2'b10: tempo = 26'b0_1111_0111_1111_0100_1001_0000_0;
			2'b11: tempo = 26'b0_1111_0111_1111_0100_1001_0000_0;
			default: tempo = 26'b0_1111_0111_1111_0100_1001_0000_0;
		endcase
	end
	
	integer i;
	always @(posedge clk) begin
		if (reset) begin
			read_addr <= 7'b0;
			song_has_ended <= 0;
			
			// When a song reloads fill it rests initially
			for (i=0; i < 16; i=i+1) begin
				next_notes[i] <= 4'b0000;
			end
		end else if (tempo_beat) begin
			// Shift each note
			for (i=0; i < 15; i=i+1) begin
				next_notes[i] <= next_notes[i+1];
			end
			
			// Find the next note to load, this is where different
			// songs are loaded into the game
			if (song_has_ended == 1) begin
				next_notes[15] <= 4'b0000;
			end else begin
				case(song_id)
					2'b00: next_notes[15] <= next_note_lotr;
					2'b01: next_notes[15] <= next_note_saints;
					2'b10: next_notes[15] <= next_note_greensleeves;
					2'b11: next_notes[15] <= next_note_ss;
					default: next_notes[15] <= 4'b0000;
				endcase
				
				read_addr <= read_addr + 1;
			end
			
			if (next_notes[15] == 4'b1111) song_has_ended <= 1;
		end
	end
	
	assign next_notes_out = { next_notes[15], next_notes[14], next_notes[13],
				  next_notes[12], next_notes[11], next_notes[10],
				  next_notes[9], next_notes[8], next_notes[7],
				  next_notes[6], next_notes[5], next_notes[4],
				  next_notes[3], next_notes[2], next_notes[1],
				  next_notes[0]};
	assign song_done = (next_notes[0] == 4'b1111);
	assign tempo_out = tempo;
endmodule
