module dp2dfe_inf (
	input		clk_491p52,
	input		rst_491p52,
	input		clk_245p76,
	input		rst_245p76,
	
	input	[ 2:0]	i_bandwidth_nr_mod,
	
	input			i_path0_fram,
	input	[31:0]	i_path0_data,
	
	input			i_path1_fram,
	input	[31:0]	i_path1_data,
	
	output	reg			o_path_fram,
	output	reg			o_path_xant,
	output	reg	[31:0]	o_path_data
);

reg		[ 2:0]	fram_dly_cnt = 0;
reg				fram_hd_dly = 0;
reg				cdc_rfram_r1 = 0;
reg				cdc_rfram_r2 = 0;
reg				cdc_rfram_r3 = 0;
wire			cdc_rfram_p;
wire			cdc_rfram_p_int;

reg		[ 3:0]	addra = 0;
reg		[ 4:0]	addrb = 0;
wire	[31:0]	dout_p0;
wire	[31:0]	dout_p1;

reg				aux_fram_r1 = 0;
reg				aux_fram_r2 = 0;
reg				aux_fram_r3 = 0;
reg		[ 3:0]	aux_cnt = 0;

reg				mod_sel = 0;

always @ (posedge clk_245p76) begin
	if(i_path0_fram)
		fram_dly_cnt <= 3'd1;
	else if(|fram_dly_cnt)
		fram_dly_cnt <= fram_dly_cnt + 3'd1;
	else
		fram_dly_cnt <= 3'd0;
end

always @ (posedge clk_245p76) begin
	if(fram_dly_cnt == 3'd7)
		fram_hd_dly <= 1'b1;
	else
		fram_hd_dly <= 1'b0;
end

always @ (posedge clk_491p52) begin
	cdc_rfram_r1 <= fram_hd_dly;
	cdc_rfram_r2 <= cdc_rfram_r1;
	cdc_rfram_r3 <= cdc_rfram_r2;
end

assign cdc_rfram_p = ~cdc_rfram_r3 & cdc_rfram_r2;

framhd_protect_20201016 u_dp2dfe_framhd_protect
(
	.asy_rst			(rst_491p52		),
	.clk				(clk_491p52		),			//clk
//--------------------input timing info--------------------
	.i_ext_hd			(cdc_rfram_p				),		//frame head from epld or receiver module
	.i_fram_max			(26'd4915199  				),		//frame cnt max
	.o_int_hd			(cdc_rfram_p_int			)       //frame head gen
);

always @ (posedge clk_245p76) begin
	if(i_path0_fram & i_path1_fram)
		addra <= 4'd0;
	else
		addra <= addra + 4'd1;
end

always @ (posedge clk_491p52) begin
	if(cdc_rfram_p_int)
		addrb <= 5'd0;
	else
		addrb <= addrb + 5'd1;
end

dp2dfe_cdc_ram u0_dp2dfe_cdc_ram (
	.clka		(clk_245p76),
	.addra		(addra),
	.wea		(1'b1),
	.dina		(i_path0_data),
	
	.clkb		(clk_491p52),
	.addrb		({addrb[4:3], addrb[1:0]}),
	.doutb		(dout_p0)
);

dp2dfe_cdc_ram u1_dp2dfe_cdc_ram (
	.clka		(clk_245p76),
	.addra		(addra),
	.wea		(1'b1),
	.dina		(i_path1_data),
	
	.clkb		(clk_491p52),
	.addrb		({addrb[4:3], addrb[1:0]}),
	.doutb		(dout_p1)
);

always @ (posedge clk_491p52) begin
	aux_fram_r1 <= cdc_rfram_p_int;
	aux_fram_r2 <= aux_fram_r1;
	aux_fram_r3 <= aux_fram_r2;
end

always @ (posedge clk_491p52) begin
	if(aux_fram_r3)
		aux_cnt <= 4'd0;
	else
		aux_cnt <= aux_cnt + 4'd1;
end

always @ (posedge clk_491p52) begin
	case(i_bandwidth_nr_mod[2:0])
		3'd2:	mod_sel <= 1'b0;	//20M
		3'd3:	mod_sel <= 1'b0;	//30M
		3'd4:	mod_sel <= 1'b1;	//40M
		3'd5:	mod_sel <= 1'b1;	//50M
		3'd6:	mod_sel <= 1'b1;	//60M
		default:mod_sel <= 1'b1;	//60M
	endcase
end

always @ (posedge clk_491p52) begin
	o_path_fram <= aux_fram_r3;
end

always @ (posedge clk_491p52) begin
	if(mod_sel)
		o_path_xant <= (aux_cnt[2:0] == 3'd7);
	else
		o_path_xant <= (aux_cnt[3:0] == 4'd15);
end

always @ (posedge clk_491p52) begin
	if(aux_cnt[2])
		o_path_data <= dout_p1;
	else
		o_path_data <= dout_p0;
end

endmodule
