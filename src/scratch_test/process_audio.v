`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:37:04 12/03/2012 
// Design Name: 
// Module Name:    process_audio 
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
module process_audio(clock_27mhz,reset,ready,from_ac97_data,haddr,hdata,hwe);
  input clock_27mhz;
  input reset;
  input ready;
  input [15:0] from_ac97_data;
  output [11:0] haddr;
  output [9:0] hdata;
  output hwe;

  wire signed [22:0] xk_re,xk_im;
  wire [11:0] xk_index;

  // IP Core Gen -> Digital Signal Processing -> Transforms -> FFTs
  // -> Fast Fourier Transform v3.2
  // Transform length: 16384
  // Implementation options: Pipelined, Streaming I/O
  // Transform length options: none
  // Input data width: 8
  // Phase factor width: 8
  // Optional pins: CE
  // Scaling options: Unscaled
  // Rounding mode: Truncation
  // Number of stages using Block Ram: 7
  // Output ordering: Bit/Digit Reversed Order
  
  my_fft fft(.clk(clock_27mhz), .ce(ready | reset),
                .xn_re(from_ac97_data[15:8]), .xn_im(8'b0),
                .start(1'b1), .fwd_inv(1'b1), .fwd_inv_we(reset),
                .xk_re(xk_re), .xk_im(xk_im), .xk_index(xk_index));

  // process fft data
  parameter [3:0] sel = 4'b1000;
  reg [2:0] state;
  reg [11:0] haddr;
  reg [19:0] rere,imim;
  reg [19:0] mag2;
  wire signed [9:0] xk_re_scaled = xk_re >> sel;
  wire signed [9:0] xk_im_scaled = xk_im >> sel;
  reg hwe;
  wire sqrt_done;


  always @ (posedge clock_27mhz) begin
    hwe <= 0;
    if (reset) begin
      state <= 0;
    end
    else case (state)
     3'h0: if (ready) state <= 1;
     3'h1: begin
			state <= 0;
			if (xk_index == 12'b000000101010) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000100011011) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000011010100) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000101100) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000010010) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000010110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001000010) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000010111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000100101100) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001011001) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001010100) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000100001) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000100111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000001111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000010011111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000010010110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000001110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000010001) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001001011) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000001100) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001101010) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000011001000) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000100111110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000001011) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000010111101) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000001110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000011111100) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000100001011) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000010110010) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000100101) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000011100001) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000011101110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000011101) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000100011) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000101010001) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001111110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000111111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000010001101) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001110111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000011001) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000011100) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000010101000) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000001101) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000111000) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000011010) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000111011) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001000110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000010011) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000011111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000010101) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001001111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000010000) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001011110) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001100100) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000001110000) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000101111) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000110101) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000010000101) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000001011) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
			if (xk_index == 12'b000000110010) begin
				state <= 2;
				haddr <= xk_index;
				rere <= xk_re_scaled * xk_re_scaled;
				imim <= xk_im_scaled * xk_im_scaled;
			end
	  end
     3'h2: begin
	     state <= 3;
             mag2 <= rere + imim;
           end
     3'h3: if (sqrt_done) begin
	     state <= 0;
             hwe <= 1;
           end
    endcase
  end

  wire [9:0] mag;
  sqrt sqmag(clock_27mhz,mag2,state==2,mag,sqrt_done);
  defparam sqmag.NBITS = 20;

  assign hdata = mag;

endmodule

module sqrt(clk,data,start,answer,done);
  parameter NBITS = 8;  // max 32
  parameter MBITS = (NBITS+1)/2;
  input clk,start;
  input [NBITS-1:0] data;
  output [MBITS-1:0] answer;
  output done;

  reg [MBITS-1:0] answer;
  reg busy;
  reg [4:0] bit;

  wire [MBITS-1:0] trial = answer | (1 << bit);

  always @ (posedge clk) begin
    if (busy) begin
      if (bit == 0) busy <= 0;
      else bit <= bit - 1;
      if (trial*trial <= data) answer <= trial;
    end
    else if (start) begin
      busy <= 1;
      answer <= 0;
      bit <= MBITS - 1;
    end
  end

  assign done = ~busy;
endmodule
