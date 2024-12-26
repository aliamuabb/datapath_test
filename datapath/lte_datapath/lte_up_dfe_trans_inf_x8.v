module lte_up_dfe_trans_inf_x8
(
	input	wire				sys_clk_491p52,
	input	wire				sys_rst_491p52,
	input	wire				sys_clk_245p76,
	input	wire				sys_rst_245p76,

	input	wire	[ 1:0]		i_mod_sel,	//1 10M 2 15M 3 20M

	input	wire				i_fram,
	input	wire				i_xant,
	input	wire	[15:0]		i_data,		//8i 8q

	output	wire				o_fram,
	output	reg					o_xant,
	output	wire	[31:0]		o_data
);

reg		[ 5:0]	base_cnt;
reg		[ 5:0]	addra;
reg		[15:0]	dina;

reg		[ 5:0]	fram_hd_dly_cnt;
reg				fram_hd_dly;
reg		[ 3:0]	fram_hd_dly_shift;
reg				fram_hd_dly_raw_hd;
reg		[ 7:0]	ass_fram_shift;

reg		[ 4:0]	addrb;
wire	[31:0]	doutb;

reg		[ 3:0]	fram_hd_dly_raw_shift;
reg		[ 3:0]	xant_cnt;

always @ (posedge sys_clk_491p52) begin
	if(i_fram & i_xant)
		base_cnt <= 6'b0;
	else
		base_cnt <= base_cnt + 6'b1;
end

always @ (posedge sys_clk_491p52) begin
	case(i_mod_sel)
		2'd1:	addra <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//10M
		2'd2:	addra <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//15M
		2'd3:	addra <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//20M
		default:addra <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//20M
	endcase
end

always @ (posedge sys_clk_491p52) begin
	dina <= i_data;
end

always @ (posedge sys_clk_491p52) begin
	if(i_fram & i_xant)
		fram_hd_dly_cnt <= 6'd1;
	else if(fram_hd_dly_cnt == 6'd32)
		fram_hd_dly_cnt <= 6'd0;
	else if(|fram_hd_dly_cnt)
		fram_hd_dly_cnt <= fram_hd_dly_cnt + 6'd1;
	else
		fram_hd_dly_cnt <= 6'd0;
end

always @ (posedge sys_clk_491p52) begin
	if(fram_hd_dly_cnt == 6'd32)
		fram_hd_dly <= 1'b1;
	else
		fram_hd_dly <= 1'b0;
end

always @ (posedge sys_clk_491p52) begin
	if(fram_hd_dly)
		ass_fram_shift <= {8{1'b1}};
	else
		ass_fram_shift <= {1'b0,ass_fram_shift[7:1]};
end

always @ (posedge sys_clk_245p76) begin
	fram_hd_dly_shift <= {fram_hd_dly_shift[2:0],ass_fram_shift[0]};
end

always @ (posedge sys_clk_245p76) begin
	if(fram_hd_dly_shift[3:2] == 2'b01)
		fram_hd_dly_raw_hd <= 1'b1;
	else
		fram_hd_dly_raw_hd <= 1'b0;
end

always @ (posedge sys_clk_245p76) begin
	if(fram_hd_dly_raw_hd)
		addrb <= 5'b0;
	else
		addrb <= addrb + 5'b1;
end

lte_up_dfe_trans_ram_x8 u_lte_up_dfe_trans_ram_x8 (
	.clka		(sys_clk_491p52),
	.addra		(addra),
	.wea		(1'b1),
	.dina		(dina),
	
	.clkb		(sys_clk_245p76),
	.addrb		(addrb),
	.doutb		(doutb)
);

always @ (posedge sys_clk_245p76) begin
	fram_hd_dly_raw_shift <= {fram_hd_dly_raw_shift[2:0],fram_hd_dly_raw_hd};
end

always @ (posedge sys_clk_245p76) begin
	if(fram_hd_dly_raw_shift[1])
		xant_cnt <= 4'd0;
	else
		xant_cnt <= xant_cnt + 4'd1;
end

always @ (posedge sys_clk_245p76) begin
	case(i_mod_sel)
		2'd1:	o_xant <= (xant_cnt[3:0] == 4'd15);	//10M
		2'd2:	o_xant <= (xant_cnt[3:0] == 4'd15);	//15M
		2'd3:	o_xant <= (xant_cnt[2:0] == 3'd7);	//15M
		default:o_xant <= (xant_cnt[2:0] == 3'd7);	//15M
	endcase
end

assign o_fram = fram_hd_dly_raw_shift[2];
assign o_data = {doutb[15:0], doutb[31:16]};

endmodule