module datapath_delay # (
	parameter	DIRECTION = "DW",
	parameter	MODE = "NR"
)(
	input			clk,
	input			rst,

	input			i_fram_hd,
	input			i_xant_hd,
	input	[31:0]	i_data,

	input			i_adjust_hd,

	output			o_fram_hd,
	output			o_xant_hd,
	output	[31:0]	o_data
);

reg		[31:0]	data_r1;
wire	[63:0]	data_64bit;
reg				fram_hd_r1, fram_hd_r2, fram_hd_r3, fram_hd_r4;
reg		[13:0]	data_72bit_waddr;

wire			fram_hd_adj;
reg				fram_hd_adj_r1, fram_hd_adj_r2;
reg				fram_hd_adj_r3, fram_hd_adj_r4;
reg		[13:0]	data_72bit_raddr;
reg		[13:0]	data_72bit_raddr_r1, data_72bit_raddr_r2;
wire	[71:0]	u0_q, u1_q;
reg		[63:0]	dout_q;
reg		[ 2:0]	xant_cnt;

always @ (posedge clk) begin
	fram_hd_r1 <= i_fram_hd;
	fram_hd_r2 <= fram_hd_r1;
	fram_hd_r3 <= fram_hd_r2;
	fram_hd_r4 <= fram_hd_r3;
end

always @ (posedge clk) begin
	data_r1 <= i_data;
end

assign data_64bit = {i_data, data_r1};

always @ (posedge clk) begin
	if(fram_hd_r1)
		data_72bit_waddr <= 14'd0;
	else if((DIRECTION == "DW") && (MODE == "NR") && (data_72bit_waddr == 14'h1FFF))
		data_72bit_waddr <= 14'd0;
	else if((DIRECTION == "UP") && (MODE == "NR") && (data_72bit_waddr == 14'h3FFF))
		data_72bit_waddr <= 14'd0;
	else if((DIRECTION == "DW") && (MODE == "LTE") && (data_72bit_waddr == 14'h1FFF))
		data_72bit_waddr <= 14'd0;
	else if((DIRECTION == "UP") && (MODE == "LTE") && (data_72bit_waddr == 14'h1FFF))
		data_72bit_waddr <= 14'd0;
	else
		data_72bit_waddr <= data_72bit_waddr + 14'd1;
end

generate
if(DIRECTION == "DW") begin
//72b*4k
	uram_72x4k u0_uram_72x4k
	(
	    .clk		(clk),
	    .rst		(rst),
	    .w_biten	(9'h1ff),
	    .wren		(~data_72bit_waddr[13] & ~data_72bit_waddr[0]),
	    .waddr		(data_72bit_waddr[12:1]),
	    .din		({8'b0, data_64bit}),
	    .r_biten	(9'h1ff),
	    .rden		(1'b1),
	    .raddr		(data_72bit_raddr[12:1]),
	    .dout		(u0_q)
	);
end
else if(DIRECTION == "UP") begin
	if(MODE == "NR") begin
	//72b*4k
	uram_72x4k u1_uram_72x4k
	(
	    .clk		(clk),
	    .rst		(rst),
	    .w_biten	(9'h1ff),
	    .wren		(~data_72bit_waddr[13] & ~data_72bit_waddr[0]),
	    .waddr		(data_72bit_waddr[12:1]),
	    .din		({8'b0, data_64bit}),
	    .r_biten	(9'h1ff),
	    .rden		(1'b1),
	    .raddr		(data_72bit_raddr[12:1]),
	    .dout		(u0_q)
	);
	//72b*4k
	uram_72x4k u2_uram_72x4k
	(
	    .clk		(clk),
	    .rst		(rst),
	    .w_biten	(9'h1ff),
	    .wren		(data_72bit_waddr[13] & ~data_72bit_waddr[0]),
	    .waddr		(data_72bit_waddr[12:1]),
	    .din		({8'b0, data_64bit}),
	    .r_biten	(9'h1ff),
	    .rden		(1'b1),
	    .raddr		(data_72bit_raddr[12:1]),
	    .dout		(u1_q)
	);
	end
	else if(MODE == "LTE") begin
	uram_72x4k u3_uram_72x4k
	(
	    .clk		(clk),
	    .rst		(rst),
	    .w_biten	(9'h1ff),
	    .wren		(~data_72bit_waddr[13] & ~data_72bit_waddr[0]),
	    .waddr		(data_72bit_waddr[12:1]),
	    .din		({8'b0, data_64bit}),
	    .r_biten	(9'h1ff),
	    .rden		(1'b1),
	    .raddr		(data_72bit_raddr[12:1]),
	    .dout		(u0_q)
	);
	end
end
endgenerate

generate
if(MODE == "NR") begin
fram_protect #(
	.FRAM_MAX	(26'd4915199)
) u_fram_protect_nr (
	.clk				(clk),
	.rst				(rst),

	.i_fram_hd			(i_adjust_hd),
	.o_fram_protect_hd	(fram_hd_adj)
);
end
else if(MODE == "LTE") begin
fram_protect #(
	.FRAM_MAX	(26'd2457599)
) u_fram_protect_lte (
	.clk				(clk),
	.rst				(rst),

	.i_fram_hd			(i_adjust_hd),
	.o_fram_protect_hd	(fram_hd_adj)
);
end
endgenerate

always @ (posedge clk) begin
	if(fram_hd_adj)
		data_72bit_raddr <= 14'd0;
	else if((DIRECTION == "DW") && (MODE == "NR") && (data_72bit_raddr == 14'h1FFF))
		data_72bit_raddr <= 14'd0;
	else if((DIRECTION == "UP") && (MODE == "NR") && (data_72bit_raddr == 14'h3FFF))
		data_72bit_raddr <= 14'd0;
	else if((DIRECTION == "DW") && (MODE == "LTE") && (data_72bit_raddr == 14'h1FFF))
		data_72bit_raddr <= 14'd0;
	else if((DIRECTION == "UP") && (MODE == "LTE") && (data_72bit_raddr == 14'h1FFF))
		data_72bit_raddr <= 14'd0;
	else
		data_72bit_raddr <= data_72bit_raddr + 14'd1;
end

always @ (posedge clk) begin
	fram_hd_adj_r1 <= fram_hd_adj;
	fram_hd_adj_r2 <= fram_hd_adj_r1;
	fram_hd_adj_r3 <= fram_hd_adj_r2;
	fram_hd_adj_r4 <= fram_hd_adj_r3;
end

always @ (posedge clk) begin
	data_72bit_raddr_r1 <= data_72bit_raddr;
	data_72bit_raddr_r2 <= data_72bit_raddr_r1;
end

always @ (posedge clk) begin
	if(~data_72bit_raddr_r2[13])
		dout_q <= u0_q;
	else if(data_72bit_raddr_r2[13])
		dout_q <= u1_q;
	else
		dout_q <= dout_q;
end

always @ (posedge clk) begin
	if(fram_hd_adj_r3)
		xant_cnt <= 3'b0;
	else
		xant_cnt <= xant_cnt + 3'b1;
end

assign o_data = (xant_cnt[0] == 0)?dout_q[31:0]:dout_q[63:32];
assign o_fram_hd = fram_hd_adj_r3;
assign o_xant_hd = (MODE == "LTE")?(xant_cnt[2:0] == 3'b111):(xant_cnt[1:0] == 2'b11);

endmodule