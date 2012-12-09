`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:16:58 11/20/2012
// Design Name:   scoreUpdater
// Module Name:   /afs/athena.mit.edu/user/a/n/andresr/6.111work/fft_display/fft_display/score_Updater_Test.v
// Project Name:  fft_display
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: scoreUpdater
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module score_Updater_Test;

	// Inputs
	reg clk;
	reg [3:1] currentNote;
	reg A;
	reg As;
	reg B;
	reg Bs;
	reg C;
	reg Cs;
	reg D;
	reg Ds;
	reg E;
	reg Es;
	reg F;
	reg Fs;
	reg G;
	reg Gs;
	reg reset;

	// Outputs
	wire hit;
	wire [63:0] score;
	wire [3:1] note;

	// Instantiate the Unit Under Test (UUT)
	scoreUpdater uut (
		.clk(clk), 
		.currentNote(currentNote), 
		.A(A), 
		.As(As), 
		.B(B), 
		.Bs(Bs), 
		.C(C), 
		.Cs(Cs), 
		.D(D), 
		.Ds(Ds), 
		.E(E), 
		.Es(Es), 
		.F(F), 
		.Fs(Fs), 
		.G(G), 
		.Gs(Gs), 
		.reset(reset), 
		.hit(hit), 
		.score(score), 
		.note(note)
	);

always #1 clk = !clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		currentNote = 0;
		A = 0;
		As = 0;
		B = 0;
		Bs = 0;
		C = 0;
		Cs = 0;
		D = 0;
		Ds = 0;
		E = 0;
		Es = 0;
		F = 0;
		Fs = 0;
		G = 0;
		Gs = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
      		
		// Add stimulus here
		currentNote = 4'b0001;
		C = 1;
		#1000000;
		currentNote = 0;
		

	end
      
endmodule

