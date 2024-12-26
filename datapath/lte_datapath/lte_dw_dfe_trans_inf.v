//only 10M LTE
//input:	12*8cycle dat + 12*8cycle 0
//output:	8cycle i + 8cycle q + 8cycle 0 + 8cycle 0
//ram_waddr:	0 1 2 3 4 ... 93 94 95	128 129 ...
//ram_wdata:	12*8cycle dat			12*8cycle 0
//ram_raddr:	0 2 4 ... 12 14 1 3 5 ... 13 15		128 130 132 ... 129 131 133
//ram_rdata:	8cycle i		8cycle q			8cycle 0		8cycle 0
//ram info:		w = 512*32b		r = 1024*16b
module lte_dw_dfe_trans_inf
(
	input	wire				sys_clk_491p52,
	input	wire				sys_rst_491p52,
	input	wire				sys_clk_245p76,
	input	wire				sys_rst_245p76,

	input	wire	[ 1:0]		i_mod_sel,	//1 10M 2 15M 3 20M

	input	wire				i_fram,
	input	wire	[31:0]		i_data,		//i[31:16] q[15: 0]

	output	wire				o_fram,
	output	reg					o_xant,
	output	wire	[15:0]		o_data
);

reg		[ 8:0]	addra;
reg		[ 7:0]	fram_hd_dly_cnt;
reg				fram_hd_dly;
reg		[ 3:0]	fram_hd_dly_shift;
reg				fram_hd_dly_raw_hd;

reg		[ 9:0]	base_cnt;
reg		[ 9:0]	bank_data;
wire	[ 9:0]	base_addr;
reg		[ 9:0]	addrb;
wire	[15:0]	doutb;
reg		[ 3:0]	fram_hd_dly_raw_shift;
reg		[ 4:0]	xant_cnt;

always @ (posedge sys_clk_245p76) begin
	if(i_fram)
		addra <= 9'd0;
	else if(addra[6:0] == 7'd95) begin
		addra[6:0] <= 7'd0;
		addra[8:7] <= addra[8:7] + 1'd1;
	end
	else begin
		addra[6:0] <= addra[6:0] + 8'd1;
		addra[8:7] <= addra[8:7];
	end
end

always @ (posedge sys_clk_245p76) begin
	if(i_fram)
		fram_hd_dly_cnt <= 8'd1;
	else if(fram_hd_dly_cnt == 8'd192)
		fram_hd_dly_cnt <= 8'd0;
	else if(|fram_hd_dly_cnt)
		fram_hd_dly_cnt <= fram_hd_dly_cnt + 8'd1;
	else
		fram_hd_dly_cnt <= 8'd0;
end

always @ (posedge sys_clk_245p76) begin
	if(fram_hd_dly_cnt == 8'd192)
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

always @ (posedge sys_clk_491p52) begin
	if(fram_hd_dly_raw_hd)
		base_cnt <= 10'b0;
	else if(base_cnt[7:0] == 8'd191) begin
		base_cnt[7:0] <= 8'd0;
		base_cnt[9:8] <= base_cnt[9:8] + 2'd1;
	end
	else begin
		base_cnt[7:0] <= base_cnt[7:0] + 8'd1;
		base_cnt[9:8] <= base_cnt[9:8];
	end
end

always @ (posedge sys_clk_491p52) begin
	if(fram_hd_dly_raw_hd)
		bank_data <= 10'b0;
	else if((bank_data == (12-1)*16) && (base_cnt[4:0] == 5'd31))
		bank_data <= 10'b0;
	else if(base_cnt[4:0] == 5'd31)
		bank_data <= bank_data + 10'd16;
	else
		bank_data <= bank_data;
end

assign base_addr = base_cnt[4]?{5'h10, base_cnt[2:0], base_cnt[3]} + bank_data:{1'b0, base_cnt[2:0], base_cnt[3]} + bank_data;

always @ (posedge sys_clk_491p52) begin
	case(i_mod_sel)
		2'd1:	addrb <= base_cnt[9]?base_addr + 10'h200:base_addr;	//10M
		2'd2:	addrb <= base_cnt[9]?base_addr + 10'h200:base_addr;	//15M
		2'd3:	addrb <= {base_cnt[9:4], base_cnt[2:0], base_cnt[3]};	//20M
		default:addrb <= {base_cnt[9:4], base_cnt[2:0], base_cnt[3]};	//20M
	endcase
end

lte_dw_dfe_trans_ram u_lte_dw_dfe_trans_ram (
	.clka		(sys_clk_245p76),
	.addra		(addra),
	.wea		(1'b1),
	.dina		({i_data[15:0], i_data[31:16]}),
	
	.clkb		(sys_clk_491p52),
	.addrb		(addrb),
	.doutb		(doutb)
);

always @ (posedge sys_clk_491p52) begin
	fram_hd_dly_raw_shift <= {fram_hd_dly_raw_shift[2:0],fram_hd_dly_raw_hd};
end

always @ (posedge sys_clk_491p52) begin
	if(fram_hd_dly_raw_shift[2])
		xant_cnt <= 5'd0;
	else
		xant_cnt <= xant_cnt + 5'd1;
end

always @ (posedge sys_clk_491p52) begin
	case(i_mod_sel)
		2'd1:	o_xant <= (xant_cnt[4:0] == 5'd31);	//10M
		2'd2:	o_xant <= (xant_cnt[4:0] == 5'd31);	//15M
		2'd3:	o_xant <= (xant_cnt[3:0] == 4'd15);	//15M
		default:o_xant <= (xant_cnt[3:0] == 4'd15);	//15M
	endcase
end

assign o_fram = fram_hd_dly_raw_shift[3];
assign o_data = doutb;

endmodule