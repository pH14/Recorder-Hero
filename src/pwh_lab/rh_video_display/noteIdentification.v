`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:17:36 11/29/2012 
// Design Name: 
// Module Name:    noteIdentification 
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
module noteIdentification(reset,clk,ready,switch,from_ac97_data,note,GuessAddr,readVal,analyzer1_out,analyzer2_out);
    input reset;
    input clk;
    input ready;
	 input [7:0] switch;
    input [15:0] from_ac97_data;
    output [3:0] note;
	 output reg[5:0] GuessAddr;
	 output readVal;
	 output [15:0] analyzer1_out;
	 output [15:0] analyzer2_out;

	wire[9:0] threshold;
	
	assign threshold = {2'd0,switch[7:0]};

    //Hex representation of each note
	parameter[3:0] Z = 4'b0000;
	parameter[3:0] C = 4'b0001;
	parameter[3:0] Cs = 4'b0010;
	parameter[3:0] D = 4'b0011;
	parameter[3:0] Ds = 4'b0100;
	parameter[3:0] E	= 4'b0101;
	parameter[3:0] F = 4'b0110;
	parameter[3:0] Fs = 4'b0111;
	parameter[3:0] G = 4'b1000;
	parameter[3:0] Gs = 4'b1001;
	parameter[3:0] A = 4'b1010;
	parameter[3:0] As = 4'b1011;
	parameter[3:0] B = 4'b1100;
	
	//Bin number for each note we sample (from 5 different octaves)
	parameter[11:0] Btwo = 12'b000000101010;
	parameter[11:0] GSfive = 12'b000100011011;
	parameter[11:0] DSfive = 12'b000011010100;
	parameter[11:0] Cthree = 12'b000000101100;
	parameter[11:0] Aone = 12'b000000010010;
	parameter[11:0] Ctwo = 12'b000000010110;
	parameter[11:0] Gthree = 12'b000001000010;
	parameter[11:0] CStwo = 12'b000000010111;
	parameter[11:0] Afive = 12'b000100101100;
	parameter[11:0] Cfour = 12'b000001011001;
	parameter[11:0] Bthree = 12'b000001010100;
	parameter[11:0] Gtwo = 12'b000000100001;
	parameter[11:0] AStwo = 12'b000000100111;
	parameter[11:0] FSone = 12'b000000001111;
	parameter[11:0] ASfour = 12'b000010011111;
	parameter[11:0] Afour = 12'b000010010110;
	parameter[11:0] Fone = 12'b000000001110;
	parameter[11:0] GSone = 12'b000000010001;
	parameter[11:0] Athree = 12'b000001001011;
	parameter[11:0] Done = 12'b000000001100;
	parameter[11:0] DSfour = 12'b000001101010;
	parameter[11:0] Dfive = 12'b000011001000;
	parameter[11:0] ASfive = 12'b000100111110;
	parameter[11:0] CSone = 12'b000000001011;
	parameter[11:0] CSfive = 12'b000010111101;
	parameter[11:0] Eone = 12'b000000001110;
	parameter[11:0] FSfive = 12'b000011111100;
	parameter[11:0] Gfive = 12'b000100001011;
	parameter[11:0] Cfive = 12'b000010110010;
	parameter[11:0] Atwo = 12'b000000100101;
	parameter[11:0] Efive = 12'b000011100001;
	parameter[11:0] Ffive = 12'b000011101110;
	parameter[11:0] Ftwo = 12'b000000011101;
	parameter[11:0] GStwo = 12'b000000100011;
	parameter[11:0] Bfive = 12'b000101010001;
	parameter[11:0] FSfour = 12'b000001111110;
	parameter[11:0] FSthree = 12'b000000111111;
	parameter[11:0] GSfour = 12'b000010001101;
	parameter[11:0] Ffour = 12'b000001110111;
	parameter[11:0] Dtwo = 12'b000000011001;
	parameter[11:0] Etwo = 12'b000000011100;
	parameter[11:0] Bfour = 12'b000010101000;
	parameter[11:0] DSone = 12'b000000001101;
	parameter[11:0] Ethree = 12'b000000111000;
	parameter[11:0] DStwo = 12'b000000011010;
	parameter[11:0] Fthree = 12'b000000111011;
	parameter[11:0] GSthree = 12'b000001000110;
	parameter[11:0] ASone = 12'b000000010011;
	parameter[11:0] FStwo = 12'b000000011111;
	parameter[11:0] Bone = 12'b000000010101;
	parameter[11:0] ASthree = 12'b000001001111;
	parameter[11:0] Gone = 12'b000000010000;
	parameter[11:0] CSfour = 12'b000001011110;
	parameter[11:0] Dfour = 12'b000001100100;
	parameter[11:0] Efour = 12'b000001110000;
	parameter[11:0] CSthree = 12'b000000101111;
	parameter[11:0] DSthree = 12'b000000110101;
	parameter[11:0] Gfour = 12'b000010000101;
	parameter[11:0] Cone = 12'b000000001011;
	parameter[11:0] Dthree = 12'b000000110010;


	reg done;
	reg[3:0] currentGuess = 0;

	wire [11:0] haddr;
	wire [9:0] hdata;
	wire hwe;
	
	//fft module, returns bin number and magnitude given ac97 signal
	process_audio audio(clk,reset,ready,from_ac97_data,haddr,hdata,hwe);
	
	reg[5:0] writeaddr = 0;
	wire [5:0] writeaddrZ;
	reg writeVal = 0;
	wire writeValz;
	reg write = 0;
	wire writeZ;
	reg writeNext;
	
	assign writeZ = write;
	assign writeaddrZ = writeaddr;
	assign writeValZ = writeVal;
	
	//Use a clock cycle to turn process audio outputs into a proper ram input
	always @(posedge clk) begin
		// If process_audio has a new value
		if (hwe) begin
		   writeNext <= 1;
		   // From bin determine the ram address
			if (haddr == Cone) writeaddr <= 6'd0;
			if (haddr == CSone) writeaddr <= 6'd1;
			if (haddr == Done) writeaddr <= 6'd2;
			if (haddr == DSone) writeaddr <= 6'd3;
			if (haddr == Eone) writeaddr <= 6'd4;
			if (haddr == Fone) writeaddr <= 6'd5;
			if (haddr == FSone) writeaddr <= 6'd6;
			if (haddr == Gone) writeaddr <= 6'd7;
			if (haddr == GSone) writeaddr <= 6'd8;
			if (haddr == Aone) writeaddr <= 6'd9;
			if (haddr == ASone) writeaddr <= 6'd10;
			if (haddr == Bone) writeaddr <= 6'd11;
			if (haddr == Ctwo) writeaddr <= 6'd12;
			if (haddr == CStwo) writeaddr <= 6'd13;
			if (haddr == Dtwo) writeaddr <= 6'd14;
			if (haddr == DStwo) writeaddr <= 6'd15;
			if (haddr == Etwo) writeaddr <= 6'd16;
			if (haddr == Ftwo) writeaddr <= 6'd17;
			if (haddr == FStwo) writeaddr <= 6'd18;
			if (haddr == Gtwo) writeaddr <= 6'd19;
			if (haddr == GStwo) writeaddr <= 6'd20;
			if (haddr == Atwo) writeaddr <= 6'd21;
			if (haddr == AStwo) writeaddr <= 6'd22;
			if (haddr == Bthree) writeaddr <= 6'd23;
			if (haddr == Cthree) writeaddr <= 6'd24;
			if (haddr == CSthree) writeaddr <= 6'd25;
			if (haddr == Dthree) writeaddr <= 6'd26;
			if (haddr == DSthree) writeaddr <= 6'd27;
			if (haddr == Ethree) writeaddr <= 6'd28;
			if (haddr == Fthree) writeaddr <= 6'd29;
			if (haddr == FSthree) writeaddr <= 6'd30;
			if (haddr == Gthree) writeaddr <= 6'd31;
			if (haddr == GSthree) writeaddr <= 6'd32;
			if (haddr == Athree) writeaddr <= 6'd33;
			if (haddr == ASthree) writeaddr <= 6'd34;
			if (haddr == Bthree) writeaddr <= 6'd35;
			if (haddr == Cfour) writeaddr <= 6'd36;
			if (haddr == CSfour) writeaddr <= 6'd37;
			if (haddr == Dfour) writeaddr <= 6'd38;
			if (haddr == DSfour) writeaddr <= 6'd39;
			if (haddr == Efour) writeaddr <= 6'd40;
			if (haddr == Ffour) writeaddr <= 6'd41;
			if (haddr == FSfour) writeaddr <= 6'd42;
			if (haddr == Gfour) writeaddr <= 6'd43;
			if (haddr == GSfour) writeaddr <= 6'd44;
			if (haddr == Afour) writeaddr <= 6'd45;
			if (haddr == ASfour) writeaddr <= 6'd46;
			if (haddr == Bfour) writeaddr <= 6'd47;
			if (haddr == Cfive) writeaddr <= 6'd48;
			if (haddr == CSfive) writeaddr <= 6'd49;
			if (haddr == Dfive) writeaddr <= 6'd50;
			if (haddr == DSfive) writeaddr <= 6'd51;
			if (haddr == Efive) writeaddr <= 6'd52;
			if (haddr == Ffive) writeaddr <= 6'd53;
			if (haddr == FSfive) writeaddr <= 6'd54;
			if (haddr == Gfive) writeaddr <= 6'd55;
			if (haddr == GSfive) writeaddr <= 6'd56;
			if (haddr == Afive) writeaddr <= 6'd57;
			if (haddr == ASfive) writeaddr <= 6'd58;
			if (haddr == Bfive) writeaddr <= 6'd59;

			//Now set the write value (note was detected if over a threshold)
			if (hdata > threshold) writeVal <= 1;
			else writeVal <= 0;
		
		end
		//delay write one cycle to assure correct values
		else begin
			if (writeNext) begin
				write <= 1;
				writeNext <= 0;
			end
			else write <= 0;
		end
	end
	
	reg[5:0] currentAddr = 0;
	wire[5:0] readaddr;
	reg[5:0] cycleAddr;
	reg cycleVal;
	
	//Ram that holds the most current values for all 60 notes, and which we read to determine the lowest note played
	cache fftcache(.addra(writeaddrZ),.dina(writeValZ),.wea(write),.clka(clk),
						.addrb(readaddr),.clkb(clk),.doutb(readVal));

	always @(posedge clk) begin
		//reset, done on reset or every time a new value is placed in the ram
		if (hwe | reset) begin
			done <= 0;
			currentAddr <= 0;
			currentGuess <= 0;
		end
		//If I haven't found a note played this cycle
		if (!done) begin
			//If the value read is a one (note played)
			if (readVal) begin
				//Determine the note that was played
				case(currentAddr)
					6'd0: currentGuess <= C;
					6'd1: currentGuess <= Cs;
					6'd2: currentGuess <= D;
					6'd3: currentGuess <= Ds;
					6'd4: currentGuess <= E;
					6'd5: currentGuess <= F;
					6'd6: currentGuess <= Fs;
					6'd7: currentGuess <= G;
					6'd8: currentGuess <= Gs;
					6'd9: currentGuess <= A;
					6'd10: currentGuess <= As;
					6'd11: currentGuess <= B;
					6'd12: currentGuess <= C;
					6'd13: currentGuess <= Cs;
					6'd14: currentGuess <= D;
					6'd15: currentGuess <= Ds;
					6'd16: currentGuess <= E;
					6'd17: currentGuess <= F;
					6'd18: currentGuess <= Fs;
					6'd19: currentGuess <= G;
					6'd20: currentGuess <= Gs;
					6'd21: currentGuess <= A;
					6'd22: currentGuess <= As;
					6'd23: currentGuess <= B;
					6'd24: currentGuess <= C;
					6'd25: currentGuess <= Cs;
					6'd26: currentGuess <= D;
					6'd27: currentGuess <= Ds;
					6'd28: currentGuess <= E;
					6'd29: currentGuess <= F;
					6'd30: currentGuess <= Fs;
					6'd31: currentGuess <= G;
					6'd32: currentGuess <= Gs;
					6'd33: currentGuess <= A;
					6'd34: currentGuess <= As;
					6'd35: currentGuess <= B ;
					6'd36: currentGuess <= C;
					6'd37: currentGuess <= Cs;
					6'd38: currentGuess <= D ;
					6'd39: currentGuess <= Ds;
					6'd40: currentGuess <= E ;
					6'd41: currentGuess <= F ;
					6'd42: currentGuess <= Fs;
					6'd43: currentGuess <= G ;
					6'd44: currentGuess <= Gs;
					6'd45: currentGuess <= A ;
					6'd46: currentGuess <= As;
					6'd47: currentGuess <= B ;
					6'd48: currentGuess <= C;
					6'd49: currentGuess <= Cs;
					6'd50: currentGuess <= D ;
					6'd51: currentGuess <= Ds;
					6'd52: currentGuess <= E ;
					6'd53: currentGuess <= F ;
					6'd54: currentGuess <= Fs;
					6'd55: currentGuess <= G ;
					6'd56: currentGuess <= Gs;
					6'd57: currentGuess <= A ;
					6'd58: currentGuess <= As;
					6'd59: currentGuess <= B ;
					default:;
				endcase
				//Debugging purposes
				GuessAddr <= currentAddr;
				//Stop until next cycle
				done <= 1;
			end
			//If found 0, try the next bin
			else currentAddr <= currentAddr + 1;
		end
	end

	assign readaddr = currentAddr;
	assign note = currentGuess;


	assign analyzer1_out = {hdata[5:0],writeaddrZ,writeValZ,hwe,clk,ready};
	assign analyzer2_out = {hdata[9:6],haddr};

endmodule
