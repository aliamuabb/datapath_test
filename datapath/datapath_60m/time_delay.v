module time_delay32
(
	input 	wire         		clk,//491.52
	input 	wire 		   		asy_rst,
	      	
	//25us	
	input 	wire		   		i_fram_hd_25us,
	input 	wire 		   		i_x8hd_25us,
	input 	wire  	[33:0] 		i_data_25us,
	      	
	input 	wire 		   		i_wfram_hd_25us,
	input 	wire 	[31:0]	   	i_time_delay_set,
	
	output 	wire        		o_fram_hd_25us,
	output 	wire 	   			o_x8hd_25us,
	output 	reg  	[33:0] 		o_data_25us
);

//72bit = (MSB)4'b0,1'b0,reg_data_016(25us),1'b0,reg_data_116(25us),1'b0,reg_data_216(25us),x8hd_25us,reg_data_316(25us)(LSB)
reg		[23:0]		time_delay_set;
reg     [23:0]  	time_dalay_cnt;
reg             	time_dalay_hd;

reg 	[33:0] 		reg_data_016_25us;
reg 	[33:0] 		reg_data_116_25us;
reg 	[33:0] 		reg_data_216_25us;
reg 	[33:0] 		reg_data_316_25us;
wire 	[71:0]		wire_uram_din;

reg 				reg_25us_x8hd_r1;
reg 				reg_25us_x8hd_r2;
reg 				reg_25us_x8hd_r3;
reg 				reg_25us_x8hd_r4;
reg 				reg_25us_x8hd_r5;

reg 				reg_25us_framhd_r1;
reg 				reg_25us_framhd_r2;
reg 				reg_25us_framhd_r3;
reg 				reg_25us_framhd_r4;
reg 				reg_25us_framhd_r5;
    
reg 	[13:0] 		reg_uram_waddr;
reg 	[13:0] 		reg_uram_waddr_d1;
reg 				reg_uram_wen;

reg 				reg_rd_valid;
reg 	[13:0] 		reg_uram_raddr;

reg 	[71:0] 		reg_rdata_buf;
reg 	[71:0] 		wire_uram_dout;

reg  	[13:0]		reg_uram_raddr_d1;
reg 	[13:0]		reg_uram_raddr_d2;
reg 	[71:0]		wire_uram_dout_d1;
reg 	[71:0]		wire_uram_dout_d2;

reg 				reg_uram_raddr0_d1;
reg 				reg_uram_raddr0_d2;
reg 				reg_uram_raddr0_d3;
reg 				reg_uram_raddr0_d4;

reg		[1:0]		wr_mask;
wire	[71:0]		u0_q;
wire	[71:0]		u1_q;
/*
//72b*4k
uram_72x4k u0_uram_72x4k
(
    .clk		(clk), 
    .din		(wire_uram_din),  
    .dout		(u0_q), 
    .waddr		(reg_uram_waddr_d1[12:1]),
    .raddr		(reg_uram_raddr[12:1]),
    .w_biten	(9'h1ff),
    .r_biten	(9'h1ff),
    .wren		(wr_mask[0]&reg_uram_wen),
    .rden		(1'b1),    
    .rst		(asy_rst)
); 

uram_72x4k u1_uram_72x4k
(
    .clk		(clk), 
    .din		(wire_uram_din),  
    .dout		(u1_q), 
    .waddr		(reg_uram_waddr_d1[12:1]),
    .raddr		(reg_uram_raddr[12:1]),
    .w_biten	(9'h1ff),
    .r_biten	(9'h1ff),
    .wren		(wr_mask[1]&reg_uram_wen),
    .rden		(1'b1),    
    .rst		(asy_rst)
);
*/

 bram_72w6144d	u0_bram_72w6144d
(
	.clka		(clk),
    .ena		(1'b1),
    .wea		(reg_uram_wen),
    .addra		(reg_uram_waddr_d1[13:1]),
    .dina		(wire_uram_din),
    .douta		(),
    .clkb		(clk),
    .enb		(1'b1),
    .web		(1'b0),
    .addrb		(reg_uram_raddr[13:1]),
    .dinb		('h0),
    .doutb		(u0_q)
);

//25us data save
always @(posedge clk)
	begin
		reg_data_016_25us <= i_data_25us;
		reg_data_116_25us <= reg_data_016_25us;
		reg_data_216_25us <= reg_data_116_25us;
		reg_data_316_25us <= reg_data_216_25us;
	end
	
//25us_x8hd delay
always @(posedge clk)
	begin
				reg_25us_x8hd_r1 <= i_x8hd_25us;
				reg_25us_x8hd_r2 <= reg_25us_x8hd_r1;
				reg_25us_x8hd_r3 <= reg_25us_x8hd_r2;
				reg_25us_x8hd_r4 <= reg_25us_x8hd_r3;
				reg_25us_x8hd_r5 <= reg_25us_x8hd_r4;
	end

//25us_framhd delay
always @(posedge clk)
	begin
				reg_25us_framhd_r1 <= i_fram_hd_25us;
				reg_25us_framhd_r2 <= reg_25us_framhd_r1;
				reg_25us_framhd_r3 <= reg_25us_framhd_r2;
				reg_25us_framhd_r4 <= reg_25us_framhd_r3;
				reg_25us_framhd_r5 <= reg_25us_framhd_r4;
	end
	
//uram_wdata
assign wire_uram_din = {reg_25us_framhd_r2,reg_25us_x8hd_r2,reg_data_016_25us,
						reg_25us_framhd_r3,reg_25us_x8hd_r3,reg_data_116_25us};

//time delay
always @ (posedge clk)
    begin
        if(i_fram_hd_25us)
            time_dalay_cnt <= 0;
        else
            time_dalay_cnt <= time_dalay_cnt + 24'd1;          
    end
    
always @ (posedge clk)
begin
	if(i_fram_hd_25us)
		time_delay_set <= i_time_delay_set[23:0];
	else
		time_delay_set <= time_delay_set;
end
    
always @ (posedge clk)
        begin
            if(time_dalay_cnt == time_delay_set + 24'd9)
                time_dalay_hd <= 1'b1;
            else
                time_dalay_hd <= 1'b0;          
        end
        
//uram_waddr
always @(posedge clk)
	begin
		if(i_wfram_hd_25us)
			reg_uram_waddr <= 14'b0;
		else if(reg_uram_waddr == 14'd12287)
			reg_uram_waddr <= 14'b0;
		else
			reg_uram_waddr <= reg_uram_waddr + 14'b1;
	end
	
always @(posedge clk)
	begin
		reg_uram_waddr_d1 <= reg_uram_waddr;
	end
	

//uram_wen
always @(posedge clk)
	begin
		reg_uram_wen <= reg_uram_waddr[0];
	end
	
//rd_valid
always @(posedge clk)
	begin
		if	(time_dalay_hd)
			reg_rd_valid <= 1;
		else
			reg_rd_valid <= reg_rd_valid;
	end

//uram_raddr
always @(posedge clk)
	begin
		if(time_dalay_hd)
			reg_uram_raddr <= 14'b0;
		else if(reg_uram_raddr == 14'd12287)
			reg_uram_raddr <= 14'b0;
		else
			reg_uram_raddr <= reg_uram_raddr + 14'b1;
	end

always @ (posedge clk)
begin
	reg_uram_raddr_d1 <= reg_uram_raddr;
	reg_uram_raddr_d2 <= reg_uram_raddr_d1;
end
	
always@(posedge clk or posedge asy_rst)
	begin
	    if(asy_rst)
	        wire_uram_dout<= 72'h0;
	    else
	        wire_uram_dout<= u0_q;
	end


//databuf 72 => 4+4*17
always @(posedge clk )
	begin
		reg_uram_raddr0_d1 <= reg_uram_raddr[0];
		reg_uram_raddr0_d2 <= reg_uram_raddr0_d1;
		reg_uram_raddr0_d3 <= reg_uram_raddr0_d2;
		reg_uram_raddr0_d4 <= reg_uram_raddr0_d3;
		wire_uram_dout_d1 <= wire_uram_dout;
	end
	
always @(posedge clk)
begin
	if(reg_uram_raddr0_d4)
		reg_rdata_buf <= wire_uram_dout_d1;
	else
		reg_rdata_buf <= reg_rdata_buf >> 36;
end

//serial output
always @(posedge clk)
	begin
		if(reg_rd_valid)
			o_data_25us <= reg_rdata_buf[33:0];
		else
			o_data_25us <= 34'b0;
	end

//output x8hd
assign o_x8hd_25us = reg_rdata_buf[34];

//output framhd
assign o_fram_hd_25us = reg_rdata_buf[35];
	
endmodule
