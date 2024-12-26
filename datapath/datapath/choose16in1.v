
module	choose16in1
(
	input						clk,	
	input	wire	[3:0]		ant_posinfo,
	input	wire	[31:0]		i_ant0_pow,
	input	wire	[31:0]		i_ant1_pow,
	input	wire	[31:0]		i_ant2_pow,
	input	wire	[31:0]		i_ant3_pow,
	input	wire	[31:0]		i_ant4_pow,
	input	wire	[31:0]		i_ant5_pow,
	input	wire	[31:0]		i_ant6_pow,
	input	wire	[31:0]		i_ant7_pow,
	input	wire	[31:0]		i_ant8_pow,
	input	wire	[31:0]		i_ant9_pow,
	input	wire	[31:0]		i_anta_pow,
	input	wire	[31:0]		i_antb_pow,
	input	wire	[31:0]		i_antc_pow,
	input	wire	[31:0]		i_antd_pow,
	input	wire	[31:0]		i_ante_pow,
	input	wire	[31:0]		i_antf_pow,
	output	reg		[31:0]		ant_pow
);

always @ (posedge clk)
	begin
		case(ant_posinfo)
			4'b0000 : ant_pow <= i_ant0_pow;
			4'b0001 : ant_pow <= i_ant1_pow;
			4'b0010 : ant_pow <= i_ant2_pow;
			4'b0011 : ant_pow <= i_ant3_pow;
			4'b0100 : ant_pow <= i_ant4_pow;
			4'b0101 : ant_pow <= i_ant5_pow;
			4'b0110 : ant_pow <= i_ant6_pow;
			4'b0111 : ant_pow <= i_ant7_pow;
			4'b1000 : ant_pow <= i_ant8_pow;
			4'b1001 : ant_pow <= i_ant9_pow;
			4'b1010 : ant_pow <= i_anta_pow;
			4'b1011 : ant_pow <= i_antb_pow;
			4'b1100 : ant_pow <= i_antc_pow;
			4'b1101 : ant_pow <= i_antd_pow;
			4'b1110 : ant_pow <= i_ante_pow;
			4'b1111 : ant_pow <= i_antf_pow;
			default: ant_pow <= 32'h00000000;
		endcase
	end	


endmodule	