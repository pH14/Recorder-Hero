module vram_display(reset,clk,hcount,vcount,vr_pixel,
		    vram_addr,vram_read_data);

   input reset, clk;
   input [10:0] hcount;
   input [9:0] 	vcount;
   output [7:0] vr_pixel;
   output [18:0] vram_addr;
   input [35:0]  vram_read_data;

   //forecast hcount & vcount 8 clock cycles ahead to get data from ZBT
   wire [10:0] hcount_f;
	assign hcount_f = (hcount >= 1024) ? (hcount - 1024) : (hcount + 2);
   wire [9:0] vcount_f;
	assign vcount_f = (hcount >= 1024) ? ((vcount == 805) ? 0 : vcount + 1) : vcount;
      
   wire [18:0] ram_addr;
	assign vram_addr = {1'b0, vcount_f, hcount_f[9:2]};
//	assign vram_addr = {1'b0, vcount, hcount[9:2]};
	
   wire [1:0] hc4;
	assign hc4 = hcount[1:0];
	
   reg [7:0] 	 vr_pixel;
   reg [35:0] 	 vr_data_latched;
   reg [35:0] 	 last_vr_data;

   always @(posedge clk)
     last_vr_data <= (hc4==2'd3) ? vr_data_latched : last_vr_data;

   always @(posedge clk)
     vr_data_latched <= (hc4==2'd1) ? vram_read_data : vr_data_latched;

   always @(*)		// each 36-bit word from RAM is decoded to 4 bytes
     case (hc4)
       2'd0: vr_pixel = last_vr_data[7:0];
       2'd1: vr_pixel = last_vr_data[7+8:0+8];
       2'd2: vr_pixel = last_vr_data[7+16:0+16];
       2'd3: vr_pixel = last_vr_data[7+24:0+24];
     endcase

endmodule // vram_display