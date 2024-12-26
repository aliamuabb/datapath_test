module datapath_delay_bram # (
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

reg		[13:0]	data_32bit_waddr;
reg		[13:0]	data_32bit_raddr;
wire			fram_hd_adj;
reg				fram_hd_adj_r1, fram_hd_adj_r2;
wire	[31:0]	data_32bit_rdata;
reg		[ 1:0]	xant_cnt;

always @ (posedge clk) begin
	if(i_fram_hd)
		data_32bit_waddr <= 14'd0;
	else if((DIRECTION == "DW") && (data_32bit_waddr == 14'h5FF))	//3.125us
		data_32bit_waddr <= 14'd0;
	else if((DIRECTION == "UP") && (data_32bit_waddr == 14'h31EB))	//26us
		data_32bit_waddr <= 14'd0;
	else
		data_32bit_waddr <= data_32bit_waddr + 14'd1;
end

generate
if(DIRECTION == "DW") begin
//32b*1536
//	dp_delay_dw u_dp_delay_dw
//	(
//	    .clka					(clk),
//	    .wea             		(1'b1),
//	    .addra           		(data_32bit_waddr),
//	    .dina            		(i_data),
//	    
//	    .clkb            		(clk),
//	    .addrb           		(data_32bit_raddr),
//	    .doutb           		(data_32bit_rdata)
//	);
	if(MODE == "NR") begin
		matrix_ram
		#(
		 .DATA_WIDTH	(32)
		,.ADDR_NUM		(3072)
		,.ADNW			(12)
		)matrix_ram_dw
		(
		 .clk	(clk)
		,.we	(1'b1)
		,.dina	(i_data)
		,.addra	(data_32bit_waddr)
		,.doutb	(data_32bit_rdata)
		,.addrb	(data_32bit_raddr)
		);
	end
	else if(MODE == "LTE") begin
		matrix_ram
		#(
		 .DATA_WIDTH	(32)
		,.ADDR_NUM		(1536)
		,.ADNW			(11)
		)matrix_ram_dw
		(
		 .clk	(clk)
		,.we	(1'b1)
		,.dina	(i_data)
		,.addra	(data_32bit_waddr)
		,.doutb	(data_32bit_rdata)
		,.addrb	(data_32bit_raddr)
		);
	end
end
else if(DIRECTION == "UP") begin
	if(MODE == "NR") begin
		//32b*12780
		dp_delay_up u_dp_delay_up
		(
		    .clka					(clk),
		    .wea             		(1'b1),
		    .addra           		(data_32bit_waddr),
		    .dina            		(i_data),
		    
		    .clkb            		(clk),
		    .addrb           		(data_32bit_raddr),
		    .doutb           		(data_32bit_rdata)
		);
	end
	else if(MODE == "LTE") begin
		matrix_ram
		#(
		 .DATA_WIDTH	(32)
		,.ADDR_NUM		(3932)	//3932/245.76 = 16us
		,.ADNW			(12)
		)matrix_ram_up
		(
		 .clk	(clk)
		,.we	(1'b1)
		,.dina	(i_data)
		,.addra	(data_32bit_waddr)
		,.doutb	(data_32bit_rdata)
		,.addrb	(data_32bit_raddr)
		);
	end
//matrix_ram
//#(
// .DATA_WIDTH	(32)
//,.ADDR_NUM		(12780)
//,.ADNW			(14)
//)matrix_ram_up
//(
// .clk	(clk)
//,.we	(1'b1)
//,.dina	(i_data)
//,.addra	(data_32bit_waddr)
//,.doutb	(data_32bit_rdata)
//,.addrb	(data_32bit_raddr)
//);
end
endgenerate

generate
if(MODE == "NR") begin
fram_protect #(
	.FRAM_MAX	(26'd2457599)//.FRAM_MAX	(26'd4915199)
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
		data_32bit_raddr <= 14'd0;
	else if((DIRECTION == "DW") && (data_32bit_raddr == 14'h5FF))	//3.125us
		data_32bit_raddr <= 14'd0;
	else if((DIRECTION == "UP") && (data_32bit_raddr == 14'h31EB))	//26us
		data_32bit_raddr <= 14'd0;
	else
		data_32bit_raddr <= data_32bit_raddr + 14'd1;
end

always @ (posedge clk) begin
	fram_hd_adj_r1 <= fram_hd_adj;
	fram_hd_adj_r2 <= fram_hd_adj_r1;
end

always @ (posedge clk) begin
	if(fram_hd_adj_r2)
		xant_cnt <= 2'b0;
	else
		xant_cnt <= xant_cnt + 2'b1;
end

assign o_data = data_32bit_rdata;
assign o_fram_hd = fram_hd_adj_r2;
assign o_xant_hd = (xant_cnt == 2'b11);

endmodule