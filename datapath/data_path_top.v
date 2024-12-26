module data_path_top
(
    input	wire		  		rst_245p76,
    input	wire		  		clk_245p76,
    input	wire				clk_491p52,
	input	wire				rst_491p52,
	input	wire				clk_125,
	input	wire				rst_125,

    input 			[23:0] 		spi_i_addr,
    input 			[31:0] 		spi_i_data,
    input 			       		spi_i_wr_en,
    input 			       		spi_i_rd_en,
    input 			       		spi_i_shift_en,
    output			       		spi_o_sdo,
//--------------------path 0------------------//
//-----------------up chu----------------//
    output	wire				o_path0_txant,
    output	wire	[31:0]		o_path0_tdata,
    output	wire				o_path0_tfram,
//-----------------dw ru----------------//    
    input	wire				i_path0_fxant,
    input	wire	[31:0]		i_path0_fdata,
    input	wire				i_path0_ffram,
//-----------------down chu----------------//
    output	wire				o_freq0_txant,
    output	wire	[31:0]		o_freq0_tdata,
    output	wire				o_freq0_tfram,
//-----------------up ru----------------//
    input	wire				i_freq0_fxant,
    input	wire	[31:0]		i_freq0_fdata,
    input	wire				i_freq0_ffram,
//---------------------path1-----------------//
//-----------------up chu----------------//
    output	wire				o_path1_txant,
    output	wire	[31:0]		o_path1_tdata,
    output	wire				o_path1_tfram,
//-----------------dw ru----------------// 
    input	wire				i_path1_fxant,
    input	wire	[31:0]		i_path1_fdata,
    input	wire				i_path1_ffram,
//-----------------down chu----------------//
    output	wire				o_freq1_txant,
    output	wire	[31:0]		o_freq1_tdata,
    output	wire				o_freq1_tfram,
//-----------------up ru----------------//    
    input	wire				i_freq1_fxant,
    input	wire	[31:0]		i_freq1_fdata,
    input	wire				i_freq1_ffram,
//--------------------path 4------------------//
    output	wire				o_path4_txant,
    output	wire	[29:0]		o_path4_tdata,
    output	wire				o_path4_tfram,
    input	wire				i_path4_fxant,
    input	wire	[29:0]		i_path4_fdata,
    input	wire				i_path4_ffram,

    output	wire				o_freq4_txant,
    output	wire	[15:0]		o_freq4_tdata,
    output	wire				o_freq4_tfram,
    input	wire				i_freq4_fxant,
    input	wire	[15:0]		i_freq4_fdata,
    input	wire				i_freq4_ffram,
//--------------------path 5------------------//
    output	wire				o_path5_txant,
    output	wire	[29:0]		o_path5_tdata,
    output	wire				o_path5_tfram,
    input	wire				i_path5_fxant,
    input	wire	[29:0]		i_path5_fdata,
    input	wire				i_path5_ffram,

    output	wire				o_freq5_txant,
    output	wire	[15:0]		o_freq5_tdata,
    output	wire				o_freq5_tfram,
    input	wire				i_freq5_fxant,
    input	wire	[15:0]		i_freq5_fdata,
    input	wire				i_freq5_ffram,
//--------------------path 6------------------//
    output	wire				o_path6_txant,
    output	wire	[29:0]		o_path6_tdata,
    output	wire				o_path6_tfram,
    input	wire				i_path6_fxant,
    input	wire	[29:0]		i_path6_fdata,
    input	wire				i_path6_ffram,

    output	wire				o_freq6_txant,
    output	wire	[15:0]		o_freq6_tdata,
    output	wire				o_freq6_tfram,
    input	wire				i_freq6_fxant,
    input	wire	[15:0]		i_freq6_fdata,
    input	wire				i_freq6_ffram,

	input	wire				i_timedelay_dw_fram,
    input	wire				i_timedelay_up_fram,
    
    input	wire				i_timedelay_lte_dw_fram_cell0,
    input	wire				i_timedelay_lte_up_fram_cell0,
    
    input	wire				i_timedelay_lte_dw_fram_cell1,
    input	wire				i_timedelay_lte_up_fram_cell1,
    
    input	wire				i_timedelay_lte_dw_fram_cell2,
    input	wire				i_timedelay_lte_up_fram_cell2,
    
    output	wire	[31:0]		o_nr_bandwidth_sel_cell0,
    
    output	wire	[31:0]		o_lte_bandwidth_sel_cell0,
    output	wire	[31:0]		o_lte_bandwidth_sel_cell1,
    output	wire	[31:0]		o_lte_bandwidth_sel_cell2,
    
    input	wire	[31:0]		i_deep_sleep_switch,

    input	wire				i_lte_frame_hd,
    input	wire	[31:0]		i_lte_data0_iq,

    input	wire				i_frame_hd,
    input	wire	[31:0]		i_data0_iq,
   	input	wire	[31:0]		i_data1_iq,

	/////////seq_insert
   	input 	wire  				i_tx_ac_valid,
   	input 	wire  	[2:0] 		i_ant_cnt,
   	input 	wire  				i_rx_seq_valid,
   	input 	wire  				i_tx_seq_valid,


   	input   wire[1:0]  		i_seq_insert_en,


   	input 	wire [13:0] 		i_seq_cnt,

   	input 	wire 				i_sw_testdata,
   	input 	wire 	[31:0] 		i_testdata0,
   	input 	wire 	[31:0] 		i_testdata1,
   	input 	wire 	[31:0] 		i_testdata2,
   	input 	wire 	[31:0] 		i_testdata3,
   	input 	wire 	[31:0] 		i_testdata4,
   	input 	wire 	[31:0] 		i_testdata5,
   	input 	wire 	[31:0] 		i_testdata6,
   	input 	wire 	[31:0] 		i_testdata7,

   	input 	wire 	[31:0] 		i_amp_seq0,
   	input 	wire 	[31:0] 		i_amp_seq1,
   	input 	wire 	[31:0] 		i_amp_seq2,
   	input 	wire 	[31:0] 		i_amp_seq3,
   	input 	wire 	[31:0] 		i_amp_seq4,
   	input 	wire 	[31:0] 		i_amp_seq5,
   	input 	wire 	[31:0] 		i_amp_seq6,
   	input 	wire 	[31:0] 		i_amp_seq7,
   	
   	input 	wire 	[7:0] 		group_index,
   	input 	wire 	[63:0] 		reg_cal_ant_en,
   	output 	wire 	[1:0] 		o_dl_frm_hd,
   	output 	wire 	[1:0] 		o_x4_sel,
   	input  	wire 	[1:0] 		i_dl_frm_hd,
   	input  	wire 	[1:0] 		i_x4_sel
);

//-----------------------------------5G--------------------------------//
//path_reg
 wire	[31:0]	reg_ddc_agc_6db_sel
;wire	[63:0]	reg_duc_gain_a0
;wire	[63:0]	reg_duc_gain_a1
;wire	[63:0]	reg_duc_gain_a2
;wire	[63:0]	reg_duc_gain_a3

;wire	[63:0]	reg_ddc_gain_a0
;wire	[63:0]	reg_ddc_gain_a1
;wire	[63:0]	reg_ddc_gain_a2
;wire	[63:0]	reg_ddc_gain_a3


;wire	[31:0]	i_dl_test_vld
;wire	[31:0]  i_dl_cell_iqselcfg
;wire	[31:0]  i_dl_cell_iq
;wire	[31:0]  i_dl_data_start
;wire	[31:0]  i_dl_data_end
;wire	[31:0]  i_dl_test_sel

;wire	[31:0]  i_ul_test_vld
;wire	[31:0]	i_ul_cell_iqselcfg
;wire	[31:0]  i_ul_cell_iq
;wire	[31:0]  i_ul_data_start
;wire	[31:0]  i_ul_data_end
;wire	[31:0]  i_ul_test_sel

;wire	[31:0]	u_dl_test_vld
;wire	[31:0]  u_dl_cell_iq
;wire	[31:0]  u_dl_test_sel

;wire	[31:0]	u_ul_test_vld
;wire	[31:0]  u_ul_cell_iq
;wire	[31:0]  u_ul_test_sel

;wire	[31:0]	ul_power_bypass
;wire	[31:0]	dl_power_bypass
;wire	[31:0]	mux_mode_switch
;wire	[63:0]	reg_dl_ant00_pow
;wire	[63:0]	reg_dl_ant01_pow
;wire	[63:0]	reg_dl_ant02_pow
;wire	[63:0]	reg_dl_ant03_pow

;wire	[63:0]	reg_ul_ant00_pow
;wire	[63:0]	reg_ul_ant01_pow
;wire	[63:0]	reg_ul_ant02_pow
;wire	[63:0]	reg_ul_ant03_pow
//pow_reg
;wire	[15:0]	reg_ul_tdl_path_pd_raddr
;wire	[63:0]	reg_ul_tdl_path_pd_rdata
;wire	[31:0]	reg_ul_tdl_path_pd_trig
;wire			power_reg_u_spi_sdo
;wire 	[31:0]	reg_dlpath_delay
;wire 	[31:0]	reg_ulpath_delay
;
reg	 [31:0] amp_seq0;
reg	 [31:0] amp_seq1;
reg	 [31:0] amp_seq2;
reg	 [31:0] amp_seq3;
reg	 [31:0] amp_seq4;
reg	 [31:0] amp_seq5;
reg	 [31:0] amp_seq6;
reg	 [31:0] amp_seq7;

reg					frame_hd_dly;
reg		[31:0]		data0_iq_dly;
reg		[31:0]		data1_iq_dly;

wire	[31:0]		reg_c0_dw_pd_clr;
wire	[31:0]		reg_c0_dw_pd_raddr;
wire	[31:0]		reg_c0_dw_pd_rdata_hi;
wire	[31:0]		reg_c0_dw_pd_rdata_lo;
wire	[31:0]		reg_c1_dw_pd_clr;
wire	[31:0]		reg_c1_dw_pd_raddr;
wire	[31:0]		reg_c1_dw_pd_rdata_hi;
wire	[31:0]		reg_c1_dw_pd_rdata_lo;

always @ (posedge clk_491p52)
begin
     amp_seq0 <= i_amp_seq0;//(sw_testdata)?testdata0:amp_seq0
     amp_seq1 <= i_amp_seq1;//(sw_testdata)?testdata1:amp_seq1
     amp_seq2 <= i_amp_seq2;//(sw_testdata)?testdata2:amp_seq2
     amp_seq3 <= i_amp_seq3;//(sw_testdata)?testdata3:amp_seq3
     amp_seq4 <= i_amp_seq4;//(sw_testdata)?testdata4:amp_seq4
     amp_seq5 <= i_amp_seq5;//(sw_testdata)?testdata5:amp_seq5
     amp_seq6 <= i_amp_seq6;//(sw_testdata)?testdata6:amp_seq6
     amp_seq7 <= i_amp_seq7;//(sw_testdata)?testdata7:amp_seq7
 end

always @ (posedge clk_491p52)
begin
     frame_hd_dly <= i_frame_hd;//(sw_testdata)?testdata0:amp_seq0
     data0_iq_dly <= i_data0_iq;//(sw_testdata)?testdata1:amp_seq1
     data1_iq_dly <= i_data1_iq;//(sw_testdata)?testdata2:amp_seq2
 end


wire  [31:0] w_bandwidth_60m;
assign o_nr_bandwidth_sel_cell0 = w_bandwidth_60m;

assign u_dl_test_vld = i_deep_sleep_switch[0]?32'h02:i_dl_test_vld;
assign u_dl_cell_iq  = i_deep_sleep_switch[0]?32'h00:i_dl_cell_iq ;
assign u_dl_test_sel = i_deep_sleep_switch[0]?32'hFF:i_dl_test_sel;

assign u_ul_test_vld = i_deep_sleep_switch[0]?32'h02:i_ul_test_vld;
assign u_ul_cell_iq  = i_deep_sleep_switch[0]?32'h00:i_ul_cell_iq ;
assign u_ul_test_sel = i_deep_sleep_switch[0]?32'hFF:i_ul_test_sel;

//--------------------dl trans----------------//
wire 		w_dl_trans_freq0_tfram;
wire [31:0] w_dl_trans_freq0_tdata;
wire 		w_dl_trans_freq0_txant;

wire 		w_dl_freq0_tfram;
wire		w_dl_freq0_txant;
wire [31:0] w_dl_freq0_tdata;
wire [31:0] w_dl_freq1_tdata;

dl_trans
dl_trans
(
	.clk_491 (clk_491p52),
	
	.i_bandwidth_sel (w_bandwidth_60m),
	
	.i_freq0_fdata (w_dl_freq0_tdata),
	.i_freq1_fdata (w_dl_freq1_tdata),
	.i_freq_ffram  (w_dl_freq0_tfram),
	.o_freq_txant  (w_dl_trans_freq0_txant),
	.o_freq_tfram  (w_dl_trans_freq0_tfram),
	.o_freq_tdata  (w_dl_trans_freq0_tdata)
);

assign o_freq0_txant 	   	= ((w_bandwidth_60m[15:0] == 32'h8)||(w_bandwidth_60m[15:0] == 32'h9)||(w_bandwidth_60m[15:0] == 32'hA)) ? w_dl_freq0_txant 	  : w_dl_trans_freq0_txant;
assign o_freq0_tfram 	   	= ((w_bandwidth_60m[15:0] == 32'h8)||(w_bandwidth_60m[15:0] == 32'h9)||(w_bandwidth_60m[15:0] == 32'hA)) ? w_dl_freq0_tfram 	  : w_dl_trans_freq0_tfram;
assign o_freq0_tdata [31:0]	= ((w_bandwidth_60m[15:0] == 32'h8)||(w_bandwidth_60m[15:0] == 32'h9)||(w_bandwidth_60m[15:0] == 32'hA)) ? w_dl_freq0_tdata[31:0] : w_dl_trans_freq0_tdata [31:0];

assign o_freq1_tdata [31:0]	= w_dl_freq1_tdata[31:0];

//ila_nr_datapath
//ila_nr_datapath
//(
//.clk (clk_491p52),
//.probe0 (i_path0_fdata [31:0]),
//.probe1 (i_path1_fdata [31:0]),
//.probe2 (i_path0_ffram),
//.probe3 (w_dl_freq0_tdata [31:0]),
//.probe4 (w_dl_freq1_tdata [31:0]),
//.probe5 (w_dl_freq0_tfram),
//.probe6 (w_dl_trans_freq0_txant),
//.probe7 (w_dl_trans_freq0_tfram),
//.probe8 (w_dl_trans_freq0_tdata[31:0])
//);

//--------------------ul trans----------------//
wire 		w_ul_trans_freq0_ffram;
wire [31:0] w_ul_trans_freq0_fdata;
wire [31:0] w_ul_trans_freq1_fdata;

wire 		w_ul_freq0_ffram;
wire 		w_ul_freq1_ffram;
wire [31:0] w_ul_freq0_fdata;
wire [31:0] w_ul_freq1_fdata;

//ul_trans 
//ul_trans
//(
//	.clk_491	(clk_491p52),
//	.i_freq_fdata  (i_freq0_fdata),
//	.i_freq_ffram  (i_freq0_ffram),
//	.o_freq_ffram  (w_ul_trans_freq0_ffram),
//	.o_freq0_fdata (w_ul_trans_freq0_fdata),
//	.o_freq1_fdata (w_ul_trans_freq1_fdata)
//);

assign w_ul_freq0_ffram 	   	=  i_freq0_ffram 	  ;
assign w_ul_freq1_ffram 	   	=  i_freq1_ffram 	  ;
assign w_ul_freq0_fdata [31:0]	=  i_freq0_fdata[31:0];
assign w_ul_freq1_fdata [31:0]	=  i_freq1_fdata[31:0];

//assign w_ul_freq0_ffram 	   	= ((w_bandwidth_60m[31:16] == 32'h8)|(w_bandwidth_60m[31:16] == 32'h9)|(w_bandwidth_60m[31:16] == 32'hA)) ? i_freq0_ffram 	  : w_ul_trans_freq0_ffram;
//assign w_ul_freq1_ffram 	   	= ((w_bandwidth_60m[31:16] == 32'h8)|(w_bandwidth_60m[31:16] == 32'h9)|(w_bandwidth_60m[31:16] == 32'hA)) ? i_freq1_ffram 	  : w_ul_trans_freq0_ffram;
//assign w_ul_freq0_fdata [31:0]	= ((w_bandwidth_60m[31:16] == 32'h8)|(w_bandwidth_60m[31:16] == 32'h9)|(w_bandwidth_60m[31:16] == 32'hA)) ? i_freq0_fdata[31:0]: w_ul_trans_freq0_fdata [31:0];
//assign w_ul_freq1_fdata [31:0]	= ((w_bandwidth_60m[31:16] == 32'h8)|(w_bandwidth_60m[31:16] == 32'h9)|(w_bandwidth_60m[31:16] == 32'hA)) ? i_freq1_fdata[31:0]: w_ul_trans_freq1_fdata [31:0];

//ila_nr_ul_datapath
//ila_nr_ul_datapath
//(
//.clk (clk_491p52),
//.probe0 (w_ul_freq0_fdata [31:0]),
//.probe1 (w_ul_freq1_fdata [31:0]),
//.probe2 (w_ul_freq0_ffram),
//.probe3 (i_freq0_fdata [31:0]),
//.probe4 (i_freq0_ffram),
//.probe5 (i_freq1_fdata [31:0]),
//.probe6 (o_path0_tfram),
//.probe7 (o_path0_tdata[31:0]),
//.probe8 (o_path1_tdata[31:0])
//);

data_path_inf u0_data_path_inf
(
     .asy_rst					(rst_491p52)
    ,.clk						(clk_491p52)
    ,.o_path_txant				(o_path0_txant)
    ,.o_path_tdata				(o_path0_tdata)
    ,.o_path_tfram				(o_path0_tfram)
    ,.i_path_fxant				(i_path0_fxant)
    ,.i_path_fdata				(i_path0_fdata)
    ,.i_path_ffram				(i_path0_ffram)
    ,.o_freq_txant				(w_dl_freq0_txant)
    ,.o_freq_tdata				(w_dl_freq0_tdata)
    ,.o_freq_tfram				(w_dl_freq0_tfram)
    ,.i_freq_fxant				(i_freq0_fxant)
    ,.i_freq_fdata				(w_ul_freq0_fdata)
    ,.i_freq_ffram				(w_ul_freq0_ffram)
    ,.dl_power_bypass			(dl_power_bypass[0])
    ,.ul_power_bypass			(ul_power_bypass[0])
    ,.i_reg_dl_delay_time		(reg_dlpath_delay)
    ,.i_reg_ul_delay_time		(reg_ulpath_delay)
	,.i_dl_test_sel				(u_dl_test_sel  [0])
	,.i_ul_test_sel				(u_ul_test_sel  [0])
    ,.i_dl_test_vld				(u_dl_test_vld)
    ,.i_dl_cell_iqselcfg		(i_dl_cell_iqselcfg)
    ,.i_dl_cell_iq				(u_dl_cell_iq)
    ,.i_dl_data_start			(i_dl_data_start)
    ,.i_dl_data_end				(i_dl_data_end)
    ,.i_ul_test_vld				(u_ul_test_vld)
    ,.i_ul_cell_iqselcfg		(i_ul_cell_iqselcfg)
    ,.i_ul_cell_iq				(u_ul_cell_iq)
    ,.i_ul_data_start			(i_ul_data_start)
    ,.i_ul_data_end				(i_ul_data_end)
    ,.i_frame_hd                (frame_hd_dly)
    ,.i_data0_iq				(data0_iq_dly)
    ,.i_data1_iq				(data1_iq_dly)
    ,.i_timedelay_dw_fram		(i_timedelay_dw_fram)
    ,.i_timedelay_up_fram		(i_timedelay_up_fram)
	,.reg_lte_duc_gain0			(reg_duc_gain_a0	[31:0])
	,.reg_lte_duc_gain1			(reg_duc_gain_a1	[31:0])
	,.reg_lte_duc_gain2			(reg_duc_gain_a2	[31:0])
	,.reg_lte_duc_gain3			(reg_duc_gain_a3	[31:0])
	,.reg_ul_tdl_pd_trig		(reg_ul_tdl_path_pd_trig	 [0]	)
    ,.reg_ul_tdl_pd_raddr		(reg_ul_tdl_path_pd_raddr  	 [7:0]	)
    ,.reg_ul_tdl_pd_rdata		(reg_ul_tdl_path_pd_rdata 	 [31:0]	)
	,.reg_ddc_gain_index_a0		(reg_ddc_gain_a0	[31:0])
	,.reg_ddc_gain_index_a1		(reg_ddc_gain_a1	[31:0])
	,.reg_ddc_gain_index_a2		(reg_ddc_gain_a2	[31:0])
	,.reg_ddc_gain_index_a3		(reg_ddc_gain_a3	[31:0])
	,.reg_ddc_agc_6db_sel		(reg_ddc_agc_6db_sel)
//	,.reg_duc_agc_6db_sel		(reg_duc_agc_6db_sel)
	,.reg_dl_ant0_pow			(reg_dl_ant00_pow	[31:0])
	,.reg_dl_ant1_pow			(reg_dl_ant01_pow	[31:0])
	,.reg_dl_ant2_pow			(reg_dl_ant02_pow	[31:0])
	,.reg_dl_ant3_pow			(reg_dl_ant03_pow	[31:0])
	,.reg_ul_ant0_pow			(reg_ul_ant00_pow	[31:0])
	,.reg_ul_ant1_pow			(reg_ul_ant01_pow	[31:0])
	,.reg_ul_ant2_pow			(reg_ul_ant02_pow	[31:0])
	,.reg_ul_ant3_pow			(reg_ul_ant03_pow	[31:0])
	
	,.i_bandwidth_60m			(w_bandwidth_60m)
	
	,.i_pd_clr							(reg_c0_dw_pd_clr		)
	,.i_pd_raddr						(reg_c0_dw_pd_raddr		)
	,.o_pd_rdata_hi						(reg_c0_dw_pd_rdata_hi	)
	,.o_pd_rdata_lo						(reg_c0_dw_pd_rdata_lo	)

    ,.i_tx_ac_valid                       (i_tx_ac_valid  )
    ,.i_ant_cnt                           (i_ant_cnt      )
    ,.i_rx_seq_valid                      (i_rx_seq_valid )
    ,.i_tx_seq_valid                      (i_tx_seq_valid )
    ,.i_seq_insert_en                     (i_seq_insert_en	[0]  )
    ,.i_seq_cnt                           (i_seq_cnt 		[6:0])
    ,.i_sw_testdata                       (i_sw_testdata  )
    ,.i_testdata0                         (i_testdata0    )
    ,.i_testdata1                         (i_testdata1    )
    ,.i_testdata2                         (i_testdata2    )
    ,.i_testdata3                         (i_testdata3    )
    ,.i_testdata4                         (i_testdata4    )
    ,.i_testdata5                         (i_testdata5    )
    ,.i_testdata6                         (i_testdata6    )
    ,.i_testdata7                         (i_testdata7    )

    ,.i_amp_seq0                         (amp_seq0)
    ,.i_amp_seq1                         (amp_seq1)
    ,.i_amp_seq2                         (amp_seq2)
    ,.i_amp_seq3                         (amp_seq3)
    ,.i_amp_seq4                         (amp_seq4)
    ,.i_amp_seq5                         (amp_seq5)
    ,.i_amp_seq6                         (amp_seq6)
    ,.i_amp_seq7	                     (amp_seq7)

    ,.group_index                        (group_index  	    [3:0])
    ,.reg_cal_ant_en                     (reg_cal_ant_en	[3:0])
    ,.o_dl_frm_hd                        (o_dl_frm_hd		[0]  )
    ,.o_x4_sel                           (o_x4_sel   		[0]  )
    ,.i_dl_frm_hd                        (i_dl_frm_hd		[0]  )
    ,.i_x4_sel                           (i_x4_sel   		[0]  )

);

data_path_inf u1_data_path_inf
(
     .asy_rst					(rst_491p52)
    ,.clk						(clk_491p52)
    ,.o_path_txant				(o_path1_txant)
    ,.o_path_tdata				(o_path1_tdata)
    ,.o_path_tfram				(o_path1_tfram)
    ,.i_path_fxant				(i_path1_fxant)
    ,.i_path_fdata				(i_path1_fdata)
    ,.i_path_ffram				(i_path1_ffram)
    ,.o_freq_txant				(o_freq1_txant)
    ,.o_freq_tdata				(w_dl_freq1_tdata)
    ,.o_freq_tfram				(o_freq1_tfram)
    ,.i_freq_fxant				(i_freq1_fxant)
    ,.i_freq_fdata				(w_ul_freq1_fdata)
    ,.i_freq_ffram				(w_ul_freq1_ffram)
    ,.dl_power_bypass			(dl_power_bypass[1])
    ,.ul_power_bypass			(ul_power_bypass[1])
    ,.i_reg_dl_delay_time		(reg_dlpath_delay)
    ,.i_reg_ul_delay_time		(reg_ulpath_delay)
	,.i_dl_test_sel				(u_dl_test_sel	[1])
	,.i_ul_test_sel				(u_ul_test_sel	[1])
    ,.i_dl_test_vld				(u_dl_test_vld)
    ,.i_dl_cell_iqselcfg		(i_dl_cell_iqselcfg)
    ,.i_dl_cell_iq				(u_dl_cell_iq)
    ,.i_dl_data_start			(i_dl_data_start)
    ,.i_dl_data_end				(i_dl_data_end)
    ,.i_ul_test_vld				(u_ul_test_vld)
    ,.i_ul_cell_iqselcfg		(i_ul_cell_iqselcfg)
    ,.i_ul_cell_iq				(u_ul_cell_iq)
    ,.i_ul_data_start			(i_ul_data_start)
    ,.i_ul_data_end				(i_ul_data_end)
    ,.i_frame_hd                (frame_hd_dly)
    ,.i_data0_iq				(data0_iq_dly)
    ,.i_data1_iq				(data1_iq_dly)
    ,.i_timedelay_dw_fram		(i_timedelay_dw_fram)
    ,.i_timedelay_up_fram		(i_timedelay_up_fram)
	,.reg_lte_duc_gain0			(reg_duc_gain_a0	[63:32])
	,.reg_lte_duc_gain1			(reg_duc_gain_a1	[63:32])
	,.reg_lte_duc_gain2			(reg_duc_gain_a2	[63:32])
	,.reg_lte_duc_gain3			(reg_duc_gain_a3	[63:32])
	,.reg_ul_tdl_pd_trig		(reg_ul_tdl_path_pd_trig	[1]	   )
    ,.reg_ul_tdl_pd_raddr		(reg_ul_tdl_path_pd_raddr	[15: 8])
    ,.reg_ul_tdl_pd_rdata		(reg_ul_tdl_path_pd_rdata	[63:32])
	,.reg_ddc_gain_index_a0		(reg_ddc_gain_a0	[63:32])
	,.reg_ddc_gain_index_a1		(reg_ddc_gain_a1	[63:32])
	,.reg_ddc_gain_index_a2		(reg_ddc_gain_a2	[63:32])
	,.reg_ddc_gain_index_a3		(reg_ddc_gain_a3	[63:32])
	,.reg_ddc_agc_6db_sel		(reg_ddc_agc_6db_sel)
//	,.reg_duc_agc_6db_sel		(reg_duc_agc_6db_sel)
	,.reg_dl_ant0_pow			(reg_dl_ant00_pow	[63:32])
	,.reg_dl_ant1_pow			(reg_dl_ant01_pow	[63:32])
	,.reg_dl_ant2_pow			(reg_dl_ant02_pow	[63:32])
	,.reg_dl_ant3_pow			(reg_dl_ant03_pow	[63:32])
	,.reg_ul_ant0_pow			(reg_ul_ant00_pow	[63:32])
	,.reg_ul_ant1_pow			(reg_ul_ant01_pow	[63:32])
	,.reg_ul_ant2_pow			(reg_ul_ant02_pow	[63:32])
	,.reg_ul_ant3_pow			(reg_ul_ant03_pow	[63:32])
	
	,.i_bandwidth_60m			(w_bandwidth_60m)
	
	,.i_pd_clr							(reg_c1_dw_pd_clr		)
	,.i_pd_raddr						(reg_c1_dw_pd_raddr		)
	,.o_pd_rdata_hi						(reg_c1_dw_pd_rdata_hi	)
	,.o_pd_rdata_lo						(reg_c1_dw_pd_rdata_lo	)
	
	/////////seq_insert
  	,.i_tx_ac_valid                       (i_tx_ac_valid  )
  	,.i_ant_cnt                           (i_ant_cnt      )
  	,.i_rx_seq_valid                      (i_rx_seq_valid )
  	,.i_tx_seq_valid                      (i_tx_seq_valid )
  	,.i_seq_insert_en                     (i_seq_insert_en	[1]	  )
  	,.i_seq_cnt                           (i_seq_cnt			[13:7])
  	,.i_sw_testdata                       (i_sw_testdata  )
  	,.i_testdata0                         (i_testdata0    )
  	,.i_testdata1                         (i_testdata1    )
  	,.i_testdata2                         (i_testdata2    )
  	,.i_testdata3                         (i_testdata3    )
  	,.i_testdata4                         (i_testdata4    )
  	,.i_testdata5                         (i_testdata5    )
  	,.i_testdata6                         (i_testdata6    )
  	,.i_testdata7                         (i_testdata7    )

   	,.i_amp_seq0                         (amp_seq0)
   	,.i_amp_seq1                         (amp_seq1)
   	,.i_amp_seq2                         (amp_seq2)
   	,.i_amp_seq3                         (amp_seq3)
   	,.i_amp_seq4                         (amp_seq4)
   	,.i_amp_seq5                         (amp_seq5)
   	,.i_amp_seq6                         (amp_seq6)
   	,.i_amp_seq7						 (amp_seq7)

   	,.group_index                        (group_index  	[7:4])
   	,.reg_cal_ant_en                     (reg_cal_ant_en	[7:4])
   	,.o_dl_frm_hd                        (o_dl_frm_hd[1]   )
   	,.o_x4_sel                           (o_x4_sel   [1]   )
   	,.i_dl_frm_hd                        (i_dl_frm_hd[1]   )
   	,.i_x4_sel                           (i_x4_sel   [1]   )

);

//********** path_reg **********//
wire path_reg_spi_sdo;
wire power_reg_spi_sdo;

path_reg #(
	.BASE_ADDR					(24'h00_0000)
) u_path_reg (
    //spi
     .spi_clk                   (clk_125	            )
    ,.usr_clk                   (clk_491p52            	)//OLD:clk 2018/4/25 18:01:17
    ,.asy_rst                   (rst_125	            )
    ,.usr_rst                   (rst_491p52            )//
    ,.spi_i_addr       			(spi_i_addr         	)
    ,.spi_i_data       			(spi_i_data        		)
    ,.spi_i_wr_en      			(spi_i_wr_en           	)
    ,.spi_i_rd_en      			(spi_i_rd_en           	)
    ,.spi_i_shift_en   			(spi_i_shift_en         )
    ,.spi_o_sdo        			(path_reg_spi_sdo     	)

    //duc
    ,.duc_gain_c0a0             (reg_duc_gain_a0			[31:0]     )
    ,.duc_gain_c0a1             (reg_duc_gain_a1			[31:0]     )
    ,.duc_gain_c0a2             (reg_duc_gain_a2			[31:0]     )
    ,.duc_gain_c0a3             (reg_duc_gain_a3			[31:0]     )
    ,.duc_gain_c0a4             (reg_duc_gain_a0			[63:32]    )
    ,.duc_gain_c0a5             (reg_duc_gain_a1			[63:32]    )
    ,.duc_gain_c0a6             (reg_duc_gain_a2			[63:32]    )
    ,.duc_gain_c0a7             (reg_duc_gain_a3			[63:32]    )

    //ddc
    ,.ddc_gain_c0a0             (reg_ddc_gain_a0			[31:0]     )
    ,.ddc_gain_c0a1             (reg_ddc_gain_a1			[31:0]     )
    ,.ddc_gain_c0a2             (reg_ddc_gain_a2			[31:0]     )
    ,.ddc_gain_c0a3             (reg_ddc_gain_a3			[31:0]     )
    ,.ddc_gain_c0a4             (reg_ddc_gain_a0			[63:32]    )
    ,.ddc_gain_c0a5             (reg_ddc_gain_a1			[63:32]    )
    ,.ddc_gain_c0a6             (reg_ddc_gain_a2			[63:32]    )
    ,.ddc_gain_c0a7             (reg_ddc_gain_a3			[63:32]    )

	,.dl_pow_ant0				(reg_dl_ant00_pow			[31:0]     )
	,.dl_pow_ant1				(reg_dl_ant01_pow			[31:0]     )
	,.dl_pow_ant2				(reg_dl_ant02_pow			[31:0]     )
	,.dl_pow_ant3				(reg_dl_ant03_pow			[31:0]     )
	,.dl_pow_ant4				(reg_dl_ant00_pow			[63:32]    )
	,.dl_pow_ant5				(reg_dl_ant01_pow			[63:32]    )
	,.dl_pow_ant6				(reg_dl_ant02_pow			[63:32]    )
	,.dl_pow_ant7				(reg_dl_ant03_pow			[63:32]    )

	,.ul_pow_ant0				(reg_ul_ant00_pow			[31:0]     )
	,.ul_pow_ant1				(reg_ul_ant01_pow			[31:0]     )
	,.ul_pow_ant2				(reg_ul_ant02_pow			[31:0]     )
	,.ul_pow_ant3				(reg_ul_ant03_pow			[31:0]     )
	,.ul_pow_ant4				(reg_ul_ant00_pow			[63:32]    )
	,.ul_pow_ant5				(reg_ul_ant01_pow			[63:32]    )
	,.ul_pow_ant6				(reg_ul_ant02_pow			[63:32]    )
	,.ul_pow_ant7				(reg_ul_ant03_pow			[63:32]    )


    //sim
    ,.dl_test_vld				(i_dl_test_vld				)
    ,.dl_cell_iqselcfg			(i_dl_cell_iqselcfg			)
    ,.dl_cell_iq				(i_dl_cell_iq				)
    ,.dl_data_start				(i_dl_data_start			)
    ,.dl_data_end				(i_dl_data_end				)
    ,.dl_test_sel				(i_dl_test_sel				)

    ,.ul_test_vld				(i_ul_test_vld				)
    ,.ul_cell_iqselcfg			(i_ul_cell_iqselcfg			)
    ,.ul_cell_iq				(i_ul_cell_iq				)
    ,.ul_data_start				(i_ul_data_start			)
    ,.ul_data_end				(i_ul_data_end				)
    ,.ul_test_sel				(i_ul_test_sel				)

    ,.o_ddc_agc_6db_sel			(reg_ddc_agc_6db_sel		)
    ,.dl_power_bypass			(dl_power_bypass			)
    ,.ul_power_bypass			(ul_power_bypass			)
    
    ,.mux_mode_switch			(mux_mode_switch			)
    ,.o_reg_dlpath_delay		(reg_dlpath_delay			)
	,.o_reg_ulpath_delay		(reg_ulpath_delay			)
	,.o_bandwidth_60m			(w_bandwidth_60m		 	)
	
	,.o_c0_dw_pd_clr			(reg_c0_dw_pd_clr		)
	,.o_c0_dw_pd_raddr			(reg_c0_dw_pd_raddr		)
	,.i_c0_dw_pd_rdata_hi		(reg_c0_dw_pd_rdata_hi	)
	,.i_c0_dw_pd_rdata_lo		(reg_c0_dw_pd_rdata_lo	)
	
	,.o_c1_dw_pd_clr			(reg_c1_dw_pd_clr		)
	,.o_c1_dw_pd_raddr			(reg_c1_dw_pd_raddr		)
	,.i_c1_dw_pd_rdata_hi		(reg_c1_dw_pd_rdata_hi	)
	,.i_c1_dw_pd_rdata_lo		(reg_c1_dw_pd_rdata_lo	)
);

//********** power_reg **********//

power_reg #(
	.BASE_ADDR					(24'h00_0000)
) u_power_reg (
    .clk                        (clk_125              	),
    .asy_rst                    (rst_125	            ),
    .i_spi_addr                 (spi_i_addr		        ),
    .i_spi_rd_en                (spi_i_rd_en	        ),
    .i_shift_en                 (spi_i_shift_en         ),
    .i_spi_data       			(spi_i_data		        ),
    .i_spi_wr_en      			(spi_i_wr_en	        ),

    .o_spi_sdo                  (power_reg_spi_sdo    	),

    .o_ram_addr_path0           (reg_ul_tdl_path_pd_raddr[8*1-1:8* 0]    	),
    .o_ram_addr_path1           (reg_ul_tdl_path_pd_raddr[8*2-1:8* 1]    	),
    .i_ram_data_path0           (reg_ul_tdl_path_pd_rdata[32*1-1:32* 0]  	),
    .i_ram_data_path1           (reg_ul_tdl_path_pd_rdata[32*2-1:32* 1]  	),
    
    .o_ul_tdl_pd_trig			(reg_ul_tdl_path_pd_trig					)
);

//-----------------------------------4G--------------------------------//
//**********lte_path_inf **********//
wire [2:0]	reg_ul_lte_tdl_pd_trig;
wire [9:0]	reg_ul_lte_tdl_path0_pd_raddr;
wire [9:0]	reg_ul_lte_tdl_path1_pd_raddr;
wire [9:0]	reg_ul_lte_tdl_path2_pd_raddr;
wire [31:0] reg_ul_lte_tdl_path0_pd_rdata;
wire [31:0] reg_ul_lte_tdl_path1_pd_rdata;
wire [31:0] reg_ul_lte_tdl_path2_pd_rdata;
//wire [31:0] reg_lte_ul_tdl_path_cfg;

wire [31:0] reg_lte_duc_gain0_c0;
wire [31:0] reg_lte_duc_gain1_c0;
wire [31:0] reg_lte_duc_gain2_c0;
wire [31:0] reg_lte_duc_gain3_c0;
wire [31:0] reg_lte_duc_gain4_c0;
wire [31:0] reg_lte_duc_gain5_c0;
wire [31:0] reg_lte_duc_gain6_c0;
wire [31:0] reg_lte_duc_gain7_c0;

wire [31:0] reg_lte_duc_gain0_c1;
wire [31:0] reg_lte_duc_gain1_c1;
wire [31:0] reg_lte_duc_gain2_c1;
wire [31:0] reg_lte_duc_gain3_c1;
wire [31:0] reg_lte_duc_gain4_c1;
wire [31:0] reg_lte_duc_gain5_c1;
wire [31:0] reg_lte_duc_gain6_c1;
wire [31:0] reg_lte_duc_gain7_c1;

wire [31:0] reg_lte_duc_gain0_c2;
wire [31:0] reg_lte_duc_gain1_c2;
wire [31:0] reg_lte_duc_gain2_c2;
wire [31:0] reg_lte_duc_gain3_c2;
wire [31:0] reg_lte_duc_gain4_c2;
wire [31:0] reg_lte_duc_gain5_c2;
wire [31:0] reg_lte_duc_gain6_c2;
wire [31:0] reg_lte_duc_gain7_c2;

wire [31:0] reg_lte_ddc_gain0_c0;
wire [31:0] reg_lte_ddc_gain1_c0;
wire [31:0] reg_lte_ddc_gain2_c0;
wire [31:0] reg_lte_ddc_gain3_c0;
wire [31:0] reg_lte_ddc_gain4_c0;
wire [31:0] reg_lte_ddc_gain5_c0;
wire [31:0] reg_lte_ddc_gain6_c0;
wire [31:0] reg_lte_ddc_gain7_c0;

wire [31:0] reg_lte_ddc_gain0_c1;
wire [31:0] reg_lte_ddc_gain1_c1;
wire [31:0] reg_lte_ddc_gain2_c1;
wire [31:0] reg_lte_ddc_gain3_c1;
wire [31:0] reg_lte_ddc_gain4_c1;
wire [31:0] reg_lte_ddc_gain5_c1;
wire [31:0] reg_lte_ddc_gain6_c1;
wire [31:0] reg_lte_ddc_gain7_c1;

wire [31:0] reg_lte_ddc_gain0_c2;
wire [31:0] reg_lte_ddc_gain1_c2;
wire [31:0] reg_lte_ddc_gain2_c2;
wire [31:0] reg_lte_ddc_gain3_c2;
wire [31:0] reg_lte_ddc_gain4_c2;
wire [31:0] reg_lte_ddc_gain5_c2;
wire [31:0] reg_lte_ddc_gain6_c2;
wire [31:0] reg_lte_ddc_gain7_c2;

wire [31:0] reg_lte_dl_ant00_pow;
wire [31:0] reg_lte_dl_ant01_pow;
wire [31:0] reg_lte_dl_ant02_pow;
wire [31:0] reg_lte_dl_ant03_pow;
wire [31:0] reg_lte_dl_ant04_pow;
wire [31:0] reg_lte_dl_ant05_pow;
wire [31:0] reg_lte_dl_ant06_pow;
wire [31:0] reg_lte_dl_ant07_pow;
wire [31:0] reg_lte_dl_ant10_pow;
wire [31:0] reg_lte_dl_ant11_pow;
wire [31:0] reg_lte_dl_ant12_pow;
wire [31:0] reg_lte_dl_ant13_pow;
wire [31:0] reg_lte_dl_ant14_pow;
wire [31:0] reg_lte_dl_ant15_pow;
wire [31:0] reg_lte_dl_ant16_pow;
wire [31:0] reg_lte_dl_ant17_pow;
wire [31:0] reg_lte_dl_ant20_pow;
wire [31:0] reg_lte_dl_ant21_pow;
wire [31:0] reg_lte_dl_ant22_pow;
wire [31:0] reg_lte_dl_ant23_pow;
wire [31:0] reg_lte_dl_ant24_pow;
wire [31:0] reg_lte_dl_ant25_pow;
wire [31:0] reg_lte_dl_ant26_pow;
wire [31:0] reg_lte_dl_ant27_pow;

wire [31:0] reg_lte_ul_ant00_pow;
wire [31:0] reg_lte_ul_ant01_pow;
wire [31:0] reg_lte_ul_ant02_pow;
wire [31:0] reg_lte_ul_ant03_pow;
wire [31:0] reg_lte_ul_ant04_pow;
wire [31:0] reg_lte_ul_ant05_pow;
wire [31:0] reg_lte_ul_ant06_pow;
wire [31:0] reg_lte_ul_ant07_pow;
wire [31:0] reg_lte_ul_ant10_pow;
wire [31:0] reg_lte_ul_ant11_pow;
wire [31:0] reg_lte_ul_ant12_pow;
wire [31:0] reg_lte_ul_ant13_pow;
wire [31:0] reg_lte_ul_ant14_pow;
wire [31:0] reg_lte_ul_ant15_pow;
wire [31:0] reg_lte_ul_ant16_pow;
wire [31:0] reg_lte_ul_ant17_pow;
wire [31:0] reg_lte_ul_ant20_pow;
wire [31:0] reg_lte_ul_ant21_pow;
wire [31:0] reg_lte_ul_ant22_pow;
wire [31:0] reg_lte_ul_ant23_pow;
wire [31:0] reg_lte_ul_ant24_pow;
wire [31:0] reg_lte_ul_ant25_pow;
wire [31:0] reg_lte_ul_ant26_pow;
wire [31:0] reg_lte_ul_ant27_pow;

wire [31:0] reg_lte_duc_agc_6db_c0_sel;
wire [31:0] reg_lte_duc_agc_6db_c1_sel;
wire [31:0] reg_lte_duc_agc_6db_c2_sel;
wire [31:0] reg_lte_ddc_agc_6db_c0_sel;
wire [31:0] reg_lte_ddc_agc_6db_c1_sel;
wire [31:0] reg_lte_ddc_agc_6db_c2_sel;

wire [31:0]	reg_lte_dl_tdl_data_sel;
wire [31:0]	reg_lte_dl_tdl_data_iq;
wire [31:0]	reg_lte_dl_tdl_data_start;
wire [31:0]	reg_lte_dl_tdl_data_end;
wire [31:0]	reg_lte_dl_tdl_data_vald;

wire [31:0]	reg_lte_ul_tdl_data_sel;
wire [31:0]	reg_lte_ul_tdl_data_iq;
wire [31:0]	reg_lte_ul_tdl_data_start;
wire [31:0]	reg_lte_ul_tdl_data_end;
wire [31:0]	reg_lte_ul_tdl_data_vald;

wire [31:0] reg_dl_tdl_lte_iqselcfg0;
wire [31:0] reg_dl_tdl_lte_iqselcfg1;
wire [31:0] reg_dl_tdl_lte_iqselcfg2;

wire [31:0] reg_ul_tdl_lte_iqselcfg0;
wire [31:0] reg_ul_tdl_lte_iqselcfg1;
wire [31:0] reg_ul_tdl_lte_iqselcfg2;

wire [31:0] reg_dlpath_lte_delay;
wire [31:0] reg_ulpath_lte_delay;

wire [31:0] reg_bandwidth_sel_cell0;
wire [31:0] reg_bandwidth_sel_cell1;
wire [31:0] reg_bandwidth_sel_cell2;

wire [31:0] reg_dw_ant_posinfo_c0;
wire [31:0] reg_up_ant_posinfo_c0;
wire [31:0] reg_dw_ant_posinfo_c1;
wire [31:0] reg_up_ant_posinfo_c1;
wire [31:0] reg_dw_ant_posinfo_c2;
wire [31:0] reg_up_ant_posinfo_c2;

wire	[31:0]		reg_c0_lte_dw_pd_clr;
wire	[31:0]		reg_c0_lte_dw_pd_raddr;
wire	[31:0]		reg_c0_lte_dw_pd_rdata_hi;
wire	[31:0]		reg_c0_lte_dw_pd_rdata_lo;
wire	[31:0]		reg_c1_lte_dw_pd_clr;
wire	[31:0]		reg_c1_lte_dw_pd_raddr;
wire	[31:0]		reg_c1_lte_dw_pd_rdata_hi;
wire	[31:0]		reg_c1_lte_dw_pd_rdata_lo;
wire	[31:0]		reg_c2_lte_dw_pd_clr;
wire	[31:0]		reg_c2_lte_dw_pd_raddr;
wire	[31:0]		reg_c2_lte_dw_pd_rdata_hi;
wire	[31:0]		reg_c2_lte_dw_pd_rdata_lo;

wire [31:0]	u_lte_dl_test_vld;
wire [31:0]	u_lte_dl_cell_iq;
wire [31:0]	u_lte_dl_test_sel;

wire [31:0]	u_lte_ul_test_vld;
wire [31:0]	u_lte_ul_cell_iq;
wire [31:0]	u_lte_ul_test_sel;

assign o_lte_bandwidth_sel_cell0 = reg_bandwidth_sel_cell0;
assign o_lte_bandwidth_sel_cell1 = reg_bandwidth_sel_cell1;
assign o_lte_bandwidth_sel_cell2 = reg_bandwidth_sel_cell2;

assign u_lte_dl_test_vld = i_deep_sleep_switch[0]?32'h002:reg_lte_dl_tdl_data_sel;
assign u_lte_dl_cell_iq  = i_deep_sleep_switch[0]?32'h000:reg_lte_dl_tdl_data_iq ;
assign u_lte_dl_test_sel = i_deep_sleep_switch[0]?32'hFFF:reg_lte_dl_tdl_data_vald;

assign u_lte_ul_test_vld = i_deep_sleep_switch[0]?32'h002:reg_lte_ul_tdl_data_sel;
assign u_lte_ul_cell_iq  = i_deep_sleep_switch[0]?32'h000:reg_lte_ul_tdl_data_iq ;
assign u_lte_ul_test_sel = i_deep_sleep_switch[0]?32'hFFF:reg_lte_ul_tdl_data_vald;

lte_data_path_inf u0_lte_data_path_inf
(
    .rst_245p76					(rst_245p76		),
    .clk_245p76					(clk_245p76		),
    .clk_491p52					(clk_491p52		),
	.rst_491p52					(rst_491p52		),

    .o_path_txant				(o_path4_txant			),
    .o_path_tdata				(o_path4_tdata			),
    .o_path_tfram				(o_path4_tfram			),
    .i_path_fxant				(i_path4_fxant      	),
    .i_path_fdata				(i_path4_fdata			),
    .i_path_ffram				(i_path4_ffram      	),
    .o_freq_txant				(o_freq4_txant			),
    .o_freq_tdata				(o_freq4_tdata			),
    .o_freq_tfram				(o_freq4_tfram			),
    .i_freq_fxant				(i_freq4_fxant			),
    .i_freq_fdata				(i_freq4_fdata			),
    .i_freq_ffram				(i_freq4_ffram			),

    .i_dw_ant_posinfo			(reg_dw_ant_posinfo_c0),
    .i_up_ant_posinfo			(reg_up_ant_posinfo_c0),

   	.i_frame_hd					(i_lte_frame_hd),
    .i_data0_iq					(i_lte_data0_iq),

    .i_dl_cell_iqselcfg0		(reg_dl_tdl_lte_iqselcfg0),
    .i_ul_cell_iqselcfg0		(reg_ul_tdl_lte_iqselcfg0),

    .i_reg_dl_delay_time		(reg_dlpath_lte_delay),
    .i_reg_ul_delay_time		(reg_ulpath_lte_delay),
    
    .i_timedelay_dw_fram		(i_timedelay_lte_dw_fram_cell0),
    .i_timedelay_up_fram		(i_timedelay_lte_up_fram_cell0),
    
    .i_mod_sel					(reg_bandwidth_sel_cell0),
    
    .reg_dl_tdl_data_sel		(u_lte_dl_test_vld[3:0]			),
    .reg_dl_tdl_data_iq			(u_lte_dl_cell_iq[31:0]			),
	.reg_dl_tdl_data_start		(reg_lte_dl_tdl_data_start		),
	.reg_dl_tdl_data_end		(reg_lte_dl_tdl_data_end		),
	.reg_dl_path_test_val		(u_lte_dl_test_sel[0]			),

	.reg_ul_tdl_data_sel		(u_lte_ul_test_vld[3:0]			),
    .reg_ul_tdl_data_iq			(u_lte_ul_cell_iq[31:0]			),
	.reg_ul_tdl_data_start		(reg_lte_ul_tdl_data_start		),
	.reg_ul_tdl_data_end		(reg_lte_ul_tdl_data_end		),
	.reg_ul_path_test_val		(u_lte_ul_test_sel[0]			),

	.reg_lte_duc_gain0			(reg_lte_duc_gain0_c0	),
	.reg_lte_duc_gain1			(reg_lte_duc_gain1_c0	),
	.reg_lte_duc_gain2			(reg_lte_duc_gain2_c0	),
	.reg_lte_duc_gain3			(reg_lte_duc_gain3_c0	),
	.reg_lte_duc_gain4			(reg_lte_duc_gain4_c0	),
	.reg_lte_duc_gain5			(reg_lte_duc_gain5_c0	),
	.reg_lte_duc_gain6			(reg_lte_duc_gain6_c0	),
	.reg_lte_duc_gain7			(reg_lte_duc_gain7_c0	),

//	.reg_duc_agc_6db_sel		(reg_lte_duc_agc_6db_c0_sel		),

	.reg_ul_tdl_pd_trig			(reg_ul_lte_tdl_pd_trig[0]		),
    .reg_ul_tdl_pd_raddr		(reg_ul_lte_tdl_path0_pd_raddr	),
    .reg_ul_tdl_pd_rdata		(reg_ul_lte_tdl_path0_pd_rdata	),

	.reg_lte_ddc_gain0			(reg_lte_ddc_gain0_c0	),
	.reg_lte_ddc_gain1			(reg_lte_ddc_gain1_c0	),
	.reg_lte_ddc_gain2			(reg_lte_ddc_gain2_c0	),
	.reg_lte_ddc_gain3			(reg_lte_ddc_gain3_c0	),
	.reg_lte_ddc_gain4			(reg_lte_ddc_gain4_c0	),
	.reg_lte_ddc_gain5			(reg_lte_ddc_gain5_c0	),
	.reg_lte_ddc_gain6			(reg_lte_ddc_gain6_c0	),
	.reg_lte_ddc_gain7			(reg_lte_ddc_gain7_c0	),

	.reg_ddc_agc_6db_sel		(reg_lte_ddc_agc_6db_c0_sel		),

	.reg_ul_tdl_path_cfg		(32'h0000_8301				),

	.reg_ant0_pow				(reg_lte_dl_ant00_pow		),
	.reg_ant1_pow				(reg_lte_dl_ant01_pow		),
	.reg_ant2_pow				(reg_lte_dl_ant02_pow		),
	.reg_ant3_pow				(reg_lte_dl_ant03_pow		),
	.reg_ant4_pow				(reg_lte_dl_ant04_pow		),
	.reg_ant5_pow				(reg_lte_dl_ant05_pow		),
	.reg_ant6_pow				(reg_lte_dl_ant06_pow		),
	.reg_ant7_pow				(reg_lte_dl_ant07_pow		),
	.i_lte_dw_pd_clr			(reg_c0_lte_dw_pd_clr[0]),
	.i_lte_dw_pd_raddr			(reg_c0_lte_dw_pd_raddr[10:0]),
	.o_lte_dw_pd_rdata_hi		(reg_c0_lte_dw_pd_rdata_hi),
	.o_lte_dw_pd_rdata_lo		(reg_c0_lte_dw_pd_rdata_lo),

	.o_debug_datapath       	()
);


lte_data_path_inf u1_lte_data_path_inf
(
    .rst_245p76					(rst_245p76			),
    .clk_245p76					(clk_245p76			),
    .clk_491p52					(clk_491p52			),
	.rst_491p52					(rst_491p52			),

    .o_path_txant				(o_path5_txant		),
    .o_path_tdata				(o_path5_tdata		),
    .o_path_tfram				(o_path5_tfram		),
    .i_path_fxant				(i_path5_fxant     	),
    .i_path_fdata				(i_path5_fdata		),
    .i_path_ffram				(i_path5_ffram    	),
    .o_freq_txant				(o_freq5_txant		),
    .o_freq_tdata				(o_freq5_tdata		),
    .o_freq_tfram				(o_freq5_tfram		),
    .i_freq_fxant				(i_freq5_fxant		),
    .i_freq_fdata				(i_freq5_fdata		),
    .i_freq_ffram				(i_freq5_ffram		),

    .i_dw_ant_posinfo			(reg_dw_ant_posinfo_c1),
    .i_up_ant_posinfo			(reg_up_ant_posinfo_c1),

   	.i_frame_hd					(i_lte_frame_hd),
    .i_data0_iq					(i_lte_data0_iq),
    
    .i_dl_cell_iqselcfg0		(reg_dl_tdl_lte_iqselcfg1),
    .i_ul_cell_iqselcfg0		(reg_ul_tdl_lte_iqselcfg1),

    .i_reg_dl_delay_time		(reg_dlpath_lte_delay),
    .i_reg_ul_delay_time		(reg_ulpath_lte_delay), 
    
    .i_timedelay_dw_fram		(i_timedelay_lte_dw_fram_cell1),
    .i_timedelay_up_fram		(i_timedelay_lte_up_fram_cell1),
    
    .i_mod_sel					(reg_bandwidth_sel_cell1),
    
    .reg_dl_tdl_data_sel		(u_lte_dl_test_vld[3:0]			),
    .reg_dl_tdl_data_iq			(u_lte_dl_cell_iq[31:0]			),
	.reg_dl_tdl_data_start		(reg_lte_dl_tdl_data_start		),
	.reg_dl_tdl_data_end		(reg_lte_dl_tdl_data_end		),
	.reg_dl_path_test_val		(u_lte_dl_test_sel[4]			),
	
	.reg_ul_tdl_data_sel		(u_lte_ul_test_vld[3:0]			),
    .reg_ul_tdl_data_iq			(u_lte_ul_cell_iq[31:0]			),
	.reg_ul_tdl_data_start		(reg_lte_ul_tdl_data_start		),
	.reg_ul_tdl_data_end		(reg_lte_ul_tdl_data_end		),
	.reg_ul_path_test_val		(u_lte_ul_test_sel[4]			),

	.reg_lte_duc_gain0			(reg_lte_duc_gain0_c1	),
	.reg_lte_duc_gain1			(reg_lte_duc_gain1_c1	),
	.reg_lte_duc_gain2			(reg_lte_duc_gain2_c1	),
	.reg_lte_duc_gain3			(reg_lte_duc_gain3_c1	),
	.reg_lte_duc_gain4			(reg_lte_duc_gain4_c1	),
	.reg_lte_duc_gain5			(reg_lte_duc_gain5_c1	),
	.reg_lte_duc_gain6			(reg_lte_duc_gain6_c1	),
	.reg_lte_duc_gain7			(reg_lte_duc_gain7_c1	),

//	.reg_duc_agc_6db_sel		(reg_lte_duc_agc_6db_c1_sel		),
	.reg_ul_tdl_pd_trig			(reg_ul_lte_tdl_pd_trig[1]		),
    .reg_ul_tdl_pd_raddr		(reg_ul_lte_tdl_path1_pd_raddr	),
    .reg_ul_tdl_pd_rdata		(reg_ul_lte_tdl_path1_pd_rdata	),

	.reg_lte_ddc_gain0			(reg_lte_ddc_gain0_c1	),
	.reg_lte_ddc_gain1			(reg_lte_ddc_gain1_c1	),
	.reg_lte_ddc_gain2			(reg_lte_ddc_gain2_c1	),
	.reg_lte_ddc_gain3			(reg_lte_ddc_gain3_c1	),
	.reg_lte_ddc_gain4			(reg_lte_ddc_gain4_c1	),
	.reg_lte_ddc_gain5			(reg_lte_ddc_gain5_c1	),
	.reg_lte_ddc_gain6			(reg_lte_ddc_gain6_c1	),
	.reg_lte_ddc_gain7			(reg_lte_ddc_gain7_c1	),

	.reg_ddc_agc_6db_sel		(reg_lte_ddc_agc_6db_c1_sel	),
	
	.reg_ul_tdl_path_cfg		(32'h0000_8301				),

	.reg_ant0_pow				(reg_lte_dl_ant10_pow	),
	.reg_ant1_pow				(reg_lte_dl_ant11_pow	),
	.reg_ant2_pow				(reg_lte_dl_ant12_pow	),
	.reg_ant3_pow				(reg_lte_dl_ant13_pow	),
	.reg_ant4_pow				(reg_lte_dl_ant14_pow	),
	.reg_ant5_pow				(reg_lte_dl_ant15_pow	),
	.reg_ant6_pow				(reg_lte_dl_ant16_pow	),
	.reg_ant7_pow				(reg_lte_dl_ant17_pow	),
	.i_lte_dw_pd_clr			(reg_c1_lte_dw_pd_clr[0]),
	.i_lte_dw_pd_raddr			(reg_c1_lte_dw_pd_raddr[10:0]),
	.o_lte_dw_pd_rdata_hi		(reg_c1_lte_dw_pd_rdata_hi),
	.o_lte_dw_pd_rdata_lo		(reg_c1_lte_dw_pd_rdata_lo),

	.o_debug_datapath       	()
);


lte_data_path_inf u2_lte_data_path_inf
(
    .rst_245p76					(rst_245p76			),
    .clk_245p76					(clk_245p76			),
    .clk_491p52					(clk_491p52			),
	.rst_491p52					(rst_491p52			),

    .o_path_txant				(o_path6_txant		),
    .o_path_tdata				(o_path6_tdata		),
    .o_path_tfram				(o_path6_tfram		),
    .i_path_fxant				(i_path6_fxant     	),
    .i_path_fdata				(i_path6_fdata		),
    .i_path_ffram				(i_path6_ffram    	),
    .o_freq_txant				(o_freq6_txant		),
    .o_freq_tdata				(o_freq6_tdata		),
    .o_freq_tfram				(o_freq6_tfram		),
    .i_freq_fxant				(i_freq6_fxant		),
    .i_freq_fdata				(i_freq6_fdata		),
    .i_freq_ffram				(i_freq6_ffram		),

    .i_dw_ant_posinfo			(reg_dw_ant_posinfo_c2),
    .i_up_ant_posinfo			(reg_up_ant_posinfo_c2),
   	.i_frame_hd					(i_lte_frame_hd),
    .i_data0_iq					(i_lte_data0_iq),
    
    .i_dl_cell_iqselcfg0		(reg_dl_tdl_lte_iqselcfg2),
    .i_ul_cell_iqselcfg0		(reg_ul_tdl_lte_iqselcfg2),

    .i_reg_dl_delay_time		(reg_dlpath_lte_delay),
    .i_reg_ul_delay_time		(reg_ulpath_lte_delay),
    
    .i_timedelay_dw_fram		(i_timedelay_lte_dw_fram_cell2),
    .i_timedelay_up_fram		(i_timedelay_lte_up_fram_cell2),
    
    .i_mod_sel					(reg_bandwidth_sel_cell2),
    
    .reg_dl_tdl_data_sel		(u_lte_dl_test_vld[3:0]			),
    .reg_dl_tdl_data_iq			(u_lte_dl_cell_iq[31:0]			),
	.reg_dl_tdl_data_start		(reg_lte_dl_tdl_data_start		),
	.reg_dl_tdl_data_end		(reg_lte_dl_tdl_data_end		),
	.reg_dl_path_test_val		(u_lte_dl_test_sel[8]			),
	
	.reg_ul_tdl_data_sel		(u_lte_ul_test_vld[3:0]			),
    .reg_ul_tdl_data_iq			(u_lte_ul_cell_iq[31:0]			),
	.reg_ul_tdl_data_start		(reg_lte_ul_tdl_data_start		),
	.reg_ul_tdl_data_end		(reg_lte_ul_tdl_data_end		),
	.reg_ul_path_test_val		(u_lte_ul_test_sel[8]			),

	.reg_lte_duc_gain0			(reg_lte_duc_gain0_c2	),
	.reg_lte_duc_gain1			(reg_lte_duc_gain1_c2	),
	.reg_lte_duc_gain2			(reg_lte_duc_gain2_c2	),
	.reg_lte_duc_gain3			(reg_lte_duc_gain3_c2	),
	.reg_lte_duc_gain4			(reg_lte_duc_gain4_c2	),
	.reg_lte_duc_gain5			(reg_lte_duc_gain5_c2	),
	.reg_lte_duc_gain6			(reg_lte_duc_gain6_c2	),
	.reg_lte_duc_gain7			(reg_lte_duc_gain7_c2	),

//	.reg_duc_agc_6db_sel		(reg_lte_duc_agc_6db_c2_sel		),
	.reg_ul_tdl_pd_trig			(reg_ul_lte_tdl_pd_trig[2]		),
    .reg_ul_tdl_pd_raddr		(reg_ul_lte_tdl_path2_pd_raddr	),
    .reg_ul_tdl_pd_rdata		(reg_ul_lte_tdl_path2_pd_rdata	),

	.reg_lte_ddc_gain0	(reg_lte_ddc_gain0_c2	),
	.reg_lte_ddc_gain1	(reg_lte_ddc_gain1_c2	),
	.reg_lte_ddc_gain2	(reg_lte_ddc_gain2_c2	),
	.reg_lte_ddc_gain3	(reg_lte_ddc_gain3_c2	),
	.reg_lte_ddc_gain4	(reg_lte_ddc_gain4_c2	),
	.reg_lte_ddc_gain5	(reg_lte_ddc_gain5_c2	),
	.reg_lte_ddc_gain6	(reg_lte_ddc_gain6_c2	),
	.reg_lte_ddc_gain7	(reg_lte_ddc_gain7_c2	),

	.reg_ddc_agc_6db_sel		(reg_lte_ddc_agc_6db_c2_sel		),

	.reg_ul_tdl_path_cfg		(32'h0000_8301				),

	.reg_ant0_pow				(reg_lte_dl_ant20_pow		),
	.reg_ant1_pow				(reg_lte_dl_ant21_pow		),
	.reg_ant2_pow				(reg_lte_dl_ant22_pow		),
	.reg_ant3_pow				(reg_lte_dl_ant23_pow		),
	.reg_ant4_pow				(reg_lte_dl_ant24_pow		),
	.reg_ant5_pow				(reg_lte_dl_ant25_pow		),
	.reg_ant6_pow				(reg_lte_dl_ant26_pow		),
	.reg_ant7_pow				(reg_lte_dl_ant27_pow		),
	.i_lte_dw_pd_clr			(reg_c2_lte_dw_pd_clr[0]),
	.i_lte_dw_pd_raddr			(reg_c2_lte_dw_pd_raddr[10:0]),
	.o_lte_dw_pd_rdata_hi		(reg_c2_lte_dw_pd_rdata_hi),
	.o_lte_dw_pd_rdata_lo		(reg_c2_lte_dw_pd_rdata_lo),

	.o_debug_datapath       	()
);

//**********lte_path_reg **********//
wire path_reg_lte_spi_sdo;
wire spi_lte_power_reg_sdo;

lte_path_reg u_lte_path_reg
(
    //spi
    .spi_clk                    (clk_125	             	),
    .usr_clk                    (clk_245p76              	),
    .asy_rst                    (rst_125            		),
    .usr_rst                    (rst_245p76            		),
    .spi_i_addr       			(spi_i_addr         		),
    .spi_i_data       			(spi_i_data        			),
    .spi_i_wr_en      			(spi_i_wr_en           		),
    .spi_i_rd_en      			(spi_i_rd_en           		),
    .spi_i_shift_en   			(spi_i_shift_en         	),
    .spi_o_sdo        			(path_reg_lte_spi_sdo     	),

    .o_duc_agc_6db_c0_sel		(reg_lte_duc_agc_6db_c0_sel		),
    .o_duc_agc_6db_c1_sel		(reg_lte_duc_agc_6db_c1_sel		),
    .o_duc_agc_6db_c2_sel		(reg_lte_duc_agc_6db_c2_sel		),
    .o_ddc_agc_6db_c0_sel       (reg_lte_ddc_agc_6db_c0_sel		),
    .o_ddc_agc_6db_c1_sel       (reg_lte_ddc_agc_6db_c1_sel     ),
    .o_ddc_agc_6db_c2_sel       (reg_lte_ddc_agc_6db_c2_sel     ),

    //duc
    //duc_c0a?
    .duc_gain_c0a0              (reg_lte_duc_gain0_c0      ),
    .duc_gain_c0a1              (reg_lte_duc_gain1_c0      ),
    .duc_gain_c0a2              (reg_lte_duc_gain2_c0      ),
    .duc_gain_c0a3              (reg_lte_duc_gain3_c0      ),
    .duc_gain_c0a4              (reg_lte_duc_gain4_c0      ),
    .duc_gain_c0a5              (reg_lte_duc_gain5_c0      ),
    .duc_gain_c0a6              (reg_lte_duc_gain6_c0      ),
    .duc_gain_c0a7              (reg_lte_duc_gain7_c0      ),
    //duc_c1a?
    .duc_gain_c1a0              (reg_lte_duc_gain0_c1      ),
    .duc_gain_c1a1              (reg_lte_duc_gain1_c1      ),
    .duc_gain_c1a2              (reg_lte_duc_gain2_c1      ),
    .duc_gain_c1a3              (reg_lte_duc_gain3_c1      ),
    .duc_gain_c1a4              (reg_lte_duc_gain4_c1      ),
    .duc_gain_c1a5              (reg_lte_duc_gain5_c1      ),
    .duc_gain_c1a6              (reg_lte_duc_gain6_c1      ),
    .duc_gain_c1a7              (reg_lte_duc_gain7_c1      ),
    //duc_c2a?
    .duc_gain_c2a0              (reg_lte_duc_gain0_c2      ),
    .duc_gain_c2a1              (reg_lte_duc_gain1_c2      ),
    .duc_gain_c2a2              (reg_lte_duc_gain2_c2      ),
    .duc_gain_c2a3              (reg_lte_duc_gain3_c2      ),
    .duc_gain_c2a4              (reg_lte_duc_gain4_c2      ),
    .duc_gain_c2a5              (reg_lte_duc_gain5_c2      ),
    .duc_gain_c2a6              (reg_lte_duc_gain6_c2      ),
    .duc_gain_c2a7              (reg_lte_duc_gain7_c2      ),
    //ddc
    //ddc_c0a?
    .ddc_gain_c0a0              (reg_lte_ddc_gain0_c0	   ),
    .ddc_gain_c0a1              (reg_lte_ddc_gain1_c0	   ),
    .ddc_gain_c0a2              (reg_lte_ddc_gain2_c0	   ),
    .ddc_gain_c0a3              (reg_lte_ddc_gain3_c0	   ),
    .ddc_gain_c0a4              (reg_lte_ddc_gain4_c0	   ),
    .ddc_gain_c0a5              (reg_lte_ddc_gain5_c0	   ),
    .ddc_gain_c0a6              (reg_lte_ddc_gain6_c0	   ),
    .ddc_gain_c0a7              (reg_lte_ddc_gain7_c0	   ),
    //ddc_c1a?
    .ddc_gain_c1a0              (reg_lte_ddc_gain0_c1	   ),
    .ddc_gain_c1a1              (reg_lte_ddc_gain1_c1	   ),
    .ddc_gain_c1a2              (reg_lte_ddc_gain2_c1	   ),
    .ddc_gain_c1a3              (reg_lte_ddc_gain3_c1	   ),
    .ddc_gain_c1a4              (reg_lte_ddc_gain4_c1	   ),
    .ddc_gain_c1a5              (reg_lte_ddc_gain5_c1	   ),
    .ddc_gain_c1a6              (reg_lte_ddc_gain6_c1	   ),
    .ddc_gain_c1a7              (reg_lte_ddc_gain7_c1	   ),
    //ddc_c2a?
    .ddc_gain_c2a0              (reg_lte_ddc_gain0_c2	   ),
    .ddc_gain_c2a1              (reg_lte_ddc_gain1_c2	   ),
    .ddc_gain_c2a2              (reg_lte_ddc_gain2_c2	   ),
    .ddc_gain_c2a3              (reg_lte_ddc_gain3_c2	   ),
    .ddc_gain_c2a4              (reg_lte_ddc_gain4_c2	   ),
    .ddc_gain_c2a5              (reg_lte_ddc_gain5_c2	   ),
    .ddc_gain_c2a6              (reg_lte_ddc_gain6_c2	   ),
    .ddc_gain_c2a7              (reg_lte_ddc_gain7_c2	   ),


	.dl_pow_c0a0				(reg_lte_dl_ant00_pow	),
	.dl_pow_c0a1				(reg_lte_dl_ant01_pow	),
	.dl_pow_c0a2				(reg_lte_dl_ant02_pow	),
	.dl_pow_c0a3				(reg_lte_dl_ant03_pow	),
	.dl_pow_c0a4				(reg_lte_dl_ant04_pow	),
	.dl_pow_c0a5				(reg_lte_dl_ant05_pow	),
	.dl_pow_c0a6				(reg_lte_dl_ant06_pow	),
	.dl_pow_c0a7				(reg_lte_dl_ant07_pow	),
	.dl_pow_c1a0				(reg_lte_dl_ant10_pow	),
	.dl_pow_c1a1				(reg_lte_dl_ant11_pow	),
	.dl_pow_c1a2				(reg_lte_dl_ant12_pow	),
	.dl_pow_c1a3				(reg_lte_dl_ant13_pow	),
	.dl_pow_c1a4				(reg_lte_dl_ant14_pow	),
	.dl_pow_c1a5				(reg_lte_dl_ant15_pow	),
	.dl_pow_c1a6				(reg_lte_dl_ant16_pow	),
	.dl_pow_c1a7				(reg_lte_dl_ant17_pow	),
	.dl_pow_c2a0				(reg_lte_dl_ant20_pow	),
	.dl_pow_c2a1				(reg_lte_dl_ant21_pow	),
	.dl_pow_c2a2				(reg_lte_dl_ant22_pow	),
	.dl_pow_c2a3				(reg_lte_dl_ant23_pow	),
	.dl_pow_c2a4				(reg_lte_dl_ant24_pow	),
	.dl_pow_c2a5				(reg_lte_dl_ant25_pow	),
	.dl_pow_c2a6				(reg_lte_dl_ant26_pow	),
	.dl_pow_c2a7				(reg_lte_dl_ant27_pow	),

	.ul_pow_c0a0				(reg_lte_ul_ant00_pow	),
	.ul_pow_c0a1				(reg_lte_ul_ant01_pow	),
	.ul_pow_c0a2				(reg_lte_ul_ant02_pow	),
	.ul_pow_c0a3				(reg_lte_ul_ant03_pow	),
	.ul_pow_c0a4				(reg_lte_ul_ant04_pow	),
	.ul_pow_c0a5				(reg_lte_ul_ant05_pow	),
	.ul_pow_c0a6				(reg_lte_ul_ant06_pow	),
	.ul_pow_c0a7				(reg_lte_ul_ant07_pow	),
	.ul_pow_c1a0				(reg_lte_ul_ant10_pow	),
	.ul_pow_c1a1				(reg_lte_ul_ant11_pow	),
	.ul_pow_c1a2				(reg_lte_ul_ant12_pow	),
	.ul_pow_c1a3				(reg_lte_ul_ant13_pow	),
	.ul_pow_c1a4				(reg_lte_ul_ant14_pow	),
	.ul_pow_c1a5				(reg_lte_ul_ant15_pow	),
	.ul_pow_c1a6				(reg_lte_ul_ant16_pow	),
	.ul_pow_c1a7				(reg_lte_ul_ant17_pow	),
	.ul_pow_c2a0				(reg_lte_ul_ant20_pow	),
	.ul_pow_c2a1				(reg_lte_ul_ant21_pow	),
	.ul_pow_c2a2				(reg_lte_ul_ant22_pow	),
	.ul_pow_c2a3				(reg_lte_ul_ant23_pow	),
	.ul_pow_c2a4				(reg_lte_ul_ant24_pow	),
	.ul_pow_c2a5				(reg_lte_ul_ant25_pow	),
	.ul_pow_c2a6				(reg_lte_ul_ant26_pow	),
	.ul_pow_c2a7				(reg_lte_ul_ant27_pow	),

	.dl_tdl_lte_iqselcfg0		(reg_dl_tdl_lte_iqselcfg0),
	.dl_tdl_lte_iqselcfg1		(reg_dl_tdl_lte_iqselcfg1),
	.dl_tdl_lte_iqselcfg2		(reg_dl_tdl_lte_iqselcfg2),

	.ul_tdl_lte_iqselcfg0		(reg_ul_tdl_lte_iqselcfg0),
	.ul_tdl_lte_iqselcfg1		(reg_ul_tdl_lte_iqselcfg1),
	.ul_tdl_lte_iqselcfg2		(reg_ul_tdl_lte_iqselcfg2),

    .dl_path0_sim_sel           (reg_lte_dl_tdl_data_sel		),
    .dl_path0_sim_iq            (reg_lte_dl_tdl_data_iq			),
    .dl_path0_sim_start         (reg_lte_dl_tdl_data_start   	),
    .dl_path0_sim_end           (reg_lte_dl_tdl_data_end   		),
	.dl_path0_sim_vald			(reg_lte_dl_tdl_data_vald		),

	.ul_path0_sim_sel           (reg_lte_ul_tdl_data_sel		),
    .ul_path0_sim_iq            (reg_lte_ul_tdl_data_iq			),
    .ul_path0_sim_start         (reg_lte_ul_tdl_data_start   	),
    .ul_path0_sim_end           (reg_lte_ul_tdl_data_end   		),
	.ul_path0_sim_vald			(reg_lte_ul_tdl_data_vald		),
	.dlpath_lte_delay			(reg_dlpath_lte_delay			),
	.ulpath_lte_delay			(reg_ulpath_lte_delay			),
	.bandwidth_sel_cell0		(reg_bandwidth_sel_cell0		),
	.bandwidth_sel_cell1		(reg_bandwidth_sel_cell1		),
	.bandwidth_sel_cell2		(reg_bandwidth_sel_cell2		),
	.o_dw_ant_posinfo_c0		(reg_dw_ant_posinfo_c0),
	.o_up_ant_posinfo_c0		(reg_up_ant_posinfo_c0),
	.o_dw_ant_posinfo_c1		(reg_dw_ant_posinfo_c1),
	.o_up_ant_posinfo_c1		(reg_up_ant_posinfo_c1),
	.o_dw_ant_posinfo_c2		(reg_dw_ant_posinfo_c2),
	.o_up_ant_posinfo_c2		(reg_up_ant_posinfo_c2),
	.o_c0_lte_dw_pd_clr			(reg_c0_lte_dw_pd_clr		),
	.o_c0_lte_dw_pd_raddr		(reg_c0_lte_dw_pd_raddr		),
	.i_c0_lte_dw_pd_rdata_hi	(reg_c0_lte_dw_pd_rdata_hi	),
	.i_c0_lte_dw_pd_rdata_lo	(reg_c0_lte_dw_pd_rdata_lo	),
	.o_c1_lte_dw_pd_clr			(reg_c1_lte_dw_pd_clr		),
	.o_c1_lte_dw_pd_raddr		(reg_c1_lte_dw_pd_raddr		),
	.i_c1_lte_dw_pd_rdata_hi	(reg_c1_lte_dw_pd_rdata_hi	),
	.i_c1_lte_dw_pd_rdata_lo	(reg_c1_lte_dw_pd_rdata_lo	),
	.o_c2_lte_dw_pd_clr			(reg_c2_lte_dw_pd_clr		),
	.o_c2_lte_dw_pd_raddr		(reg_c2_lte_dw_pd_raddr		),
	.i_c2_lte_dw_pd_rdata_hi	(reg_c2_lte_dw_pd_rdata_hi	),
	.i_c2_lte_dw_pd_rdata_lo	(reg_c2_lte_dw_pd_rdata_lo	)
);


lte_power_reg u_lte_power_reg(
    //spi_port
   .clk        	(clk_125),
   .asy_rst    	(rst_125),
   .i_spi_addr 	(spi_i_addr),
   .i_spi_rd_en	(spi_i_rd_en),
   .i_shift_en 	(spi_i_shift_en),
   .i_spi_wr_en	(spi_i_wr_en),
   .i_spi_data 	(spi_i_data),

   .o_spi_lte_power_reg_sdo (spi_lte_power_reg_sdo),
   .o_ram_addr_path0		(reg_ul_lte_tdl_path0_pd_raddr),
   .o_ram_addr_path1		(reg_ul_lte_tdl_path1_pd_raddr),
   .o_ram_addr_path2		(reg_ul_lte_tdl_path2_pd_raddr),

   .i_ram_data_path0		(reg_ul_lte_tdl_path0_pd_rdata),
   .i_ram_data_path1		(reg_ul_lte_tdl_path1_pd_rdata),
   .i_ram_data_path2		(reg_ul_lte_tdl_path2_pd_rdata),
   .o_ul_tdl_pd_trig		(reg_ul_lte_tdl_pd_trig)

);

assign	spi_o_sdo = path_reg_lte_spi_sdo & spi_lte_power_reg_sdo &  path_reg_spi_sdo
					& power_reg_spi_sdo;

endmodule