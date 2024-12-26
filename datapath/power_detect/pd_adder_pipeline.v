//wangshuyi@2018-04-26

module	pd_adder_pipeline
#(
 parameter	MODE = "BOARD"
,parameter	ANW			   =	2
,parameter	SNW			   =	5
,parameter	SANW			=	5
,parameter	SF_ADDR_NUM		=	20
,parameter	ANT_NUM			=	4
,parameter ADNW           =   6
)
(
 input				clk
,input		[31:0]	i_data
,input				lo_clr
,input				hi_clr
,input		[ADNW-1:0]	lo_waddr
,input		[ADNW-1:0]	lo_raddr
,input		[ADNW-1:0]	hi_waddr
,input		[ADNW-1:0]	hi_raddr
,output	reg	[63:0]	o_data
);

wire    [47:0]  s_step2;

reg [31:0]  data = 0;
reg [31:0]  data_reg1 = 0;
wire [47:0]  sqrt_q;
reg [47:0]  s_step2_reg1 = 0;
wire [47:0]  s_step2_d2;

wire			carry_out;
reg	[15:0]	dina;
wire	[15:0]	douta;	

always	@	(posedge clk)
begin
	data <= i_data;
	data_reg1 <= data;
	s_step2_reg1 <= s_step2;
	o_data <= {dina,s_step2_reg1};
end

mult_16x16_dsp1 tdl_q_square(
	.CLK			(clk					),
	.A  			(data[15:0]				),
	.B  			(data[15:0]				),
	.PCOUT  			(sqrt_q						)
);

//d2
generate	
	case	(MODE)
	"CARRY_SIM"	:
        mult_16x16_c  step2(
          .CLK(clk),
          .A(data_reg1[31:16]),
          .B(data_reg1[31:16]),
          .SEL(lo_clr),
          .C(s_step2_d2),
          .PCIN(48'hffff_ffff_ffff),
          .CARRYOUT(carry_out),
          .P(s_step2)
       ) ;
	default:
		  mult_16x16_c  step2(
            .CLK(clk),
            .A(data_reg1[31:16]),
            .B(data_reg1[31:16]),
            .SEL(lo_clr),
            .C(s_step2_d2),
            .PCIN(sqrt_q),
            .CARRYOUT(carry_out),
            .P(s_step2)
         ) ;
	endcase
endgenerate


matrix_ram
#(48,SF_ADDR_NUM*ANT_NUM,ADNW)
pd_ram_48_carry (
  .clk(clk),    // input wire clka
  .we(1'b1),      // input wire [0 : 0] wea
  .addra(lo_waddr),  // input wire [6 : 0] addra
  .dina(s_step2),    // input wire [46 : 0] dina
  .addrb(lo_raddr),  // input wire [6 : 0] addrb
  .doutb(s_step2_d2)  // output wire [46 : 0] doutb
);

wire carry;

assign  carry=~carry_out;

always  @   (posedge clk)
begin
    if  (hi_clr)
        dina <= carry + 16'h0;
    else
        dina <= carry + douta;
end

matrix_ram
#(17,SF_ADDR_NUM*ANT_NUM,ADNW)
pd_ram_17_carry (
  .clk(clk),    // input wire clka
  .we(1'b1),      // input wire [0 : 0] wea
  .addra(hi_waddr),  // input wire [6 : 0] addra
  .dina(dina),    // input wire [46 : 0] dina
  .addrb(hi_raddr),  // input wire [6 : 0] addrb
  .doutb(douta)  // output wire [46 : 0] doutb
);

endmodule