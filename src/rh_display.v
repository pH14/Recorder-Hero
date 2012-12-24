`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:52:27 11/26/2012 
// Design Name: 
// Module Name:    rh_display 
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
module rh_display (
	input vclock,
	input reset,
	input up,
	input down,
	
	input playing_correct,
	input [63:0] next_notes,
	input [25:0] tempo,
	
	input [10:0] hcount,
	input [9:0] vcount,
	input hsync,
	input vsync,
	input blank,
	output phsync,
	output pvsync,
	output pblank,
	output [23:0] pixel,
	output [63:0] debug
	);
	
	assign phsync = hsync;
	assign pvsync = vsync;
	assign pblank = blank;
	
	parameter [10:0] SCREEN_WIDTH = 1023;
	parameter [9:0] SCREEN_HEIGHT = 767;
	parameter NOTE_WIDTH = 64;
	parameter NOTE_HEIGHT = 24;
	parameter FIRST_LETTER = 550;
	parameter ACTION_LINE_X = 72;
	
	wire [3:0] notes[15:0];
	wire [23:0] note_pixels[15:0];
	reg [10:0] lead_note_x = 1023;
	
	parameter [23:0] COLOR = 24'hFF_FF_FF;
	
	assign {notes[15], notes[14], notes[13], notes[12],
			  notes[11], notes[10], notes[9], notes[8],
			  notes [7], notes[6], notes[5], notes[4],
			  notes [3], notes[2], notes[1], notes[0] } = next_notes;

	reg [9:0] note_y_pos[15:0];
	reg [23:0] note_color[15:0];
	
	integer k;
	always @(posedge vclock) begin
		for (k=0; k<16; k=k+1) begin
			case(notes[k])
				4'd0: note_y_pos[k] <= FIRST_LETTER;
				// C, C#
				4'd1:  note_y_pos[k] <= FIRST_LETTER + 6*32;
				4'd2:  note_y_pos[k] <= FIRST_LETTER + 6*32;
				// D, D#
				4'd3:  note_y_pos[k] <= FIRST_LETTER + 5*32;
				4'd4:  note_y_pos[k] <= FIRST_LETTER + 5*32;
				// E
				4'd5:  note_y_pos[k] <= FIRST_LETTER + 4*32;
				// F, F#
				4'd6:  note_y_pos[k] <= FIRST_LETTER + 3*32;
				4'd7:  note_y_pos[k] <= FIRST_LETTER + 3*32;
				// G, G#
				4'd8:  note_y_pos[k] <= FIRST_LETTER + 2*32;
				4'd9:  note_y_pos[k] <= FIRST_LETTER + 2*32;
				// A, A#
				4'd10: note_y_pos[k] <= FIRST_LETTER + 1*32;
				4'd11: note_y_pos[k] <= FIRST_LETTER + 1*32;
				// B
				4'd12: note_y_pos[k] <= FIRST_LETTER + 0*32;
				// C high
				4'd13: note_y_pos[k] <= FIRST_LETTER + 6*32;
				default: note_y_pos[k] <= FIRST_LETTER;
			endcase
			
			case(notes[k])
				// Don't display rests
				4'd0: note_color[k] <= 24'h00_00_00;
				// C#
				4'd2:  note_color[k] <= 24'h55_55_FF;
				// D#
				4'd4:  note_color[k] <= 24'h55_55_FF;
				// F#
				4'd7:  note_color[k] <= 24'h55_55_FF;
				// G#
				4'd9:  note_color[k] <= 24'h55_55_FF;
				// A#
				4'd11: note_color[k] <= 24'h55_55_FF;
				// C high
				4'd13: note_color[k] <= 24'h00_DD_00;
				default: note_color[k] <= 24'hFF_FF_FF;
			endcase
		end
		
		if (playing_correct) begin
			note_color[0] <= 24'hFF_FF_00;
		end
	end
	
	genvar j;
	generate
		for(j=0; j<16; j=j+1) begin:generate_note_blobs
		  blob #(.WIDTH(NOTE_WIDTH), .HEIGHT(NOTE_HEIGHT))
				note(.x(lead_note_x + NOTE_WIDTH * j),
					  .y(note_y_pos[j]),
					  .hcount(hcount),
					  .vcount(vcount),
					  .color(note_color[j]),
					  .pixel(note_pixels[j]));
		end
	endgenerate

	reg load_tempo = 0;
	
	// Temporary tempo is 1/2 vclock, .5s per eighth note
	reg [25:0] temp_tempo = 26'b1111_0111_1111_0100_1001_0000_0;
	wire tempo_beat;
	wire tempo_beat_move;
	
	counter c(.clk(vclock),
				 .reset(load_tempo),
				 .count_to(temp_tempo),
				 .ready(tempo_beat));
	
	// The width of one note is 64, break the tempo up by 64
	// to know the interval we need to move the notes by 1px
	counter c2(.clk(vclock),
				 .reset(load_tempo),
				 .count_to(temp_tempo/64),
				 .ready(tempo_beat_move));
	
	always @(posedge vclock) begin
		if (reset) begin
			lead_note_x <= ACTION_LINE_X;
			load_tempo = 1;
		end else begin
			load_tempo = 0;
		end
		
		// Debug single note
		if (hcount == 1 && vcount == 1) begin
			if (up) begin
				lead_note_x <= lead_note_x - 4;
			end else if (down) begin
				lead_note_x <= lead_note_x + 4;
			end 
		end
		
		if (tempo_beat_move) begin
			lead_note_x <= lead_note_x - 1;
		end else if (tempo_beat) begin
			lead_note_x <= ACTION_LINE_X;
		end
	end
	
	// character display module: sample string in middle of screen
	// char height = 24px
   wire [55:0] cstring = "BAGFEDC";
   wire [2:0] cdpixel[6:0];
	
	genvar i;
	generate
		for(i=0; i<7; i=i+1) begin:generate_characters
		  char_string_display csd(.vclock(vclock), 
										  .hcount(hcount), 
										  .vcount(vcount),
										  .pixel(cdpixel[i]),
										  .cstring(cstring[8*(i+1)-1 : 8*i]),
										  .cx(11'd24),
										  .cy(FIRST_LETTER + 192 - 32*i));
			defparam csd.NCHAR = 1;
		end
	endgenerate
	
	wire action_line = hcount == ACTION_LINE_X & vcount >= 550;
   
	reg [23:0] onscreen_notes[15:0];
	
	integer n;
	always @(posedge vclock) begin
		for (n=0; n<16; n=n+1) begin
			onscreen_notes[n] <= (hcount > ACTION_LINE_X) ? note_pixels[n] : 0;
		end
	end
	
	wire [23:0] bmp_pixel;
	picture_blob pb(.pixel_clk(vclock),
					    .x(15),
						 .hcount(hcount),
						 .y(15),
						 .vcount(vcount),
						 .pixel(bmp_pixel));
	
	assign pixel = onscreen_notes[0]
						| onscreen_notes[1]
						| onscreen_notes[2]
						| onscreen_notes[3]
						| onscreen_notes[4]
						| onscreen_notes[5]
						| onscreen_notes[6]
						| onscreen_notes[7]
						| onscreen_notes[8]
						| onscreen_notes[9]
						| onscreen_notes[10]
						| onscreen_notes[11]
						| onscreen_notes[12]
						| onscreen_notes[13]
						| onscreen_notes[14]
						| onscreen_notes[15]
						| {8{cdpixel[6]}}
						| {8{cdpixel[5]}} 
						| {8{cdpixel[4]}}
						| {8{cdpixel[3]}} 
						| {8{cdpixel[2]}}
						| {8{cdpixel[1]}} 
						| {8{cdpixel[0]}}
						| {24{action_line}}
						| bmp_pixel;
						
	assign debug = {next_notes[63:60], 15};
endmodule
