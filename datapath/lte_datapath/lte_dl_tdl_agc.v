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

module lte_dl_tdl_agc    (
input   wire            asy_rst,
input   wire            clk_245,
// 
input	wire			 i_fram_hd,
input   wire     [29:0]  i_data,
input   wire             i_data_valid,
input   wire             i_ant8_sel,
output	reg				 o_fram_hd,
output  reg              o_ant8_sel,	//rdy is 1 cycles earlier than data
output  reg   	 		 o_data_valid,
output  reg	    [31:0]   o_data,
//path_reg
input   wire     [31:0]   i_lte_duc_gain1,      //[15:0]
input   wire     [31:0]   i_lte_duc_gain2,
input   wire     [31:0]   i_lte_duc_gain3,
input   wire     [31:0]   i_lte_duc_gain4,
input   wire     [31:0]   i_lte_duc_gain5,
input   wire     [31:0]   i_lte_duc_gain6,
input   wire     [31:0]   i_lte_duc_gain7,
input   wire     [31:0]   i_lte_duc_gain8
);


reg		[5:0]	ant8_sel_d;
reg		[5:0]	fram_hd_d;
reg		[5:0]	data_valid_d;

wire	[35:0]	pout_i;	 
wire	[35:0]	pout_q;

wire    [16:0]  duc_gain;

reg	    [2:0] 	lte_rdy_cnt;

wire    [31:0]  lte_agc_data;
reg     [15:0]   lte_duc_gain;

//agc 


always @ ( posedge asy_rst or posedge clk_245 )
begin   
    if ( asy_rst )
      	lte_rdy_cnt<= 3'b0;
    else if (i_fram_hd == 1'b1)
    		lte_rdy_cnt<= 3'd3;
    else 
    		lte_rdy_cnt <= lte_rdy_cnt+3'b1;
end

always @ (posedge asy_rst or posedge clk_245)
begin
	if (asy_rst)
		lte_duc_gain <= 16'b0;
	else
		begin
			case(lte_rdy_cnt)
			3'd0 : lte_duc_gain <= i_lte_duc_gain1;
			3'd1 : lte_duc_gain <= i_lte_duc_gain2;
			3'd2 : lte_duc_gain <= i_lte_duc_gain3;
			3'd3 : lte_duc_gain <= i_lte_duc_gain4;
			3'd4 : lte_duc_gain <= i_lte_duc_gain5;
			3'd5 : lte_duc_gain <= i_lte_duc_gain6;
			3'd6 : lte_duc_gain <= i_lte_duc_gain7;
			3'd7 : lte_duc_gain <= i_lte_duc_gain8;
			default:lte_duc_gain <= i_lte_duc_gain1;
			endcase
		end
end


db_gain_table u_db_gain_table(
	.addra(lte_duc_gain[7:0]), //8bit
	.dina(17'b0),
	.wea(1'b0),
	.clka(clk_245),
	.douta(duc_gain)     //17bit
	);

        
        
agc_18_18 u_dl_tdl_agc_i (
  .CLK  ( clk_245 ),              // input CLK
  .A    ( {1'b0,duc_gain} ),        // input [17 : 0] A
  .B    ( {i_data[29:15],3'b0}),    // input [17 : 0] B
  .P    ( pout_i )		               // output [35 : 0] P
);

agc_18_18 u_dl_tdl_agc_q (
  .CLK  ( clk_245 ),                      // input CLK
  .A    ( {1'b0,duc_gain} ),               // input [17 : 0] A
  .B    ( {i_data[14:0],3'b0} ),         // input [17 : 0] B
  .P    ( pout_q )		                      // output [35 : 0] P
);                           


assign  lte_agc_data[31:16] = {pout_i[35],pout_i[32:18]} ;
assign  lte_agc_data[15:0]  = {pout_q[35],pout_q[32:18]} ;


always @ ( posedge asy_rst or posedge clk_245 )
begin   
    if ( asy_rst )
      	o_data <= 32'b0;
    else
			o_data <= lte_agc_data;
end

always @ ( posedge asy_rst or posedge clk_245 )
begin   
    if ( asy_rst )
		ant8_sel_d<=6'b0;
	else
		ant8_sel_d<={ant8_sel_d[4:0],i_ant8_sel};	
end   

always @ ( posedge asy_rst or posedge clk_245 )
begin   
    if ( asy_rst )
      o_ant8_sel <= 1'b0;      
    else
	  o_ant8_sel <= ant8_sel_d[5];
end

always @ ( posedge asy_rst or posedge clk_245 )
begin   
    if ( asy_rst )
		fram_hd_d<=6'b0;
	else
		fram_hd_d<={fram_hd_d[4:0],i_fram_hd};	
end    

always @ ( posedge asy_rst or posedge clk_245 )
begin   
    if ( asy_rst )
		o_fram_hd<=1'b0;
	else
		o_fram_hd<=fram_hd_d[5];	
end 

//o_data_valid,add by chendanqing 2012-05-15
always @ ( posedge asy_rst or posedge clk_245 )
begin   
    if ( asy_rst )
		data_valid_d<=6'b0;
	else
		data_valid_d<={data_valid_d[4:0],i_data_valid};	
end    

always @ ( posedge asy_rst or posedge clk_245 )
begin   
    if ( asy_rst )
		o_data_valid<=1'b0;
	else
		o_data_valid<=data_valid_d[5];	
end 

endmodule