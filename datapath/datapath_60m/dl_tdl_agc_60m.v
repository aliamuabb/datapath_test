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

module dl_tdl_agc_60m
#(
parameter	XNUM = 8
)(
input   wire            	asy_rst,
input   wire            	clk_245,
//
input	wire			 	i_fram_hd,
input   wire	[31:0]  	i_data,
input   wire             	i_data_valid,
input   wire             	i_ant8_sel,
output	wire				o_fram_hd,
output  wire				o_ant8_sel,	//rdy is 1 cycles earlier than data
output  wire				o_data_valid,
output  reg		[31:0]		o_data,
//path_reg
input   wire     [31:0]   i_lte_duc_gain0,
input   wire     [31:0]   i_lte_duc_gain1,
input   wire     [31:0]   i_lte_duc_gain2,
input   wire     [31:0]   i_lte_duc_gain3,
input   wire     [31:0]   i_lte_duc_gain4,
input   wire     [31:0]   i_lte_duc_gain5,
input   wire     [31:0]   i_lte_duc_gain6,
input   wire     [31:0]   i_lte_duc_gain7
);

reg		[7:0]	ant8_sel_d;
reg		[7:0]	fram_hd_d;
reg		[7:0]	data_valid_d;

wire	[35:0]	pout_i;
wire	[35:0]	pout_q;

wire    [16:0]  duc_gain;

reg	    [3:0] 	lte_rdy_cnt = 0;

wire    [31:0]  lte_agc_data;
reg     [15:0]   lte_duc_gain;

//agc


always @ (posedge clk_245 )
begin
    	if (fram_hd_d[0])
    		lte_rdy_cnt<= 0;
    	else
    	begin
    	   if  (lte_rdy_cnt == XNUM - 1)
    	       lte_rdy_cnt <= 0;
    	   else
    	       lte_rdy_cnt <= lte_rdy_cnt+1;
        end
end

always @ (posedge clk_245)
begin
			case(lte_rdy_cnt)
			3'h0 : lte_duc_gain <= i_lte_duc_gain0;
			3'h1 : lte_duc_gain <= i_lte_duc_gain1;
			3'h2 : lte_duc_gain <= i_lte_duc_gain2;
			3'h3 : lte_duc_gain <= i_lte_duc_gain3;
			3'h4 : lte_duc_gain <= i_lte_duc_gain4;
			3'h5 : lte_duc_gain <= i_lte_duc_gain5;
			3'h6 : lte_duc_gain <= i_lte_duc_gain6;
			3'h7 : lte_duc_gain <= i_lte_duc_gain7;
			default	: lte_duc_gain <= i_lte_duc_gain0;
			endcase
end


db_gain_table u_db_gain_table(
	.addra(lte_duc_gain[7:0]), //8bit
	.dina(17'b0),
	.wea(1'b0),
	.clka(clk_245),
	.douta(duc_gain)     //17bit
	);


agc_18_18 u_dl_tdl_agc_i (
  .CLK  ( clk_245 ),				// input CLK
  .A    ( {1'b0,duc_gain} ),		// input [17 : 0] A
  .B    ( {i_data[31:16],2'b00}),	// input [17 : 0] B
  .P    ( pout_i )					// output [35 : 0] P
);

agc_18_18 u_dl_tdl_agc_q (
  .CLK  ( clk_245 ),				// input CLK
  .A    ( {1'b0,duc_gain} ),		// input [17 : 0] A
  .B    ( {i_data[15:0],2'b00} ),	// input [17 : 0] B
  .P    ( pout_q )					// output [35 : 0] P
);


assign  lte_agc_data[31:16] = {pout_i[35],pout_i[32:18]} ;
assign  lte_agc_data[15:0]  = {pout_q[35],pout_q[32:18]} ;

assign	o_ant8_sel = ant8_sel_d[6];
assign	o_fram_hd = fram_hd_d[6];
assign	o_data_valid = data_valid_d[6];

always @ (posedge clk_245 )
begin
		o_data <= lte_agc_data;
		ant8_sel_d<={ant8_sel_d[6:0],i_ant8_sel};
		fram_hd_d<={fram_hd_d[6:0],i_fram_hd};
		data_valid_d<={data_valid_d[6:0],i_data_valid};
end


endmodule