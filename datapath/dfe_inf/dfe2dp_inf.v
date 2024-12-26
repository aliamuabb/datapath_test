module dfe2dp_inf (
	input		clk_491p52,
	input		rst_491p52,
	input		clk_245p76,
	input		rst_245p76,
	
	input	[ 2:0]	i_bandwidth_nr_mod,
	
	input			i_path_fram,
	input			i_path_xant,
	input	[31:0]	i_path_data,
	
	output	reg			o_path0_fram,
	output	reg			o_path0_xant,
	output	reg	[31:0]	o_path0_data,
	
	output	reg			o_path1_fram,
	output	reg			o_path1_xant,
	output	reg	[31:0]	o_path1_data
);

reg		[ 2:0]	fram_hd_dly_cnt = 0;
reg				fram_hd_dly = 0;
reg		[ 3:0]	fram_hd_dly_shift = 0;
reg				fram_hd_dly_raw_hd = 0;
wire			fram_hd_dly_raw_hd_int;
reg		[ 7:0]	ass_fram_shift = 0;

reg		[ 4:0]	addra = 0;
reg		[ 3:0]	addrb = 0;
wire	[31:0]	dout_p0;
wire	[31:0]	dout_p1;

reg				aux_fram_r1 = 0;
reg				aux_fram_r2 = 0;
reg				aux_fram_r3 = 0;
reg		[ 3:0]	aux_cnt = 0;

reg				mod_sel = 0;

always @ (posedge clk_491p52) begin
	if(i_path_fram & i_path_xant)
		fram_hd_dly_cnt <= 3'd1;
	else if(|fram_hd_dly_cnt)
		fram_hd_dly_cnt <= fram_hd_dly_cnt + 3'd1;
	else
		fram_hd_dly_cnt <= 3'd0;
end

always @ (posedge clk_491p52) begin
	if(fram_hd_dly_cnt == 3'd7)
		fram_hd_dly <= 1'b1;
	else
		fram_hd_dly <= 1'b0;
end

always @ (posedge clk_491p52) begin
	if(fram_hd_dly)
		ass_fram_shift <= {8{1'b1}};
	else
		ass_fram_shift <= {1'b0,ass_fram_shift[7:1]};
end

always @ (posedge clk_245p76) begin
	fram_hd_dly_shift <= {fram_hd_dly_shift[2:0],ass_fram_shift[0]};
end

always @ (posedge clk_245p76) begin
	if(fram_hd_dly_shift[3:2] == 2'b01)
		fram_hd_dly_raw_hd <= 1'b1;
	else
		fram_hd_dly_raw_hd <= 1'b0;
end

framhd_protect_20201016 u_dfe2dp_framhd_protect
(
	.asy_rst			(rst_245p76		),
	.clk				(clk_245p76		),			//clk
//--------------------input timing info--------------------
	.i_ext_hd			(fram_hd_dly_raw_hd			),		//frame head from epld or receiver module
	.i_fram_max			(26'd2457599  				),		//frame cnt max
	.o_int_hd			(fram_hd_dly_raw_hd_int		)       //frame head gen
);

always @ (posedge clk_491p52) begin
	if(i_path_fram & i_path_xant)
		addra <= 5'd0;
	else
		addra <= addra + 5'd1;
end

always @ (posedge clk_245p76) begin
	if(fram_hd_dly_raw_hd_int)
		addrb <= 4'd0;
	else
		addrb <= addrb + 4'd1;
end

dfe2dp_cdc_ram u0_dfe2dp_cdc_ram (
	.clka		(clk_491p52),
	.addra		(addra),
	.wea		(1'b1),
	.dina		(i_path_data),
	
	.clkb		(clk_245p76),
	.addrb		({addrb[3:2], 1'b0, addrb[1:0]}),
	.doutb		(dout_p0)
);

dfe2dp_cdc_ram u1_dfe2dp_cdc_ram (
	.clka		(clk_491p52),
	.addra		(addra),
	.wea		(1'b1),
	.dina		(i_path_data),
	
	.clkb		(clk_245p76),
	.addrb		({addrb[3:2], 1'b1, addrb[1:0]}),
	.doutb		(dout_p1)
);

always @ (posedge clk_245p76) begin
	case(i_bandwidth_nr_mod[2:0])
		3'd2:	mod_sel <= 1'b0;	//20M
		3'd3:	mod_sel <= 1'b0;	//30M
		3'd4:	mod_sel <= 1'b1;	//40M
		3'd5:	mod_sel <= 1'b1;	//50M
		3'd6:	mod_sel <= 1'b1;	//60M
		default:mod_sel <= 1'b1;	//60M
	endcase
end

always @ (posedge clk_245p76) begin
	aux_fram_r1 <= fram_hd_dly_raw_hd_int;
	aux_fram_r2 <= aux_fram_r1;
	aux_fram_r3 <= aux_fram_r2;
end

always @ (posedge clk_245p76) begin
	if(aux_fram_r3)
		aux_cnt <= 4'd0;
	else
		aux_cnt <= aux_cnt + 4'd1;
end

always @ (posedge clk_245p76) begin
	o_path0_fram <= aux_fram_r3;
	o_path1_fram <= aux_fram_r3;
end

always @ (posedge clk_245p76) begin
	o_path0_data <= dout_p0;
	o_path1_data <= dout_p1;
end

always @ (posedge clk_245p76) begin
	if(mod_sel)
		o_path0_xant <= (aux_cnt[1:0] == 2'd3);
	else
		o_path0_xant <= (aux_cnt[2:0] == 3'd7);
end

always @ (posedge clk_245p76) begin
	if(mod_sel)
		o_path1_xant <= (aux_cnt[1:0] == 2'd3);
	else
		o_path1_xant <= (aux_cnt[2:0] == 3'd7);
end

endmodule
