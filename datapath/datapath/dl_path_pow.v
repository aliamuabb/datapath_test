//wangshuyi@2018-01-29

module dl_path_pow
#(
parameter	XNUM = 4
)
(
	input	wire				clk,
	input	wire				asy_rst,

	input	wire	[31:0]		i_ant_posinfo0,
	input	wire	[31:0]		i_ant_posinfo1,

	input	wire	[31:0]		i_ant0_pow,
	input	wire	[31:0]		i_ant1_pow,
	input	wire	[31:0]		i_ant2_pow,
	input	wire	[31:0]		i_ant3_pow,
	input	wire				power_bypass,

	input	wire				i_fram_hd,
	input	wire				i_ant8_sel,
	input	wire	[31:0]		i_data,
	input	wire				i_data_valid,

	output	wire				o_fram_hd,
	output	wire				o_ant8_sel,
	output	reg		[31:0]		o_data,
	output	wire				o_data_valid
);

reg		[ 1:0]		cycle_cnt;
reg		[ 3:0]		cycle_cnt_d1;
reg		[31:0]		ant_posinfo0;
reg		[31:0]		ant_posinfo1;
reg		[ 8:0]		fram_hd;
reg		[ 8:0]		ant8_sel;
reg		[31:0]		data;

reg		[31:0]		ant_pow;

wire   [72:0]      m_axis_dout_tdata;
//data counter
always @ (posedge clk)
	begin
		fram_hd <= {fram_hd[7:0],i_fram_hd};
		ant8_sel <= {ant8_sel[7:0],i_ant8_sel};
	end

always @ (posedge clk)
	begin
		if (i_fram_hd | (cycle_cnt == XNUM-1))
			cycle_cnt <= 0;
		else
			cycle_cnt <= cycle_cnt + 1;
	end

always @ (posedge clk)
	begin
		ant_posinfo0 <= i_ant_posinfo0;
		ant_posinfo1 <= i_ant_posinfo1;
		cycle_cnt_d1 <= cycle_cnt;
		data <= i_data;
	end



always @ (posedge clk)
	begin
		case(cycle_cnt[1:0])
			2'b00 : ant_pow <= i_ant0_pow;
			2'b01 : ant_pow <= i_ant1_pow;
			2'b10 : ant_pow <= i_ant2_pow;
			2'b11 : ant_pow <= i_ant3_pow;
			default: ant_pow <= 32'b00000;
		endcase	
	end
	

path_complex_mult u_path_complex_mult
(
	.aclk				(clk),                              // input wire aclk
  	.s_axis_a_tvalid	(1'b1),        						// input wire s_axis_a_tvalid
  	.s_axis_a_tdata		({data[15:0],data[31:16]}),		// input wire [31 : 0] s_axis_a_tdata
  	.s_axis_b_tvalid	(1'b1),        						// input wire s_axis_b_tvalid
  	.s_axis_b_tdata		({ant_pow[15:0],ant_pow[31:16]}),	// input wire [31 : 0] s_axis_b_tdata
    .s_axis_ctrl_tvalid (1'b0),  // input wire s_axis_ctrl_tvalid
    .s_axis_ctrl_tdata  (8'h0),    // input wire [7 : 0] s_axis_ctrl_tdata  	
  	.m_axis_dout_tvalid	(),  								// output wire m_axis_dout_tvalid
  	.m_axis_dout_tdata	(m_axis_dout_tdata)    				// output wire [31 : 0] m_axis_dout_tdata
);


reg    [31:0] i_data_d0;
reg    [31:0] i_data_d1;
reg    [31:0] i_data_d2;
reg    [31:0] i_data_d3;
reg    [31:0] i_data_d4;
reg    [31:0] i_data_d5;
reg    [31:0] i_data_d6;
reg    [31:0] i_data_d7;


assign o_ant8_sel = ant8_sel[7];
assign o_fram_hd =  fram_hd[7];
assign o_data_valid = 1'b1;
always  @   (posedge clk)
begin
	o_data <= power_bypass ? i_data_d6 : {m_axis_dout_tdata[15:0],m_axis_dout_tdata[39:24]};
end
//assign o_data = power_bypass ? i_data_d6 : {m_axis_dout_tdata[15:0],m_axis_dout_tdata[39:24]};

always  @   (posedge clk)
begin
    i_data_d0 <= i_data;
    i_data_d1 <= i_data_d0;
    i_data_d2 <= i_data_d1;
    i_data_d3 <= i_data_d2;
    i_data_d4 <= i_data_d3;
    i_data_d5 <= i_data_d4;
    i_data_d6 <= i_data_d5;
    i_data_d7 <= i_data_d6;
end

//vavido_ila_pow vavido_ila_pow
//(
//    .clk                (clk),
//    .probe0				(i_fram_hd),
//    .probe1				(i_ant8_sel),
//    .probe2				(i_data),
//    .probe3				(o_fram_hd),
//    .probe4				(o_ant8_sel),
//    .probe5				(o_data)
//);

endmodule