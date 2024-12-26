//wangshuyi@2020-10-29

module	data_joint_split
#(
 parameter	INPUT_WIDTH = 72
,parameter	OUTPUT_WIDTH = 60
,parameter	WR_START_ADDR = 0
,parameter	FIBRE_DELAY_CLK_NUM = 0
,parameter	W_ADDR_WIDTH = 14
)
(
 input						clk
,input	[INPUT_WIDTH-1:0]	i_data
,input						i_start
,input						i_en
,output	reg					i_wait = 0
,output	[OUTPUT_WIDTH-1:0]	o_data
,output	[W_ADDR_WIDTH-1:0]	o_addr
,output	reg					o_en = 0
);

reg	[W_ADDR_WIDTH-1:0]								o_addr = WR_START_ADDR;
reg	[INPUT_WIDTH + OUTPUT_WIDTH - 1:0]				data_temp = 0;
reg	[clogb2(INPUT_WIDTH + OUTPUT_WIDTH)-1:0]		shift_num = 0;

always	@	(posedge clk)
begin
	if	(i_start)
		o_addr <= WR_START_ADDR;
	else
	begin
		if	(o_en)
		begin
			if	(o_addr == FIBRE_DELAY_CLK_NUM + WR_START_ADDR - 1)
				o_addr <= WR_START_ADDR;
			else
				o_addr <= o_addr + 1;
		end
		else
			o_addr <= o_addr;
	end
end

generate
	if	(INPUT_WIDTH > OUTPUT_WIDTH)
	begin	:	B2S

		always	@	(posedge clk)
		begin
			if	(i_start)
			begin
				shift_num <= INPUT_WIDTH - OUTPUT_WIDTH;
				data_temp <= {{OUTPUT_WIDTH{1'b0}},i_data};
				i_wait <= ((INPUT_WIDTH - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
				o_en <= 1;
			end		
			else
			begin
				casex	({i_wait,i_en})
				2'b01	:
						begin
							shift_num <= shift_num + INPUT_WIDTH - OUTPUT_WIDTH;
							data_temp <= (data_temp >> OUTPUT_WIDTH) | (i_data << shift_num);
							i_wait <= ((shift_num + INPUT_WIDTH - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
							o_en <= 1;
						end
				2'b1x	:
						begin
							shift_num <= shift_num - OUTPUT_WIDTH;
							data_temp <= (data_temp >> OUTPUT_WIDTH);
							i_wait <= ((shift_num - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
							o_en <= 1;
						end
	//			2'b00	:
	//					begin
	//						if	()
	//						shift_num <= shift_num - OUTPUT_WIDTH;
	//						data_temp <= (data_temp >> OUTPUT_WIDTH);
	//						i_wait <= ((shift_num - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
	//						o_en <= 1;
	//					end					
				default	:
						begin
							shift_num <= shift_num;
							data_temp <= 0;
							i_wait <= 0;
							o_en <= 0;
						end
				endcase
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
				data_temp <= {{OUTPUT_WIDTH{1'b0}},i_data};
				i_wait <= 0;
				o_en <= 0;
			end
			else
			begin		
				casex	({o_en,i_en})
				2'b01	:
						begin
							shift_num <= shift_num + INPUT_WIDTH;
							data_temp <= data_temp | (i_data << shift_num);
							i_wait <= 0;
							o_en <= (shift_num + INPUT_WIDTH > OUTPUT_WIDTH);
						end
				2'b11	:
						begin
							shift_num <= shift_num + INPUT_WIDTH - OUTPUT_WIDTH;
							data_temp <= (data_temp >> OUTPUT_WIDTH) | (i_data << shift_num - OUTPUT_WIDTH);
							i_wait <= 0;
							o_en <= ((shift_num + INPUT_WIDTH - OUTPUT_WIDTH) >= OUTPUT_WIDTH);
						end
				default	:
						begin
							shift_num <= shift_num;
							data_temp <= data_temp;
							i_wait <= 0;
							o_en <= 0;
						end
				endcase
			end
		end		
	end
	else
	begin
		
	end

endgenerate

assign	o_data = data_temp[OUTPUT_WIDTH-1:0];

`include	"clogb2.v"

//function integer clogb2;
//  input integer depth;
//    for (clogb2=0; depth>0; clogb2=clogb2+1)
//      depth = depth >> 1;
//endfunction

endmodule