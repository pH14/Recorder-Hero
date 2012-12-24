///////////////////////////////////////////////////////////////////////////////
// Sample fft.v    gph 10/2012
//
// FFT was removed from ISE 10 to  minimize support for older Virtex FPGA.
// As a workaround, create the FFT from a ISE8.2 system and then compile
// using ISE 10
//
// step 1:  generate FFT using ISE 8.2
// step 2:  save project and open in ISE 10
// step 3:  in ISE 10 select ngc as project type
// step 4:  generate bit file
// step 5:  in ISE 10 change project type back to VDL
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
// Switch Debounce Module
//
///////////////////////////////////////////////////////////////////////////////

module debounce (reset, clock, noisy, clean);

   input reset, clock, noisy;
   output clean;

   reg [18:0] count;
   reg new, clean;

   always @(posedge clock)
     if (reset)
       begin
	  count <= 0;
	  new <= noisy;
	  clean <= noisy;
       end
     else if (noisy != new)
       begin
	  new <= noisy;
	  count <= 0;
       end
     else if (count == 270000)
       clean <= new;
     else
       count <= count+1;

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// bi-directional mono interface to AC97
//
///////////////////////////////////////////////////////////////////////////////
module fft_audio (clock_27mhz, reset, volume,
                  audio_in_data, audio_out_data, ready,
	          audio_reset_b, ac97_sdata_out, ac97_sdata_in,
                  ac97_synch, ac97_bit_clock);

   input clock_27mhz;
   input reset;
   input [4:0] volume;
   output [15:0] audio_in_data;
   input [15:0] audio_out_data;
   output ready;

   //ac97 interface signals
   output audio_reset_b;
   output ac97_sdata_out;
   input ac97_sdata_in;
   output ac97_synch;
   input ac97_bit_clock;

   wire [2:0] source;
   assign source = 0;	   //mic

   wire [7:0] command_address;
   wire [15:0] command_data;
   wire command_valid;
   wire [19:0] left_in_data, right_in_data;
   wire [19:0] left_out_data, right_out_data;

   reg audio_reset_b;
   reg [9:0] reset_count;

   //wait a little before enabling the AC97 codec
   always @(posedge clock_27mhz) begin
      if (reset) begin
         audio_reset_b = 1'b0;
         reset_count = 0;
      end else if (reset_count == 1023)
        audio_reset_b = 1'b1;
      else
        reset_count = reset_count+1;
   end

   wire ac97_ready;
   ac97 ac97(ac97_ready, command_address, command_data, command_valid,
             left_out_data, 1'b1, right_out_data, 1'b1, left_in_data,
             right_in_data, ac97_sdata_out, ac97_sdata_in, ac97_synch,
             ac97_bit_clock);

   // generate two pulses synchronous with the clock: first capture, then ready
   reg [2:0] ready_sync;
   always @ (posedge clock_27mhz) begin
     ready_sync <= {ready_sync[1:0], ac97_ready};
   end
   assign ready = ready_sync[1] & ~ready_sync[2];

   reg [15:0] out_data;
   always @ (posedge clock_27mhz)
     if (ready) out_data <= audio_out_data;
   assign audio_in_data = left_in_data[19:4];
   assign left_out_data = {out_data, 4'b0000};
   assign right_out_data = left_out_data;

   // generate repeating sequence of read/writes to AC97 registers
   ac97commands cmds(clock_27mhz, ready, command_address, command_data,
                     command_valid, volume, source);
endmodule

// assemble/disassemble AC97 serial frames
module ac97 (ready,
             command_address, command_data, command_valid,
             left_data, left_valid,
             right_data, right_valid,
             left_in_data, right_in_data,
             ac97_sdata_out, ac97_sdata_in, ac97_synch, ac97_bit_clock);

   output ready;
   input [7:0] command_address;
   input [15:0] command_data;
   input command_valid;
   input [19:0] left_data, right_data;
   input left_valid, right_valid;
   output [19:0] left_in_data, right_in_data;

   input ac97_sdata_in;
   input ac97_bit_clock;
   output ac97_sdata_out;
   output ac97_synch;

   reg ready;

   reg ac97_sdata_out;
   reg ac97_synch;

   reg [7:0] bit_count;

   reg [19:0] l_cmd_addr;
   reg [19:0] l_cmd_data;
   reg [19:0] l_left_data, l_right_data;
   reg l_cmd_v, l_left_v, l_right_v;
   reg [19:0] left_in_data, right_in_data;

   initial begin
      ready <= 1'b0;
      // synthesis attribute init of ready is "0";
      ac97_sdata_out <= 1'b0;
      // synthesis attribute init of ac97_sdata_out is "0";
      ac97_synch <= 1'b0;
      // synthesis attribute init of ac97_synch is "0";

      bit_count <= 8'h00;
      // synthesis attribute init of bit_count is "0000";
      l_cmd_v <= 1'b0;
      // synthesis attribute init of l_cmd_v is "0";
      l_left_v <= 1'b0;
      // synthesis attribute init of l_left_v is "0";
      l_right_v <= 1'b0;
      // synthesis attribute init of l_right_v is "0";

      left_in_data <= 20'h00000;
      // synthesis attribute init of left_in_data is "00000";
      right_in_data <= 20'h00000;
      // synthesis attribute init of right_in_data is "00000";
   end

   always @(posedge ac97_bit_clock) begin
      // Generate the sync signal
      if (bit_count == 255)
        ac97_synch <= 1'b1;
      if (bit_count == 15)
        ac97_synch <= 1'b0;

      // Generate the ready signal
      if (bit_count == 128)
        ready <= 1'b1;
      if (bit_count == 2)
        ready <= 1'b0;

      // Latch user data at the end of each frame. This ensures that the
      // first frame after reset will be empty.
      if (bit_count == 255)
        begin
           l_cmd_addr <= {command_address, 12'h000};
           l_cmd_data <= {command_data, 4'h0};
           l_cmd_v <= command_valid;
           l_left_data <= left_data;
           l_left_v <= left_valid;
           l_right_data <= right_data;
           l_right_v <= right_valid;
        end

      if ((bit_count >= 0) && (bit_count <= 15))
        // Slot 0: Tags
        case (bit_count[3:0])
          4'h0: ac97_sdata_out <= 1'b1;      // Frame valid
          4'h1: ac97_sdata_out <= l_cmd_v;   // Command address valid
          4'h2: ac97_sdata_out <= l_cmd_v;   // Command data valid
          4'h3: ac97_sdata_out <= l_left_v;  // Left data valid
	  4'h4: ac97_sdata_out <= l_right_v; // Right data valid
          default: ac97_sdata_out <= 1'b0;
        endcase

      else if ((bit_count >= 16) && (bit_count <= 35))
        // Slot 1: Command address (8-bits, left justified)
        ac97_sdata_out <= l_cmd_v ? l_cmd_addr[35-bit_count] : 1'b0;

      else if ((bit_count >= 36) && (bit_count <= 55))
        // Slot 2: Command data (16-bits, left justified)
        ac97_sdata_out <= l_cmd_v ? l_cmd_data[55-bit_count] : 1'b0;

      else if ((bit_count >= 56) && (bit_count <= 75))
        begin
           // Slot 3: Left channel
           ac97_sdata_out <= l_left_v ? l_left_data[19] : 1'b0;
           l_left_data <= { l_left_data[18:0], l_left_data[19] };
        end
      else if ((bit_count >= 76) && (bit_count <= 95))
        // Slot 4: Right channel
           ac97_sdata_out <= l_right_v ? l_right_data[95-bit_count] : 1'b0;
      else
        ac97_sdata_out <= 1'b0;

      bit_count <= bit_count+1;

   end // always @ (posedge ac97_bit_clock)

   always @(negedge ac97_bit_clock) begin
      if ((bit_count >= 57) && (bit_count <= 76))
        // Slot 3: Left channel
        left_in_data <= { left_in_data[18:0], ac97_sdata_in };
      else if ((bit_count >= 77) && (bit_count <= 96))
        // Slot 4: Right channel
        right_in_data <= { right_in_data[18:0], ac97_sdata_in };
   end

endmodule

// issue initialization commands to AC97
module ac97commands (clock, ready, command_address, command_data,
                     command_valid, volume, source);

   input clock;
   input ready;
   output [7:0] command_address;
   output [15:0] command_data;
   output command_valid;
   input [4:0] volume;
   input [2:0] source;

   reg [23:0] command;
   reg command_valid;

   reg [3:0] state;

   initial begin
      command <= 4'h0;
      // synthesis attribute init of command is "0";
      command_valid <= 1'b0;
      // synthesis attribute init of command_valid is "0";
      state <= 16'h0000;
      // synthesis attribute init of state is "0000";
   end

   assign command_address = command[23:16];
   assign command_data = command[15:0];

   wire [4:0] vol;
   assign vol = 31-volume;  // convert to attenuation

   always @(posedge clock) begin
      if (ready) state <= state+1;

      case (state)
        4'h0: // Read ID
          begin
             command <= 24'h80_0000;
             command_valid <= 1'b1;
          end
        4'h1: // Read ID
          command <= 24'h80_0000;
        4'h3: // headphone volume
          command <= { 8'h04, 3'b000, vol, 3'b000, vol };
        4'h5: // PCM volume
          command <= 24'h18_0808;
        4'h6: // Record source select
          command <= { 8'h1A, 5'b00000, source, 5'b00000, source};
        4'h7: // Record gain = max
	  command <= 24'h1C_0F0F;
        4'h9: // set +20db mic gain
          command <= 24'h0E_8048;
        4'hA: // Set beep volume
          command <= 24'h0A_0000;
        4'hB: // PCM out bypass mix1
          command <= 24'h20_8000;
        default:
          command <= 24'h80_0000;
      endcase // case(state)
   end // always @ (posedge clock)
endmodule // ac97commands

///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Template Toplevel Module
//
// For Labkit Revision 004
//
//
// Created: October 31, 2004, from revision 003 file
// Author: Nathan Ickes
//
///////////////////////////////////////////////////////////////////////////////
//
// CHANGES FOR BOARD REVISION 004
//
// 1) Added signals for logic analyzer pods 2-4.
// 2) Expanded "tv_in_ycrcb" to 20 bits.
// 3) Renamed "tv_out_data" to "tv_out_i2c_data" and "tv_out_sclk" to
//    "tv_out_i2c_clock".
// 4) Reversed disp_data_in and disp_data_out signals, so that "out" is an
//    output of the FPGA, and "in" is an input.
//
// CHANGES FOR BOARD REVISION 003
//
// 1) Combined flash chip enables into a single signal, flash_ce_b.
//
// CHANGES FOR BOARD REVISION 002
//
// 1) Added SRAM clock feedback path input and output
// 2) Renamed "mousedata" to "mouse_data"
// 3) Renamed some ZBT memory signals. Parity bits are now incorporated into 
//    the data bus, and the byte write enables have been combined into the
//    4-bit ram#_bwe_b bus.
// 4) Removed the "systemace_clock" net, since the SystemACE clock is now
//    hardwired on the PCB to the oscillator.
//
///////////////////////////////////////////////////////////////////////////////
//
// Complete change history (including bug fixes)
//
// 2005-Sep-09: Added missing default assignments to "ac97_sdata_out",
//              "disp_data_out", "analyzer[2-3]_clock" and
//              "analyzer[2-3]_data".
//
// 2005-Jan-23: Reduced flash address bus to 24 bits, to match 128Mb devices
//              actually populated on the boards. (The boards support up to
//              256Mb devices, with 25 address lines.)
//
// 2004-Oct-31: Adapted to new revision 004 board.
//
// 2004-May-01: Changed "disp_data_in" to be an output, and gave it a default
//              value. (Previous versions of this file declared this port to
//              be an input.)
//
// 2004-Apr-29: Reduced SRAM address busses to 19 bits, to match 18Mb devices
//              actually populated on the boards. (The boards support up to
//              72Mb devices, with 21 address lines.)
//
// 2004-Apr-29: Change history started
//
///////////////////////////////////////////////////////////////////////////////

module fft   (beep, audio_reset_b, ac97_sdata_out, ac97_sdata_in, ac97_synch,
	       ac97_bit_clock,
	       
	       vga_out_red, vga_out_green, vga_out_blue, vga_out_sync_b,
	       vga_out_blank_b, vga_out_pixel_clock, vga_out_hsync,
	       vga_out_vsync,

	       tv_out_ycrcb, tv_out_reset_b, tv_out_clock, tv_out_i2c_clock,
	       tv_out_i2c_data, tv_out_pal_ntsc, tv_out_hsync_b,
	       tv_out_vsync_b, tv_out_blank_b, tv_out_subcar_reset,

	       tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1,
	       tv_in_line_clock2, tv_in_aef, tv_in_hff, tv_in_aff,
	       tv_in_i2c_clock, tv_in_i2c_data, tv_in_fifo_read,
	       tv_in_fifo_clock, tv_in_iso, tv_in_reset_b, tv_in_clock,

	       ram0_data, ram0_address, ram0_adv_ld, ram0_clk, ram0_cen_b,
	       ram0_ce_b, ram0_oe_b, ram0_we_b, ram0_bwe_b, 

	       ram1_data, ram1_address, ram1_adv_ld, ram1_clk, ram1_cen_b,
	       ram1_ce_b, ram1_oe_b, ram1_we_b, ram1_bwe_b,

	       clock_feedback_out, clock_feedback_in,

	       flash_data, flash_address, flash_ce_b, flash_oe_b, flash_we_b,
	       flash_reset_b, flash_sts, flash_byte_b,

	       rs232_txd, rs232_rxd, rs232_rts, rs232_cts,

	       mouse_clock, mouse_data, keyboard_clock, keyboard_data,

	       clock_27mhz, clock1, clock2,

	       disp_blank, disp_data_out, disp_clock, disp_rs, disp_ce_b,
	       disp_reset_b, disp_data_in,

	       button0, button1, button2, button3, button_enter, button_right,
	       button_left, button_down, button_up,

	       switch,

	       led,
	       
	       user1, user2, user3, user4,
	       
	       daughtercard,

	       systemace_data, systemace_address, systemace_ce_b,
	       systemace_we_b, systemace_oe_b, systemace_irq, systemace_mpbrdy,
	       
	       analyzer1_data, analyzer1_clock,
 	       analyzer2_data, analyzer2_clock,
 	       analyzer3_data, analyzer3_clock,
 	       analyzer4_data, analyzer4_clock);

   output beep, audio_reset_b, ac97_synch, ac97_sdata_out;
   input  ac97_bit_clock, ac97_sdata_in;
   
   output [7:0] vga_out_red, vga_out_green, vga_out_blue;
   output vga_out_sync_b, vga_out_blank_b, vga_out_pixel_clock,
	  vga_out_hsync, vga_out_vsync;

   output [9:0] tv_out_ycrcb;
   output tv_out_reset_b, tv_out_clock, tv_out_i2c_clock, tv_out_i2c_data,
	  tv_out_pal_ntsc, tv_out_hsync_b, tv_out_vsync_b, tv_out_blank_b,
	  tv_out_subcar_reset;
   
   input  [19:0] tv_in_ycrcb;
   input  tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, tv_in_aef,
	  tv_in_hff, tv_in_aff;
   output tv_in_i2c_clock, tv_in_fifo_read, tv_in_fifo_clock, tv_in_iso,
	  tv_in_reset_b, tv_in_clock;
   inout  tv_in_i2c_data;
        
   inout  [35:0] ram0_data;
   output [18:0] ram0_address;
   output ram0_adv_ld, ram0_clk, ram0_cen_b, ram0_ce_b, ram0_oe_b, ram0_we_b;
   output [3:0] ram0_bwe_b;
   
   inout  [35:0] ram1_data;
   output [18:0] ram1_address;
   output ram1_adv_ld, ram1_clk, ram1_cen_b, ram1_ce_b, ram1_oe_b, ram1_we_b;
   output [3:0] ram1_bwe_b;

   input  clock_feedback_in;
   output clock_feedback_out;
   
   inout  [15:0] flash_data;
   output [23:0] flash_address;
   output flash_ce_b, flash_oe_b, flash_we_b, flash_reset_b, flash_byte_b;
   input  flash_sts;
   
   output rs232_txd, rs232_rts;
   input  rs232_rxd, rs232_cts;

   input  mouse_clock, mouse_data, keyboard_clock, keyboard_data;

   input  clock_27mhz, clock1, clock2;

   output disp_blank, disp_clock, disp_rs, disp_ce_b, disp_reset_b;  
   input  disp_data_in;
   output  disp_data_out;
   
   input  button0, button1, button2, button3, button_enter, button_right,
	  button_left, button_down, button_up;
   input  [7:0] switch;
   output [7:0] led;

   inout [31:0] user1, user2, user3, user4;
   
   inout [43:0] daughtercard;

   inout  [15:0] systemace_data;
   output [6:0]  systemace_address;
   output systemace_ce_b, systemace_we_b, systemace_oe_b;
   input  systemace_irq, systemace_mpbrdy;

   output [15:0] analyzer1_data, analyzer2_data, analyzer3_data, 
		 analyzer4_data;
   output analyzer1_clock, analyzer2_clock, analyzer3_clock, analyzer4_clock;

   ////////////////////////////////////////////////////////////////////////////
   //
   // Reset Generation
   //
   // A shift register primitive is used to generate an active-high reset
   // signal that remains high for 16 clock cycles after configuration finishes
   // and the FPGA's internal clocks begin toggling.
   //
   ////////////////////////////////////////////////////////////////////////////

   wire reset;
   SRL16 reset_sr (.D(1'b0), .CLK(clock_27mhz), .Q(reset),
		   .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   defparam reset_sr.INIT = 16'hFFFF;
   
   // Audio Input and Output
   assign beep= 1'b0;
   //lab3 assign audio_reset_b = 1'b0;
   //lab3 assign ac97_synch = 1'b0;
   //lab3 assign ac97_sdata_out = 1'b0;
   // ac97_sdata_in is an input

   // VGA Output
   //assign vga_out_red = 10'h0;
   //assign vga_out_green = 10'h0;
   //assign vga_out_blue = 10'h0;
   //assign vga_out_sync_b = 1'b1;
   //assign vga_out_blank_b = 1'b1;
   //assign vga_out_pixel_clock = 1'b0;
   //assign vga_out_hsync = 1'b0;
   //assign vga_out_vsync = 1'b0;

   // Video Output
   assign tv_out_ycrcb = 10'h0;
   assign tv_out_reset_b = 1'b0;
   assign tv_out_clock = 1'b0;
   assign tv_out_i2c_clock = 1'b0;
   assign tv_out_i2c_data = 1'b0;
   assign tv_out_pal_ntsc = 1'b0;
   assign tv_out_hsync_b = 1'b1;
   assign tv_out_vsync_b = 1'b1;
   assign tv_out_blank_b = 1'b1;
   assign tv_out_subcar_reset = 1'b0;
   
   // Video Input
   assign tv_in_i2c_clock = 1'b0;
   assign tv_in_fifo_read = 1'b0;
   assign tv_in_fifo_clock = 1'b0;
   assign tv_in_iso = 1'b0;
   assign tv_in_reset_b = 1'b0;
   assign tv_in_clock = 1'b0;
   assign tv_in_i2c_data = 1'bZ;
   // tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, 
   // tv_in_aef, tv_in_hff, and tv_in_aff are inputs
   
   // SRAMs
/*
   assign ram0_data = 36'hZ;
   assign ram0_address = 19'h0;
   assign ram0_clk = 1'b0;
   assign ram0_we_b = 1'b1;
   assign ram0_cen_b = 1'b0;	// clock enable
*/

/* enable RAM pins */

   assign ram0_ce_b = 1'b0;
   assign ram0_oe_b = 1'b0;
   assign ram0_adv_ld = 1'b0;
   assign ram0_bwe_b = 4'h0; 

   assign ram1_data = 36'hZ; 
   assign ram1_address = 19'h0;
   assign ram1_adv_ld = 1'b0;
   assign ram1_clk = 1'b0;
   assign ram1_cen_b = 1'b1;
   assign ram1_ce_b = 1'b1;
   assign ram1_oe_b = 1'b1;
   assign ram1_we_b = 1'b1;
   assign ram1_bwe_b = 4'hF;
   //assign clock_feedback_out = 1'b0;
   // clock_feedback_in is an input
   
   // Flash ROM
   assign flash_data = 16'hZ;
   assign flash_address = 24'h0;
   assign flash_ce_b = 1'b1;
   assign flash_oe_b = 1'b1;
   assign flash_we_b = 1'b1;
   assign flash_reset_b = 1'b0;
   assign flash_byte_b = 1'b1;
   // flash_sts is an input

   // RS-232 Interface
   assign rs232_txd = 1'b1;
   assign rs232_rts = 1'b1;
   // rs232_rxd and rs232_cts are inputs

   // PS/2 Ports
   // mouse_clock, mouse_data, keyboard_clock, and keyboard_data are inputs

//   // LED Displays
//   assign disp_blank = 1'b1;
//   assign disp_clock = 1'b0;
//   assign disp_rs = 1'b0;
//   assign disp_ce_b = 1'b1;
//   assign disp_reset_b = 1'b0;
//   assign disp_data_out = 1'b0;
   // disp_data_in is an input

   // Buttons, Switches, and Individual LEDs
   assign led = 8'hFF;
   // button0, button1, button2, button3, button_enter, button_right,
   // button_left, button_down, button_up, and switches are inputs

   // User I/Os
   //assign user1 = 32'hZ;
   assign user2 = 32'hZ;
   assign user3 = 32'hZ;
   assign user4 = 32'hZ;

   // Daughtercard Connectors
   assign daughtercard = 44'hZ;

   // SystemACE Microprocessor Port
   assign systemace_data = 16'hZ;
   assign systemace_address = 7'h0;
   assign systemace_ce_b = 1'b1;
   assign systemace_we_b = 1'b1;
   assign systemace_oe_b = 1'b1;
   // systemace_irq and systemace_mpbrdy are inputs

   // Logic Analyzer
   //assign analyzer1_data = 16'h0;
   assign analyzer1_clock = 1'b1;
   assign analyzer2_data = 16'h0;
   assign analyzer2_clock = 1'b1;
   //assign analyzer3_data = 16'h0;
   assign analyzer3_clock = 1'b1;
   assign analyzer4_data = 16'h0;
   assign analyzer4_clock = 1'b1;
			    
   // use FPGA's digital clock manager to produce a
   // 65MHz clock (actually 64.8MHz)
   wire clock_65mhz_unbuf,clock_65mhz;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_65mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 10
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 24
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_65mhz),.I(clock_65mhz_unbuf));


   // use FPGA's digital clock manager to produce a
   // 65MHz clock (actually 64.8MHz)
   wire clk;

	// ZBT Memory
	wire locked;
	//assign clock_feedback_out = 0; // gph 2011-Nov-10
   
   ramclock rc(.ref_clock(clock_65mhz), 
					.fpga_clock(clk),
					.ram0_clock(ram0_clk), 
					//.ram1_clock(ram1_clk),   //uncomment if ram1 is used
					.clock_feedback_in(clock_feedback_in),
					.clock_feedback_out(clock_feedback_out), 
					.locked(locked));

	wire up;
	wire down;
	wire enter;
	wire resetButton;
	
	//Set up signals from all the buttons used.
	debounce bup(reset, clock_27mhz, ~button_up, up);
    debounce bdown(reset, clock_27mhz, ~button_down, down);
	debounce benter(reset, clock_27mhz, ~button_enter, enter);
	debounce breset(reset, clock_27mhz, ~button0, resetButton);
	
	wire boardReset;
	wire menuReset;
	
	assign boardReset = (reset | resetButton);

	wire songDone;
	wire [2:0] menuState;
	wire menuResetOut;
	wire [1:0] song;

	wire[17:0] scoreBinary;
	wire[47:0] asciiScore;
	wire[47:0] highScore;

	//Menu FSM instantiation, deals with menu states and keeping correct high scores
   menuFSM menu(up,down,enter,boardReset,songDone,clock_65mhz,scoreBinary,
						asciiScore,menuState,menuResetOut,song,highScore);

						
	assign menuReset = (menuResetOut | boardReset);

   wire [15:0] from_ac97_data, to_ac97_data;
   wire ready;

   // AC97 driver
   fft_audio a(clock_27mhz, reset, volume, from_ac97_data, to_ac97_data, ready,
	       audio_reset_b, ac97_sdata_out, ac97_sdata_in,
	       ac97_synch, ac97_bit_clock);

   // loopback incoming audio to headphones
   assign to_ac97_data = from_ac97_data;
	
	wire [3:0] currentNote;
	wire readVal;
	wire [5:0] GuessAddr;
	
	wire [15:0] analyzer1_out;
	wire [15:0] analyzer2_out;
	
	//Note identification instatiation, takes in ac97 information and outputs the currentNote played.
	noteIdentification a1(reset,clock_27mhz,ready,switch,from_ac97_data,currentNote,GuessAddr,readVal,analyzer1_out,analyzer2_out);
	
	assign analyzer3_data = analyzer2_out;
	assign analyzer1_data = analyzer1_out;
	
	wire[3:0] notePlayed;
	
	wire score;
	
	wire [63:0] nn;
	
	// Takes in a hex representation of a note from noteIdentification and a hex representation from the musical score loader and updates the score and if note was played correctly.
	scoreUpdater updater(clock_65mhz,currentNote,nn[3:0],menuReset,hit,
						score,notePlayed,scoreBinary);
	
	//Counts up in ASCII to our maximum score value
	binaryCounterASCII counter(clock_65mhz,menuReset,score,asciiScore);

	wire[15:0] asciiNote;
	//Turns the hex representation of a note to a 2 byte ascii representation to be shown
	hexToAscii hexy(notePlayed,clock_65mhz,asciiNote);
   
   ////////////////////////////////////////////////////////////////////////////
   //
   // PAUL! A NOT SIMPLE PONG GAME
   //
   ////////////////////////////////////////////////////////////////////////////

	// generate basic XVGA video signals
	wire [10:0] hcount;
	wire [9:0]  vcount;
	wire hsync,vsync,blank;
	xvga xvga1(.vclock(clk),.hcount(hcount),.vcount(vcount),
	      .hsync(hsync),.vsync(vsync),.blank(blank));

	// feed XVGA signals to user's pong game
	wire [23:0] pixel;
	wire [63:0] dispdata;
	wire phsync,pvsync,pblank;
	
	// Connections to rh_video_display
	wire debug_rh_display = 0;
	reg right_note = 1;
	reg [31:0] count = 0;
	reg [3:0] notes[15:0];
	wire [25:0] tempo;
	
	/*** Wiring up USB FIFO to talk to user1 pins ***/
	wire [7:0] fifo_data_input;
	wire [7:0] fifo_data_output;
	wire [3:0] fifo_state;
	wire rd, rxf, fifo_newout, fifo_hold;
	reg [7:0] from_fifo;
	
	assign fifo_data_input = user1[9:2];
	assign user1[1] = rd;
	assign rxf = user1[0];
	
	usb_input usb_input_module(.clk(clk),
				   .reset(resetButton),
				   .data(fifo_data_input),
				   .rd(rd),
				   .rxf(rxf),
				   .out(fifo_data_output),
				   .newout(fifo_newout),
				   .hold(1'b0),
				   .state(fifo_state));
										
	always @(posedge clk) begin
		if (fifo_newout) begin
			from_fifo <= fifo_data_output;
		end
	end
	
	/*** Wiring up ZBT RAM ***/
	wire [35:0] vram_write_data;
	wire [35:0] vram_read_data;
	wire [18:0] vram_addr;
	wire         vram_we;

	wire ram0_clk_not_used;
	zbt_6111 zbt1(clk, 1'b1, 
		      vram_we, 
		      vram_addr,
		      vram_write_data, 
		      vram_read_data,
		      ram0_clk_not_used,   //to get good timing, don't connect ram_clk to zbt_6111
		      ram0_we_b, ram0_address, ram0_data, ram0_cen_b);
	
	/*** Shift-register module to store 4 pixels in each row ***/
	wire zbt_iw_newout;
	wire [35:0] zbt_iw_output;
	reg [35:0] zbt_iw_output_reg; // Required for write to be successful
	zbt_image_writer ziw1(.clk(clk),
			      .reset(resetButton),
			      .image_data(fifo_data_output),
			      .new_input(fifo_newout),
			      .new_output(zbt_iw_newout),
			      .image_data_zbt(zbt_iw_output));
	
	wire [7:0] image_bits;
	reg [18:0] vram_write_addr = 0;
	wire [18:0] vram_read_addr;
	
	assign vram_we = zbt_iw_newout;
	assign vram_addr = (zbt_iw_newout == 1) ? vram_write_addr : vram_read_addr;
	assign vram_write_data = zbt_iw_output_reg;
	
	/*** Grab background image pixels from vram_display ***/
	vram_display vd1(.reset(resetButton),
			 .clk(clk),
			 .hcount(hcount),
			 .vcount(vcount),
			 .vr_pixel(image_bits),
			 .vram_addr(vram_read_addr),
		         .vram_read_data(vram_read_data));

	reg [9:0] x_pixels = 0;
	reg [9:0] y_pixels = 0;
	
	/*** Control when to write to ZBT based on zbt_image_writer's ready signal ***/
	always @(posedge clk) begin
		if (reset) begin
			vram_write_addr <= 0;
			x_pixels <= 0;
			y_pixels <= 0;
		end
		
		if (zbt_iw_newout) begin
			vram_write_addr <= {0, y_pixels, x_pixels[9:2]-1'b1};
			zbt_iw_output_reg <= zbt_iw_output;
		end
		
		if (fifo_newout) begin
			x_pixels <= x_pixels + 1;
		end
		
		if (x_pixels >= 1023) begin
			x_pixels <= 0;
			y_pixels <= y_pixels + 1;
		end
	end
	
	musical_score_loader msl(.clk(clk), .reset(menuReset),
				 .song_id(song), .next_notes_out(nn),
				 .tempo_out(tempo),
				 .song_done(songDone));
	
   	rh_display rh_disp(.vclock(clk),.reset(menuReset),
		  	   .up(up), .down(down),
			   .playing_correct(hit),
			   .menu_state(menuState),
			   .next_notes(nn),
			   .score_string({asciiScore,"00"}),
			   .high_score_string({highScore, "00"}),
			   .current_note_string(asciiNote),
			   .tempo(tempo),
			   .bono_image_bits(image_bits),
			   .hcount(hcount),.vcount(vcount),
	      		   .hsync(hsync),.vsync(vsync),
			   .blank(blank),.phsync(phsync),
			   .pvsync(pvsync),.pblank(pblank),
			   .pixel(pixel), .debug(dispdata));

   // switch[1:0] selects which video generator to use:
   //  00: user's pong game
   //  01: 1 pixel outline of active video area (adjust screen controls)
   //  10: color bars
   reg [23:0] rgb;
   wire border = (hcount==0 | hcount==1023 | vcount==0 | vcount==767);
   
   reg b,hs,vs;
   always @(posedge clk) begin
		hs <= phsync;
		vs <= pvsync;
		b <= pblank;
		rgb <= pixel;
   end

   // VGA Output.  In order to meet the setup and hold times of the
   // AD7125, we send it ~clock_65mhz.
   assign vga_out_red = rgb[23:16];
   assign vga_out_green = rgb[15:8];
   assign vga_out_blue = rgb[7:0];
   assign vga_out_sync_b = 1'b1;    // not used
   assign vga_out_blank_b = ~b;
   assign vga_out_pixel_clock = ~clk;
   assign vga_out_hsync = hs;
   assign vga_out_vsync = vs;
   
	display_16hex hex(.reset(menuReset), .clock_27mhz(clock_27mhz),
	.data({1'b0,menuState,notePlayed,asciiScore,4'd0,currentNote}),
	.disp_blank(disp_blank), .disp_clock(disp_clock),
	.disp_rs(disp_rs), .disp_ce_b(disp_ce_b),
	.disp_reset_b(disp_reset_b), .disp_data_out(disp_data_out));

	
endmodule

////////////////////////////////////////////////////////////////////////////////
//
// xvga: Generate XVGA display signals (1024 x 768 @ 60Hz)
//
////////////////////////////////////////////////////////////////////////////////

module xvga(input vclock,
            output reg [10:0] hcount,    // pixel number on current line
            output reg [9:0] vcount,	 // line number
            output reg vsync,hsync,blank);

   // horizontal: 1344 pixels total
   // display 1024 pixels per line
   reg hblank,vblank;
   wire hsyncon,hsyncoff,hreset,hblankon;
   assign hblankon = (hcount == 1023);    
   assign hsyncon = (hcount == 1047);
   assign hsyncoff = (hcount == 1183);
   assign hreset = (hcount == 1343);

   // vertical: 806 lines total
   // display 768 lines
   wire vsyncon,vsyncoff,vreset,vblankon;
   assign vblankon = hreset & (vcount == 767);    
   assign vsyncon = hreset & (vcount == 776);
   assign vsyncoff = hreset & (vcount == 782);
   assign vreset = hreset & (vcount == 805);

   // sync and blanking
   wire next_hblank,next_vblank;
   assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
   assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
   always @(posedge vclock) begin
      hcount <= hreset ? 0 : hcount + 1;
      hblank <= next_hblank;
      hsync <= hsyncon ? 0 : hsyncoff ? 1 : hsync;  // active low

      vcount <= hreset ? (vreset ? 0 : vcount + 1) : vcount;
      vblank <= next_vblank;
      vsync <= vsyncon ? 0 : vsyncoff ? 1 : vsync;  // active low

      blank <= next_vblank | (next_hblank & ~hreset);
   end
endmodule

module rh_display (
	input vclock,
	input reset,
	input up,
	input down,
	input playing_correct,
	input [2:0] menu_state,
	input [15:0] current_note_string,
	input [63:0] high_score_string,
	input [63:0] score_string,
	input [63:0] next_notes,
	input [25:0] tempo,
	input [7:0] bono_image_bits,
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
	parameter NOTE_HEIGHT = 35;
	parameter FIRST_LETTER = 128 + 16;
	parameter NOTE_STEP = 74;
	parameter ACTION_LINE_X = 72;
	parameter [23:0] COLOR = 24'hFF_FF_FF;
	
	wire [3:0] notes[15:0];
	wire [23:0] note_pixels[15:0];
	
	// All notes positions are based on this one
	reg [10:0] lead_note_x = 1023;
	
	assign {notes[15], notes[14], notes[13], notes[12],
	        notes[11], notes[10], notes[9], notes[8],
		notes [7], notes[6], notes[5], notes[4],
		notes [3], notes[2], notes[1], notes[0] } = next_notes;

	// Track y positions and colors for each note on screen
	reg [9:0] note_y_pos[15:0];
	reg [23:0] note_color[15:0];
	wire [23:0] note_line_pixels[7:0];
	
	/*** Generators for creating the notes and staff lines ***/
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
	
	genvar w;
	generate
		for(w=0; w<8; w=w+1) begin:generate_note_lines
		  blob #(.WIDTH(1023-72), .HEIGHT(1))
				note_line(.x(ACTION_LINE_X),
				          .y(128 + w*73),
					  .hcount(hcount),
					  .vcount(vcount),
					  .color(24'hAA_AA_AA),
					  .pixel(note_line_pixels[w]));
		end
	endgenerate
		
	/////////////////////////
	///// TEMPO CONTROL /////
	/////////////////////////

	// Default song tempo is 1/2s per 8th note
	reg load_tempo = 0;
	reg [25:0] song_tempo = 26'b1111_0111_1111_0100_1001_0000_0;
	wire tempo_beat;      // Indicates 1/8th note beat
	wire tempo_beat_move; // Indicates 1/8th*1/64 to move the notes
	
	counter c(.clk(vclock),
		  .reset(load_tempo),
		  .count_to(song_tempo),
		  .ready(tempo_beat));
	
	// The width of one note is 64, break the tempo up by 64
	// to know the interval we need to move the notes by 1px
	counter c2(.clk(vclock),
		   .reset(load_tempo),
		   .count_to(song_tempo/64),
	           .ready(tempo_beat_move));
	
	/***** VISUAL BOUNDARY LINES *****/
	wire action_line = hcount == ACTION_LINE_X & vcount >= 128 & vcount <= 639;
	wire right_boundary_line = hcount == 1022 & vcount >= 128 & vcount <= 639;
	
	///////////////////////////////////////////
	/// CONTROLLING NOTE POSITIONS & COLORS ///
	///////////////////////////////////////////

	reg [23:0] onscreen_notes[15:0];
	integer n, k;
	always @(posedge vclock) begin
		if (reset) begin
			song_tempo <= tempo;
			lead_note_x <= 1023; // TODO: Revert back to 1023
			load_tempo <= 1;
		end else begin
			load_tempo <= 0;
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
			
			for (k=0; k<16; k=k+1) begin
				case(notes[k])
					4'd0: note_y_pos[k] <= FIRST_LETTER + 768;
					// C, C#
					4'd1:  note_y_pos[k] <= FIRST_LETTER + 6*NOTE_STEP;
					4'd2:  note_y_pos[k] <= FIRST_LETTER + 6*NOTE_STEP;
					// D, D#
					4'd3:  note_y_pos[k] <= FIRST_LETTER + 5*NOTE_STEP;
					4'd4:  note_y_pos[k] <= FIRST_LETTER + 5*NOTE_STEP;
					// E
					4'd5:  note_y_pos[k] <= FIRST_LETTER + 4*NOTE_STEP;
					// F, F#
					4'd6:  note_y_pos[k] <= FIRST_LETTER + 3*NOTE_STEP;
					4'd7:  note_y_pos[k] <= FIRST_LETTER + 3*NOTE_STEP;
					// G, G#
					4'd8:  note_y_pos[k] <= FIRST_LETTER + 2*NOTE_STEP;
					4'd9:  note_y_pos[k] <= FIRST_LETTER + 2*NOTE_STEP;
					// A, A#
					4'd10: note_y_pos[k] <= FIRST_LETTER + 1*NOTE_STEP;
					4'd11: note_y_pos[k] <= FIRST_LETTER + 1*NOTE_STEP;
					// B
					4'd12: note_y_pos[k] <= FIRST_LETTER + 0*NOTE_STEP;
					// C high
					4'd13: note_y_pos[k] <= FIRST_LETTER + 6*NOTE_STEP;
					// D high
					4'd14: note_y_pos[k] <= FIRST_LETTER + 5*NOTE_STEP;
					// EOF
					4'd15: note_y_pos[k] <= FIRST_LETTER + 768;
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
					// D high
					4'd14: note_color[k] <= 24'h00_DD_00;
					default: note_color[k] <= 24'hFF_FF_FF;
				endcase
			end
		end
		
		// Change color of to-be-played note based on whether
		// the player is playing the right now
		if (notes[0] == 4'd0) begin
			note_color[0] <= 24'h00_00_00;
		end else if ((playing_correct) && (notes[0] > 4'd0)) begin
			note_color[0] <= 24'hFF_FF_00;
		end else if ((!playing_correct) && (notes[0] > 4'd0)) begin
			note_color[0] <= 24'hFF_45_00;
		end
		
		for (n=0; n<16; n=n+1) begin
			onscreen_notes[n] <= (hcount > ACTION_LINE_X) ? note_pixels[n] : 0;
		end
	end
	
	///////////////////////////
	// ONSCREEN TEXT DISPLAY //
        ///////////////////////////
	wire [2:0] score_pixel;
	char_string_display csd_score(.vclock(vclock),
				      .hcount(hcount),
				      .vcount(vcount),
				      .pixel(score_pixel),
				      .cstring({"SCORE: ", score_string}),
				      .cx(700),
				      .cy(10));
	defparam csd_score.NCHAR = 15;
	defparam csd_score.NCHAR_BITS = 4;
	
	wire [2:0] high_score_pixel;
	char_string_display csd_hscore(.vclock(vclock),
				       .hcount(hcount),
				       .vcount(vcount),
				       .pixel(high_score_pixel),
				       .cstring({"HIGH SCORE: ", high_score_string}),
				       .cx(120),
				       .cy(10));
	defparam csd_hscore.NCHAR = 20;
	defparam csd_hscore.NCHAR_BITS = 5;
	
	wire [2:0] current_note_pixel;
	wire [10:0] current_note_x;
	wire [9:0] current_note_y;
	assign current_note_x = (menu_state[2] == 1) ? 700 : 23;
	assign current_note_y = (menu_state[2] == 1) ? 30 : 715;
	char_string_display csd_note(.vclock(vclock),
				     .hcount(hcount),
				     .vcount(vcount),
				     .pixel(current_note_pixel),
				     .cstring({"NOTE: ", current_note_string}),
				     .cx(current_note_x),
				     .cy(current_note_y));
	defparam csd_note.NCHAR = 8;
	defparam csd_note.NCHAR_BITS = 4;

	//////////////////////////////
	//// IMAGES FROM BROM/ZBT ////
	//////////////////////////////
	wire [23:0] bmp_pixel;
	picture_blob pb(.pixel_clk(vclock),
		        .x(4),
		        .hcount(hcount),
		        .y(128),
	                .vcount(vcount),
		        .pixel(bmp_pixel));
						 
	wire [23:0] bono_pixel;
	bono_picture_blob bpb_img(.pixel_clk(vclock),
			          .x(0),
			          .hcount(hcount+2),
				  .y(0),
				  .vcount(vcount+2),
				  .image_bits(bono_image_bits),
			          .pixel(bono_pixel));

	// Highlight the note currently being played
	// on the scale on the left by alphablending
	// the image
	reg [23:0] curr_note_color;
	reg [9:0] curr_note_y;
	reg [23:0] bmp_pixel_alpha;
	always @(*) begin
		case(current_note_string)
			"B " : curr_note_y = 127;
			"A#" : curr_note_y = 127 + 1*NOTE_STEP;
			"A " : curr_note_y = 127 + 1*NOTE_STEP;
			"G#" : curr_note_y = 127 + 2*NOTE_STEP;
			"G " : curr_note_y = 127 + 2*NOTE_STEP;
			"F#" : curr_note_y = 127 + 3*NOTE_STEP;
			"F " : curr_note_y = 127 + 3*NOTE_STEP;
			"E " : curr_note_y = 127 + 4*NOTE_STEP;
			"D#" : curr_note_y = 127 + 5*NOTE_STEP;
			"D " : curr_note_y = 127 + 5*NOTE_STEP;
			"C#" : curr_note_y = 127 + 6*NOTE_STEP;
			"C " : curr_note_y = 127 + 6*NOTE_STEP;
		endcase
		
		case(current_note_string)
			"A#": curr_note_color = 24'h77_77_FF;
			"G#": curr_note_color = 24'h77_77_FF;
			"F#": curr_note_color = 24'h77_77_FF;
			"D#": curr_note_color = 24'h77_77_FF;
			"C#": curr_note_color = 24'h77_77_FF;
			default: curr_note_color = 24'hDD_DD_00;
		endcase
		
		// Alphablend the currently-played note along the music staff
		if (|bmp_pixel 
		    && vcount >= curr_note_y 
		    && vcount <= curr_note_y + NOTE_STEP) begin
			bmp_pixel_alpha = bmp_pixel/4 + 3*(curr_note_color / 2);
		end else begin
			bmp_pixel_alpha = bmp_pixel;
		end
	end
	
	///////////////////////
	// MAIN MENU DISPLAY //
        ///////////////////////
	wire [2:0] song_title_1_pixel;
	char_string_display csd_st1(.vclock(vclock),
				    .hcount(hcount),
				    .vcount(vcount),
				    .pixel(song_title_1_pixel),
				    .cstring("Concerning Hobbits"),
				    .cx(23),
			            .cy(285));
	defparam csd_st1.NCHAR = 18;
	defparam csd_st1.NCHAR_BITS = 5;
	
	wire [2:0] song_title_2_pixel;
	char_string_display csd_st2(.vclock(vclock),
				    .hcount(hcount),
				    .vcount(vcount),
				    .pixel(song_title_2_pixel),
				    .cstring("When the Saints..."),
				    .cx(23),
				    .cy(315));
	defparam csd_st2.NCHAR = 18;
	defparam csd_st2.NCHAR_BITS = 5;
	
	wire [2:0] song_title_3_pixel;
	char_string_display csd_st3(.vclock(vclock),
				    .hcount(hcount),
				    .vcount(vcount),
				    .pixel(song_title_3_pixel),
				    .cstring("Greensleeves"),
				    .cx(23),
			            .cy(345));
	defparam csd_st3.NCHAR = 12;
	defparam csd_st3.NCHAR_BITS = 4;
	
	wire [2:0] song_title_4_pixel;
	char_string_display csd_st4(.vclock(vclock),
			            .hcount(hcount),
				    .vcount(vcount),
				    .pixel(song_title_4_pixel),
				    .cstring("Practice Scale"),
				    .cx(23),
				    .cy(375));
	defparam csd_st4.NCHAR = 14;
	defparam csd_st4.NCHAR_BITS = 4;
	
	// Create a block that indicates selected song
	reg [8:0] current_song_y;
	always @(*) begin
		case(menu_state[1:0])
			2'b00: current_song_y = 9'd285;
			2'b01: current_song_y = 9'd315;
			2'b10: current_song_y = 9'd345;
			2'b11: current_song_y = 9'd375;
			default: current_song_y = 9'd285;
		endcase
	end
	
	wire [23:0] song_select_box_pixel;
   	blob #(.WIDTH(10), .HEIGHT(10))
		song_selector_box(.x(8),
		  .y(current_song_y + 6),
		  .hcount(hcount),
		  .vcount(vcount),
		  .color(24'hFF_FF_FF),
		  .pixel(song_select_box_pixel));
		  
	/////////////////////
	/////// LEGEND //////
	/////////////////////
	wire [23:0] legend_sharp_pixel;
	wire [23:0] legend_high_pixel;
	wire [23:0] legend_hit_pixel;
	wire [23:0] legend_miss_pixel;
	wire [2:0] legend_sharp_text_pixel;
	wire [2:0] legend_high_text_pixel;
	wire [2:0] legend_hit_text_pixel;
	wire [2:0] legend_miss_text_pixel;
	
	blob #(.WIDTH(NOTE_WIDTH), .HEIGHT(NOTE_HEIGHT))
		legend_sharp(.x(196),
		  .y(640+17),
		  .hcount(hcount),
		  .vcount(vcount),
		  .color(24'h55_55_FF),
		  .pixel(legend_sharp_pixel));
		  
	char_string_display csd_ls(.vclock(vclock),
				   .hcount(hcount),
				   .vcount(vcount),
				   .pixel(legend_sharp_text_pixel),
			           .cstring("= Sharp"),
				   .cx(196+64+16),
				   .cy(640+17));
	defparam csd_ls.NCHAR = 7;
	defparam csd_ls.NCHAR_BITS = 3;
	
	blob #(.WIDTH(NOTE_WIDTH), .HEIGHT(NOTE_HEIGHT))
		legend_octave(.x(196),
		  .y(640+17+24+24),
		  .hcount(hcount),
		  .vcount(vcount),
		  .color(24'h00_DD_00),
		  .pixel(legend_high_pixel));
		  
	char_string_display csd_lh(.vclock(vclock),
			           .hcount(hcount),
				   .vcount(vcount),
				   .pixel(legend_high_text_pixel),
				   .cstring("= Octave higher"),
				   .cx(196+64+16),
				   .cy(640+17+24+24));
	defparam csd_lh.NCHAR = 15;
	defparam csd_lh.NCHAR_BITS = 4;
	
	blob #(.WIDTH(NOTE_WIDTH), .HEIGHT(NOTE_HEIGHT))
		legend_hit_text(.x(580),
		  .y(640+17),
		  .hcount(hcount),
		  .vcount(vcount),
		  .color(24'hFF_FF_00),
		  .pixel(legend_hit_pixel));
		  
	char_string_display csd_lhittext(.vclock(vclock),
					 .hcount(hcount),
					 .vcount(vcount),
					 .pixel(legend_hit_text_pixel),
					 .cstring("= Hit!"),
					 .cx(580+64+16),
					 .cy(640+17));
	defparam csd_lhittext.NCHAR = 6;
	defparam csd_lhittext.NCHAR_BITS = 3;
	
	blob #(.WIDTH(NOTE_WIDTH), .HEIGHT(NOTE_HEIGHT))
		legend_miss_text(.x(580),
		  .y(640+17+24+24),
		  .hcount(hcount),
		  .vcount(vcount),
		  .color(24'hFF_45_00),
		  .pixel(legend_miss_pixel));
		  
	char_string_display csd_lmisstext(.vclock(vclock),
					  .hcount(hcount),
					  .vcount(vcount),
					  .pixel(legend_miss_text_pixel),
					  .cstring("= Miss!"),
					  .cx(580+64+16),
					  .cy(640+17+24+24));
	defparam csd_lmisstext.NCHAR = 7;
	defparam csd_lmisstext.NCHAR_BITS = 3;
	
	///// BUG FIX
	// For some reason the image from the zbt shows a small sliver
	// on the side. This hack at least covers it up on the main screen
	wire [23:0] vga_display_hack_pixel;
	blob #(.WIDTH(16), .HEIGHT(768))
		vga_display_hack(.x(0), .y(0),
				 .hcount(hcount),
				 .vcount(vcount),
				 .color(24'h00_00_00),
				 .pixel(vga_display_hack_pixel));
	
	reg [23:0] pixel_reg;
	wire [23:0] bono_pixel_fix;
	assign bono_pixel_fix = (hcount < 16) ? 24'h00_00_00 : bono_pixel;
	
	//////////////////////
	//// FINAL OUTPUT ////
	//////////////////////

	// Display output for menu / game
	always @(posedge vclock) begin
		if (!menu_state[2]) begin
			pixel_reg <= bono_pixel_fix
				  | {8{song_title_1_pixel}}
				  | {8{song_title_2_pixel}}
				  | {8{song_title_3_pixel}}
				  | {8{song_title_4_pixel}}
				  | {8{current_note_pixel}}
				  | song_select_box_pixel;
		end else begin
			pixel_reg <= onscreen_notes[0]
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
				| note_line_pixels[0]
				| note_line_pixels[1]
				| note_line_pixels[2]
				| note_line_pixels[3]
				| note_line_pixels[4]
				| note_line_pixels[5]
				| note_line_pixels[6]
				| note_line_pixels[7]
				| {24{action_line}}
				| {24{right_boundary_line}}
				| {8{score_pixel}}
				| {8{high_score_pixel}}
				| {8{current_note_pixel}}
				| bmp_pixel_alpha
				| legend_sharp_pixel
				| legend_high_pixel
				| legend_hit_pixel
				| legend_miss_pixel
				| {8{legend_sharp_text_pixel}}
				| {8{legend_high_text_pixel}}
				| {8{legend_hit_text_pixel}}
				| {8{legend_miss_text_pixel}};
		end
	end
	
	assign pixel = pixel_reg;
	assign debug = {bono_pixel};
endmodule
