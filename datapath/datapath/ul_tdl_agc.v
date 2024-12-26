//wangshuyi@2018-01-30

module ul_tdl_agc
#(
parameter	XNUM = 4
)(
input   wire            asy_rst	,
input   wire			clk_245,
input   wire  [31:0]    i_data,
input   wire            i_ant8_sel,
input   wire			i_fram_hd,
input	wire			i_data_valid,		//add by chendanqing 2012-03-13
output  wire            o_fram_hd,			//te_agc_hd is 1 cycles earlier than data
output  wire            o_ant8_sel,
output  wire  [31:0]    o_data,
output	wire 			o_data_valid,		//add by chendanqing 2012-03-13
//reg interface
input	wire	[31:0]	i_a0_ddc_gain_lte,
input	wire	[31:0]	i_a1_ddc_gain_lte,
input	wire	[31:0]	i_a2_ddc_gain_lte,
input	wire	[31:0]	i_a3_ddc_gain_lte,
input	wire	[31:0]	i_ddc_agc_6db_sel

);

reg [31:0] data1;
reg [31:0] data2;
reg [31:0] data3;
reg [31:0] data4;
reg [31:0] data5;
reg [31:0] data6;
reg [31:0] data7;
reg [31:0] data8;
reg [31:0] data9;
					
reg		[15:0]	ddc_gain_index;
wire 	[16:0]	ddc_gain;
reg 	[16:0]	ddc_gain_dly;   

					
reg		[31:0] 	ul_tdl_agc_data;
wire	[14:0]	pout_q;
wire	[14:0]	pout_i;

reg		[9:0]	ant8_sel_d;
reg		[9:0]	fram_hd_d;
reg		[9:0]	data_valid_d;

reg		[3:0]	cnt = 0;

always @ (posedge clk_245 )
begin		
		if(i_fram_hd | (cnt==XNUM-1))	
			cnt<=0;
		else
			cnt<=cnt+1;
end
	
always@(posedge asy_rst or posedge clk_245)	
begin
		if(asy_rst)
				ddc_gain_index<=16'b0;
		else begin
				case(cnt)
					4'b0000	:	ddc_gain_index<=i_a0_ddc_gain_lte[15:0];
					4'b0001	:	ddc_gain_index<=i_a1_ddc_gain_lte[15:0];				 	
					4'b0010	:	ddc_gain_index<=i_a2_ddc_gain_lte[15:0];				 	
					4'b0011	:	ddc_gain_index<=i_a3_ddc_gain_lte[15:0];
				default		:	ddc_gain_index<=16'b0;
				endcase
		end						 	
end
	
db_gain_table	db_gain_table (
	.addra	( ddc_gain_index[7:0] ),
	.clka	( clk_245 ),
	.dina	(17'b0),
    .wea	(1'b0),
	.douta	( ddc_gain )  //output it after 2 cycle(db_gain_idx input)
	);
	
always @ (posedge clk_245 )
	begin
		ddc_gain_dly<=ddc_gain;
	end

ddc_agc u_tdl_ddc_agc (	
//ddc_agc u_tdl_ddc_agc (
	.ddc_agc_clk		( clk_245								),
//	.ce					(   1'b1                         		),
	.ddc_agc_rst		( 1'b0								),
	.ddc_agc_6db_sel	( i_ddc_agc_6db_sel[1:0]				),
	.ddc_agc_data_i		( pout_i								),
	.ddc_agc_data_q		( pout_q								),
	.ddc_agc_value		( {1'b0,ddc_gain_dly}						),
	.ddc_data_i			( {data4[31:16], 2'b0 }					),
	.ddc_data_q			( {data4[15:0], 2'b0} 					)
	);//output after 5clk

	
always @ (posedge clk_245 )

	begin
		data1<=i_data;
		data2<=data1;
		data3<=data2;
		data4<=data3;		
		data5<=data4;
		data6<=data5;
		data7<=data6;		
		data8<=data7;
		data9<=data8;
	end


//always @ ( posedge asy_rst or posedge clk_245 )
//begin
//    if ( asy_rst )
//    	ul_tdl_agc_data <= 30'b0;
//    else if(i_ddc_agc_6db_sel[4]==1'b0)begin
//		ul_tdl_agc_data[14:0] <= pout_q;
//		ul_tdl_agc_data[29:15] <= pout_i; 
//	end
//	else begin
//			ul_tdl_agc_data[14:0] <= data8[15:1];
//			ul_tdl_agc_data[29:15] <= data8[31:17]; 
//	end	
//end     

//????需要修改模型?
always @ ( posedge clk_245 )
    begin
    	if(i_ddc_agc_6db_sel[4]==1'b0)
			ul_tdl_agc_data <= {pout_i,1'b0,pout_q,1'b0};
		else
			ul_tdl_agc_data <= data9;
	end

assign o_data=ul_tdl_agc_data;



assign	o_ant8_sel = ant8_sel_d[9];
assign	o_fram_hd = fram_hd_d[9];
assign	o_data_valid = data_valid_d[9];

always @ (posedge clk_245 )
begin
	ant8_sel_d<={ant8_sel_d[8:0],i_ant8_sel};
	fram_hd_d<={fram_hd_d[8:0],i_fram_hd};
	data_valid_d<={data_valid_d[8:0],i_data_valid};
end


endmodule