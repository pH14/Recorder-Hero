`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:19 12/08/2012 
// Design Name: 
// Module Name:    hexToAscii 
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
module hexToAscii(
    input [3:0] hex,
    input clk,
    output [15:0] asciiNote
    );
	
	parameter[7:0] space =  8'b00100000; 
	parameter[7:0] pound =  8'b00100011; 
	
	parameter[7:0] A = 8'b01000001; 
	parameter[7:0] B = 8'b01000010;
	parameter[7:0] C = 8'b01000011;
	parameter[7:0] D = 8'b01000100;
	parameter[7:0] E = 8'b01000101;
	parameter[7:0] F = 8'b01000110; 
	parameter[7:0] G = 8'b01000111;
	
	reg [15:0] ascii;
	
	//Takes hex representation of note and translates to ascii.
	always @(posedge clk) begin
		case (hex)
			4'b0000: ascii <= {space,space};
			4'b0001: ascii <= {C,space};
			4'b0010: ascii <= {C,pound};
			4'b0011: ascii <= {D,space};
			4'b0100: ascii <= {D,pound};
			4'b0101: ascii <= {E,space};
			4'b0110: ascii <= {F,space};
			4'b0111: ascii <= {F,pound};
			4'b1000: ascii <= {G,space};
			4'b1001: ascii <= {G,pound};
			4'b1010: ascii <= {A,space};
			4'b1011: ascii <= {A,pound};
			4'b1100: ascii <= {B,space};
			default: ascii <= {space,space};
		endcase
	end
	
	assign asciiNote = ascii;
	

endmodule
