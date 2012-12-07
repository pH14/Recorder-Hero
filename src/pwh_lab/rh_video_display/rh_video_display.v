`default_nettype none

///////////////////////////////////////////////////////////////////////////////
//
// Pushbutton Debounce Module (video version - 24 bits)  
//
///////////////////////////////////////////////////////////////////////////////

module debounce (input reset, clock, noisy,
                 output reg clean);

   reg [19:0] count;
   reg new;

   always @(posedge clock)
     if (reset) begin new <= noisy; clean <= noisy; count <= 0; end
     else if (noisy != new) begin new <= noisy; count <= 0; end
     else if (count == 650000) clean <= new;
     else count <= count+1;

endmodule

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
// 2012-Sep-15: Converted to 24bit RGB
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

module lab3   (beep, audio_reset_b, ac97_sdata_out, ac97_sdata_in, ac97_synch,
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
   // I/O Assignments
   //
   ////////////////////////////////////////////////////////////////////////////
   
   // Audio Input and Output
   assign beep= 1'b0;
   assign audio_reset_b = 1'b0;
   assign ac97_synch = 1'b0;
   assign ac97_sdata_out = 1'b0;
   // ac97_sdata_in is an input

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
/* change lines below to enable ZBT RAM bank0 */

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

/**********/
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

   // LED Displays
//   assign disp_blank = 1'b1;
//   assign disp_clock = 1'b0;
//   assign disp_rs = 1'b0;
//   assign disp_ce_b = 1'b1;
//   assign disp_reset_b = 1'b0;
//   assign disp_data_out = 1'b0;
   // disp_data_in is an input

   // Buttons, Switches, and Individual LEDs
   //lab3 assign led = 8'hFF;
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
   assign analyzer1_data = 16'h0;
   assign analyzer1_clock = 1'b1;
   assign analyzer2_data = 16'h0;
   assign analyzer2_clock = 1'b1;
   assign analyzer3_data = 16'h0;
   assign analyzer3_clock = 1'b1;
   assign analyzer4_data = 16'h0;
   assign analyzer4_clock = 1'b1;
			    
   ////////////////////////////////////////////////////////////////////////////
   //
   // lab3 : a simple pong game
   //
   ////////////////////////////////////////////////////////////////////////////

   // use FPGA's digital clock manager to produce a
   // 65MHz clock (actually 64.8MHz)
   wire clock_65mhz_unbuf,clock_65mhz,clk;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_65mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 10
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 24
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_65mhz),.I(clock_65mhz_unbuf));
	
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

   // power-on reset generation
   wire power_on_reset;    // remain high for first 16 clocks
   SRL16 reset_sr (.D(1'b0), .CLK(clk), .Q(power_on_reset),
		   .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   defparam reset_sr.INIT = 16'hFFFF;

   // ENTER button is user reset
   wire reset,user_reset;
   debounce db1(.reset(power_on_reset),.clock(clock_65mhz),.noisy(~button_enter),.clean(user_reset));
   assign reset = user_reset | power_on_reset;
   
   // UP and DOWN buttons for pong paddle
   wire up,down;
   debounce db2(.reset(reset),.clock(clk),.noisy(~button_up),.clean(up));
   debounce db3(.reset(reset),.clock(clk),.noisy(~button_down),.clean(down));

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
	
	wire debug_rh_display = 0;
	reg right_note = 1;
	
	reg [31:0] count = 0;
	reg [3:0] notes[15:0];
	
	always @(posedge clk) begin
		count <= count + 1;
		
		if (reset) begin
			count <= 0;
		end
		
		if (debug_rh_display) begin
			if (count > 26'b1111_0111_1111_0100_1001_0000_0 * 7) begin
				{notes[0], notes[1], notes[2], notes[3],
				 notes[4], notes[5], notes[6], notes[7],
				 notes[8], notes[9], notes[10], notes[11],
				 notes[12], notes[13], notes[14], notes[15]} <= {4'd4, 4'd3, 4'd2, 4'd1,
																					 4'd2, 4'd3, 4'd4, 4'd5,
																					 4'd4, 4'd3, 4'd2, 4'd1,
																					 4'd2, 4'd3, 4'd4, 4'd5};
				right_note <= 1;
			end else if (count > 26'b1111_0111_1111_0100_1001_0000_0 * 6) begin
				{notes[0], notes[1], notes[2], notes[3],
				 notes[4], notes[5], notes[6], notes[7],
				 notes[8], notes[9], notes[10], notes[11],
				 notes[12], notes[13], notes[14], notes[15]} <= {4'd5, 4'd4, 4'd3, 4'd2,
																					 4'd1, 4'd2, 4'd3, 4'd4,
																					 4'd5, 4'd4, 4'd3, 4'd2,
																					 4'd1, 4'd2, 4'd3, 4'd4};
				right_note <= 0;
			end else if (count > 26'b1111_0111_1111_0100_1001_0000_0 * 5) begin
				{notes[0], notes[1], notes[2], notes[3],
				 notes[4], notes[5], notes[6], notes[7],
				 notes[8], notes[9], notes[10], notes[11],
				 notes[12], notes[13], notes[14], notes[15]} <= {4'd6, 4'd5, 4'd4, 4'd3,
																					 4'd2, 4'd1, 4'd2, 4'd3,
																					 4'd4, 4'd5, 4'd4, 4'd3,
																					 4'd2, 4'd1, 4'd2, 4'd3};
				right_note <= 1;
			end else if (count > 26'b1111_0111_1111_0100_1001_0000_0 * 4) begin
				{notes[0], notes[1], notes[2], notes[3],
				 notes[4], notes[5], notes[6], notes[7],
				 notes[8], notes[9], notes[10], notes[11],
				 notes[12], notes[13], notes[14], notes[15]} <= {4'd5, 4'd6, 4'd5, 4'd4,
																					 4'd3, 4'd2, 4'd1, 4'd2,
																					 4'd3, 4'd4, 4'd5, 4'd4,
																					 4'd3, 4'd2, 4'd1, 4'd2};
				right_note <= 0;
			end else if (count > 26'b1111_0111_1111_0100_1001_0000_0 * 3) begin
				{notes[0], notes[1], notes[2], notes[3],
				 notes[4], notes[5], notes[6], notes[7],
				 notes[8], notes[9], notes[10], notes[11],
				 notes[12], notes[13], notes[14], notes[15]} <= {4'd4, 4'd5, 4'd6, 4'd5,
																					 4'd4, 4'd3, 4'd2, 4'd1,
																					 4'd2, 4'd3, 4'd4, 4'd5,
																					 4'd4, 4'd3, 4'd2, 4'd1};
				right_note <= 1;
			end else if (count > 26'b1111_0111_1111_0100_1001_0000_0 * 2) begin
				{notes[0], notes[1], notes[2], notes[3],
				 notes[4], notes[5], notes[6], notes[7],
				 notes[8], notes[9], notes[10], notes[11],
				 notes[12], notes[13], notes[14], notes[15]} <= {4'd3, 4'd4, 4'd5, 4'd6,
																					 4'd5, 4'd4, 4'd3, 4'd2,
																					 4'd1, 4'd2, 4'd3, 4'd4,
																					 4'd5, 4'd4, 4'd3, 4'd2};
				right_note <= 0;
			end else if (count > 26'b1111_0111_1111_0100_1001_0000_0 * 1) begin
				{notes[0], notes[1], notes[2], notes[3],
				 notes[4], notes[5], notes[6], notes[7],
				 notes[8], notes[9], notes[10], notes[11],
				 notes[12], notes[13], notes[14], notes[15]} <= {4'd2, 4'd3, 4'd4, 4'd5,
																					 4'd6, 4'd5, 4'd4, 4'd3,
																					 4'd2, 4'd1, 4'd2, 4'd3,
																					 4'd4, 4'd5, 4'd4, 4'd3 };
				right_note <= 1;
			end else if (count <= 26'b1111_0111_1111_0100_1001_0000_0 * 1) begin
				{notes[0], notes[1], notes[2], notes[3],
				 notes[4], notes[5], notes[6], notes[7],
				 notes[8], notes[9], notes[10], notes[11],
				 notes[12], notes[13], notes[14], notes[15]} <= {4'd1, 4'd2, 4'd3, 4'd4,
																					 4'd5, 4'd6, 4'd5, 4'd4,
																					 4'd3, 4'd2, 4'd1, 4'd2,
																					 4'd3, 4'd4, 4'd5, 4'd4 };
				right_note <= 0;
			end
		end
	end
	
//	wire [63:0] nn = {notes[15], notes[14], notes[13], notes[12], notes[11], notes[10],
//							 notes[9], notes[8], notes[7], notes[6], notes[5], notes[4], notes[3],
//							 notes[2], notes[1], notes[0]};
	wire [63:0] nn;
	wire [25:0] tempo;
	wire [63:0] msl_debug;
	
	wire [7:0] fifo_data_input;
	wire rd;
	wire rxf;
	wire [7:0] fifo_data_output;
	reg [7:0] from_fifo;
	wire fifo_newout;
	wire fifo_hold;
	wire [3:0] fifo_state;
	
	assign fifo_data_input = user1[9:2];
//	assign rd = user1[1];
	assign user1[1] = rd;
	assign rxf = user1[0];
	
	usb_input usb_input_module(.clk(clk),
										.reset(reset),
										.data(fifo_data_input),
										.rd(rd),
										.rxf(rxf),
										.out(fifo_data_output),
										.newout(fifo_newout),
										.hold(switch[3]),
										.state(fifo_state));
										
	always @(posedge clk) begin
		if (fifo_newout) begin
			from_fifo <= fifo_data_output;
		end
	end
	
   // wire up to ZBT ram
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
			
	wire zbt_iw_newout;
	wire [35:0] zbt_iw_output;
	reg [35:0] zbt_iw_output_reg;
	zbt_image_writer ziw1(.clk(clk),
						  .reset(reset),
						  .image_data(fifo_data_output),
						  .new_input(fifo_newout),
						  .new_output(zbt_iw_newout),
						  .image_data_zbt(zbt_iw_output));
	
	wire [7:0] image_bits;
	reg [18:0] vram_write_addr = 0;
	wire [18:0] vram_read_addr;
//	reg [2:0] vram_read_img_counter = 0;
	
	assign vram_we = zbt_iw_newout;
	assign vram_addr = (zbt_iw_newout == 1) ? vram_write_addr 
															: vram_read_addr;
	assign vram_write_data = zbt_iw_output_reg;
	
	vram_display vd1(.reset(reset),
						  .clk(clk),
						  .hcount(hcount),
						  .vcount(vcount),
						  .vr_pixel(image_bits),
						  .vram_addr(vram_read_addr),
						  .vram_read_data(vram_read_data));
	reg [9:0] x_pixels = 0;
	reg [9:0] y_pixels = 0;
	
	always @(posedge clk) begin
		if (reset) begin
			vram_write_addr <= 0;
			x_pixels <= 0;
			y_pixels <= 0;
//			vram_read_addr <= 0;
//			vram_read_img_counter <= 0;
		end
		
		if (fifo_newout) begin
			x_pixels <= x_pixels + 1;
		end
		
		if (x_pixels >= 1023) begin
			x_pixels <= 0;
			y_pixels <= y_pixels + 1;
		end
		
		if (zbt_iw_newout) begin
			vram_write_addr <= {0, y_pixels, x_pixels[9:2]};
			zbt_iw_output_reg <= zbt_iw_output;
		end
		
//		vram_read_img_counter <= vram_read_img_counter + 1;
//		
//		if (vram_read_img_counter >= 3) begin
//			vram_read_addr <= vram_read_addr + 1;
//			vram_read_img_counter <= 0;
//		end
		
//		if ((hcount == 1) && (vcount == 1)) begin
//			vram_read_addr <= 0;
//		end
//		
//		case(vram_read_img_counter)
//			3'd0: image_bits <= vram_read_data[7:0];
//			3'd1: image_bits <= vram_read_data[15:8];
//			3'd2: image_bits <= vram_read_data[23:16];
//			3'd3: image_bits <= vram_read_data[31:24];
//			default: image_bits <= 8'h00;
//		endcase
		// PIXEL # (hcount-x) + (vcount-y) * WIDTH;
	end
	
	musical_score_loader msl(.clk(clk), .reset(reset),
								    .song_id(switch[7]), .next_notes_out(nn),
									 .tempo_out(tempo),
									 .debug_out(msl_debug));
	
   rh_display rh_disp(.vclock(clk),.reset(reset),
		.up(up), .down(down),
		.playing_correct(right_note),
		.menu_state(switch[6:4]),
		.next_notes(nn),
		.score_string("00006111"),
		.current_note_string("C"),
		.tempo(tempo),
		.bono_image_bits(image_bits),
		.hcount(hcount),.vcount(vcount),
      .hsync(hsync),.vsync(vsync),
		.blank(blank),.phsync(phsync),
		.pvsync(pvsync),.pblank(pblank),
		.pixel(pixel), .debug(dispdata));

	display_16hex hex_display(.reset(reset), 
		.clock_27mhz(clk), 
		.data({ dispdata,
				  from_fifo,image_bits }),//fifo_state,
				  //3'b0,fifo_newout}),//{nn[63:31], 2'b00, dispdata}),
		.disp_blank(disp_blank), 
		.disp_clock(disp_clock), 
		.disp_rs(disp_rs), 
		.disp_ce_b(disp_ce_b),
		.disp_reset_b(disp_reset_b),
		.disp_data_out(disp_data_out));
		
	//{ 4'hF,1'b0,vram_read_addr,4'hF,
//				  1'b0,vram_write_addr,
//				  from_fifo,image_bits}

   // switch[1:0] selects which video generator to use:
   //  00: user's pong game
   //  01: 1 pixel outline of active video area (adjust screen controls)
   //  10: color bars
   reg [23:0] rgb;
   wire border = (hcount==0 | hcount==1023 | vcount==0 | vcount==767);
   
   reg b,hs,vs;
   always @(posedge clk) begin
      if (switch[1:0] == 2'b01) begin
	 // 1 pixel outline of visible area (white)
	 hs <= hsync;
	 vs <= vsync;
	 b <= blank;
	 rgb <= {24{border}};
      end else if (switch[1:0] == 2'b10) begin
	 // color bars
	 hs <= hsync;
	 vs <= vsync;
	 b <= blank;
	 rgb <= {{8{hcount[8]}}, {8{hcount[7]}}, {8{hcount[6]}}} ;
      end else begin
         // default: pong
	 hs <= phsync;
	 vs <= pvsync;
	 b <= pblank;
	 rgb <= pixel;
      end
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
   
   assign led = ~{2'b00, vram_we,up,down,reset,switch[1:0]};

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
	input [7:0] current_note_string,
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
	
	wire [3:0] notes[15:0];
	wire [23:0] note_pixels[15:0];
	reg [10:0] lead_note_x = 1023;
	
	parameter [23:0] COLOR = 24'hFF_FF_FF;
	
	assign {notes[15], notes[14], notes[13], notes[12],
			  notes[11], notes[10], notes[9], notes[8],
			  notes [7], notes[6], notes[5], notes[4],
			  notes [3], notes[2], notes[1], notes[0] } = next_notes;

	reg [9:0] note_y_pos[15:0];
	reg [23:0] note_color[15:0];
	
	wire [23:0] note_line_pixels[7:0];
	integer k;
	
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
	

	reg load_tempo = 0;
	
	// Temporary tempo is 1/2 vclock, .5s per eighth note
	//reg [25:0] temp_tempo = 26'b1111_0111_1111_0100_1001_0000_0;
	reg [25:0] song_tempo = 26'b1111_0111_1111_0100_1001_0000_0;
	wire tempo_beat;
	wire tempo_beat_move;
	
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
	
	wire action_line = hcount == ACTION_LINE_X & vcount >= 128 & vcount <= 639;
	wire right_boundary_line = hcount == 1023 & vcount >= 128 & vcount <= 639;
	
	reg [23:0] onscreen_notes[15:0];
	integer n;
	
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
					// EOF
					4'd16: note_y_pos[k] <= FIRST_LETTER + 768;
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
	
	wire [2:0] current_note_pixel;
	char_string_display csd_note(.vclock(vclock),
											.hcount(hcount),
											.vcount(vcount),
											.pixel(current_note_pixel),
											.cstring({"NOTE: ", current_note_string}),
											.cx(700),
											.cy(30));
	defparam csd_note.NCHAR = 7;
	defparam csd_note.NCHAR_BITS = 3;

	wire [23:0] bmp_pixel;
	picture_blob pb(.pixel_clk(vclock),
					    .x(4),
						 .hcount(hcount),
						 .y(128),
						 .vcount(vcount),
						 .pixel(bmp_pixel));
						 
	wire [23:0] bono_pixel;
	bono_picture_blob bpb_img(.pixel_clk(vclock),
								     .x(1),
									  .hcount(hcount),
									  .y(1),
									  .vcount(vcount),
									  .image_bits(bono_image_bits),
									  .pixel(bono_pixel));

	wire [23:0] curr_note_alpha_blend_pixel;
	reg [9:0] curr_note_y;
	reg [23:0] bmp_pixel_alpha;
	
//   blob #(.WIDTH(72), .HEIGHT(50))
//		letter_alpha(.x(1),
//			  .y(curr_note_y),
//			  .hcount(hcount),
//			  .vcount(vcount),
//			  .color(24'hFF_FF_00),
//			  .pixel(curr_note_alpha_blend_pixel));

	always @(*) begin
		case(current_note_string)
			"B" : curr_note_y = 127;
			"A#": curr_note_y = 127 + 1*NOTE_STEP;
			"A" : curr_note_y = 127 + 1*NOTE_STEP;
			"G#": curr_note_y = 127 + 2*NOTE_STEP;
			"G" : curr_note_y = 127 + 2*NOTE_STEP;
			"F#": curr_note_y = 127 + 3*NOTE_STEP;
			"F" : curr_note_y = 127 + 3*NOTE_STEP;
			"E" : curr_note_y = 127 + 4*NOTE_STEP;
			"D#": curr_note_y = 127 + 5*NOTE_STEP;
			"D" : curr_note_y = 127 + 5*NOTE_STEP;
			"C#": curr_note_y = 127 + 6*NOTE_STEP;
			"C" : curr_note_y = 127 + 6*NOTE_STEP;
		endcase
		
		if (|bmp_pixel 
		    && vcount >= curr_note_y 
		    && vcount <= curr_note_y + NOTE_STEP) begin
			bmp_pixel_alpha = bmp_pixel/2 + (24'hFF_FF_00 / 2);
		end else begin
			bmp_pixel_alpha = bmp_pixel;
		end
	end
	
	///////////////////////
	// MAIN MENU DISPLAY //
//	///////////////////////
//	always @(*) begin
//		if (menu_state[2] == 0) begin
//			pixel = onscreen_notes[0]
//						| onscreen_notes[1]
//						| onscreen_notes[2]
//						| onscreen_notes[3]
//						| onscreen_notes[4]
//						| onscreen_notes[5]
//						| onscreen_notes[6]
//						| onscreen_notes[7]
//						| onscreen_notes[8]
//						| onscreen_notes[9]
//						| onscreen_notes[10]
//						| onscreen_notes[11]
//						| onscreen_notes[12]
//						| onscreen_notes[13]
//						| onscreen_notes[14]
//						| onscreen_notes[15]
//						| note_line_pixels[0]
//						| note_line_pixels[1]
//						| note_line_pixels[2]
//						| note_line_pixels[3]
//						| note_line_pixels[4]
//						| note_line_pixels[5]
//						| note_line_pixels[6]
//						| note_line_pixels[7]
//						| {24{action_line}}
//						| {24{right_boundary_line}}
//						| {8{score_pixel}}
//						| {8{current_note_pixel}}
//						| bmp_pixel_alpha;
//		end else begin
//			pixel = 24'b0;
//		end
//	end
	
	assign pixel = bono_pixel;
//	assign pixel = onscreen_notes[0]
//						| onscreen_notes[1]
//						| onscreen_notes[2]
//						| onscreen_notes[3]
//						| onscreen_notes[4]
//						| onscreen_notes[5]
//						| onscreen_notes[6]
//						| onscreen_notes[7]
//						| onscreen_notes[8]
//						| onscreen_notes[9]
//						| onscreen_notes[10]
//						| onscreen_notes[11]
//						| onscreen_notes[12]
//						| onscreen_notes[13]
//						| onscreen_notes[14]
//						| onscreen_notes[15]
//						| note_line_pixels[0]
//						| note_line_pixels[1]
//						| note_line_pixels[2]
//						| note_line_pixels[3]
//						| note_line_pixels[4]
//						| note_line_pixels[5]
//						| note_line_pixels[6]
//						| note_line_pixels[7]
//						| {24{action_line}}
//						| {24{right_boundary_line}}
//						| {8{score_pixel}}
//						| {8{current_note_pixel}}
//						| bmp_pixel_alpha;
						
	assign debug = {bono_pixel};
endmodule