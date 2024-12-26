module fram_protect #(
	parameter FRAM_MAX = 26'd4915199
)(
	input	clk,
	input	rst,

	input	i_fram_hd,
	output	o_fram_protect_hd
);

reg		[ 3:0]	frame_hd_shift;
reg				frame_raw_hd;

always @ (posedge rst or posedge clk)
	begin
		if(rst)
			frame_hd_shift <= 4'b0;
		else
			frame_hd_shift <= {frame_hd_shift[2:0],i_fram_hd};
	end

always @ (posedge rst or posedge clk)
	begin
		if(rst)
			frame_raw_hd <= 1'b0;
		else
    		if(frame_hd_shift[3:2] == 2'b01)
    			frame_raw_hd <= 1'b1;
    		else
    			frame_raw_hd <= 1'b0;
	end

framhd_protect_20201016 u_framhd_protect
(
	.asy_rst			(rst		),
	.clk				(clk		),			//clk
//--------------------input timing info--------------------
	.i_ext_hd			(frame_raw_hd		),		//frame head from epld or receiver module
	.i_fram_max			(FRAM_MAX	  		),		//frame cnt max
	.o_int_hd			(o_fram_protect_hd	)       //frame head gen
);

//assign o_fram_protect_hd = frame_raw_hd;

endmodule