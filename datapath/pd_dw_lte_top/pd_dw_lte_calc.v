module pd_dw_lte_calc (
	input	sys_clk,	//245.76M
	input	sys_rst,
	
	input			i_fram,
	input			i_xant,
	input			i_last,		//write to ram
	input	[31:0]	i_data,

	output	reg			o_we,
	output	reg	[10:0]	o_addr,	//14symbol * 10slot
	output	reg	[47:0]	o_din
);

reg		[ 7:0]	fram_dly;
reg		[ 7:0]	xant_dly;
reg		[ 7:0]	last_dly;
reg		[31:0]	data_step1;
reg		[31:0]	data_step1_dly1;
reg		[31:0]	data_step1_dly2;
reg		[31:0]	data_step2;
reg		[31:0]	data_step2_dly1;
reg		[31:0]	data_step2_dly2;
wire	[47:0]	sqrt_i;
wire	[47:0]	calc_ret;

reg				ret_storage_we = 1'd0;
reg		[ 2:0]	ret_storage_waddr = 3'd0;
reg		[ 2:0]	ret_storage_raddr = 3'd0;
wire	[47:0]	ret_storage_wdata;
wire	[47:0]	ret_storage_rdata;

reg		[ 7:0]	pd_storage_waddr = 8'd0;

always @ (posedge sys_clk) begin
	data_step1 <= i_data;
	data_step2 <= data_step1;
end

always @ (posedge sys_clk) begin
	data_step1_dly1 <= data_step1;
	data_step1_dly2 <= data_step1_dly1;
	
	data_step2_dly1 <= data_step2;
	data_step2_dly2 <= data_step2_dly1;
end

always @ (posedge sys_clk) begin
	fram_dly <= {fram_dly[6:0], i_fram};
end

always @ (posedge sys_clk) begin
	xant_dly <= {xant_dly[6:0], i_xant};
end

always @ (posedge sys_clk) begin
	last_dly <= {last_dly[6:0], i_last};
end

pd_lte_dsp_step1 u_pd_lte_dsp_step1 (
//i*i
	.CLK		(sys_clk),
//	.SCLR		(i_fram),
	.A			(data_step1_dly2[31:16]),
	.B			(data_step1_dly2[31:16]),
	.PCOUT		(sqrt_i),
	.P			()
//	.CARRYOUT	()
);

pd_lte_dsp_step2 u_pd_lte_dsp_step2 (
//q*q+mult_step_ret
	.CLK		(sys_clk),
//	.SCLR		(i_fram),//(fram_dly[7] | symb_dly[7]),
	.PCIN		(sqrt_i),
	.A			(data_step2_dly2[15: 0]),
	.B			(data_step2_dly2[15: 0]),
	.C			(ret_storage_rdata),
	.P			(calc_ret)
//	.CARRYOUT	()
);

always @ (posedge sys_clk) begin
	if(fram_dly[7])
		ret_storage_waddr <= 3'b0;
	else
		ret_storage_waddr <= ret_storage_waddr + 3'd1;
end

always @ (posedge sys_clk) begin
	if(fram_dly[0])
		ret_storage_raddr <= 3'b0;
	else
		ret_storage_raddr <= ret_storage_raddr + 3'd1;
end

always @ (posedge sys_clk) begin
	if(xant_dly[7])
		ret_storage_we <= 1'b1;
	else if(ret_storage_waddr == 3'd7)
		ret_storage_we <= 1'b0;
	else
		ret_storage_we <= ret_storage_we;
end

pd_lte_ret_storage u_pd_lte_ret_storage
(
	.clka	(sys_clk),
	.addra	(ret_storage_waddr),
	.dina	(ret_storage_wdata),//(calc_ret),
	.wea	(ret_storage_we),

	.clkb	(sys_clk),
	.addrb	(ret_storage_raddr),
	.doutb	(ret_storage_rdata)
);

always @ (posedge sys_clk) begin
	if(fram_dly[7])
		pd_storage_waddr <= 8'b0;
	else if((pd_storage_waddr == 8'd139) && (last_dly[7:6] == 2'b10))
		pd_storage_waddr <= 8'b0;
	else if(last_dly[7:6] == 2'b10)
		pd_storage_waddr <= pd_storage_waddr + 8'd1;
	else
		pd_storage_waddr <= pd_storage_waddr;
end

assign ret_storage_wdata = last_dly[7]?48'd0:calc_ret;

always @ (posedge sys_clk) begin
	o_we	<=	last_dly[7];
	o_addr	<=	{pd_storage_waddr, ret_storage_waddr};
	o_din	<=	calc_ret;
end

endmodule