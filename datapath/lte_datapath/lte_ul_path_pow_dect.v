//---------------------------------------------------------------------------------
//Module Name:					ul_tdl_pow_dect.v   
//Department:					Beijing R&D Center FPGA Design Dept
//Function Description:			tdl data power detect
//---------------------------------------------------------------------------------
//Version				Design				Coding				Simulate				Review				Rel data
//V1.0					chendanqing			chendanqing			chendanqing			2012-10-15				2012-10-15
//
//---------------------------------------------------------------------------------
//Version				Modified History
//V1.0					draft
//
//-------------------------------key words-----------------------------------------
//
//
//`include "public.v"

module lte_ul_path_pow_dect 
(
	//global input
	input   wire            asy_rst				,			
	input   wire            clk_245				,                              
	//from ul_tdl_trans
	input	wire			i_fram_hd			,		
	input	wire			i_ant8_sel			,
	input	wire			i_data_valid		,	
	input	wire	[31:0]	i_data				,
	//reg interface
	input	wire			clk_apb				,
	input	wire	[31:0]	i_ul_tdl_pd_trig	,
	input	wire	[31:0]	i_pow_dect_raddr	,
	output	wire	[31:0]	o_pow_dect_rdata	,
	input	wire			i_ram_reg_read_en
);


parameter	[11:0]  MAX_FRAM_NUM	=	12'd299	;	//0~2999
parameter	[19:0]	SF_DATA_NUM		=	20'd245759	;	//1ms 
parameter	[31:0]	MAX_DATA_NUM	=	( MAX_FRAM_NUM + 1'b1 ) * 30720;//total sampling points of one subframe in 3s

parameter			NUM_FRAM_245		= 	(SF_DATA_NUM+1)*10-1;	//5ms					
parameter			NUM_SFM4_245		= 	(SF_DATA_NUM+1)*9-1;		//4ms

reg		[11:0]			fram_cnt				;
reg		[19:0]			data_cnt				;
reg		[ 3:0]			sf_num					;
//PortB of ram_tdl_mac
reg		[ 6:0]			tdl_mac_ram_raddr		; 
reg		[ 6:0]			tdl_mac_ram_raddr_d1	;
reg		[ 6:0]			tdl_mac_ram_raddr_d2	;
reg		[ 6:0]			tdl_mac_ram_raddr_d3	;
reg		[ 6:0]			tdl_mac_ram_raddr_d4	;
reg		[ 6:0]			tdl_mac_ram_raddr_d5	;
wire	[63:0]			tdl_mac_ram_rdata		;   
//PortA of ram_tdl_mac 
reg		[ 6:0]			tdl_mac_ram_waddr		;
reg		[ 6:0]			tdl_mac_ram_waddr_d1	;
reg		[ 6:0]			tdl_mac_ram_waddr_d2	;
reg		[ 6:0]			tdl_mac_ram_waddr_d3	;
reg		[ 6:0]			tdl_mac_ram_waddr_d4	;
reg		[ 6:0]			tdl_mac_ram_waddr_d5	;
reg		[63:0]			tdl_mac_ram_wdata		; 
//mac 
wire	[31:0]			sqrt_i					;
wire	[31:0]			sqrt_q					;
reg		[63:0]			pre_mac_data			;
reg		[63:0]			mac_data				; 
//power average                                  
wire	[95:0]			pd_avg					;
//PortA of ram_tdl_pow_dect
reg		[ 6:0]			tdl_pow_dect_ram_waddr	;	
reg		[31:0]			tdl_pow_dect_ram_wdata	;
reg						tdl_pow_dect_ram_we		;
reg						ul_tdl_pd_trig_d1		;
reg						ul_tdl_pd_trig_d2		;
wire					ul_tdl_pd_trig_pos		;
reg						ul_tdl_pd_trig_pos_dly	;
reg						ul_tdl_pd_trig_flag		;

//PortB of ram_tdl_pow_dect
wire	[ 7:0]			tdl_pow_dect_ram_raddr	;
wire	[31:0]			tdl_pow_dect_ram_rdata	;

reg			[21:0]			clk_cnt			;
reg			[21:0]			sfm0_offset		;
reg							sfm0_fhd		;

always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		clk_cnt<= 21'h0;
	else if(i_fram_hd==1'b1)
		clk_cnt<= 21'h0;
	else if(clk_cnt==NUM_FRAM_245)
		clk_cnt<= 21'h0;
	else		
		clk_cnt<= clk_cnt + 21'h1;
end

always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		sfm0_offset<=21'b0;
	else
		sfm0_offset<=NUM_SFM4_245-21'b1;	
end
		
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		sfm0_fhd <= 1'b0;
	else if(clk_cnt==sfm0_offset)
		sfm0_fhd <= 1'b1;
	else
		sfm0_fhd <= 1'b0;	
end	

//counter of 5ms_fram
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		fram_cnt<=12'd0;
	else if(i_fram_hd==1'b1)
		begin
			if(fram_cnt==MAX_FRAM_NUM)
				fram_cnt<=12'd0;
			else	
				fram_cnt<=fram_cnt+1'b1;
		end
	else;	
end

//data counter
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		data_cnt<=20'b0;
	else if(i_fram_hd==1'b1)
		data_cnt<=20'b0;
	else if(data_cnt==SF_DATA_NUM)	
		data_cnt<=20'b0;
	else	
		data_cnt<=data_cnt+1'b1;	
end

//subframe counter
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		sf_num<=4'b0;
	else if(i_fram_hd==1'b1)
		sf_num<=4'b0;
	else if(data_cnt==SF_DATA_NUM)
        if (sf_num == 9)
            sf_num <= 0;
        else		
            sf_num<=sf_num+1'b1;	
	else;	
end

//*************************************this ram save the mac result*************************
//bit width:64bit	depth:80
ram_tdl_mac_64b_80 u_tdl_mac_ram(
	.clka			(clk_245						), 
	.clkb 			(clk_245						), 
	.dina 			(tdl_mac_ram_wdata				), 
	.addrb			(tdl_mac_ram_raddr				), 
	.addra			(tdl_mac_ram_waddr				), 
	.wea  			(1'b1							), 
	.doutb			(tdl_mac_ram_rdata				)  
);

//-----------------read addresss of ram_tdl_mac----------------------
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		tdl_mac_ram_raddr<=7'b0;
	else 		
		tdl_mac_ram_raddr<={sf_num[3:0],data_cnt[2:0]};	
end

//-----------------write addresss of ram_tdl_mac----------------------
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		begin
			tdl_mac_ram_raddr_d1<=7'b0;
			tdl_mac_ram_raddr_d2<=7'b0;
			tdl_mac_ram_raddr_d3<=7'b0;      
			tdl_mac_ram_raddr_d4<=7'b0;
			tdl_mac_ram_raddr_d5<=7'b0;
			tdl_mac_ram_waddr	<=7'b0;
		end
	else 
		begin		
			tdl_mac_ram_raddr_d1<=tdl_mac_ram_raddr;
			tdl_mac_ram_raddr_d2<=tdl_mac_ram_raddr_d1;
			tdl_mac_ram_raddr_d3<=tdl_mac_ram_raddr_d2;  
			tdl_mac_ram_raddr_d4<=tdl_mac_ram_raddr_d3;
			tdl_mac_ram_raddr_d5<=tdl_mac_ram_raddr_d4;
			tdl_mac_ram_waddr	<=tdl_mac_ram_raddr_d4;
		end
end


//-----------------write data of ram_tdl_mac----------------------
//sqaure i

opd_mult_16x16 tdl_i_square(
	.CLK			(clk_245					),
	.A  			(i_data[31:16]				),
	.B  			(i_data[31:16]				),
	.P  			(sqrt_i						)
);//delay 4 clk                                    

//sqare q
opd_mult_16x16 tdl_q_square(
	.CLK			(clk_245					),
	.A  			(i_data[15:0]				),
	.B  			(i_data[15:0]				),
	.P  			(sqrt_q						)
);//delay 4 clk  

//the previously mac result
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		pre_mac_data<=64'b0;
	else if((fram_cnt==12'd0)&&(data_cnt[19:0]<20'd11)&&(data_cnt[19:0]>=20'd3))
		pre_mac_data<=sqrt_i + sqrt_q;
	else 		
		pre_mac_data<=sqrt_i + sqrt_q + tdl_mac_ram_rdata;	
end

//mac result
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		mac_data<=64'b0;
	else
		mac_data<=pre_mac_data	; 
end

//write data
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		tdl_mac_ram_wdata<=	64'b0;
	else
		tdl_mac_ram_wdata<=	mac_data; 
end



//*************************************this ram save the power value*************************
//spi read power value from this ram 
ram_tdl_pow_dect_64b_80_32b u_tdl_pow_dect_ram(
	.clka          	(clk_245							),
	.clkb 			(clk_apb							),
	.dina 			(tdl_mac_ram_wdata					),
	.addrb			(tdl_pow_dect_ram_raddr				),
	.addra			(tdl_mac_ram_waddr					),
	.wea  			(tdl_pow_dect_ram_we				),
//	.enb			(1'b1					),
	.doutb			(tdl_pow_dect_ram_rdata				) 
);
//

//write enable	
//only when reg_ul_tdl_pd_trig has a posedge,data could be writen to the ram	

always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)begin
		ul_tdl_pd_trig_d1<=1'b0;
		ul_tdl_pd_trig_d2<=1'b0;	
	end
	else begin
		ul_tdl_pd_trig_d1<=i_ul_tdl_pd_trig[0];
		ul_tdl_pd_trig_d2<=ul_tdl_pd_trig_d1;	
	end
end	

assign ul_tdl_pd_trig_pos=ul_tdl_pd_trig_d1&&(~ul_tdl_pd_trig_d2);
		
always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		ul_tdl_pd_trig_pos_dly<=1'b0;
	else if(ul_tdl_pd_trig_pos==1'b1)
		ul_tdl_pd_trig_pos_dly<=1'b1;	
	else if(ul_tdl_pd_trig_flag==1'b1)
		ul_tdl_pd_trig_pos_dly<=1'b0;	
end 

always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		ul_tdl_pd_trig_flag<=1'b0;
	else if((ul_tdl_pd_trig_pos_dly==1'b1)&&(fram_cnt==(MAX_FRAM_NUM-1'b1)))
		ul_tdl_pd_trig_flag<=1'b1;
	else if((fram_cnt==12'b0)&&(sf_num==4'b1))
		ul_tdl_pd_trig_flag<=1'b0;			
end

always @(posedge clk_245 or posedge asy_rst)
begin
	if(asy_rst==1'b1)
		tdl_pow_dect_ram_we<=1'b0;
	else if((fram_cnt==MAX_FRAM_NUM)&&(data_cnt[19:0]==(SF_DATA_NUM-20'd2)))
		tdl_pow_dect_ram_we<=ul_tdl_pd_trig_flag;
	else if(data_cnt[19:0]==20'h5)
		tdl_pow_dect_ram_we<=1'b0;			
end		

assign	tdl_pow_dect_ram_raddr	=	i_pow_dect_raddr[7:0]	;
assign	o_pow_dect_rdata		=	tdl_pow_dect_ram_rdata		;

//ila_trig ila_trig (
//	.clk(clk_245), // input wire clk


//	.probe0(i_ul_tdl_pd_trig), // input wire [0:0]  probe0  
//	.probe1(tdl_pow_dect_ram_raddr), // input wire [7:0]  probe1 
//	.probe2(tdl_pow_dect_ram_rdata) // input wire [31:0]  probe2
//);		
      	
endmodule 