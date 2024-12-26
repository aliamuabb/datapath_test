module bw_sel_nr_dw (
	input	clk,		//NR dp clk 491.52M
	input	rst,
//-----------------------------//
//description: bandwidth select//
//parameter: i_bw_sel
//0: 7.68M
//1: 15.36M
//2: 30.72M
//3: 61.44M
//4: 122.88M
//default: 122.88M
//-----------------------------//
	input	[ 2:0]	i_bw_sel,
//-----------------------------------------------//
//make sure the "i_path0_fram" and "i_path1_fram"
//in the same clock domain and location.
//-----------------------------------------------//
	input			i_path0_fram,
	input			i_path0_xant,
	input	[31:0]	i_path0_data,
	
	input			i_path1_fram,
	input			i_path1_xant,
	input	[31:0]	i_path1_data,
//-----------------------------------------------//
//if the signal was inputted any value without "4",
//it was only outputted by the "path0".
//-----------------------------------------------//
	output	reg			o_freq0_fram,
	output	reg			o_freq0_xant,
	output	reg	[31:0]	o_freq0_data,
//-----------------------------------------------//
//if the value of signal, the "i_bw_sel", is 4,
//it was outputted both the "path0" and the "path1".
//-----------------------------------------------//
	output	reg			o_freq1_fram,
	output	reg			o_freq1_xant,
	output	reg	[31:0]	o_freq1_data
);

reg		[127:0]	data_buf;
reg		[  5:0]	xant_cnt;

always @ (posedge clk) begin
	data_buf <= {data_buf[95:0], i_path1_data};
end

always @ (posedge clk) begin
	if(i_path0_fram & i_path1_fram)
		xant_cnt <= 6'd0;
	else
		xant_cnt <= xant_cnt + 6'd1;
end

always @ (posedge clk) begin
	case(i_bw_sel)
		3'd0:	o_freq0_xant <= (xant_cnt[5:0] == 6'h3f);	//x64
		3'd1:	o_freq0_xant <= (xant_cnt[4:0] == 5'h1f);	//x32
		3'd2:	o_freq0_xant <= (xant_cnt[3:0] == 4'hf);	//x16
		3'd3:	o_freq0_xant <= (xant_cnt[2:0] == 3'h7);	//x8
		3'd4:	o_freq0_xant <= i_path0_xant;
		default:o_freq0_xant <= i_path0_xant;
	endcase
end

always @ (posedge clk) begin
	if(i_bw_sel >= 3'd4)
		o_freq0_data <= i_path0_data;
	else
		o_freq0_data <= xant_cnt[2]?data_buf[127:96]:i_path0_data;
end

always @ (posedge clk) begin
	o_freq0_fram <= i_path0_fram;
end

always @ (posedge clk) begin
	if(i_bw_sel >= 3'd4) begin
		o_freq1_fram <= i_path1_fram;
		o_freq1_xant <= i_path1_xant;
		o_freq1_data <= i_path1_data;
	end
	else begin
		o_freq1_fram <= 1'b0;
		o_freq1_xant <= 1'b0;
		o_freq1_data <= 32'b0;
	end
end

endmodule
