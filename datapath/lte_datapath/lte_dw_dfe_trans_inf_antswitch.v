module lte_dw_dfe_trans_inf_antswitch
(
	input	wire				sys_clk_491p52,
	input	wire				sys_rst_491p52,
	input	wire				sys_clk_245p76,
	input	wire				sys_rst_245p76,

	input	wire	[ 1:0]		i_mod_sel,	//0->5M   1->10M   2->15M   3->20M
	
	input	wire	[31:0]		i_ant_pos,

	input	wire				i_fram,
	input	wire	[31:0]		i_data,		//i[31:16] q[15: 0]

	output	wire				o_fram,
	output	reg					o_xant,
	output	wire	[15:0]		o_data
);

reg		[ 4:0]	aux_cnt;
reg		[ 4:0]	addra;
reg		[ 4:0]	fram_hd_dly_cnt;
reg				fram_hd_dly;
reg		[ 3:0]	fram_hd_dly_shift;
reg				fram_hd_dly_raw_hd;
wire			fram_hd_dly_raw_hd_int;

reg		[ 5:0]	base_cnt;
reg		[ 5:0]	addrb;
wire	[15:0]	doutb;
reg		[ 3:0]	fram_hd_dly_raw_shift;
reg		[ 5:0]	xant_cnt;

always @ (posedge sys_clk_245p76) begin
	if(i_fram)
		aux_cnt <= 5'b0;
	else
		aux_cnt <= aux_cnt + 5'b1;
end

always @ (*) begin
	case(aux_cnt[2:0])
		3'd0:	addra = {aux_cnt[ 4: 3], i_ant_pos[ 2: 0]};
		3'd1:	addra = {aux_cnt[ 4: 3], i_ant_pos[ 6: 4]};
		3'd2:	addra = {aux_cnt[ 4: 3], i_ant_pos[10: 8]};
		3'd3:	addra = {aux_cnt[ 4: 3], i_ant_pos[14:12]};
		3'd4:	addra = {aux_cnt[ 4: 3], i_ant_pos[18:16]};
		3'd5:	addra = {aux_cnt[ 4: 3], i_ant_pos[22:20]};
		3'd6:	addra = {aux_cnt[ 4: 3], i_ant_pos[26:24]};
		3'd7:	addra = {aux_cnt[ 4: 3], i_ant_pos[30:28]};
		default:addra = aux_cnt;
	endcase
end

always @ (posedge sys_clk_245p76) begin
	if(i_fram)
		fram_hd_dly_cnt <= 5'd1;
	else if(fram_hd_dly_cnt == 5'd16)
		fram_hd_dly_cnt <= 5'd0;
	else if(|fram_hd_dly_cnt)
		fram_hd_dly_cnt <= fram_hd_dly_cnt + 5'd1;
	else
		fram_hd_dly_cnt <= 5'd0;
end

always @ (posedge sys_clk_245p76) begin
	if(fram_hd_dly_cnt == 5'd16)
		fram_hd_dly <= 1'b1;
	else
		fram_hd_dly <= 1'b0;
end

always @ (posedge sys_clk_491p52) begin
	fram_hd_dly_shift <= {fram_hd_dly_shift[2:0],fram_hd_dly};
end

always @ (posedge sys_clk_491p52) begin
	if(fram_hd_dly_shift[3:2] == 2'b01)
		fram_hd_dly_raw_hd <= 1'b1;
	else
		fram_hd_dly_raw_hd <= 1'b0;
end

framhd_protect_20201016 u_framhd_protect
(
	.asy_rst			(sys_rst_491p52		),
	.clk				(sys_clk_491p52		),			//clk
//--------------------input timing info--------------------
	.i_ext_hd			(fram_hd_dly_raw_hd		),		//frame head from epld or receiver module
	.i_fram_max			(26'd4915199  			),		//frame cnt max
	.o_int_hd			(fram_hd_dly_raw_hd_int	)       //frame head gen
);

always @ (posedge sys_clk_491p52) begin
	if(fram_hd_dly_raw_hd_int)
		base_cnt <= 6'b0;
	else
		base_cnt <= base_cnt + 6'b1;
end

always @ (posedge sys_clk_491p52) begin
	case(i_mod_sel)
	    2'd0:	addrb <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//5M
		2'd1:	addrb <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//10M
		2'd2:	addrb <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//15M
		2'd3:	addrb <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//20M
		default:addrb <= {base_cnt[5:4], base_cnt[2:0], base_cnt[3]};	//20M
	endcase
end

lte_dw_dfe_trans_x8_ram u_lte_dw_dfe_trans_x8_ram (
	.clka		(sys_clk_245p76),
	.addra		(addra),
	.wea		(1'b1),
	.dina		({i_data[15:0], i_data[31:16]}),
	
	.clkb		(sys_clk_491p52),
	.addrb		(addrb),
	.doutb		(doutb)
);

always @ (posedge sys_clk_491p52) begin
	fram_hd_dly_raw_shift <= {fram_hd_dly_raw_shift[2:0],fram_hd_dly_raw_hd_int};
end

always @ (posedge sys_clk_491p52) begin
	if(fram_hd_dly_raw_shift[2])
		xant_cnt <= 6'd0;
	else
		xant_cnt <= xant_cnt + 6'd1;
end

always @ (posedge sys_clk_491p52) begin
	case(i_mod_sel)
	    2'd0:	o_xant <= (xant_cnt[5:0] == 6'd63);	//5M
		2'd1:	o_xant <= (xant_cnt[4:0] == 5'd31);	//10M
		2'd2:	o_xant <= (xant_cnt[4:0] == 5'd31);	//15M
		2'd3:	o_xant <= (xant_cnt[3:0] == 4'd15);	//20M
		default:o_xant <= (xant_cnt[3:0] == 4'd15);	//20M
	endcase
end

assign o_fram = fram_hd_dly_raw_shift[3];
assign o_data = doutb;

endmodule