module pd_dw_lte_top (
	input	sys_clk,	//245.76M
	input	sys_rst,
	input			i_fram,
	input			i_xant,
	input	[31:0]	i_data,

	input			i_clr,
	input	[ 1:0]	i_sel,
	input	[10:0]	i_pd_raddr,
	output	[31:0]	o_pd_rdata_lo,
	output	[31:0]	o_pd_rdata_hi
);

//inf
wire			u_last;

//storage
wire			u_wea;
wire	[10:0]	u_addra;
wire	[47:0]	u_dina;

pd_dw_lte_inf u_pd_dw_lte_inf (
	.sys_clk		(sys_clk),	//245.76M
	.sys_rst		(sys_rst),

	.i_sel			(i_sel),
	.i_fram			(i_fram),
	.o_last			(u_last)
);

pd_dw_lte_calc u_pd_dw_lte_calc (
	.sys_clk		(sys_clk),	//245.76M
	.sys_rst		(sys_rst),

	.i_fram			(i_fram),
	.i_xant			(i_xant),
	.i_last			(u_last),
	.i_data			(i_data),

	.o_we			(u_wea),
	.o_addr			(u_addra),	//8ant * 14symbol * 10slot
	.o_din			(u_dina)
);

pd_dw_lte_bus u_pd_dw_lte_bus (
	.sys_clk		(sys_clk),	//245.76M
	.sys_rst		(sys_rst),
	.i_we			(u_wea),
	.i_addr			(u_addra),	//8ant * 14symbol * 10slot
	.i_din			(u_dina),

	.i_pd_clr		(i_clr),
	.i_pd_raddr		(i_pd_raddr),
	.o_pd_rdata_hi	(o_pd_rdata_hi),
	.o_pd_rdata_lo	(o_pd_rdata_lo)
);

//ila_pd_dw_lte
//ila_pd_dw_lte
//(
//.clk	(sys_clk),
//.probe0	(i_fram),
//.probe1	(i_xant),
//.probe2	(i_data),
//.probe3	(u_wea),
//.probe4	(u_addra),
//.probe5	(u_dina),
//.probe6	(i_pd_raddr),
//.probe7	(o_pd_rdata_hi),
//.probe8	(o_pd_rdata_lo)
//);

endmodule