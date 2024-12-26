

module srcx1_inf_60m
(
	input   wire           		asy_rst,   
    input   wire            	clk,
    
    input   wire    [ 2:0]		i_test_vld,
                      
    input   wire            	i_frame_hd,
    input   wire    [31:0]		i_data0_iq,
    input   wire    [31:0]		i_data1_iq,
    
    input   wire            	i_framn_hd,
    input   wire    [31:0]		i_datan_iq,
    input	wire				i_ant8_sel,
    
    input   wire    [31:0]		i_cell_iqselcfg,
    input   wire    [31:0]		i_cell_iq,
    input   wire    [31:0]		i_data_start,
    input   wire    [31:0]		i_data_end,
    input   wire    			i_test_sel,
    
    output  wire    [31:0]		o_data_iq,
    output  wire 				o_fram_hd,
    output	wire				o_ant8_sel
);

reg		[ 2:0]		antx16_cnt = 0;
reg		[ 2:0]		antx16_cntn = 0;
reg		[ 2:0]		antx16_cnt_d1 = 0;
reg		[19:0]		frame_hd_dly;
reg		[ 3:0]		framn_hd_dly;
reg		[ 3:0]		ant8_sel_dly;

reg		[31:0]		data0_iq_dlym0;
reg		[31:0]		data0_iq_dly0;
reg		[31:0]		data0_iq_dly1;
reg		[31:0]		data0_iq_dly2;
reg		[31:0]		data0_iq_dly3;

reg		[31:0]		data1_iq_dlym0;
reg		[31:0]		data1_iq_dly0;
reg		[31:0]		data1_iq_dly1;
reg		[31:0]		data1_iq_dly2;
reg		[31:0]		data1_iq_dly3;

reg		[31:0]		cell_iqselcfg;
reg		[31:0]		cell_iq;

reg		[31:0]		cell_data0_iq;
reg		[31:0]		cell_data_iq;
reg		[31:0]		data_out;

reg		[ 3:0]		cell_iqselnum;
reg		[ 2:0]		test_vld;
reg					fram_hd;
reg                 ant8_sel;

reg		[31:0]		data_iq_s0;
reg		[31:0]		data_iq_s1;
reg		[31:0]		data_iq_s2;
reg		[31:0]		data_iq_s3;
reg		[31:0]		data_iq_s4;
reg		[31:0]		data_iq_s5;
reg		[31:0]		data_iq_s6;
reg		[31:0]		data_iq_s7;

reg		[31:0]		datan_iq_d1;
wire	[31:0]		if2dds_data;
reg		[31:0]		if2dds_data_temp;
reg		[31:0]		if2dds_data_temp_d1;
reg		[31:0]		dds_phase_temp_dly0;
reg		[31:0]		dds_phase_temp_dly1;
reg		[31:0]		dds_phase_temp;
reg		[31:0]		dds_phase_temp_d1;
reg 	[15:0]		dds_phase_cnt = 16'b10;
reg 	[ 7:0]		dds_phase = 8'b0;

reg		[23:0]		cycle_cnt = 0;
reg		[ 4:0]		chip_cnt = 0;
reg		[ 8:0]		sgn_cnt = 0;
reg		[15:0]		chip_num = 0;

reg					dds_phase_cnt_clr;

always @ (posedge clk)
	begin
		if(frame_hd_dly[0])	
			antx16_cnt <= 3'b1;
		else
			antx16_cnt <= antx16_cnt + 3'b1;
	end		

always @ (posedge clk)
	begin
		if(framn_hd_dly[0])	
			antx16_cntn <= 3'b1;
		else
			antx16_cntn <= antx16_cntn + 3'b1;
	end	
	
always @ (posedge clk)
	begin
		frame_hd_dly <= {frame_hd_dly[18:0],i_frame_hd};    
		data0_iq_dly3 <= i_data0_iq;
		data0_iq_dly2 <= data0_iq_dly3;
		data0_iq_dly1 <= data0_iq_dly2;
		data0_iq_dly0 <= data0_iq_dly1;
		data0_iq_dlym0 <= data0_iq_dly0;
	
		data1_iq_dly3 <= i_data1_iq;
		data1_iq_dly2 <= data1_iq_dly3;
		data1_iq_dly1 <= data1_iq_dly2;
		data1_iq_dly0 <= data1_iq_dly1;
		data1_iq_dlym0 <= data1_iq_dly0;
		
		cell_iqselcfg <= i_cell_iqselcfg;
		antx16_cnt_d1 <= antx16_cnt;
		framn_hd_dly <= {framn_hd_dly[2:0],i_framn_hd}; 
		ant8_sel_dly <= {ant8_sel_dly[2:0],i_ant8_sel}; 
	end	

reg data_first0;
reg data_first1;
reg data_first2;
reg data_first3;

always  @   (posedge clk)
begin
    data_first0 <= (antx16_cnt == 0);
    data_first1 <= (antx16_cnt == 0);
    data_first2 <= (antx16_cnt == 0);
    data_first3 <= (antx16_cnt == 0);
end
	
always @ (posedge clk)
	begin		
		if(data_first0)
			begin
				data_iq_s0 <= data0_iq_dlym0;
				data_iq_s1 <= data0_iq_dly0;
			end
		else;
	end	
	
always @ (posedge clk)
        begin        
            if(data_first1)
                begin
                    data_iq_s2 <= data0_iq_dly1;
                    data_iq_s3 <= data0_iq_dly2;
                end
            else;
        end    

always @ (posedge clk)
	begin		
		if(data_first2)
			begin
				data_iq_s4 <= data1_iq_dlym0;
				data_iq_s5 <= data1_iq_dly0;
			end
		else;
	end	

always @ (posedge clk)
	begin		
		if(data_first3)
			begin
				data_iq_s6 <= data1_iq_dly1;
				data_iq_s7 <= data1_iq_dly2;
			end
		else;
	end

always @ (posedge clk)
	begin
		case(antx16_cnt_d1) 
			4'h0 : cell_iqselnum <= cell_iqselcfg[ 3: 0]; 																																							   
			4'h1 : cell_iqselnum <= cell_iqselcfg[ 7: 4]; 																																							
			4'h2 : cell_iqselnum <= cell_iqselcfg[11: 8]; 																																						
			4'h3 : cell_iqselnum <= cell_iqselcfg[15:12];
			4'h4 : cell_iqselnum <= cell_iqselcfg[19:16]; 																																							   
			4'h5 : cell_iqselnum <= cell_iqselcfg[23:20]; 																																							
			4'h6 : cell_iqselnum <= cell_iqselcfg[27:24]; 																																						
			4'h7 : cell_iqselnum <= cell_iqselcfg[31:28];																				
			default : cell_iqselnum <= cell_iqselcfg[ 3: 0]; 																																							
		endcase
	end	
	
always @ (posedge clk)
	begin
		case(cell_iqselnum) 
			4'b0000 : cell_data0_iq <= data_iq_s0; 																																							   
			4'b0001 : cell_data0_iq <= data_iq_s1; 																																							
			4'b0010 : cell_data0_iq <= data_iq_s2; 																																							
			4'b0011 : cell_data0_iq <= data_iq_s3;
			4'b0100 : cell_data0_iq <= data_iq_s4; 																																							   
			4'b0101 : cell_data0_iq <= data_iq_s5; 																																							
			4'b0110 : cell_data0_iq <= data_iq_s6; 																																							
			4'b0111 : cell_data0_iq <= data_iq_s7;																																							
			default : cell_data0_iq <= data_iq_s0; 																																							
		endcase
	end	

always @ (posedge clk)
	begin
		if(dds_phase_cnt == {cell_iqselcfg[29:16],2'b10})
			dds_phase_cnt_clr <= 1'd1;
		else
			dds_phase_cnt_clr <= 1'd0;
	end
		
always @ (posedge clk)
	begin
		if(framn_hd_dly[0])
			dds_phase_cnt <= 16'b10;
		else
			if(dds_phase_cnt_clr)
				dds_phase_cnt <= 16'd0;
			else
				dds_phase_cnt <= dds_phase_cnt + 16'd1;	
	end
	
always @ (posedge clk)
	begin
		if(dds_phase_cnt_clr)
			dds_phase <= dds_phase + 8'd1;
		else
			dds_phase <= dds_phase;	
	end
	
dl_dds_compiler u_dl_dds_compiler 
(
	.aclk					(clk),                                     
	.s_axis_phase_tvalid	(1'b1),       
	.s_axis_phase_tdata		(dds_phase[7:0]),         
	.m_axis_data_tvalid		(),         
	.m_axis_data_tdata		(if2dds_data)  
);


always @ (posedge clk)
	begin
		if2dds_data_temp <= {if2dds_data[31],if2dds_data[31],if2dds_data[31],if2dds_data[31],if2dds_data[31:20],if2dds_data[15],if2dds_data[15],if2dds_data[15],if2dds_data[15],if2dds_data[15:4]};
		if2dds_data_temp_d1 <= if2dds_data_temp;
		dds_phase_temp_dly0 <= {dds_phase_cnt,dds_phase_cnt};
		dds_phase_temp_dly1 <= dds_phase_temp_dly0;
		dds_phase_temp <= dds_phase_temp_dly1;
		dds_phase_temp_d1 <= dds_phase_temp;
	end	


reg test_sel_d = 0;	
always @ (posedge clk)
	begin
		test_vld <= i_test_vld;
		cell_iq <= i_cell_iq;
		datan_iq_d1 <= i_datan_iq;
		test_sel_d <= i_test_sel;
	end	
	
always @ (posedge clk)
	begin
		if	(test_sel_d)
			case(test_vld)   
				3'b000:cell_data_iq <= datan_iq_d1;
				3'b001:cell_data_iq <= cell_data0_iq;
				3'b010:cell_data_iq <= cell_iq;
				3'b011:cell_data_iq <= if2dds_data_temp;    //dds + 1 delay ÕıÏÒ£¿£¿
				3'b100:cell_data_iq <= dds_phase_temp_d1;
				default:cell_data_iq <= datan_iq_d1;
			endcase
		else
			cell_data_iq <= datan_iq_d1;
	end	

//cycle cnt   
//always @(posedge clk)
//	begin
//		if(framn_hd_dly[0])  
//			cycle_cnt <= 8'd0;
//		else
//		begin
//			if(cycle_cnt == 8'd191)
//				cycle_cnt <= 8'd0;
//			else
//				cycle_cnt <= cycle_cnt + 1'b1;
//		end
//	end
always @(posedge clk)
        begin
                if(framn_hd_dly[0])  
                    cycle_cnt <= 24'd0;
                else
                begin
                    if(cycle_cnt == 24'd4915199)
                        cycle_cnt <= 24'd0;
                    else
                        cycle_cnt <= cycle_cnt + 24'b1;
                end
        end	
//chip cnt    
always @(posedge clk)
	begin 
		if(framn_hd_dly[0])  
			chip_cnt <= 5'b0;
		else
		begin
			if(cycle_cnt == 8'd191)
				chip_cnt <= chip_cnt + 5'b1;
		    else
		    	chip_cnt <= chip_cnt;
		end
	end

//chip num  
always @(posedge clk)
	begin 
		chip_num <= {2'b0,sgn_cnt[8:0],chip_cnt[4:0]};      
	end

//sgn cnt   
always @(posedge clk)
	begin 
		if(framn_hd_dly[0])  
		    sgn_cnt <= 9'b0;
		else
		begin
			if((chip_cnt == 5'd31)&&(cycle_cnt == 8'd191))
			begin
				if(sgn_cnt==9'd399)
					sgn_cnt <= 9'b0;
				else
					sgn_cnt <= sgn_cnt + 9'b1;
			end
			else
				sgn_cnt <= sgn_cnt;
		end    
	end 

reg data_sel;
reg data_sel_d1;

//always @(posedge clk)
//begin
//	if	(chip_num <= i_data_end)
//		data_sel <= 0;
//	else
//	begin
//		if	(chip_num >= i_data_start)
//			data_sel <= 1;
//		else
//			data_sel <= data_sel;
//	end
//end

always @(posedge clk)
begin
	if	(cycle_cnt <= i_data_end)
		data_sel <= 0;
	else
	begin
		if	(cycle_cnt >= i_data_start)
			data_sel <= 1;
		else
			data_sel <= data_sel;
	end
end

reg data_start;
reg data_end;

always @(posedge clk)
begin
        data_start <= (cycle_cnt == i_data_start);
		data_end <=(cycle_cnt == i_data_end);
end

always @(posedge clk)
begin
    casex    ({data_end,data_start})
    2'bx1   :   data_sel_d1 <= 1;
    2'b10   :   data_sel_d1 <= 0;
    default :   data_sel_d1 <= data_sel_d1;
    endcase
end

always @(posedge clk)
begin
		data_out <= data_sel_d1 ? cell_data_iq : 32'b0;
end

//always @(posedge clk)
//begin
//        data_sel_d1 <= data_sel;
//		data_out <= data_sel_d1 ? cell_data_iq : 32'b0;
//end
	
always @ (posedge clk)
	begin
		if(test_vld == 3'b001)
			fram_hd <= frame_hd_dly[7];
		else
			fram_hd <= framn_hd_dly[1];
	end	

always @ (posedge clk)
	begin
		if(test_vld == 3'b001)
			ant8_sel <= (antx16_cnt == 7);
		else
//			ant8_sel <= ant8_sel_dly[0];
			ant8_sel <= (antx16_cntn == 7);
	end	

assign o_ant8_sel = ant8_sel;
assign o_data_iq = data_out;
assign o_fram_hd = fram_hd;


//ila_nr_datapath_src ila_nr_datapath_src
//(
//.clk			(clk),
//.probe0			(i_framn_hd),
//.probe1			(i_datan_iq),
//.probe2			(o_fram_hd),
//.probe3			(o_data_iq)
//);

endmodule

