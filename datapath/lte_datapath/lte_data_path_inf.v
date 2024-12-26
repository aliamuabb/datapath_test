module lte_data_path_inf
(
    input	wire		  		clk_245p76,
    input	wire		  		rst_245p76,
    input	wire				clk_491p52,
	input	wire				rst_491p52,

    output	wire				o_path_txant,
    output	wire	[29:0]		o_path_tdata,
    output	wire				o_path_tfram,

    input	wire				i_path_fxant,
    input	wire	[29:0]		i_path_fdata,
    input	wire				i_path_ffram,

    output	wire				o_freq_txant,
    output	wire	[15:0]		o_freq_tdata,
    output	wire				o_freq_tfram,

    input	wire				i_freq_fxant,
    input	wire	[15:0]		i_freq_fdata,
    input	wire				i_freq_ffram,
    
    input	wire	[31:0]		i_mod_sel,

    input	wire	[31:0]		i_dw_ant_posinfo,
    input	wire	[31:0]		i_up_ant_posinfo,
    
    input	wire				i_timedelay_dw_fram,
    input	wire				i_timedelay_up_fram,

    input 						i_frame_hd,
    input 			[31:0]		i_data0_iq,
    input 			[31:0]		i_dl_cell_iqselcfg0,
    input 			[31:0]		i_ul_cell_iqselcfg0,

    input 			[31:0]		i_reg_dl_delay_time,
    input 			[31:0]		i_reg_ul_delay_time,
    input 	wire 	[31:0]		reg_ul_tdl_path_cfg,

    input	wire	[ 3:0]		reg_dl_tdl_data_sel,
    input	wire	[31:0]		reg_dl_tdl_data_iq,
	input	wire	[31:0]		reg_dl_tdl_data_start,
	input	wire	[31:0]		reg_dl_tdl_data_end,
	input	wire	[ 0:0]		reg_dl_path_test_val,

	input	wire	[ 3:0]		reg_ul_tdl_data_sel,
    input	wire	[31:0]		reg_ul_tdl_data_iq,
	input   wire    [31:0]      reg_ul_tdl_data_start,
	input   wire    [31:0]      reg_ul_tdl_data_end,
	input	wire	[ 0:0]		reg_ul_path_test_val,

	input	wire	[31:0]   	reg_lte_duc_gain0,
	input	wire	[31:0]   	reg_lte_duc_gain1,
	input	wire	[31:0]   	reg_lte_duc_gain2,
	input	wire	[31:0]   	reg_lte_duc_gain3,
	input	wire	[31:0]   	reg_lte_duc_gain4,
	input	wire	[31:0]   	reg_lte_duc_gain5,
	input	wire	[31:0]   	reg_lte_duc_gain6,
	input	wire	[31:0]   	reg_lte_duc_gain7,


	input   wire                reg_ul_tdl_pd_trig,
    input   wire    [7:0]       reg_ul_tdl_pd_raddr,
    output  wire    [31:0]      reg_ul_tdl_pd_rdata,

	input   wire    [31:0]      reg_lte_ddc_gain0,
	input   wire    [31:0]      reg_lte_ddc_gain1,
	input   wire    [31:0]      reg_lte_ddc_gain2,
	input   wire    [31:0]      reg_lte_ddc_gain3,
	input   wire    [31:0]      reg_lte_ddc_gain4,
	input   wire    [31:0]      reg_lte_ddc_gain5,
	input   wire    [31:0]      reg_lte_ddc_gain6,
	input   wire    [31:0]      reg_lte_ddc_gain7,

	input   wire    [31:0]      reg_ddc_agc_6db_sel,
	input   wire    [31:0]      reg_duc_agc_6db_sel,

	input	wire	[31:0]		reg_ant0_pow,
	input	wire	[31:0]		reg_ant1_pow,
	input	wire	[31:0]		reg_ant2_pow,
	input	wire	[31:0]		reg_ant3_pow,
	input	wire	[31:0]		reg_ant4_pow,
	input	wire	[31:0]		reg_ant5_pow,
	input	wire	[31:0]		reg_ant6_pow,
	input	wire	[31:0]		reg_ant7_pow,
	input	wire				i_lte_dw_pd_clr,
	input	wire	[10:0]		i_lte_dw_pd_raddr,
	output	wire	[31:0]		o_lte_dw_pd_rdata_hi,
	output	wire	[31:0]		o_lte_dw_pd_rdata_lo,

	output  wire    [42:0]     o_debug_datapath
);

wire	[15:0]		loop_data;
wire				loop_ant8_sel;
wire				loop_data_valid;
wire				loop_fram_hd;

//assign o_freq_tdata = loop_data;
//assign o_freq_tfram = loop_fram_hd;
//assign o_freq_txant = loop_ant8_sel;

lte_dl_path_inf u_lte_dl_path_inf
(
	.asy_rst                            (rst_245p76),
    .clk                                (clk_245p76),
    .clk_491p52							(clk_491p52),
	.rst_491p52							(rst_491p52),

    .i_ant8_sel							(i_path_fxant),
    .i_data								(i_path_fdata),
    .i_data_valid						(1'b1),
    .i_fram_hd                          (i_path_ffram),

	.i_frame_hd							(i_frame_hd),
	.i_data0_iq							(i_data0_iq),
	.i_cell_iqselcfg0					(i_dl_cell_iqselcfg0),
	
	.i_mod_sel							(i_mod_sel[15:0]),
    
    .i_timedelay_fram					(i_timedelay_dw_fram),
    .i_reg_dl_delay_time				(i_reg_dl_delay_time),
    
    .i_ac_flag                          (1'b0),
    .i_odd_even                         (1'b0),

    .o_ant8_sel                         (o_freq_txant),
    .o_data                             (o_freq_tdata),
    .o_data_valid                       (),
    .o_fram_hd                       	(o_freq_tfram),

    .reg_ant_posinfo					(i_dw_ant_posinfo),
    .reg_path_bandwidth					(16'd3),

    .reg_dl_tdl_data_sel				(reg_dl_tdl_data_sel),
	.reg_dl_tdl_data_iq                 (reg_dl_tdl_data_iq),
	.reg_dl_tdl_data_start              (reg_dl_tdl_data_start),
	.reg_dl_tdl_data_end                (reg_dl_tdl_data_end),
	.reg_dl_path_test_val               (reg_dl_path_test_val),

	.reg_lte_duc_gain0                  (reg_lte_duc_gain0),
	.reg_lte_duc_gain1                  (reg_lte_duc_gain1),
	.reg_lte_duc_gain2                  (reg_lte_duc_gain2),
	.reg_lte_duc_gain3                  (reg_lte_duc_gain3),
	.reg_lte_duc_gain4                  (reg_lte_duc_gain4),
	.reg_lte_duc_gain5                  (reg_lte_duc_gain5),
	.reg_lte_duc_gain6                  (reg_lte_duc_gain6),
	.reg_lte_duc_gain7                	(reg_lte_duc_gain7),
//	.reg_duc_agc_6db_sel				(reg_duc_agc_6db_sel),

	.reg_ant0_pow                   	(reg_ant0_pow),
	.reg_ant1_pow                   	(reg_ant1_pow),
	.reg_ant2_pow                   	(reg_ant2_pow),
	.reg_ant3_pow                   	(reg_ant3_pow),
	.reg_ant4_pow                   	(reg_ant4_pow),
	.reg_ant5_pow                   	(reg_ant5_pow),
	.reg_ant6_pow                   	(reg_ant6_pow),
	.reg_ant7_pow                		(reg_ant7_pow),
	.i_lte_pd_clr						(i_lte_dw_pd_clr),
	.i_lte_pd_raddr						(i_lte_dw_pd_raddr),
	.o_lte_pd_rdata_hi					(o_lte_dw_pd_rdata_hi),
	.o_lte_pd_rdata_lo					(o_lte_dw_pd_rdata_lo),

	.o_debug_dl_path                    (o_debug_datapath)

);

lte_ul_path_inf u_lte_ul_path_inf
(
    .asy_rst                            (rst_245p76),
    .clk                                (clk_245p76),
    .clk_491p52							(clk_491p52),
	.rst_491p52							(rst_491p52),

	.i_fram_hd                          (i_freq_ffram),
	.i_ant8_sel                         (i_freq_fxant),
	.i_data                           	(i_freq_fdata),
	.i_data_valid                       (1'b1),
	.i_ac_flag                          (1'b1),
	
	.i_mod_sel							(i_mod_sel[31:16]),

	.i_timedelay_fram					(i_timedelay_up_fram),
    .i_reg_ul_delay_time				(i_reg_ul_delay_time),

	.i_frame_hd							(i_frame_hd),
	.i_data0_iq							(i_data0_iq),
	.i_cell_iqselcfg0					(i_ul_cell_iqselcfg0),

	.o_data                        		(o_path_tdata),
    .o_ant8_sel                        	(o_path_txant),
    .o_fram_hd                          (o_path_tfram),
    .o_data_valid						(),

    .i_loop_fram_hd                     (1'b0),
 	.i_loop_data                        (32'd0),
 	.i_loop_ant8_sel                    (1'b0),
 	.i_loop_data_valid                  (1'b0),

	.reg_ant_posinfo					(i_up_ant_posinfo),
	.reg_path_bandwidth					(16'd3),

	.reg_ul_tdl_data_sel				(reg_ul_tdl_data_sel),
	.reg_ul_tdl_data_iq                 (reg_ul_tdl_data_iq),
	.reg_ul_tdl_data_start              (reg_ul_tdl_data_start),
	.reg_ul_tdl_data_end                (reg_ul_tdl_data_end),
	.reg_ul_path_test_val               (reg_ul_path_test_val),
	.reg_ul_tdl_path_cfg				(reg_ul_tdl_path_cfg),

	.reg_ul_tdl_pd_trig                 (reg_ul_tdl_pd_trig),
    .reg_ul_tdl_pd_raddr                (reg_ul_tdl_pd_raddr),
    .reg_ul_tdl_pd_rdata                (reg_ul_tdl_pd_rdata),

	.reg_lte_ddc_gain0              	(reg_lte_ddc_gain0),
	.reg_lte_ddc_gain1              	(reg_lte_ddc_gain1),
	.reg_lte_ddc_gain2              	(reg_lte_ddc_gain2),
	.reg_lte_ddc_gain3              	(reg_lte_ddc_gain3),
	.reg_lte_ddc_gain4              	(reg_lte_ddc_gain4),
	.reg_lte_ddc_gain5              	(reg_lte_ddc_gain5),
	.reg_lte_ddc_gain6              	(reg_lte_ddc_gain6),
	.reg_lte_ddc_gain7              	(reg_lte_ddc_gain7),

	.reg_ddc_agc_6db_sel	             (reg_ddc_agc_6db_sel),

	.o_debug_datapath                   ()
);

//ila_uldatapath u_ila_uldatapath
//(
//.clk        (clk_245p76),
//.probe0     (o_path_tdata),
//.probe1     (o_path_txant),
//.probe2     (o_path_tfram),
//.probe3     (i_freq_ffram),
//.probe4     (i_freq_fxant),
//.probe5     (i_freq_fdata)
//);

endmodule
