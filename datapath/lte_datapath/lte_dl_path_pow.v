`timescale 1ns / 1ps
//---------------------------------------------------------------------------------
//Module Name:					dl_trans_lte.v   
//Department:					Beijing R&D Center FPGA Design Dept
//Function Description:			5th Generation Data Path
//---------------------------------------------------------------------------------
//Version				Design				Coding				Simulate				Review				Rel data
//V1.0					Yangliu				Yangliu															2011-12-20
//
//---------------------------------------------------------------------------------
//Version				Modified History
//V1.0					draft

//-------------------------------key words-----------------------------------------
//	
//
// 
////////////////////////////////////////////////////////////////////////////////

module lte_dl_path_pow
(
	input	wire				clk,
	input	wire				asy_rst,
	
	input	wire	[31:0]		i_ant0_pow,
	input	wire	[31:0]		i_ant1_pow,
	input	wire	[31:0]		i_ant2_pow,
	input	wire	[31:0]		i_ant3_pow,
	input	wire	[31:0]		i_ant4_pow,
	input	wire	[31:0]		i_ant5_pow,
	input	wire	[31:0]		i_ant6_pow,
	input	wire	[31:0]		i_ant7_pow,
	
	input	wire				i_fram_hd,		
	input	wire				i_ant8_sel,	
	input	wire	[31:0]		i_data,				
	input	wire				i_data_valid,
	
	output	wire				o_fram_hd,				
	output	wire				o_ant8_sel,
	output	wire	[31:0]		o_data,		
	output	wire				o_data_valid			
);

reg		[ 2:0]		cycle_cnt;	
reg		[31:0]		ant_posinfo;
reg		[ 7:0]		fram_hd;
reg		[ 7:0]		ant8_sel;

reg		[31:0]		ant_pow;
wire    [72:0]      m_axis_dout_tdata;
//data counter
always @ (posedge clk)
	begin
		fram_hd <= {fram_hd[6:0],i_fram_hd};	
		ant8_sel <= {ant8_sel[6:0],i_ant8_sel};
	end
	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			cycle_cnt <= 3'd0;
		else if (i_fram_hd)
			cycle_cnt <= 3'd0;
		else
			cycle_cnt <= cycle_cnt + 3'b1;		
	end
/*	
always @ (posedge clk)
	begin
		ant_posinfo <= i_ant_posinfo;	
	end
	
always @ (posedge clk)
	begin
		case(ant_posinfo[2:0])
			3'b000 : ant0_pow <= i_ant0_pow;	
			3'b001 : ant0_pow <= i_ant1_pow;
			3'b010 : ant0_pow <= i_ant2_pow;
			3'b011 : ant0_pow <= i_ant3_pow;
			3'b100 : ant0_pow <= i_ant4_pow;
			3'b101 : ant0_pow <= i_ant5_pow;
			3'b110 : ant0_pow <= i_ant6_pow;
			3'b111 : ant0_pow <= i_ant7_pow;
			default: ant0_pow <= 32'b00000;	
		endcase
	end
	
always @ (posedge clk)
	begin
		case(ant_posinfo[6:4])
			3'b000 : ant1_pow <= i_ant0_pow;	
			3'b001 : ant1_pow <= i_ant1_pow;
			3'b010 : ant1_pow <= i_ant2_pow;
			3'b011 : ant1_pow <= i_ant3_pow;
			3'b100 : ant1_pow <= i_ant4_pow;
			3'b101 : ant1_pow <= i_ant5_pow;
			3'b110 : ant1_pow <= i_ant6_pow;
			3'b111 : ant1_pow <= i_ant7_pow;
			default: ant1_pow <= 32'b00000;	
		endcase
	end
	
always @ (posedge clk)
	begin
		case(ant_posinfo[10:8])
			3'b000 : ant2_pow <= i_ant0_pow;	
			3'b001 : ant2_pow <= i_ant1_pow;
			3'b010 : ant2_pow <= i_ant2_pow;
			3'b011 : ant2_pow <= i_ant3_pow;
			3'b100 : ant2_pow <= i_ant4_pow;
			3'b101 : ant2_pow <= i_ant5_pow;
			3'b110 : ant2_pow <= i_ant6_pow;
			3'b111 : ant2_pow <= i_ant7_pow;
			default: ant2_pow <= 32'b00000;	
		endcase
	end
	
always @ (posedge clk)
	begin
		case(ant_posinfo[14:12])
			3'b000 : ant3_pow <= i_ant0_pow;	
			3'b001 : ant3_pow <= i_ant1_pow;
			3'b010 : ant3_pow <= i_ant2_pow;
			3'b011 : ant3_pow <= i_ant3_pow;
			3'b100 : ant3_pow <= i_ant4_pow;
			3'b101 : ant3_pow <= i_ant5_pow;
			3'b110 : ant3_pow <= i_ant6_pow;
			3'b111 : ant3_pow <= i_ant7_pow;
			default: ant3_pow <= 32'b00000;	
		endcase
	end
	
always @ (posedge clk)
	begin
		case(ant_posinfo[18:16])
			3'b000 : ant4_pow <= i_ant0_pow;	
			3'b001 : ant4_pow <= i_ant1_pow;
			3'b010 : ant4_pow <= i_ant2_pow;
			3'b011 : ant4_pow <= i_ant3_pow;
			3'b100 : ant4_pow <= i_ant4_pow;
			3'b101 : ant4_pow <= i_ant5_pow;
			3'b110 : ant4_pow <= i_ant6_pow;
			3'b111 : ant4_pow <= i_ant7_pow;
			default: ant4_pow <= 32'b00000;	
		endcase
	end
	
always @ (posedge clk)
	begin
		case(ant_posinfo[22:20])
			3'b000 : ant5_pow <= i_ant0_pow;	
			3'b001 : ant5_pow <= i_ant1_pow;
			3'b010 : ant5_pow <= i_ant2_pow;
			3'b011 : ant5_pow <= i_ant3_pow;
			3'b100 : ant5_pow <= i_ant4_pow;
			3'b101 : ant5_pow <= i_ant5_pow;
			3'b110 : ant5_pow <= i_ant6_pow;
			3'b111 : ant5_pow <= i_ant7_pow;
			default: ant5_pow <= 32'b00000;	
		endcase
	end
	
always @ (posedge clk)
	begin
		case(ant_posinfo[26:24])
			3'b000 : ant6_pow <= i_ant0_pow;	
			3'b001 : ant6_pow <= i_ant1_pow;
			3'b010 : ant6_pow <= i_ant2_pow;
			3'b011 : ant6_pow <= i_ant3_pow;
			3'b100 : ant6_pow <= i_ant4_pow;
			3'b101 : ant6_pow <= i_ant5_pow;
			3'b110 : ant6_pow <= i_ant6_pow;
			3'b111 : ant6_pow <= i_ant7_pow;
			default: ant6_pow <= 32'b00000;	
		endcase
	end
	
always @ (posedge clk)
	begin
		case(ant_posinfo[30:28])
			3'b000 : ant7_pow <= i_ant0_pow;	
			3'b001 : ant7_pow <= i_ant1_pow;
			3'b010 : ant7_pow <= i_ant2_pow;
			3'b011 : ant7_pow <= i_ant3_pow;
			3'b100 : ant7_pow <= i_ant4_pow;
			3'b101 : ant7_pow <= i_ant5_pow;
			3'b110 : ant7_pow <= i_ant6_pow;
			3'b111 : ant7_pow <= i_ant7_pow;
			default: ant7_pow <= 32'b00000;	
		endcase
	end
*/	
always @ (posedge clk)
	begin
		case(cycle_cnt[2:0])
			3'b000 : ant_pow <= i_ant0_pow;
			3'b001 : ant_pow <= i_ant1_pow;
			3'b010 : ant_pow <= i_ant2_pow;
			3'b011 : ant_pow <= i_ant3_pow;
			3'b100 : ant_pow <= i_ant4_pow;
			3'b101 : ant_pow <= i_ant5_pow;
			3'b110 : ant_pow <= i_ant6_pow;
			3'b111 : ant_pow <= i_ant7_pow;
			default: ant_pow <= 32'b00000;
		endcase	
	end
	
//path_complex_mult u_path_complex_mult 
//(
//   .CLK				(clk),
//   .A				(i_data),
//   .B				(ant_pow),
//   .P				(o_data)
//);

//complex_mult u_complex_mult
//(
//	.aclk					(clk),
//	.s_axis_a_tvalid     	(1'b1),
//	.s_axis_a_tdata      	(i_data),
//	.s_axis_b_tvalid     	(1'b1),
//	.s_axis_b_tdata      	(ant_pow),
//	.m_axis_dout_tvalid  	(),
//	.m_axis_dout_tdata   	(o_data)
//); 

path_complex_mult u_path_complex_mult 
(
	.aclk				(clk),                              // input wire aclk
  	.s_axis_a_tvalid	(1'b1),        // input wire s_axis_a_tvalid
  	.s_axis_a_tdata		({i_data[15:0],i_data[31:16]}),          // input wire [31 : 0] s_axis_a_tdata
  	.s_axis_b_tvalid	(1'b1),        // input wire s_axis_b_tvalid
  	.s_axis_b_tdata		({ant_pow[15:0],ant_pow[31:16]}),          // input wire [31 : 0] s_axis_b_tdata
  	.s_axis_ctrl_tvalid	(1'b0), 
  	.s_axis_ctrl_tdata	(8'h0),
  	.m_axis_dout_tvalid	(),  // output wire m_axis_dout_tvalid
  	.m_axis_dout_tdata	(m_axis_dout_tdata)    // output wire [31 : 0] m_axis_dout_tdata
);

assign o_ant8_sel = ant8_sel[5];
assign o_fram_hd =  fram_hd[5];
assign o_data_valid = 1'b1;
assign o_data = {m_axis_dout_tdata[15:0],m_axis_dout_tdata[39:24]};
//assign o_data = i_data;
//vavido_ila_pow vavido_ila_pow
//(
//    .clk                (clk),
//    .probe0				(i_fram_hd),
//    .probe1				(i_ant8_sel),
//    .probe2				(i_data),
//    .probe3				(o_fram_hd),
//    .probe4				(o_ant8_sel),
//    .probe5				(o_data)
//);
			
endmodule