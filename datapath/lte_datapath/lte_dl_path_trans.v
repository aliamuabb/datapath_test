`timescale 1ns / 1ps
//---------------------------------------------------------------------------------
//Module Name:					dl_trans_lte.v   
//Department:					Beijing R&D Center FPGA Design Dept
//Function Description:			5th Generation Data Path
//---------------------------------------------------------------------------------
//Version				Design				Coding				Simulate				Review				Rel data
//V1.0					Yangliu				Yangliu															2011-12-20
//
//---------------------------------------------------------------------------------
//Version				Modified History
//V1.0					draft

//-------------------------------key words-----------------------------------------
//	
//
// 
////////////////////////////////////////////////////////////////////////////////

module lte_dl_path_trans
(
	input	wire				clk_491p52,
	input	wire				rst_491p52,
	input	wire				clk,
	input	wire				asy_rst,
	
	input	wire	[31:0]		i_ant_posinfo,
	
	input	wire				i_fram_hd,		
	input	wire				i_ant8_sel,	
	input	wire	[31:0]		i_data,				
	input	wire				i_data_valid,
	
	output	wire				o_fram_hd,				
	output	wire				o_ant8_sel,
	output	wire	[15:0]		o_data,		
	output	wire				o_data_valid			
);


reg		[ 4:0]		cycle_cnt;
reg		[ 4:0]		buf_waddr;	
reg		[31:0]		ant_posinfo;
reg		[ 4:0]		frame_cnt;

reg		[ 3:0]		frame_dly;
reg					frame_edg;
reg		[ 5:0]		buf_raddr;
wire				frame_hd;

reg		[ 3:0]		fram_hd_d;
reg					ant8_sel;
//data counter
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			frame_cnt <= 5'd0;
		else if (i_fram_hd)
			frame_cnt <= 5'd1;
		else if(|frame_cnt)
			frame_cnt <= frame_cnt + 5'b1;	
		else;	
	end
	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			cycle_cnt <= 5'd0;
		else if (i_fram_hd)
			cycle_cnt <= 5'd0;
		else
			cycle_cnt <= cycle_cnt + 5'b1;		
	end
	
always @ (posedge clk)
	begin
		ant_posinfo <= i_ant_posinfo;	
	end
	
always @ (*)
	begin
		case(cycle_cnt[2:0])
			3'b000 : buf_waddr <= {cycle_cnt[4:3],ant_posinfo[ 2: 0]};
			3'b001 : buf_waddr <= {cycle_cnt[4:3],ant_posinfo[ 6: 4]};
			3'b010 : buf_waddr <= {cycle_cnt[4:3],ant_posinfo[10: 8]};
			3'b011 : buf_waddr <= {cycle_cnt[4:3],ant_posinfo[14:12]};
			3'b100 : buf_waddr <= {cycle_cnt[4:3],ant_posinfo[18:16]};
			3'b101 : buf_waddr <= {cycle_cnt[4:3],ant_posinfo[22:20]};
			3'b110 : buf_waddr <= {cycle_cnt[4:3],ant_posinfo[26:24]};
			3'b111 : buf_waddr <= {cycle_cnt[4:3],ant_posinfo[30:28]};
			default: buf_waddr <= 5'b00000;
		endcase	
	end
		
path2freq_ram u_path2freq_ram
(
    .clka            		(clk),
    .wea             		(1'b1),
    .addra           		(buf_waddr),
    .dina            		({i_data[15:0],i_data[31:16]}),
    .clkb            		(clk_491p52),
    .addrb           		({buf_raddr[5:4],buf_raddr[2:0],buf_raddr[3]}),
    .doutb           		(o_data)
);

always @ (posedge clk_491p52)
	begin
		frame_dly <= {frame_dly[2:0],frame_cnt[4]};
		frame_edg <= frame_dly[2] & (~frame_dly[3]);
	end
/*	
framhd_protect_clk # 
(
	.NUM_DECIMAL_FRAM (8'd149					),
	.NUM_INTEGER_FRAM (15'd32767				)
)
u_framhd_protect
(
	.asy_rst         (rst_491p52				),
	.clk             (clk_491p52				),
	.i_ext_hd        (frame_edg					),
	.i_fram_max      (24'd3686399               ),
	.o_int_hd        (frame_hd					) 
);
*/

assign frame_hd = frame_edg;
always @ (posedge rst_491p52 or posedge clk_491p52)
	begin
		if (rst_491p52)
			buf_raddr <= 6'd0;
		else if (frame_hd)
			buf_raddr <= 6'd0;
		else
			buf_raddr <= buf_raddr + 6'b1;		
	end

always @ (posedge rst_491p52 or posedge clk_491p52)
	begin
		if (rst_491p52)
			ant8_sel <= 1'b0;
		else 
			ant8_sel <= (buf_raddr[3:0] == 4'b0);	
	end
	
assign o_ant8_sel = ant8_sel;

always @ (posedge rst_491p52 or posedge clk_491p52)
	begin
		if (rst_491p52)
			fram_hd_d <= 4'b0;	
		else
			fram_hd_d <={fram_hd_d[2:0],frame_hd};
	end
	
assign o_fram_hd =  fram_hd_d[1];
//assign o_fram_hd = frame_edg;
assign o_data_valid = 1'b1;

//vavido_ila_trans vavido_ila_trans
//(
//    .clk                (clk_491p52),
//    .probe0				(i_fram_hd),
//    .probe1				(i_ant8_sel),
//    .probe2				(i_data),
//    .probe3				(o_fram_hd),
//    .probe4				(o_ant8_sel),
//    .probe5				(o_data),
//    .probe6				(buf_waddr),
//    .probe7				(buf_raddr),
//    .probe8				(frame_hd)
//);
			
endmodule