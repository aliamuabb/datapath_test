module ul_path_inf_60m
(
    input   wire                asy_rst,				
    input   wire                clk,        
	input	wire				clk_125,
	input   wire                i_fram_hd,		
	input   wire                i_ant8_sel,
	input   wire	[31:0]      i_data,
//	input   wire                i_data_valid,

	//bbu interface
	output	wire				o_ant8_sel,
    output	wire	[31:0]		o_data,
//    output	wire			o_data_valid,
    output	wire				o_fram_hd,                                                                  
	//reg_if
	//reg ul_mem_ctr
	input	wire	[31:0]		reg_ant_posinfo0,
	input	wire	[31:0]		reg_ant_posinfo1,
//	input   wire    [15:0]      reg_path_bandwidth,
    input	wire				ul_power_bypass,  

	input 	wire 	[31:0]		i_reg_ul_delay_time,
    input   wire    [31:0]      i_frame_hd,    
    input	wire	[31:0]		i_data0_iq,
    input	wire	[31:0]		i_data1_iq,    	
	//reg ul_tdl_test
    input	wire	[31:0]		i_test_vld,			
    input	wire	[31:0]		i_cell_iqselcfg,			
    input	wire	[31:0]		i_cell_iq,			
	input	wire	[31:0]		i_data_start,
	input	wire	[31:0]		i_data_end,
	input	wire	    		i_test_sel,
	//reg ul_tdl_pow_dect
	input   wire				reg_ul_tdl_pd_trig,
    input   wire    [7:0]		reg_ul_tdl_pd_raddr,
    output  wire    [31:0]      reg_ul_tdl_pd_rdata,
    //reg ul_tdl_agc       
	input   wire    [31:0]      reg_ddc_gain_index_a0,
	input   wire    [31:0]      reg_ddc_gain_index_a1,
	input   wire    [31:0]      reg_ddc_gain_index_a2,
	input   wire    [31:0]      reg_ddc_gain_index_a3,
	input   wire    [31:0]      reg_ddc_gain_index_a4,
	input   wire    [31:0]      reg_ddc_gain_index_a5,
	input   wire    [31:0]      reg_ddc_gain_index_a6,
	input   wire    [31:0]      reg_ddc_gain_index_a7,
	
	input   wire    [31:0]      reg_ddc_agc_6db_sel,
	
	input	wire	[31:0]		reg_ant0_pow,
	input	wire	[31:0]		reg_ant1_pow,
	input	wire	[31:0]		reg_ant2_pow,
	input	wire	[31:0]		reg_ant3_pow,
	input	wire	[31:0]		reg_ant4_pow,
	input	wire	[31:0]		reg_ant5_pow,
	input	wire	[31:0]		reg_ant6_pow,
	input	wire	[31:0]		reg_ant7_pow,


	output  wire    [255:0]     o_debug_datapath
);

//output of ul_path_trans  
wire		 	    test2pow_fram; 
wire			    test2pow_sel;  
wire    [31:0]      test2pow_data;      
wire			    test2pow_vald;
//output of ul_path_sync
wire		 	    pow2agc_fram;
wire			    pow2agc_sel;
wire    [31:0]      pow2agc_data;
wire			    pow2agc_vald;

wire				src2delay_fram;
wire	[31:0]		src2delay_data;
wire				src2delay_sel;  
//chipsocope


srcx1_inf_60m u_srcx1_inf_60m
(
	.asy_rst					(asy_rst),   
    .clk						(clk),
   
    .i_frame_hd					(i_frame_hd),
    .i_data0_iq					(i_data0_iq),
    .i_data1_iq					(i_data1_iq),
    
    .i_framn_hd					(i_fram_hd),
    .i_datan_iq					(i_data),
    .i_ant8_sel					(i_ant8_sel),
//    .i_data_valid				(i_data_valid),    
    .o_data_iq					(src2delay_data),
    .o_fram_hd          		(src2delay_fram),
    .o_ant8_sel					(src2delay_sel),
//    .o_data_valid          		(test2pow_vald),
    
    .i_test_vld							(i_test_vld),
    .i_cell_iqselcfg					(i_cell_iqselcfg),
    .i_cell_iq							(i_cell_iq),    
    .i_data_start						(i_data_start),
    .i_data_end							(i_data_end),
    .i_test_sel							(i_test_sel)    	
            
);

lte_src_inf_ila ul_src_inf_ila
(
.clk   (clk),
.probe0(i_fram_hd),
.probe1(i_data),
.probe2(i_ant8_sel),
.probe3(src2delay_data),
.probe4(src2delay_fram),
.probe5(src2delay_sel),
.probe6(i_test_vld),
.probe7(i_test_sel),
.probe8(i_cell_iqselcfg),
.probe9(i_cell_iq)
);

time_delay32 u_time_delay32
(
	.clk						(clk),
	.asy_rst					(asy_rst),
	                            
	.i_fram_hd_25us				(src2delay_fram),
	.i_x8hd_25us				(src2delay_sel),
	.i_data_25us				({2'b0,src2delay_data}),
	                            
	.i_wfram_hd_25us			(src2delay_fram),
	.i_time_delay_set			(i_reg_ul_delay_time),
	                            
	.o_fram_hd_25us				(test2pow_fram),
	.o_x8hd_25us				(test2pow_sel),
	.o_data_25us				(test2pow_data)
);
   

power_detect_top
#(
.SF_TIME(245760),
.FRAM_NUM(300),
.SF_NUM(20),
.SF_ADDR_NUM(20),
.ANT_NUM(8),
.MODE("BOARD")
)power_detect_top
(
	.reset        (asy_rst),			
	.clk          (clk), 
	                             
	.i_fram_hd            (test2pow_fram),
	.i_data               (test2pow_data),
	.trig                 (reg_ul_tdl_pd_trig), 
	.i_pow_dect_raddr     (reg_ul_tdl_pd_raddr),
	.o_pow_dect_rdata     (reg_ul_tdl_pd_rdata)
	
);


dl_path_pow_60m u_ul_path_pow_60m
(
	.clk								(clk),
	.asy_rst							(asy_rst),
	.i_ant_posinfo0						(reg_ant_posinfo0),	
	.i_ant_posinfo1						(reg_ant_posinfo1),	
//	.i_ant_posinfo						(32'h76543210),
	.i_ant0_pow							(reg_ant0_pow),
	.i_ant1_pow							(reg_ant1_pow),
	.i_ant2_pow							(reg_ant2_pow),
	.i_ant3_pow							(reg_ant3_pow),
	.i_ant4_pow							(reg_ant4_pow),
	.i_ant5_pow							(reg_ant5_pow),
	.i_ant6_pow							(reg_ant6_pow),
	.i_ant7_pow							(reg_ant7_pow),

	.power_bypass						(ul_power_bypass),	
	.i_fram_hd							(test2pow_fram),			
	.i_ant8_sel							(test2pow_sel),	
	.i_data								(test2pow_data),				
//	.i_data_valid						(test2pow_vald),
	.o_fram_hd							(pow2agc_fram),				
	.o_ant8_sel							(pow2agc_sel),
	.o_data								(pow2agc_data)		
//	.o_data_valid						(pow2agc_vald)		
);

ul_tdl_agc_60m u_ul_path_agc_60m
(                                    
	.asy_rst                            (asy_rst),
	.clk_245                            (clk),
	
	.i_fram_hd                          (pow2agc_fram),
 	.i_data                             (pow2agc_data),
 	.i_ant8_sel                         (pow2agc_sel),
// 	.i_data_valid                       (pow2agc_vald), 

 	.o_fram_hd                          (o_fram_hd),                     
	.o_ant8_sel                         (o_ant8_sel),
 	.o_data                             (o_data),
// 	.o_data_valid                       (o_data_valid), 
 	
	.i_a0_ddc_gain_lte			        (reg_ddc_gain_index_a0),
	.i_a1_ddc_gain_lte			        (reg_ddc_gain_index_a1),
	.i_a2_ddc_gain_lte			        (reg_ddc_gain_index_a2),
	.i_a3_ddc_gain_lte			        (reg_ddc_gain_index_a3),
	.i_a4_ddc_gain_lte			        (reg_ddc_gain_index_a4),
	.i_a5_ddc_gain_lte			        (reg_ddc_gain_index_a5),
	.i_a6_ddc_gain_lte			        (reg_ddc_gain_index_a6),
	.i_a7_ddc_gain_lte			        (reg_ddc_gain_index_a7),
	.i_ddc_agc_6db_sel					(reg_ddc_agc_6db_sel)
);
  
endmodule
