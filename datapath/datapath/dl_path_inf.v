//`define	5G_AC

module dl_path_inf
(
	input	wire		  		asy_rst,	
    input	wire		  		clk,
	input	wire				i_ant8_sel,
    input	wire	[31:0]		i_data,
//    input	wire				i_data_valid,
    input	wire				i_fram_hd,
    
    //output to duc   
    output	wire				o_ant8_sel,
    output	wire	[31:0]		o_data,
//    output	wire			o_data_valid,
    output	wire				o_fram_hd,
    //reg_if   
    input	wire	[31:0]		reg_ant_posinfo0,
    input	wire	[31:0]		reg_ant_posinfo1,
//    input	wire	[15:0]		reg_path_bandwidth,
    input	wire				dl_power_bypass,    
    
	input	wire	[31:0]		i_reg_dl_delay_time,

    input   wire    [31:0]      i_frame_hd,
    input	wire	[31:0]		i_data0_iq,
    input	wire	[31:0]		i_data1_iq,
    
    input	wire				i_timedelay_fram,

    //dl_tdl_test 
    input	wire	[31:0]		i_test_vld,			
    input	wire	[31:0]		i_cell_iqselcfg,			
    input	wire	[31:0]		i_cell_iq,			
	input	wire	[31:0]		i_data_start,
	input	wire	[31:0]		i_data_end,
	input	wire	    		i_test_sel,
//    //input from module timing
//    input	wire				i_ac_flag,
//    input	wire				i_odd_even,	    	
//	//dl_tdl_prbs 
//	input	wire	[15:0]		reg_ant_cfg,                       			
//	input	wire	[31:0]		reg_dl_tdl_bit,
//	input	wire	[31:0]		reg_ul_start_time,
//	input	wire	[31:0]		reg_ul_end_time,
	//dl_tdl_agc
	input	wire	[31:0]   	reg_lte_duc_gain0,
	input	wire	[31:0]   	reg_lte_duc_gain1,
	input	wire	[31:0]   	reg_lte_duc_gain2,
	input	wire	[31:0]   	reg_lte_duc_gain3,
//	input	wire	[31:0]		reg_duc_agc_6db_sel,
	
	input	wire	[31:0]		reg_ant0_pow,
	input	wire	[31:0]		reg_ant1_pow,
	input	wire	[31:0]		reg_ant2_pow,
	input	wire	[31:0]		reg_ant3_pow,
	
	input	wire	[ 31:0]		i_bandwidth_60m,
	
	input	wire				i_pd_clr,
	input	wire	[10:0]		i_pd_raddr,
	output	wire	[31:0]		o_pd_rdata_hi,
	output	wire	[31:0]		o_pd_rdata_lo,
	
	output	wire	[42:0]		o_debug_dl_path,
/////////seq_insert

   input  wire  i_tx_ac_valid          ,
   input  wire  [2:0] i_ant_cnt        ,
   input  wire  i_rx_seq_valid         ,
   input  wire  i_tx_seq_valid         ,
                                       
                                      
   input  wire  i_seq_insert_en        ,
                                       
                                       
   input wire [6:0] i_seq_cnt          ,
   	                                  
   input wire i_sw_testdata            ,
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
   input wire i_dl_frm_hd              ,
   input wire i_x4_sel   
);


wire				test2pow_vald;                                                     	
wire				test2pow_fram;   
wire				test2pow_sel;
wire	[31:0]		test2pow_data;  
    
wire				pow2ac_vald;                                                     	
wire				pow2ac_fram;   
wire				pow2ac_sel;
wire	[31:0]		pow2ac_data;

wire				ac2agc_vald;                                                     	
wire				ac2agc_fram;   
wire				ac2agc_sel;
wire	[31:0]		ac2agc_data;


wire	[127:0]		debug_agc;
wire	[42:0]		debug_mem;

wire				src2pow_fram;
wire	[31:0]		src2pow_data;
wire				src2pow_sel;  

wire				agc2delay_fram;
wire	[31:0]		agc2delay_data;
wire				agc2delay_sel; 

srcx1_inf u_srcx1_inf
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
    .o_data_iq					(src2pow_data),
    .o_fram_hd          		(src2pow_fram),
    .o_ant8_sel					(src2pow_sel),
//    .o_data_valid          	(test2pow_vald),
    
    .i_test_vld					(i_test_vld),
    .i_cell_iqselcfg			(i_cell_iqselcfg),
    .i_cell_iq					(i_cell_iq),    
    .i_data_start				(i_data_start),
    .i_data_end					(i_data_end),
    .i_test_sel					(i_test_sel)    	         
);

//datapath_delay_bram # (
//	.DIRECTION			("DW"),
//	.MODE				("NR")
//) u_datapath_delay_bram (
//	.clk				(clk),
//	.rst				(asy_rst),

//	.i_fram_hd			(src2delay_fram	),
//	.i_xant_hd			(src2delay_sel	),
//	.i_data				(src2delay_data	),

//	.i_adjust_hd		(i_timedelay_fram),

//	.o_fram_hd			(delay2pow_fram	),
//	.o_xant_hd			(delay2pow_sel	),
//	.o_data				(delay2pow_data	)
//);
  
dl_path_pow u_dl_path_pow
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
	.power_bypass						(1),
	.i_fram_hd							(src2pow_fram),			
	.i_ant8_sel							(src2pow_sel),	
	.i_data								(src2pow_data),				
//	.i_data_valid						(test2pow_vald),
	.o_fram_hd							(pow2ac_fram),				
	.o_ant8_sel							(pow2ac_sel),
	.o_data								(pow2ac_data)		
//	.o_data_valid						(pow2ac_valid)		
);

`ifdef AC_5G
//seq_insert
seq_insert u_seq_insert0_a

( 
.asy_rst                    (asy_rst       ),					//reset    
.clk_245p76                 (clk    ),                    	
.reg_cal_ant_en             (reg_cal_ant_en),           //一组的校准天线使能
.dl_wdata                   (pow2ac_data      ),
                            
.rx_ant_cnt                 (i_ant_cnt    ),   
.tx_ant_cnt                 (i_ant_cnt    ),
.tx_ac_valid                (i_tx_ac_valid   ),
.group_index                (group_index          ),
.rx_seq_valid               (i_rx_seq_valid  ),
.tx_seq_valid               (i_tx_seq_valid  ),
.amp_seq0                   (i_amp_seq0),
.amp_seq1                   (i_amp_seq1),
.amp_seq2                   (i_amp_seq2),
.amp_seq3                   (i_amp_seq3),
.amp_seq4                   (i_amp_seq4),
.amp_seq5                   (i_amp_seq5),
.amp_seq6                   (i_amp_seq6),
.amp_seq7                   (i_amp_seq7),
.i_seq_insert_en            (i_seq_insert_en),
.i_seq_cnt                  (i_seq_cnt),
.dl_wdata_out               (ac2agc_data  ),

.sw_testdata                (i_sw_testdata    ),
.testdata0                  (i_testdata0      ),
.testdata1                  (i_testdata1      ),
.testdata2                  (i_testdata2      ),
.testdata3                  (i_testdata3      ),
.testdata4                  (i_testdata4      ),
.testdata5                  (i_testdata5      ),
.testdata6                  (i_testdata6      ),
.testdata7                  (i_testdata7      )

); 


//seq_insert
//(
//);

//assign	ac2agc_data = pow2ac_data;
//assign	ac2agc_fram = pow2ac_fram;
//assign	ac2agc_sel = pow2ac_sel;   

assign	o_dl_frm_hd = pow2ac_fram;  
assign	o_x4_sel    = pow2ac_sel;  

assign ac2agc_fram = i_dl_frm_hd;
assign ac2agc_sel = i_x4_sel;
`else
assign	ac2agc_data = pow2ac_data;
assign	ac2agc_fram = pow2ac_fram;
assign	ac2agc_sel = pow2ac_sel; 
`endif
 
/*        
dl_tdl_agc u_dl_path_agc
(
	.asy_rst							(asy_rst),	//rst
	.clk_245						    (clk),  //clk 245p76    
	.i_data								(ac2agc_data),	//tds duc agc fram hd
//	.i_data_valid						(ac2agc_vald),
	.i_fram_hd							(ac2agc_fram),//(ac2agc_fram),  //tds duc agc data
	.i_ant8_sel							(ac2agc_sel   ),//(ac2agc_sel),         
	.o_data								(o_data),//o_data  																		),	//dfe ca switch ram wdata
//	.o_data_valid						(o_data_valid  ),//o_data_valid  															),
	.o_ant8_sel							(o_ant8_sel ),//o_ant8_sel  																),  //dfe ca switch ram we
	.o_fram_hd      					(o_fram_hd),  //dfe ca switch ram fram hd
	.i_lte_duc_gain0					(reg_lte_duc_gain0),
	.i_lte_duc_gain1					(reg_lte_duc_gain1),
	.i_lte_duc_gain2					(reg_lte_duc_gain2),
	.i_lte_duc_gain3					(reg_lte_duc_gain3)
);
*/


data_path_agc        
#(
.XNUM(4)
)u_dl_path_agc
(
	.reset							  	(asy_rst),	//rst
	.clk						     	(clk),  //clk 245p76    
	.i_data								(ac2agc_data),	//tds duc agc fram hd
	.i_fram_hd							(ac2agc_fram),//(ac2agc_fram),  //tds duc agc data
	.i_ant8_sel							(ac2agc_sel   ),//(ac2agc_sel),         
	.o_data								(agc2delay_data        ),//o_data  																		),	//dfe ca switch ram wdata
	.o_ant8_sel							(agc2delay_sel    ),//o_ant8_sel  																),  //dfe ca switch ram we
	.o_fram_hd      					(agc2delay_fram     ),  //dfe ca switch ram fram hd
	.i_ddc_agc_6db_sel               	(0),//(reg_ddc_agc_6db_sel),
	.i_ddc_gain_lte						({reg_lte_duc_gain3,reg_lte_duc_gain2,reg_lte_duc_gain1,reg_lte_duc_gain0})
); 

datapath_delay # (
	.DIRECTION			("DW"),
	.MODE				("NR")
) u_datapath_delay (
	.clk				(clk),
	.rst				(asy_rst),

	.i_fram_hd			(agc2delay_fram	),
	.i_xant_hd			(agc2delay_sel	),
	.i_data				(agc2delay_data	),

	.i_adjust_hd		(i_timedelay_fram),

	.o_fram_hd			(o_fram_hd	),
	.o_xant_hd			(o_ant8_sel	),
	.o_data				(o_data	)
);

//ila_2 your_instance_name (
//	.clk(clk), // input wire clk

//	.probe0(i_data), // input wire [31:0]  probe0  
//	.probe1(src2pow_data), // input wire [31:0]  probe1 
//	.probe2(pow2ac_data), // input wire [31:0]  probe2 
//	.probe3(ac2agc_data), // input wire [31:0]  probe3 
//	.probe4(agc2delay_data), // input wire [31:0]  probe4 
//	.probe5(o_data) // input wire [31:0]  probe5
//);


pd_dw_nr_top u_pd_dw_nr_top (
	.sys_clk		(clk		),	//245.76M
	.sys_rst		(asy_rst	),
	.i_fram			(o_fram_hd	),
	.i_xant			(o_ant8_sel	),
	.i_data			(o_data		),
	.i_clr			(i_pd_clr	),
	.i_sel			(i_bandwidth_60m[3:0]),
	.i_pd_raddr		(i_pd_raddr	),
	.o_pd_rdata_lo	(o_pd_rdata_lo	),
	.o_pd_rdata_hi	(o_pd_rdata_hi	)
);

//ila_dl_datapath ila_dl_datapath (
//	.clk(clk), // input wire clk


//	.probe0(i_fram_hd), // input wire [0:0]  probe0  
//	.probe1(i_ant8_sel), // input wire [0:0]  probe1 
//	.probe2(i_data), // input wire [31:0]  probe2 
//	.probe3(test2pow_fram), // input wire [0:0]  probe3 
//	.probe4(test2pow_sel), // input wire [0:0]  probe4 
//	.probe5(test2pow_data), // input wire [31:0]  probe5 
//	.probe6(pow2ac_fram), // input wire [0:0]  probe6 
//	.probe7(pow2ac_sel), // input wire [0:0]  probe7 
//	.probe8(pow2ac_data), // input wire [31:0]  probe8 
//	.probe9(o_fram_hd), // input wire [0:0]  probe9 
//	.probe10(o_ant8_sel), // input wire [0:0]  probe10 
//	.probe11(o_data) // input wire [31:0]  probe11
//);


endmodule