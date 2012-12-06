`timescale 1ns / 1ps
////////////////////////////////////////////////////
//
// picture_blob: display a picture
//
//////////////////////////////////////////////////
module bono_picture_blob
	#(parameter WIDTH = 1023, HEIGHT=767)
	(input pixel_clk,
	input [10:0] x,hcount,
	input [9:0] y,vcount,
	output reg [23:0] pixel);
	
	wire [19:0] image_addr; // num of bits for 20 
	wire [7:0] image_bits, red_mapped, green_mapped, blue_mapped;
	// note the one clock cycle delay in pixel!
	always @ (posedge pixel_clk) begin
		if ((hcount >= x && hcount < (x+WIDTH)) &&
			(vcount >= y && vcount < (y+HEIGHT)))
			pixel <= {red_mapped, green_mapped, blue_mapped};
		else pixel <= 0;
	end
	
	// calculate rom address and read the location
	assign image_addr = (hcount-x) + (vcount-y) * WIDTH;
	//bono_pixels b_rom(pixel_clk, image_addr, image_bits);
	
	bono_blue b_blue(image_bits, pixel_clk, blue_mapped);
	bono_red b_red(image_bits, pixel_clk, red_mapped);
	bono_green b_green(image_bits, pixel_clk, green_mapped);
endmodule


