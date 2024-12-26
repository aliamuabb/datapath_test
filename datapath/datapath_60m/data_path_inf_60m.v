
module data_path_inf_60m
(
     input	wire		  		asy_rst
    ,input	wire		  		clk
	,input	wire				clk_125
    
    ,output	wire				o_path_txant
    ,output	wire	[31:0]		o_path_tdata
    ,output	wire				o_path_tfram
    
    ,input	wire				i_path_fxant
    ,input	wire	[31:0]		i_path_fdata
    ,input	wire				i_path_ffram
    
    ,output	wire				o_freq_txant
    ,output	wire	[31:0]		o_freq_tdata
    ,output	wire				o_freq_tfram
    
    ,input	wire				i_freq_fxant
    ,input	wire	[31:0]		i_freq_fdata
    ,input	wire				i_freq_ffram

    ,input  wire    [31:0]      i_frame_hd
    ,input	wire	[31:0]		i_data0_iq
    ,input	wire	[31:0]		i_data1_iq   
    
    ,input	wire				dl_power_bypass
    ,input	wire				ul_power_bypass
    ,input	wire	[31:0]		i_reg_dl_delay_time
    ,input	wire	[31:0]		i_reg_ul_delay_time
    
    ,input	wire	[31:0]		i_dl_test_vld
    ,input	wire	[31:0]		i_dl_cell_iqselcfg
    ,input	wire	[31:0]		i_dl_cell_iq
	,input	wire	[31:0]		i_dl_data_start
	,input	wire	[31:0]		i_dl_data_end
	,input	wire	    		i_dl_test_sel
    
    ,input	wire	[31:0]		i_ul_test_vld
    ,input	wire	[31:0]		i_ul_cell_iqselcfg
    ,input	wire	[31:0]		i_ul_cell_iq
	,input	wire	[31:0]		i_ul_data_start
	,input	wire	[31:0]		i_ul_data_end
	,input	wire	    		i_ul_test_sel
    
	,input	wire	[31:0]   	reg_lte_duc_gain0
	,input	wire	[31:0]   	reg_lte_duc_gain1
	,input	wire	[31:0]   	reg_lte_duc_gain2
	,input	wire	[31:0]   	reg_lte_duc_gain3
	,input	wire	[31:0]   	reg_lte_duc_gain4
	,input	wire	[31:0]   	reg_lte_duc_gain5
	,input	wire	[31:0]   	reg_lte_duc_gain6
	,input	wire	[31:0]   	reg_lte_duc_gain7
    
	,input   wire                reg_ul_tdl_pd_trig
    ,input   wire    [7:0]		reg_ul_tdl_pd_raddr
    ,output  wire    [31:0]      reg_ul_tdl_pd_rdata
    
	,input   wire    [31:0]      reg_ddc_gain_index_a0
	,input   wire    [31:0]      reg_ddc_gain_index_a1
	,input   wire    [31:0]      reg_ddc_gain_index_a2
	,input   wire    [31:0]      reg_ddc_gain_index_a3
	,input   wire    [31:0]      reg_ddc_gain_index_a4
	,input   wire    [31:0]      reg_ddc_gain_index_a5
	,input   wire    [31:0]      reg_ddc_gain_index_a6
	,input   wire    [31:0]      reg_ddc_gain_index_a7
    
	,input   wire    [31:0]      reg_ddc_agc_6db_sel
    
	,input	wire	[31:0]		reg_dl_ant0_pow
	,input	wire	[31:0]		reg_dl_ant1_pow
	,input	wire	[31:0]		reg_dl_ant2_pow
	,input	wire	[31:0]		reg_dl_ant3_pow
	,input	wire	[31:0]		reg_dl_ant4_pow
	,input	wire	[31:0]		reg_dl_ant5_pow
	,input	wire	[31:0]		reg_dl_ant6_pow
	,input	wire	[31:0]		reg_dl_ant7_pow
	    
	,input	wire	[31:0]		reg_ul_ant0_pow
	,input	wire	[31:0]		reg_ul_ant1_pow
	,input	wire	[31:0]		reg_ul_ant2_pow
	,input	wire	[31:0]		reg_ul_ant3_pow
	,input	wire	[31:0]		reg_ul_ant4_pow
	,input	wire	[31:0]		reg_ul_ant5_pow
	,input	wire	[31:0]		reg_ul_ant6_pow
	,input	wire	[31:0]		reg_ul_ant7_pow
	,
/////////seq_insert                          
                                             
   input  wire  i_tx_ac_valid          ,     
   input  wire  [2:0] i_ant_cnt        ,     
   input  wire  i_rx_seq_valid         ,     
   input  wire  i_tx_seq_valid         ,     
                                             
                                             
   input  wire  i_seq_insert_en        ,     
                                             
                                             
   input wire [6:0] i_seq_cnt          ,     
   	                                         
   input wire 		 i_sw_testdata     ,     
   input wire [31:0] i_testdata0       ,     
   input wire [31:0] i_testdata1       ,     
   input wire [31:0] i_testdata2       ,     
   input wire [31:0] i_testdata3       ,     
   input wire [31:0] i_testdata4       ,     
   input wire [31:0] i_testdata5       ,     
   input wire [31:0] i_testdata6       ,     
   input wire [31:0] i_testdata7       ,     
                                  
   input wire [31:0] i_amp_seq0        ,     
   input wire [31:0] i_amp_seq1        ,     
   input wire [31:0] i_amp_seq2        ,     
   input wire [31:0] i_amp_seq3        ,     
   input wire [31:0] i_amp_seq4        ,     
   input wire [31:0] i_amp_seq5        ,     
   input wire [31:0] i_amp_seq6        ,     
   input wire [31:0] i_amp_seq7	       ,     
                                             
   input wire [3:0] group_index        ,     
   input wire [3:0] reg_cal_ant_en     ,     
   output wire o_dl_frm_hd             ,     
   output wire o_x4_sel                ,
   input  wire i_dl_frm_hd             ,
   input  wire i_x4_sel   
      


);


dl_path_inf_60m u_dl_path_inf_60m
(
	.asy_rst                            (asy_rst),
    .clk                                (clk),

    .i_data								(i_path_fdata),
    .i_fram_hd                          (i_path_ffram),
	.i_ant8_sel							(i_path_fxant),

    .o_ant8_sel                         (o_freq_txant),
    .o_data                             (o_freq_tdata),
    .o_fram_hd                       	(o_freq_tfram),

    .reg_ant_posinfo0					(32'h76543210),
    .reg_ant_posinfo1					(32'h76543210),
    .dl_power_bypass					(dl_power_bypass),

	.i_reg_dl_delay_time				(i_reg_dl_delay_time),
    .i_frame_hd                         (i_frame_hd),
    .i_data0_iq							(i_data0_iq),
    .i_data1_iq							(i_data1_iq),

    .i_test_vld							(i_dl_test_vld),
    .i_cell_iqselcfg					(i_dl_cell_iqselcfg),
    .i_cell_iq							(i_dl_cell_iq),
    .i_data_start						(i_dl_data_start),
    .i_data_end							(i_dl_data_end),
    .i_test_sel							(i_dl_test_sel),

	.reg_lte_duc_gain0                  (reg_lte_duc_gain0),
	.reg_lte_duc_gain1                  (reg_lte_duc_gain1),
	.reg_lte_duc_gain2                  (reg_lte_duc_gain2),
	.reg_lte_duc_gain3                  (reg_lte_duc_gain3),
	.reg_lte_duc_gain4                  (reg_lte_duc_gain4),
	.reg_lte_duc_gain5                  (reg_lte_duc_gain5),
	.reg_lte_duc_gain6                  (reg_lte_duc_gain6),
	.reg_lte_duc_gain7                  (reg_lte_duc_gain7),
//	.reg_duc_agc_6db_sel				(reg_duc_agc_6db_sel),

	.reg_ant0_pow                   	(reg_dl_ant0_pow),
	.reg_ant1_pow                   	(reg_dl_ant1_pow),
	.reg_ant2_pow                   	(reg_dl_ant2_pow),
	.reg_ant3_pow                   	(reg_dl_ant3_pow),
	.reg_ant4_pow                   	(reg_dl_ant4_pow),
	.reg_ant5_pow                   	(reg_dl_ant5_pow),
	.reg_ant6_pow                   	(reg_dl_ant6_pow),
	.reg_ant7_pow                   	(reg_dl_ant7_pow),

	.o_debug_dl_path                    (),
	/////////seq_insert

   .i_tx_ac_valid                       (i_tx_ac_valid  ),
   .i_ant_cnt                           (i_ant_cnt      ),
   .i_rx_seq_valid                      (i_rx_seq_valid ),
   .i_tx_seq_valid                      (i_tx_seq_valid ),
   .i_seq_insert_en                     (i_seq_insert_en),
   .i_seq_cnt                           (i_seq_cnt      ),
   .i_sw_testdata                       (i_sw_testdata  ),
   .i_testdata0                         (i_testdata0    ),
   .i_testdata1                         (i_testdata1    ),
   .i_testdata2                         (i_testdata2    ),
   .i_testdata3                         (i_testdata3    ),
   .i_testdata4                         (i_testdata4    ),
   .i_testdata5                         (i_testdata5    ),
   .i_testdata6                         (i_testdata6    ),
   .i_testdata7                         (i_testdata7    ),
                                       
   .i_amp_seq0                         (i_amp_seq0),
   .i_amp_seq1                         (i_amp_seq1),
   .i_amp_seq2                         (i_amp_seq2),
   .i_amp_seq3                         (i_amp_seq3),
   .i_amp_seq4                         (i_amp_seq4),
   .i_amp_seq5                         (i_amp_seq5),
   .i_amp_seq6                         (i_amp_seq6),
   .i_amp_seq7	                       (i_amp_seq7),
   
   .group_index                        (group_index   ), 
   .reg_cal_ant_en                     (reg_cal_ant_en), 
   .o_dl_frm_hd                        (o_dl_frm_hd   ), 
   .o_x4_sel                           (o_x4_sel      ),
   .i_dl_frm_hd                        (i_dl_frm_hd   ),
   .i_x4_sel                           (i_x4_sel      )

);

ul_path_inf_60m u_ul_path_inf_60m
(
    .asy_rst                            (asy_rst),
    .clk                                (clk),
	.clk_125							(clk_125),

	.i_fram_hd                          (i_freq_ffram),
	.i_data                           	(i_freq_fdata),
	.i_ant8_sel							(i_freq_fxant),

	.o_data                        		(o_path_tdata),
    .o_fram_hd                          (o_path_tfram),
    .o_ant8_sel                         (o_path_txant),


	.reg_ant_posinfo0					(32'h76543210),
	.reg_ant_posinfo1					(32'h76543210),
    .ul_power_bypass					(ul_power_bypass),

	.i_reg_ul_delay_time				(i_reg_ul_delay_time),
    .i_frame_hd                         (i_frame_hd),
    .i_data0_iq							(i_data0_iq),
    .i_data1_iq							(i_data1_iq),

    .i_test_vld							(i_ul_test_vld),
    .i_cell_iqselcfg					(i_ul_cell_iqselcfg),
    .i_cell_iq							(i_ul_cell_iq),
    .i_data_start						(i_ul_data_start),
    .i_data_end							(i_ul_data_end),
    .i_test_sel							(i_ul_test_sel),

	.reg_ul_tdl_pd_trig                 (reg_ul_tdl_pd_trig),
    .reg_ul_tdl_pd_raddr                (reg_ul_tdl_pd_raddr),
    .reg_ul_tdl_pd_rdata                (reg_ul_tdl_pd_rdata),

	.reg_ddc_gain_index_a0              (reg_ddc_gain_index_a0),
	.reg_ddc_gain_index_a1              (reg_ddc_gain_index_a1),
	.reg_ddc_gain_index_a2              (reg_ddc_gain_index_a2),
	.reg_ddc_gain_index_a3              (reg_ddc_gain_index_a3),
	.reg_ddc_gain_index_a4              (reg_ddc_gain_index_a4),
	.reg_ddc_gain_index_a5              (reg_ddc_gain_index_a5),
	.reg_ddc_gain_index_a6              (reg_ddc_gain_index_a6),
	.reg_ddc_gain_index_a7              (reg_ddc_gain_index_a7),
	
	.reg_ant0_pow                   	(reg_ul_ant0_pow),
	.reg_ant1_pow                   	(reg_ul_ant1_pow),
	.reg_ant2_pow                   	(reg_ul_ant2_pow),
	.reg_ant3_pow                   	(reg_ul_ant3_pow),
	.reg_ant4_pow                   	(reg_ul_ant4_pow),
	.reg_ant5_pow                   	(reg_ul_ant5_pow),
	.reg_ant6_pow                   	(reg_ul_ant6_pow),
	.reg_ant7_pow                   	(reg_ul_ant7_pow),

	.reg_ddc_agc_6db_sel	             (reg_ddc_agc_6db_sel),
	.o_debug_datapath                   ()
);

endmodule
