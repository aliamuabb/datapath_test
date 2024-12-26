module pd_dw_lte_inf (
	input	sys_clk,	//245.76M
	input	sys_rst,
	
	//i_sel:
	//7.68	x32	5M
	//15.36	x16	10M
	//15.36	x16	15M
	//30.72	x8	20M
	input	[ 1:0]	i_sel,

	input			i_fram,
	output			o_last
);

//basic parameter
reg		[ 4:0]	xant_max = 5'd0;
reg		[11:0]	spec_symbol_len = 12'd0;
reg		[11:0]	norm_symbol_len = 12'd0;

reg		[ 4:0]	xant_cnt = 5'd0;
reg		[11:0]	symb_point_cnt = 12'd0;
reg		[11:0]	symb_point_max = 12'd0;
reg		[ 3:0]	symb_cnt = 4'd0;

reg				symb_last = 1'b0;

always @ (posedge sys_clk) begin
	case(i_sel)
		2'd0:	xant_max <= 5'd31;
		2'd1:	xant_max <= 5'd15;
		2'd2:	xant_max <= 5'd15;
		2'd3:	xant_max <= 5'd7;
	endcase
end

always @ (posedge sys_clk) begin
	case(i_sel)
		2'd0:	spec_symbol_len <= (12'd512  + 12'd40 ) - 1;
		2'd1:	spec_symbol_len <= (12'd1024 + 12'd80 ) - 1;
		2'd2:	spec_symbol_len <= (12'd1024 + 12'd80 ) - 1;
		2'd3:	spec_symbol_len <= (12'd2048 + 12'd160) - 1;
	endcase
end

always @ (posedge sys_clk) begin
	case(i_sel)
		2'd0:	norm_symbol_len <= (12'd512  + 12'd36 ) - 1;
		2'd1:	norm_symbol_len <= (12'd1024 + 12'd72 ) - 1;
		2'd2:	norm_symbol_len <= (12'd1024 + 12'd72 ) - 1;
		2'd3:	norm_symbol_len <= (12'd2048 + 12'd144) - 1;
	endcase
end

always @ (posedge sys_clk) begin
	if(i_fram)
		xant_cnt <= 5'd0;
	else if(xant_cnt == xant_max)
		xant_cnt <= 5'd0;
	else
		xant_cnt <= xant_cnt + 5'd1;
end

always @ (*) begin
	if((symb_cnt == 4'd0) || (symb_cnt == 4'd7))
		symb_point_max = spec_symbol_len;
	else
		symb_point_max = norm_symbol_len;
end

always @ (posedge sys_clk) begin
	if(i_fram)
		symb_point_cnt <= 12'd0;
	else if((symb_point_cnt == symb_point_max) && (xant_cnt == xant_max))
		symb_point_cnt <= 12'd0;
	else if(xant_cnt == xant_max)
		symb_point_cnt <= symb_point_cnt + 12'd1;
	else
		symb_point_cnt <= symb_point_cnt;
end

always @ (posedge sys_clk) begin
	if(i_fram)
		symb_cnt <= 4'd0;
	else if((symb_cnt == 4'd13) && (symb_point_cnt == symb_point_max) && (xant_cnt == xant_max))
		symb_cnt <= 4'd0;
	else if((symb_point_cnt == symb_point_max) && (xant_cnt == xant_max))
		symb_cnt <= symb_cnt + 4'd1;
	else
		symb_cnt <= symb_cnt;
end

always @ (posedge sys_clk) begin
	if(i_fram)
		symb_last <= 1'b0;
	else if((symb_point_cnt == symb_point_max - 1) && (xant_cnt == xant_max))
		symb_last <= 1'b1;
	else if(xant_cnt == 5'd7)
		symb_last <= 1'b0;
	else
		symb_last <= symb_last;
end

assign o_last = symb_last;

endmodule
