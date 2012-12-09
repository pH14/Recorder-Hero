`timescale 1ns / 1ps
////////////////////////////////////////////////////
//
// picture_blob: display a picture
//
//////////////////////////////////////////////////
module picture_blob
	#(parameter WIDTH = 72, HEIGHT=512)
	(input pixel_clk,
	input [10:0] x,hcount,
	input [9:0] y,vcount,
	output reg [23:0] pixel);
	
	wire [15:0] image_addr; // num of bits for 8*50000 ROM
	wire [7:0] image_bits, red_mapped, green_mapped,
	blue_mapped;
	// note the one clock cycle delay in pixel!
	always @ (posedge pixel_clk) begin
		if ((hcount >= x && hcount < (x+WIDTH)) &&
			(vcount >= y && vcount < (y+HEIGHT)))
			pixel <= {red_mapped, green_mapped, blue_mapped};
		else pixel <= 0;
	end
	
	// calculate rom address and read the location
	assign image_addr = (hcount-x) + (vcount-y) * WIDTH;
	note_letters_bmp nl_rom(pixel_clk, image_addr, image_bits);
	
	// use color map to create 8bits R, 8bits G, 8 bits B;
	assign red_mapped = (image_bits == 8'h00) ? 8'h00 : 8'hFF;
	assign green_mapped = (image_bits == 8'h00) ? 8'h00 : 8'hFF;
	assign blue_mapped = (image_bits == 8'h00) ? 8'h00 : 8'hFF;
//	notes_red_map rcm (pixel_clk, image_bits, red_mapped);
//	notes_green_map gcm (pixel_clk, image_bits, green_mapped);
//	notes_blue_map bcm (pixel_clk, image_bits, blue_mapped);
endmodule


