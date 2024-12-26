
module lte_ul_path_trans
(
	input	wire				clk_491p52,
	input	wire				rst_491p52,
	input	wire				clk,	
	input	wire				asy_rst,
	
	input	wire	[31:0]		i_ant_posinfo,  
	 
	input	wire				i_fram_hd,            
	input	wire				i_ant8_sel,       
	input	wire	[15:0]		i_data,       
	input	wire				i_data_valid,
	
	output	wire				o_fram_hd,
	output	wire				o_ant8_sel,
	output	wire    [31:0]		o_data,
	output	wire				o_data_valid      	
);                                                 

reg		[ 4:0]		cycle_cnt;
reg		[ 5:0]		buf_waddr;	
reg		[31:0]		ant_posinfo;
reg		[ 5:0]		frame_cnt;

reg		[ 3:0]		frame_dly;
reg					frame_edg;
reg		[ 4:0]		buf_raddr;

reg		[ 3:0]		fram_hd_d;
reg					ant8_sel;
wire				frame_hd;

always @ (posedge rst_491p52 or posedge clk_491p52)
	begin
		if (rst_491p52)
			buf_waddr <= 6'd0;
		else if (i_fram_hd)
			buf_waddr <= 6'd0;
		else
			buf_waddr <= buf_waddr + 6'b1;		
	end
	
always @ (posedge rst_491p52 or posedge clk_491p52)
	begin
		if (rst_491p52)
			frame_cnt <= 6'd0;
		else if (i_fram_hd)
			frame_cnt <= 6'd1;
		else if(|frame_cnt)
			frame_cnt <= frame_cnt + 6'b1;	
		else;	
	end

freq2path_ram u_freq2path_ram
(
    .clka            		(clk_491p52),
    .wea             		(1'b1),
    .addra           		({buf_waddr[5:4],buf_waddr[2:0],buf_waddr[3]}),
    .dina            		(i_data),
    .clkb            		(clk),
    .addrb           		(buf_raddr),
    .doutb           		({o_data[15:0],o_data[31:16]})
);

always @ (posedge clk)
	begin
		frame_dly <= {frame_dly[2:0],frame_cnt[5]};
		frame_edg <= frame_dly[2] & (~frame_dly[3]);
	end
	
/*	
framhd_protect_clk u_framhd_protect
(
	.asy_rst         (asy_rst					),
	.clk             (clk						),
	.i_ext_hd        (frame_edg					),
	.i_fram_max      (24'd2457599               ),
	.o_int_hd        (frame_hd					) 
);
*/
	
assign frame_hd = frame_edg;

always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			cycle_cnt <= 5'd0;
		else if (frame_hd)
			cycle_cnt <= 5'd0;
		else
			cycle_cnt <= cycle_cnt + 5'b1;		
	end
	
always @ (posedge clk)
	begin
		ant_posinfo <= i_ant_posinfo;	
	end
	
always @ (*)
	begin
		case(cycle_cnt[2:0])
			3'b000 : buf_raddr <= {cycle_cnt[4:3],ant_posinfo[ 2: 0]};
			3'b001 : buf_raddr <= {cycle_cnt[4:3],ant_posinfo[ 6: 4]};
			3'b010 : buf_raddr <= {cycle_cnt[4:3],ant_posinfo[10: 8]};
			3'b011 : buf_raddr <= {cycle_cnt[4:3],ant_posinfo[14:12]};
			3'b100 : buf_raddr <= {cycle_cnt[4:3],ant_posinfo[18:16]};
			3'b101 : buf_raddr <= {cycle_cnt[4:3],ant_posinfo[22:20]};
			3'b110 : buf_raddr <= {cycle_cnt[4:3],ant_posinfo[26:24]};
			3'b111 : buf_raddr <= {cycle_cnt[4:3],ant_posinfo[30:28]};
			default: buf_raddr <= 5'b00000;
		endcase	
	end

always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			ant8_sel <= 1'd0;
		else
			ant8_sel <= (cycle_cnt[2:0] == 3'd0);//ant8_sel_d[1];		
	end

assign o_ant8_sel = ant8_sel;

always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			fram_hd_d <= 4'b0;	
		else
			fram_hd_d <={fram_hd_d[2:0],frame_hd};
	end


/*
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)begin
			o_data		<= 32'b0;	
        end
		else begin
			o_data      <=    {o_data[15:0],i_data[15:0]};
        end
	end
*/	
		
assign o_fram_hd =  fram_hd_d[1];
assign o_data_valid = 1'b1;

//vavido_ila_trans vavido_ila_trans
//(
//    .clk                (clk_491p52),
//    .probe0				(o_fram_hd),
//    .probe1				(o_ant8_sel),
//    .probe2				(o_data),
//    .probe3				(i_fram_hd),
//    .probe4				(i_ant8_sel),
//    .probe5				(i_data),
//    .probe6				(buf_raddr),
//    .probe7				(buf_waddr),
//    .probe8				(frame_hd)
//);
		
endmodule
