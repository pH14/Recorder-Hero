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
	wire [7:0] image_bits;
	// note the one clock cycle delay in pixel!
	always @ (posedge pixel_clk) begin
		if ((hcount >= x && hcount < (x+WIDTH)) &&
			(vcount >= y && vcount < (y+HEIGHT)))
				pixel <= {3{image_bits}};
		else pixel <= 0;
	end
	
	// calculate rom address and read the location
	assign image_addr = (hcount-x) + (vcount-y) * WIDTH;
	note_letters nl(.addra(image_addr), .clka(clock_65mhz), .douta(image_bits));
endmodule

