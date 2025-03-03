//wangshuyi@2018-12-01

module	data_path_agc
#(
 parameter		DATA_DW 	= 32
,parameter		XNUM 		= 4
,parameter		CFG_DW		= 32
)(
 input   wire            			reset
,input   wire						clk
,input   wire	[DATA_DW-1:0]		i_data
,input   wire            			i_ant8_sel
,input   wire						i_fram_hd
,output  wire            			o_fram_hd			//te_agc_hd is 1 cycles earlier than data
,output  wire            			o_ant8_sel
,output  wire	[DATA_DW-1:0]		o_data
//reg interface
,input	wire	[CFG_DW*XNUM-1:0]	i_ddc_gain_lte
,input	wire	[CFG_DW-1:0]		i_ddc_agc_6db_sel

);
					
reg		[CFG_DW-1:0]				ddc_gain;
reg 	[CFG_DW*XNUM-1:0]          inner_ddc_gain_lte;
					
reg		[DATA_DW-1:0] 				ul_tdl_agc_data;
wire	[DATA_DW/2-1:0]				pout_q;
wire	[DATA_DW/2-1:0]				pout_i;

reg		[9:0]				ant8_sel_d;
reg		[9:0]				fram_hd_d;
reg		[10*DATA_DW-1:0]	data_d;
reg		[CFG_DW/2-1:0]		i_dpd_agc;
reg		[3:0]				cnt = 0;

always @ (posedge clk )
begin		
		if(i_fram_hd | (cnt==XNUM-1))	
			cnt<=0;
		else
			cnt<=cnt+1;
end

always @ (posedge clk)
begin
	inner_ddc_gain_lte <= i_ddc_gain_lte;
end

//always @ (posedge clk)
//begin
//	ddc_gain <= inner_ddc_gain_lte[CFG_DW*cnt+:32];
//end

always @ (posedge clk)
begin
	ddc_gain <= i_ddc_gain_lte[CFG_DW*cnt+:32];
end

always @ (posedge clk)
begin
	i_dpd_agc <= (i_ddc_agc_6db_sel[7])?ddc_gain[CFG_DW-1:CFG_DW/2]:ddc_gain[CFG_DW/2-1:0];
end

//assign i_dpd_agc = (i_ddc_agc_6db_sel[7])?ddc_gain[CFG_DW/2-1:CFG_DW/2]:ddc_gain[CFG_DW/2-1:0];

dpd_mult_rounding dpd_mult_rounding_i (
  .CLK(clk),  // input wire CLK
  .A(i_dpd_agc),      // input wire [15 : 0] A
  .B(data_d[(1+1)*DATA_DW-1:1*DATA_DW+DATA_DW/2]),      // input wire [15 : 0] B
  .P(pout_i)      // output wire [15 : 0] P
);

dpd_mult_rounding dpd_mult_rounding_q (
  .CLK(clk),  // input wire CLK
  .A(i_dpd_agc),      // input wire [15 : 0] A
  .B(data_d[1*DATA_DW+DATA_DW/2-1:1*DATA_DW]),      // input wire [15 : 0] B
  .P(pout_q)      // output wire [15 : 0] P
);

always @ (posedge clk )

	begin
		data_d<={data_d[9*DATA_DW-1:0],i_data};
	end

always @ ( posedge clk )
    begin
    	if(~i_ddc_agc_6db_sel[4])
			ul_tdl_agc_data <= {pout_i,pout_q};
		else
			ul_tdl_agc_data <= data_d[(4+1)*DATA_DW-1:4*DATA_DW];
	end

always @ (posedge clk )
begin
	ant8_sel_d<={ant8_sel_d[8:0],i_ant8_sel};
	fram_hd_d<={fram_hd_d[8:0],i_fram_hd};
end

assign	o_data			= ul_tdl_agc_data;
assign	o_ant8_sel		= ant8_sel_d[5];
assign	o_fram_hd		= fram_hd_d[5];

endmodule