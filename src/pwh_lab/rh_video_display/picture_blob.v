`timescale 1ns / 1ps
////////////////////////////////////////////////////
//
// picture_blob: display a picture
//
//////////////////////////////////////////////////
module picture_blob
	#(parameter WIDTH = 72,
	// default picture width
	HEIGHT =512)
	// default picture height
	(input pixel_clk,
	input [10:0] x,hcount,
	input [9:0] y,vcount,
	output reg [23:0] pixel);
	
	wire [11:0] image_adr;
	// num of bits for 128*256 ROM
	wire [7:0] image_bits, red_mapped,
	green_mapped, blue_mapped;
	// note the one clock cycle delay in pixel!
	always @ (posedge pixel_clk) begin
		if ((hcount >= x && hcount < (x+WIDTH)) &&
			(vcount >= y && vcount < (y+HEIGHT)))
				pixel <= {red_mapped, green_mapped, blue_mapped};
		else pixel = 0;
	end
	// calculate rom address and read the location
	assign image_addr = (hcount-x) + (vcount-y) * WIDTH;
	image_rom note_letters(image_addr, clock_65mhz, image_bits);
	// use color map to create 8bits R, 8bits G, 8 bits B;
	red_color_map rcm (image_bits, pixel_clk, red_mapped);
	green_color_map gcm (image_bits, pixel_clk.green_mapped);
	blue_color_map bcm (image_bits, pixel_clk, blue_mapped);
endmodule

