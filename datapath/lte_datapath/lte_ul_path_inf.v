module lte_ul_path_inf
(
	input	wire				clk_491p52,
	input	wire				rst_491p52,
    input   wire                asy_rst,				
    input   wire                clk,                
	input   wire                i_fram_hd,		
	input   wire                i_ant8_sel,
	input   wire	[15:0]      i_data,
	input   wire                i_data_valid,
	input   wire                i_ac_flag,
	
	input						i_frame_hd,
	input			[31:0]		i_data0_iq,
	input			[31:0]		i_cell_iqselcfg0,
	input			[31:0]		i_reg_ul_delay_time,
	
	input	wire	[15:0]		i_mod_sel,
	
	input	wire				i_timedelay_fram,
	
	input   wire    [31:0]      i_loop_data,
    input   wire                i_loop_ant8_sel,
    input   wire                i_loop_fram_hd,
    input   wire                i_loop_data_valid,  //add by chendanqing 2012-03-13
	//bbu interface
	output	wire				o_ant8_sel,
    output	wire	[29:0]		o_data,
    output	wire				o_data_valid,
    output	wire				o_fram_hd,                                                                  
	//reg_if
	//reg ul_mem_ctr
	input	wire	[31:0]		reg_ant_posinfo,
	input   wire    [15:0]      reg_path_bandwidth,
	//reg ul_tdl_test
	input   wire    [ 3:0]      reg_ul_tdl_data_sel,  
	input   wire    [31:0]      reg_ul_tdl_data_iq,
	input   wire    [31:0]      reg_ul_tdl_data_start,
	input   wire    [31:0]      reg_ul_tdl_data_end,
	input 	wire 	[ 0:0]		reg_ul_path_test_val,
	input	wire	[31:0]		reg_ul_tdl_path_cfg,
	//reg ul_tdl_pow_dect
	input   wire                reg_ul_tdl_pd_trig,
    input   wire    [7:0]      	reg_ul_tdl_pd_raddr,
    output  wire    [31:0]      reg_ul_tdl_pd_rdata,
    //reg ul_tdl_agc       
	input   wire    [31:0]      reg_lte_ddc_gain0,
	input   wire    [31:0]      reg_lte_ddc_gain1,
	input   wire    [31:0]      reg_lte_ddc_gain2,
	input   wire    [31:0]      reg_lte_ddc_gain3,
	input   wire    [31:0]      reg_lte_ddc_gain4,
	input   wire    [31:0]      reg_lte_ddc_gain5,
	input   wire    [31:0]      reg_lte_ddc_gain6,
	input   wire    [31:0]      reg_lte_ddc_gain7,
	input   wire    [31:0]      reg_ddc_agc_6db_sel,
	
	
	output  wire    [255:0]     o_debug_datapath
);

     
wire			    ul_data_valid;
//output of ul_path_sync
wire		 	    ul_path_test2ul_tdl_agc_u_fram;
wire			    ul_path_test2ul_tdl_agc_u_ant8_sel;
wire    [31:0]      ul_path_test2ul_tdl_agc_u_data;
wire			    ul_path_test2ul_tdl_agc_u_data_valid;
//output of u_ul_path_agc
wire			    ul_path_agc2ul_mem_ctr_u_fram;
wire			    ul_path_agc2ul_mem_ctr_u_ant8_sel;
wire	[29:0]	    ul_path_agc2ul_mem_ctr_u_data;
wire			    ul_path_agc2ul_mem_ctr_u_data_valid;
wire    [127:0]     debug_tdl_test;
wire    [127:0]     debug_mem;

// ul trans test
wire                u_ant8_sel_test;
wire    [15:0]      u_data_0_test;
wire    [15:0]      u_data_1_test;
wire                u_data_vld_test;
wire    [70:0]      debug_men;
wire    [114:0]     debug_test;

//chipsocope
wire	[255:0]	o_debug_ul_pow_dect_245;

wire				trans2src_fram;
wire	[31:0]		trans2src_data;
wire				trans2src_sel; 
wire				trans2src_valid;

wire				src2delay_fram;
wire	[31:0]		src2delay_data;
wire				src2delay_sel; 

wire				delay2agc_fram;
wire	[31:0]		delay2agc_data;
wire				delay2agc_sel; 

wire 	[31:0]		w_agc_data;

//modify lte_ulpower_framhd @ 2022-07-14 by liushaojie
localparam		MAX_10MS_CNT = 2457600;
localparam		LTE_PRE_VAL = MAX_10MS_CNT / 10 * 3;	//pre 3ms
reg		[21:0]	lte_ulpower_cnt;
reg		[ 8:0]	lte_ulpower_framhd_exp;
wire			lte_ulpower_framhd;
lte_up_dfe_trans_inf_antswitch u_lte_up_dfe_trans_inf_antswitch
(
	.sys_clk_491p52		(clk_491p52),
	.sys_rst_491p52		(rst_491p52),
	.sys_clk_245p76		(clk),
	.sys_rst_245p76		(asy_rst),

	.i_mod_sel			(i_mod_sel[1:0]),	//0->5M   1->10M   2->15M   3->20M
	.i_ant_pos			(reg_ant_posinfo),

	.i_fram				(i_fram_hd),
	.i_xant				(i_ant8_sel),
	.i_data				(i_data),		//8i 8q

	.o_fram				(trans2src_fram),
	.o_xant				(trans2src_sel),
	.o_data				(trans2src_data)
);

lte_ul_tdl_test u_lte_ul_tdl_test
(
	.asy_rst							(asy_rst),
	.clk_245							(clk),
	
	.i_fram_hd							(trans2src_fram),
	.i_ant8_sel							(trans2src_sel),     
	.i_data								(trans2src_data),
	.i_data_valid						(1'b1),
	.i_ac_flag							(i_ac_flag),

	.i_frame_hd							(i_frame_hd),
	.i_data0_iq							(i_data0_iq),
	.i_cell_iqselcfg0					('h0),

	.o_fram_hd							(src2delay_fram),    
	.o_ant8_sel							(src2delay_sel),
	.o_data								(src2delay_data),
	.o_data_valid						(),

	.i_ul_tdl_path_src_sel				(reg_ul_tdl_data_sel[3:0]	),
	.i_ul_tdl_path_data_i				(reg_ul_tdl_data_iq[31:16]	),
	.i_ul_tdl_path_data_q				(reg_ul_tdl_data_iq[15:0]	),
	.i_ul_tdl_path_data_start			(reg_ul_tdl_data_start		),
	.i_ul_tdl_path_data_end				(reg_ul_tdl_data_end		),
	.i_ul_tdl_path_cfg 					(reg_ul_tdl_path_cfg		),
	.i_ul_tdl_test_val      			(reg_ul_path_test_val		)     
);

datapath_delay # (
	.DIRECTION			("UP"),
	.MODE				("LTE")
) u_datapath_delay (
	.clk				(clk),
	.rst				(asy_rst),

	.i_fram_hd			(src2delay_fram	),
	.i_xant_hd			(src2delay_sel	),
	.i_data				(src2delay_data	),

	.i_adjust_hd		(i_timedelay_fram),

	.o_fram_hd			(delay2agc_fram	),
	.o_xant_hd			(delay2agc_sel	),
	.o_data				(delay2agc_data	)
);

power_detect_top
#(
.SF_TIME(245760),
.FRAM_NUM(300),
.SF_NUM(10),
.SF_ADDR_NUM(10),
.ANT_NUM(8),
.MODE("BOARD")
)lte_power_detect_top
(
 .reset			(asy_rst		)			
,.clk			(clk			)                             
,.i_fram_hd		(lte_ulpower_framhd)
,.i_data		(delay2agc_data	)
,.trig			(reg_ul_tdl_pd_trig	)
,.i_pow_dect_raddr  (reg_ul_tdl_pd_raddr)
,.o_pow_dect_rdata  (reg_ul_tdl_pd_rdata)  
);

always @ (posedge clk) begin
	if(delay2agc_fram)
		lte_ulpower_cnt <= 22'd0;
	else
		lte_ulpower_cnt <= lte_ulpower_cnt + 22'd1;
end
//expend 8 clk cycle
always @ (posedge clk) begin
	if(lte_ulpower_cnt == MAX_10MS_CNT - LTE_PRE_VAL - 1)
		lte_ulpower_framhd_exp <= 8'hff;
	else
		lte_ulpower_framhd_exp <= {lte_ulpower_framhd_exp[6:0], 1'b0};
end
assign lte_ulpower_framhd = lte_ulpower_framhd_exp[7] & delay2agc_sel;

data_path_agc        
#(
.XNUM(8)
)u_lte_ul_path_agc
(
	.reset							  	(asy_rst),	//rst
	.clk						     	(clk),  //clk 245p76    
	.i_data								(delay2agc_data),	//tds duc agc fram hd
	.i_fram_hd							(delay2agc_fram),//(ac2agc_fram),  //tds duc agc data
	.i_ant8_sel							(delay2agc_sel   ),//(ac2agc_sel),         
	.o_data								(w_agc_data      ),//o_data  																		),	//dfe ca switch ram wdata
	.o_ant8_sel							(o_ant8_sel    ),//o_ant8_sel  																),  //dfe ca switch ram we
	.o_fram_hd      					(o_fram_hd     ),  //dfe ca switch ram fram hd
	.i_ddc_agc_6db_sel               	('d0),
	.i_ddc_gain_lte						({reg_lte_ddc_gain7,reg_lte_ddc_gain6,reg_lte_ddc_gain5,reg_lte_ddc_gain4,reg_lte_ddc_gain3,reg_lte_ddc_gain2,reg_lte_ddc_gain1,reg_lte_ddc_gain0})
); 

assign o_data = {w_agc_data [31:17],w_agc_data[15:1]};

endmodule
