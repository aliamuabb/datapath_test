module pd_dw_nr_bus (
	input	sys_clk,	//245.76M
	input	sys_rst,
	input			i_we,
	input	[10:0]	i_addr,	//14symbol * 10slot
	input	[47:0]	i_din,
	
	//register control
	input				i_pd_clr,
	input		[10:0]	i_pd_raddr,
	output	reg	[31:0]	o_pd_rdata_hi,
	output	reg	[31:0]	o_pd_rdata_lo
);

reg		[10:0]	addra_dly1;
reg		[10:0]	addra_dly2;
reg		[10:0]	addra_dly3;
reg		[10:0]	addra_dly4;
reg		[10:0]	addra;

reg		[47:0]	dina_dly1;
reg		[47:0]	dina_dly2;
reg		[47:0]	dina_dly3;
reg		[47:0]	dina_dly4;
reg		[47:0]	dina;

reg				wea_dly1;
reg				wea_dly2;
reg				wea_dly3;
reg				wea_dly4;
reg				wea;

reg		[10:0]	addrb;
wire	[47:0]	doutb;

reg		[10:0]	addrb_dly1;
reg		[10:0]	addrb_dly2;
reg		[10:0]	addrb_dly3;

always @ (posedge sys_clk) begin
	wea_dly1 <= i_we;
	wea_dly2 <= wea_dly1;
	wea_dly3 <= wea_dly2;
	wea_dly4 <= wea_dly3;
end

always @ (posedge sys_clk) begin
	addra_dly1 <= i_addr;
	addra_dly2 <= addra_dly1;
	addra_dly3 <= addra_dly2;
	addra_dly4 <= addra_dly3;
end

always @ (posedge sys_clk) begin
	dina_dly1 <= i_din;
	dina_dly2 <= dina_dly1;
	dina_dly3 <= dina_dly2;
	dina_dly4 <= dina_dly3;
end

always @ (posedge sys_clk) begin
	addrb <= i_addr;
end

always @ (posedge sys_clk) begin
	wea		<= wea_dly4;
	addra	<= addra_dly4;
end

always @ (posedge sys_clk) begin
	if(i_pd_clr)
		dina <= 48'd0;
	else if(doutb > dina_dly4)
		dina <= doutb;
	else
		dina <= dina_dly4;
end

syn_sdp_ram 
#(
    .DATA_WIDTH_A(48),             ////= 48        ,//range: 1 ~ 4608
	.DATA_WIDTH_B(48),             //= 48        ,//range: 1 ~ 4608
    .NUMWORDS_A(1120),              // = 4       ,//range: 2 ~ min(2^20,150994944/DATA_WIDTH_A)
	.BYTE_ENA_SIZE(8),           // = 8         ,//8/9        
	.NUM_PIPES(3),               // = 2         ,//true dly value,when no register:1~100 ; when register:2~100 
	.BYTE_EN(0),                 // = 0         ,//1: enable byte_en function;  0:disable byte_en function
	.OUTDATA_REG_B("CLOCK0"),     //       = "CLOCK0"  ,//string: "UNREGISTERED","CLOCK0";Clock for the data output registers of port B. 
	.INI_FILE(""),                // = ""        ,//string: "","*.mif","*.hex" 
	.RAM_BLOCK_TYPE("block")     //      = "block"    //string: "auto", "block", "distributed", "ultra"
)
u_syn_sdp_ram 
(
	.data	    (dina),
	.q	        (doutb),
	.wraddress	(addra),//(calc_ret),
	.rdaddress	(addrb),

	.wren	(wea),
	.clock	(sys_clk),
	.rden	(),
	.sclr	(1'b0),
	.byteena_a	(1'b0)
);
// pd_dw_nr_ram u_pd_dw_nr_ram (
// 	.clka			(sys_clk),
// 	.wea			(wea),
// 	.addra			(addra),
// 	.dina			(dina),

// 	.clkb			(sys_clk),
// 	.addrb			(addrb),
// 	.doutb			(doutb)
// );

//register control
always @ (posedge sys_clk) begin
	addrb_dly1 <= addrb;
	addrb_dly2 <= addrb_dly1;
	addrb_dly3 <= addrb_dly2;
end

always @ (posedge sys_clk) begin
	if(addrb_dly3 == i_pd_raddr) begin
		o_pd_rdata_hi <= {16'd0, doutb[47:32]};
		o_pd_rdata_lo <= doutb[31:0];
	end
	else;
end

endmodule
