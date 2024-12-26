//wangshuyi@2020-10-29

module	data_joint_split_ram
#(
 parameter	INPUT_WIDTH = 72
,parameter	OUTPUT_WIDTH = 60
,parameter	RAM_LATENCY = 5
,parameter	FIBRE_DELAY_CLK_NUM = 0
,parameter	RD_START_ADDR = 0
,parameter	WR_START_ADDR = 0
,parameter	R_ADDR_WIDTH = 14
,parameter	W_ADDR_WIDTH = 14
)
(
 input							clk
,input	[INPUT_WIDTH-1:0]		i_data
,input							i_start
,output							i_wait
,output	[R_ADDR_WIDTH-1:0]		i_addr
,output	[OUTPUT_WIDTH-1:0]		o_data
,output	[W_ADDR_WIDTH-1:0]		o_addr
,output							o_en
);

reg		[R_ADDR_WIDTH-1:0]							i_addr = WR_START_ADDR;
reg		[W_ADDR_WIDTH-1:0]							o_addr = RD_START_ADDR;
wire												i_wait;
reg													output_en = 0;
wire												i_start_d4;
reg													i_wait_pre = 0;
wire												i_wait_d4;
wire												output_en_d4;
reg		[INPUT_WIDTH + OUTPUT_WIDTH - 1:0]			data_temp = 0;
reg		[clogb2(INPUT_WIDTH + OUTPUT_WIDTH)-1:0]	shift_num = 0;
wire	[clogb2(INPUT_WIDTH + OUTPUT_WIDTH)-1:0]	shift_num_d4;

always	@	(posedge clk)
begin
	if	(~i_wait)
	begin
		if	(i_start)
			i_addr <= RD_START_ADDR;
		else
		begin
			if	(i_addr == FIBRE_DELAY_CLK_NUM + RD_START_ADDR - 1)
				i_addr <= RD_START_ADDR;
			else
				i_addr <= i_addr + 1;
		end
	end
	else
		i_addr <= i_addr;
end

always	@	(posedge clk)
begin
	if	(i_start_d4)
		o_addr <= WR_START_ADDR;
	else
	begin
		if	(output_en_d4)
			o_addr <= o_addr + 1;
		else
			o_addr <= o_addr;
	end
end

assign	o_en = output_en_d4;
assign	o_data = data_temp[OUTPUT_WIDTH-1:0];

shift_regs	#(RAM_LATENCY+1,1)									shreg_start		(clk,1'b0,i_start,i_start_d4);
shift_regs	#(RAM_LATENCY+1,1)									shreg_o_en		(clk,1'b0,output_en,output_en_d4);
shift_regs	#(RAM_LATENCY+1,1)									shreg_wait		(clk,1'b0,i_wait_pre,i_wait_d4);
shift_regs	#(1,1)												shreg_wait_d1	(clk,1'b0,i_wait_pre,i_wait);
shift_regs	#(RAM_LATENCY+1,clogb2(INPUT_WIDTH + OUTPUT_WIDTH))	shreg_shift_num	(clk,1'b0,shift_num,shift_num_d4);

generate
	if	(INPUT_WIDTH > OUTPUT_WIDTH)
	begin	:	B2S

		always	@	(posedge clk)
		begin
			if	(i_start)
			begin
				shift_num <= INPUT_WIDTH - OUTPUT_WIDTH;
				i_wait_pre <= ((INPUT_WIDTH - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
				output_en <= 1;
			end		
			else
			begin
				if	(~i_wait_pre)
				begin
					shift_num <= shift_num + INPUT_WIDTH - OUTPUT_WIDTH;
					i_wait_pre <= ((shift_num + INPUT_WIDTH - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
					output_en <= 1;
				end
				else
				begin
					shift_num <= shift_num - OUTPUT_WIDTH;
					i_wait_pre <= ((shift_num - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
					output_en <= 1;
				end	
			end
		end

		always	@	(posedge clk)
		begin
			if	(i_start_d4)
				data_temp <= {{OUTPUT_WIDTH{1'b0}},i_data};
			else
			begin
				if	(~i_wait_d4)
					data_temp <= (data_temp >> OUTPUT_WIDTH) | (i_data << shift_num_d4);
				else
					data_temp <= (data_temp >> OUTPUT_WIDTH);
			end
		end
		
	end
	else	if	(INPUT_WIDTH < OUTPUT_WIDTH)
	begin	: S2B
		always	@	(posedge clk)
		begin
			if	(i_start)
			begin
				shift_num <= INPUT_WIDTH;
				i_wait_pre <= 0;
				output_en <= 0;
			end
			else
			begin		
				if	(~output_en)
				begin
					shift_num <= shift_num + INPUT_WIDTH;
					i_wait_pre <= 0;
					output_en <= (shift_num + INPUT_WIDTH > OUTPUT_WIDTH);
				end
				else
				begin
					shift_num <= shift_num + INPUT_WIDTH - OUTPUT_WIDTH;
					i_wait_pre <= 0;
					output_en <= ((shift_num + INPUT_WIDTH - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
				end
			end
		end		
		
		
		always	@	(posedge clk)
		begin
			if	(i_start_d4)
				data_temp <= {{OUTPUT_WIDTH{1'b0}},i_data};
			else
			begin		
				if	(~output_en_d4)
					data_temp <= data_temp | (i_data << shift_num_d4);
				else
					data_temp <= (data_temp >> OUTPUT_WIDTH) | (i_data << shift_num_d4 - OUTPUT_WIDTH);
			end
		end				
	end
	else
	begin
		
	end

endgenerate

`include	"clogb2.v"

//function integer clogb2;
//  input integer depth;
//    for (clogb2=0; depth>0; clogb2=clogb2+1)
//      depth = depth >> 1;
//endfunction

endmodule