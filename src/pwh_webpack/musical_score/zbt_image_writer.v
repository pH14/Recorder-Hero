`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:04:23 12/06/2012 
// Design Name: 
// Module Name:    zbt_image_writer 
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
module zbt_image_writer(
    input clk,
    input reset,
    input [7:0] image_data,
    input new_input,
	 output new_output,
	 output [35:0] image_data_zbt
    );

	reg n_out = 0;
	reg [2:0] count = 0;
	reg [35:0] image_row = 36'b0;
	
	always @(posedge clk) begin
		if (reset) begin
			count <= 0;
			image_row <= 36'b0;
			n_out <= 0;
		end else begin
			if (new_input) begin
				if (count == 3) begin
					count <= 0;
					image_row[35:32] <= 4'h0;
					n_out <= 1;
				end else begin
					count <= count + 1;
				end
				
				if (count == 0) begin
					image_row[35:0] <= 36'b0;
				end
				
				image_row[(count+1)*8-1 -: 8] <= image_data;
			end else begin
				n_out <= 0;
			end
		end
	end
	
	assign new_output = n_out;
	assign image_data_zbt = (n_out == 1) ? image_row : 36'b0;

endmodule
