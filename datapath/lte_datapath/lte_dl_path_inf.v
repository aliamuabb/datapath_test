module lte_dl_path_inf
(
	input	wire				clk_491p52,
	input	wire				rst_491p52,
	input	wire		  		asy_rst,	
    input	wire		  		clk,
	
	input	wire				i_ant8_sel,
    input	wire	[29:0]		i_data,
    input	wire				i_data_valid,
    input	wire				i_fram_hd,

	input	wire 				i_frame_hd,
	input	wire 	[31:0]		i_data0_iq,
	input	wire 	[31:0]		i_cell_iqselcfg0,
	input			[31:0]		i_reg_dl_delay_time,
	
	input	wire	[15:0]		i_mod_sel,
	
	input	wire				i_timedelay_fram,
    //input from module timing
    input	wire				i_ac_flag,
    input	wire				i_odd_even,	
    //output to duc   
    output	wire				o_ant8_sel,
    output	wire	[15:0]		o_data,
    output	wire				o_data_valid,
    output	wire				o_fram_hd,
    //reg_if   
    input	wire	[31:0]		reg_ant_posinfo,
    input	wire	[15:0]		reg_path_bandwidth,
    //dl_tdl_test 
    input	wire	[ 3:0]		reg_dl_tdl_data_sel,			
	input	wire	[31:0]		reg_dl_tdl_data_iq,
	input	wire	[31:0]		reg_dl_tdl_data_start,
	input	wire	[31:0]		reg_dl_tdl_data_end,
	input	wire	[ 0:0]	   	reg_dl_path_test_val,
	//dl_tdl_agc
	input	wire	[31:0]   	reg_lte_duc_gain0,
	input	wire	[31:0]   	reg_lte_duc_gain1,
	input	wire	[31:0]   	reg_lte_duc_gain2,
	input	wire	[31:0]   	reg_lte_duc_gain3,
	input	wire	[31:0]   	reg_lte_duc_gain4,
	input	wire	[31:0]   	reg_lte_duc_gain5,
	input	wire	[31:0]   	reg_lte_duc_gain6,
	input	wire	[31:0]   	reg_lte_duc_gain7,	
//	input	wire	[31:0]		reg_duc_agc_6db_sel,
	
	input	wire	[31:0]		reg_ant0_pow,
	input	wire	[31:0]		reg_ant1_pow,
	input	wire	[31:0]		reg_ant2_pow,
	input	wire	[31:0]		reg_ant3_pow,
	input	wire	[31:0]		reg_ant4_pow,
	input	wire	[31:0]		reg_ant5_pow,
	input	wire	[31:0]		reg_ant6_pow,
	input	wire	[31:0]		reg_ant7_pow,
	input	wire				i_lte_pd_clr,
	input	wire	[10:0]		i_lte_pd_raddr,
	output	wire	[31:0]		o_lte_pd_rdata_hi,
	output	wire	[31:0]		o_lte_pd_rdata_lo,

	output	wire	[42:0]		o_debug_dl_path
	
//	output wire	[255:0]	o_debug_datapath
);

wire				src2agc_fram;
wire	[29:0]		src2agc_data;
wire				src2agc_sel; 
wire				src2agc_valid;

wire				agc2delay_fram;   
wire				agc2delay_sel;
wire	[31:0]		agc2delay_data;

wire				delay2trans_fram;
wire	[31:0]		delay2trans_data;
wire				delay2trans_sel; 

lte_dl_tdl_test u_lte_dl_tdl_test
(
    .asy_rst                (asy_rst                                    ),      
    .clk_245                (clk										),
    .i_fram_hd              (i_fram_hd									),
    .i_ant8_sel             (i_ant8_sel									),
    .i_data                 (i_data										),
    .i_data_valid           (i_data_valid								),
    .i_frame_hd				(i_frame_hd									),
    .i_data0_iq				(i_data0_iq									),
    .i_cell_iqselcfg0		(i_cell_iqselcfg0							),
    .i_ac_flag              (i_ac_flag								),
    .o_fram_hd              (src2agc_fram							),
    .o_ant8_sel             (src2agc_sel							),
    .o_data                 (src2agc_data							),
    .o_data_valid           (						),
    .reg_sim_tdl_sel        (reg_dl_tdl_data_sel						),
    .reg_sim_tdl_data_i     (reg_dl_tdl_data_iq[31:16]					),
    .reg_sim_tdl_data_q     (reg_dl_tdl_data_iq[15:0]					),
    .reg_dl_tdl_data_start  (reg_dl_tdl_data_start                      ),
    .reg_dl_tdl_data_end    (reg_dl_tdl_data_end                        ),
    .reg_dl_tdl_test_val    (reg_dl_path_test_val						)
);

//lte_dl_tdl_agc u_lte_dl_tdl_agc
//(
//	.asy_rst							(asy_rst),	//rst
//	.clk_245						    (clk),  //clk 245p76    
//	.i_data								(delay2pow_data),	//tds duc agc fram hd
//	.i_data_valid						(),
//	.i_fram_hd							(delay2pow_fram),  //tds duc agc data
//	.i_ant8_sel							(delay2pow_sel),         
//	.o_data								(u_dl_path_agc2dl_trans_data        ),//o_data  																		),	//dfe ca switch ram wdata
//	.o_data_valid						(  ),//o_data_valid  															),
//	.o_ant8_sel							(u_dl_path_agc2dl_trans_ant8_sel    ),//o_ant8_sel  																),  //dfe ca switch ram we
//	.o_fram_hd      					(u_dl_path_agc2dl_trans_fram     ),  //dfe ca switch ram fram hd
//	.i_lte_duc_gain1					(reg_lte_duc_gain0),
//	.i_lte_duc_gain2					(reg_lte_duc_gain1),
//	.i_lte_duc_gain3					(reg_lte_duc_gain2),
//	.i_lte_duc_gain4					(reg_lte_duc_gain3),  
//	.i_lte_duc_gain5					(reg_lte_duc_gain4),
//	.i_lte_duc_gain6					(reg_lte_duc_gain5),
//	.i_lte_duc_gain7					(reg_lte_duc_gain6),
//	.i_lte_duc_gain8					(reg_lte_duc_gain7)//,  	
//);

data_path_agc        
#(
.XNUM(8)
)u_lte_dl_path_agc
(
	.reset							  	(asy_rst),	//rst
	.clk						     	(clk),  //clk 245p76    
	.i_data								({src2agc_data[29:15],1'd0,src2agc_data[14:0],1'd0}),	//tds duc agc fram hd
	.i_fram_hd							(src2agc_fram		),//(ac2agc_fram),  //tds duc agc data
	.i_ant8_sel							(src2agc_sel		),//(ac2agc_sel),         
	.o_data								(agc2delay_data		),//o_data  																		),	//dfe ca switch ram wdata
	.o_ant8_sel							(agc2delay_sel		),//o_ant8_sel  																),  //dfe ca switch ram we
	.o_fram_hd      					(agc2delay_fram		),  //dfe ca switch ram fram hd
	.i_ddc_agc_6db_sel               	('d0),
	.i_ddc_gain_lte						({reg_lte_duc_gain7,reg_lte_duc_gain6,reg_lte_duc_gain5,reg_lte_duc_gain4,reg_lte_duc_gain3,reg_lte_duc_gain2,reg_lte_duc_gain1,reg_lte_duc_gain0})
);

datapath_delay # (
	.DIRECTION			("DW"),
	.MODE				("LTE")
) u_datapath_delay (
	.clk				(clk),
	.rst				(asy_rst),

	.i_fram_hd			(agc2delay_fram	),
	.i_xant_hd			(agc2delay_sel	),
	.i_data				(agc2delay_data	),

	.i_adjust_hd		(i_timedelay_fram),

	.o_fram_hd			(delay2trans_fram	),
	.o_xant_hd			(delay2trans_sel	),
	.o_data				(delay2trans_data)
);

pd_dw_lte_top u_pd_dw_lte_top (
	.sys_clk		(clk),	//245.76M
	.sys_rst		(asy_rst),
	.i_fram			(delay2trans_fram),
	.i_xant			(delay2trans_sel),
	.i_data			(delay2trans_data),
	.i_clr			(i_lte_pd_clr),
	.i_sel			(i_mod_sel[1:0]),
	.i_pd_raddr		(i_lte_pd_raddr),
	.o_pd_rdata_lo	(o_lte_pd_rdata_lo),
	.o_pd_rdata_hi	(o_lte_pd_rdata_hi)
);

lte_dw_dfe_trans_inf_antswitch u_lte_dw_dfe_trans_inf_antswitch
(
	.sys_clk_491p52		(clk_491p52),
	.sys_rst_491p52		(rst_491p52),
	.sys_clk_245p76		(clk),
	.sys_rst_245p76		(asy_rst),

	.i_mod_sel			(i_mod_sel[1:0]),	//0->5M   1->10M   2->15M   3->20M
	.i_ant_pos			(reg_ant_posinfo),

	.i_fram				(delay2trans_fram),
	.i_data				(delay2trans_data),		//i[31:16] q[15: 0]

	.o_fram				(o_fram_hd),
	.o_xant				(o_ant8_sel),
	.o_data				(o_data)
);

endmodule