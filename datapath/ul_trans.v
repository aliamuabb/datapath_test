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

module ul_trans
(
input   wire            	clk_491,
//
input   wire	[31:0]  	i_freq_fdata,
input   wire             	i_freq_ffram,

output  wire				o_freq_ffram,
output  wire	[31:0]		o_freq0_fdata,
output  wire	[31:0]		o_freq1_fdata

);


reg [127:0] r_freq_fdata;
reg [  3:0]	r_freq_ffram;
reg	[  2:0]	r_antx8_cnt;		



always @ (posedge clk_491)
begin
	r_freq_ffram   [3:0]  <= {r_freq_ffram [2:0],i_freq_ffram};
	r_freq_fdata [127:0]  <= {r_freq_fdata [95:0],i_freq_fdata[31:0]};
end


always @ (posedge clk_491)
begin
	if (i_freq_ffram)
		r_antx8_cnt <= 3'h0;
	else 
		r_antx8_cnt <= r_antx8_cnt + 3'd1; 
end



assign o_freq_ffram  = r_freq_ffram[3];
assign o_freq0_fdata = (r_antx8_cnt[2]) ? r_freq_fdata[127:96]:32'h0;
assign o_freq1_fdata = (r_antx8_cnt[2]) ? i_freq_fdata [31: 0]:32'h0;

endmodule