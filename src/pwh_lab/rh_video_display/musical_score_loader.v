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
    input song_id,
    output [63:0] next_notes_out
    );
	reg [6:0] read_addr;
	reg [3:0] next_notes[15:0];
	wire [3:0] next_note;
	
	lotr_song lotr(.clka(clk), .addra(read_addr), .douta(next_note));
	
	reg [25:0] temp_tempo = 26'b1111_0111_1111_0100_1001_0000_0;
	wire tempo_beat;
	
	counter c(.clk(clk),
				 .reset(load_tempo),
				 .count_to(temp_tempo),
				 .ready(tempo_beat));
	
	integer i;
	always @(posedge clk) begin
		if (reset) begin
			read_addr <= 7'b0;
			for (i=0; i < 16; i=i+1) begin
				next_notes[i] <= 4'b0;
			end
		end else if (tempo_beat) begin
			for (i=0; i < 15; i=i+1) begin
				next_notes[i] <= next_notes[i+1];
			end
			
			next_notes[15] <= next_note;
			read_addr <= read_addr + 1;
		end
	end
	
	assign next_notes_out = {next_notes[15], next_notes[14], next_notes[13],
									  next_notes[12], next_notes[11], next_notes[10],
									  next_notes[9], next_notes[8], next_notes[7],
									  next_notes[6], next_notes[5], next_notes[4],
									  next_notes[3], next_notes[2], next_notes[1],
									  next_notes[0]};

endmodule
