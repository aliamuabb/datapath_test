//This confidential and proprietary software may be used
//only as authorized by a licsnsing agreement from
//DTmobile
//In the event of publication, the following notice is
//applicable:
//
// (C) COPYRIGHT 2009 DTmobile
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all
//authorized copies.
//
// Filename : lte_ir_2_duc_interface.v
// Author : wangxinsheng
// Date : 12/11/09
// Version : 1.0
// Description :
//
// Modification History:
//Date By Version Change Description
//
//========================================================
// 12/11/09 wangxinsheng 1.0 Original
//
//========================================================
//`timescale 1ns / 10ps

module dl_trans
(
input   wire            	clk_491,
//
input   wire	[31:0]		i_bandwidth_sel,

input   wire	[31:0]  	i_freq0_fdata,
input   wire	[31:0]  	i_freq1_fdata,
input   wire             	i_freq_ffram,

output  reg					o_freq_txant,
output  reg					o_freq_tfram,
output  reg		[31:0]		o_freq_tdata

);


reg [127:0] r_freq1_buff;
reg [ 31:0] r_freq1_fdata;
reg [ 31:0] r_freq0_fdata;
reg 		r_freq_ffram;
reg	[  4:0]	r_antx8_cnt;		

reg r_freq_tfram;

always @ (posedge clk_491)
begin
	r_freq_tfram 		  <= i_freq_ffram;
	o_freq_tfram		  <= r_freq_tfram;
	r_freq0_fdata [ 31:0] <= i_freq0_fdata;
	r_freq1_buff  [127:0] <= {r_freq1_buff [95:0],i_freq1_fdata[31:0]};
	r_freq1_fdata [ 31:0] <= r_freq1_buff[127:96];
end


always @ (posedge clk_491)
begin
	if (r_freq_tfram)
		r_antx8_cnt <= 5'd0;
	else 
		r_antx8_cnt <= r_antx8_cnt + 5'd1; 
end

// 2->20M ;3->30M ;4->40M ;5->50M ;6->60M ;8->80M ;9->90M ;A->100M
always @ (posedge clk_491)
begin
    case (i_bandwidth_sel[3:0])
        4'h1:    o_freq_txant <= (r_antx8_cnt[4:0] == 5'd31);   //10M x32 ant
		4'h2:    o_freq_txant <= (r_antx8_cnt[3:0] == 4'd15);   //20M x16 ant
		4'h3:    o_freq_txant <= (r_antx8_cnt[3:0] == 4'd15);   //30M x16 ant
		4'h4:    o_freq_txant <= (r_antx8_cnt[2:0] == 3'd7 );   //40M x8 ant
		4'h5:    o_freq_txant <= (r_antx8_cnt[2:0] == 3'd7 );   //50M x8 ant
		4'h6:    o_freq_txant <= (r_antx8_cnt[2:0] == 3'd7 );   //60M x8 ant
		default : o_freq_txant <= (r_antx8_cnt[2:0] == 3'd7 );   //60M x8 ant
	endcase
end

always @ (posedge clk_491)
begin
	if (r_antx8_cnt[2])
		o_freq_tdata <= r_freq1_fdata[31:0];
	else
		o_freq_tdata <= r_freq0_fdata[31:0];
end

endmodule