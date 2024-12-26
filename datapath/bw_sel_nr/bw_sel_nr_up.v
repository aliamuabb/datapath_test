module bw_sel_nr_up (
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
//make sure the "i_freq0_fram" and "i_freq1_fram"
//in the same clock domain and location.
//-----------------------------------------------//
	input			i_freq0_fram,
	input			i_freq0_xant,
	input	[31:0]	i_freq0_data,
	
	input			i_freq1_fram,
	input			i_freq1_xant,
	input	[31:0]	i_freq1_data,
//-----------------------------------------------//
//if the signal was inputted any value without "4",
//it was only outputted by the "path0".
//-----------------------------------------------//
	output	reg			o_path0_fram,
	output	reg			o_path0_xant,
	output		[31:0]	o_path0_data,
//-----------------------------------------------//
//if the value of signal, the "i_bw_sel", is 4,
//it was outputted both the "path0" and the "path1".
//-----------------------------------------------//
	output	reg			o_path1_fram,
	output	reg			o_path1_xant,
	output	reg	[31:0]	o_path1_data
);

reg		[127:0]	data_buf;
reg		[  5:0]	xant_cnt;

reg		[ 31:0]	w_path0_data;
reg		[ 31:0]	w_path1_data;
reg		[  3:0]	w_path_fram;
reg		[  3:0]	w_path0_xant;
reg		[  3:0]	w_path1_xant;

always @ (posedge clk) begin
	if(i_freq0_fram & i_freq0_xant)
		xant_cnt <= 6'd0;
	else
		xant_cnt <= xant_cnt + 6'd1;
end
always @ (posedge clk) begin
	if(i_bw_sel >= 3'd4)
		w_path0_data <= i_freq0_data;
	else
		w_path0_data <= xant_cnt[2]?32'b0:i_freq0_data;
end
always @ (posedge clk) begin
	if(i_bw_sel >= 3'd4)
		o_path1_data <= i_freq1_data;
	else
		o_path1_data <= xant_cnt[2]?i_freq0_data:32'b0;
end
always @ (posedge clk) begin
	data_buf <= {data_buf[95:0], w_path0_data};
end
always @ (posedge clk) begin
	w_path_fram <= {w_path_fram[2:0], i_freq0_fram};
end
assign o_path0_data = data_buf[127:96];
always @ (posedge clk) begin
	case(i_bw_sel)
		3'd0:	w_path0_xant <= {w_path0_xant[2:0], (xant_cnt[5:0] == 6'h3f)};	//x64
		3'd1:	w_path0_xant <= {w_path0_xant[2:0], (xant_cnt[4:0] == 5'h1f)};	//x32
		3'd2:	w_path0_xant <= {w_path0_xant[2:0], (xant_cnt[3:0] == 4'hf)};	//x16
		3'd3:	w_path0_xant <= {w_path0_xant[2:0], (xant_cnt[2:0] == 3'h7)};	//x8
		3'd4:	w_path0_xant <= {w_path0_xant[2:0], i_freq0_xant};
		default:w_path0_xant <= {w_path0_xant[2:0], i_freq0_xant};
	endcase
end
always @ (posedge clk) begin
	case(i_bw_sel)
		3'd0:	w_path1_xant <= {w_path1_xant[2:0], (xant_cnt[5:0] == 6'h3f)};	//x64
		3'd1:	w_path1_xant <= {w_path1_xant[2:0], (xant_cnt[4:0] == 5'h1f)};	//x32
		3'd2:	w_path1_xant <= {w_path1_xant[2:0], (xant_cnt[3:0] == 4'hf)};	//x16
		3'd3:	w_path1_xant <= {w_path1_xant[2:0], (xant_cnt[2:0] == 3'h7)};	//x8
		3'd4:	w_path1_xant <= {w_path1_xant[2:0], i_freq1_xant};
		default:w_path1_xant <= {w_path1_xant[2:0], i_freq1_xant};
	endcase
end
always @ (posedge clk) begin
	o_path0_xant <= w_path0_xant[3];
	o_path1_xant <= w_path1_xant[3];
	o_path0_fram <= w_path_fram[3];
	o_path1_fram <= w_path_fram[3];
end
endmodule