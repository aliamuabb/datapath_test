//////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------
//Module Name:              ul_tdl_test.v
//Department:               Beijing R&D Center FPGA Design Dept
//Function Description:     ul_tdl_test
//--------------------------------------------------------------
//Version       Design       Coding         Simulate          Review          Reldata 		Date
//V1.0          chendanqing  chendanqing													2012-05-01
//-----------------------------------------------------------------
//Version               Modified History           
//V1.0                  draft
//--------------------------------Key words--------------------------
//////////////////////////////////////////////////////////////////////////////////

//`include "public.v"

module lte_ul_tdl_test 
(
	input						asy_rst			,
	input						clk_245			,
	input						i_fram_hd		,//the fram_hd is 8clk
	input						i_ant8_sel		,     
	input 	[31:0]				i_data			,
	input						i_data_valid	,
	input           			i_ac_flag		,
	
	input	wire				i_frame_hd		,
	input	wire 	[31:0]		i_data0_iq		,
	input   wire    [31:0]		i_cell_iqselcfg0,
	
	output	reg					o_fram_hd		,    
	output	reg					o_ant8_sel		,
	output	reg 	[31:0]		o_data			,
	output  reg					o_data_valid	,
	//reg_if
	input	wire	[ 3:0]		i_ul_tdl_path_src_sel	,
	input	wire	[31:0]		i_ul_tdl_path_data_i	,
	input	wire	[31:0]		i_ul_tdl_path_data_q	,
	input	wire	[31:0]		i_ul_tdl_path_data_start,
	input	wire	[31:0]		i_ul_tdl_path_data_end	,
	input	wire	[31:0]		i_ul_tdl_path_cfg 		,
	input   wire    [ 0:0]      i_ul_tdl_test_val           
);

reg			fram_hd;
reg 	    fram_hd_d1;
reg [31:0]	data_d1;
reg [31:0]	data_temp;
reg		  	ant8_sel_d1,ant8_sel_d2;

reg	[7:0] 	cycle_cnt;
reg [4:0] 	chip_cnt;
reg	[7:0] 	sgn_cnt;
reg	[15:0] 	chip_num;

reg [2:0]	antx8_cnt;
reg [11:0]	frame_hd;
reg [32*8-1:0]	i_data0_iq_regi;
reg [32*8-1:0]	i_data0_iq_regi_1;
reg [3:0]	iq_sel;
reg [31:0]	i_cell_iqselcfg_pro;
reg 		antx8_cnt_start;
reg	[31:0]	cell_data0_iq;

//fram_hd
always @(posedge asy_rst or  posedge clk_245)
begin
	if(asy_rst==1'b1)
		fram_hd<=1'b0;
	else 
		fram_hd<=i_fram_hd&&i_ant8_sel;
end		

//data_d1
always @(posedge asy_rst or  posedge clk_245)
begin
	if(asy_rst==1'b1)
		data_d1<=32'b0;
	else 
		data_d1<=i_data;
end		

//cycle cnt   
always @(posedge asy_rst or  posedge clk_245)
begin
	if(asy_rst==1'b1)
		cycle_cnt<=8'd0;
	else if(fram_hd)	
		cycle_cnt<=8'd0;
	else if(cycle_cnt==8'd191)
		cycle_cnt<=8'd0;
	else
		cycle_cnt<=cycle_cnt+1'b1;
end
//chip cnt		
always @(posedge asy_rst or  posedge clk_245)
begin	
	if(asy_rst==1'b1)
		chip_cnt<=5'b0;
	else if(fram_hd)	
		chip_cnt<=5'b0;
	else if(cycle_cnt==8'd191)
		chip_cnt<=chip_cnt+5'b1;			
end

//chip num	
always @(posedge asy_rst or  posedge clk_245)
begin	
	if(asy_rst==1'b1)
		chip_num<=16'b0;
	else 
		chip_num<={3'b0,sgn_cnt[7:0],chip_cnt[4:0]};			
end

//sgn cnt		
always @(posedge asy_rst or  posedge clk_245)
begin	
	if(asy_rst==1'b1)
		sgn_cnt<=8'b0;
	else if(fram_hd)	
		sgn_cnt<=8'b0;
	else if((chip_cnt==5'd31)&&(cycle_cnt==8'd191))begin
		if(sgn_cnt==8'd199)
			sgn_cnt<=8'b0;
		else
			sgn_cnt<=sgn_cnt+8'b1;	
	end			
end	

//ÉÏÐÐ´ò×®
always @ (posedge clk_245)
begin
	frame_hd[11:0] <= {frame_hd[10:0],i_frame_hd};
end

always @ (posedge clk_245)
begin
	if(i_frame_hd | (antx8_cnt == 3'h7))	
		antx8_cnt <= 3'b0;
	else
		antx8_cnt <= antx8_cnt + 3'b1;
end	


always @ (posedge clk_245)
begin
	i_data0_iq_regi[8*32-1:0] <= {i_data0_iq,i_data0_iq_regi[8*32-1:32]};
end

always  @   (posedge clk_245)
begin
    antx8_cnt_start <= (antx8_cnt == 3'h7);
end

always @ (posedge clk_245)
begin
	if	(antx8_cnt_start)
		i_data0_iq_regi_1 <= i_data0_iq_regi;
	else
		i_data0_iq_regi_1 <= i_data0_iq_regi_1;
end

always @ (posedge clk_245)
begin
	i_cell_iqselcfg_pro <= i_cell_iqselcfg0;
end

always @ (posedge clk_245)
begin
	iq_sel <= i_cell_iqselcfg_pro[4*antx8_cnt+:4];
end

always @ (posedge clk_245)
begin
	cell_data0_iq <= i_data0_iq_regi_1[iq_sel*32+:32];
end

				
//data source select						
always @(posedge asy_rst or  posedge clk_245)
begin
	if(asy_rst==1'b1)
		data_temp<=32'b0;
	else begin
		case({i_ul_tdl_path_src_sel[2:0],i_ul_tdl_test_val[0]})
		4'b000x:data_temp<=data_d1;  //work mode
		4'b0011:data_temp<=cell_data0_iq[31:0]; 
		4'b0101:data_temp<={i_ul_tdl_path_data_i[15:0],i_ul_tdl_path_data_q[15:0]}; //constant data 
		4'b0111:data_temp<={i_ul_tdl_path_data_i[15:0],i_ul_tdl_path_data_q[15:0]};
		4'b1001:data_temp<={2'b0,sgn_cnt[7:0],3'b0,chip_cnt[4:3],1'b0,chip_cnt[2:0],4'b0,cycle_cnt[7:0],1'b0};//increase data
		default:data_temp<=data_d1; 
		endcase  				
	end	
end

//output data	
always @(posedge asy_rst or posedge clk_245)
begin
	if(asy_rst==1'b1)
		o_data<=32'b0;
	else if (i_ul_tdl_path_src_sel[2] == 1'b0)
		if ((chip_num>=i_ul_tdl_path_data_start[15:0])&&(chip_num<=i_ul_tdl_path_data_end[15:0]))
			o_data<=data_temp;
		else
			o_data<=32'b0;
	else if (i_ul_tdl_path_src_sel[2] == 1'b1)
		if ((chip_num>=i_ul_tdl_path_data_start[15:0])&&(chip_num<=i_ul_tdl_path_data_end[15:0])&&(i_ac_flag == 1'b1))
			o_data<=data_temp;
		else
			o_data<=32'b0;
	else
		o_data<=32'b0;
end

//output frame header
always @(posedge asy_rst or  posedge clk_245)
begin
	if(asy_rst==1'b1)begin
		fram_hd_d1<=1'b0;
		o_fram_hd<=1'b0;
	end
	else begin
		fram_hd_d1<=fram_hd;
		if(i_ul_tdl_path_src_sel[2:0] == 3'b001)
			o_fram_hd<=frame_hd[10];
		else
			o_fram_hd<=fram_hd_d1;
	end
end
//output ant8_sel
always @(posedge asy_rst or  posedge clk_245)
begin
	if(asy_rst==1)begin
		ant8_sel_d1<=1'b0;
		ant8_sel_d2<=1'b0;
		o_ant8_sel<=1'b0;
	end	
	else begin
		ant8_sel_d1<=i_ant8_sel;
		ant8_sel_d2<=ant8_sel_d1;
		if(i_ul_tdl_path_src_sel[2:0] == 3'b001)
			o_ant8_sel<=(antx8_cnt == 3'h2);
		else
			o_ant8_sel<=ant8_sel_d2;		
	end	
end

//output ant8_sel
//always @(posedge asy_rst or  posedge clk_245)
//begin
//	if(asy_rst==1)
//		o_ant8_sel<=1'b0;
//	else if(cycle_cnt[2:0]==3'b0)
//		o_ant8_sel<=1'b1;
//	else
//		o_ant8_sel<=1'b0;
//end

//always @(posedge asy_rst or  posedge clk_245)
//begin
//	if(asy_rst==1)begin
//		data_valid_d1<=1'b0;
//		data_valid_d2<=1'b0;
//		o_data_valid<=1'b0;
//	end	
//	else begin
//		data_valid_d1<=i_data_valid;	
//		data_valid_d2<=data_valid_d1;
//		o_data_valid<=data_valid_d2;	
//	end				
//end
reg		data_valid_d1;
//output data_valid
always @(posedge asy_rst or  posedge clk_245)
begin
	if(asy_rst==1)
		data_valid_d1<=1'b0;
	else if(i_ul_tdl_path_cfg[9:8]==2'b11)	//20M
		data_valid_d1<=1'b1;
	else if(i_ul_tdl_path_cfg[9:8]==2'b00)begin	//5M
		if(cycle_cnt[4:3]==2'b0)
			data_valid_d1<=1'b1;
		else
			data_valid_d1<=1'b0;					
	end		
	else	//10M&15M
		data_valid_d1<=~cycle_cnt[3];
end	

always @(posedge asy_rst or  posedge clk_245)
begin
	if(asy_rst==1)
		o_data_valid<=1'b0;
	else	
		o_data_valid<=data_valid_d1;				
end		

	
endmodule