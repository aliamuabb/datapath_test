//wangshuyi@2018-04-26
//wangshuyi@2019-11-20
//min@4antenna

module	power_detect_top
#(
 parameter	FRAM_NUM 		= 	75
,parameter	SF_TIME			=	245760
,parameter	SF_NUM			=	20
,parameter SF_ADDR_NUM    =     20
,parameter	ANT_NUM			=	4
,parameter	MODE			=	"BOARD"
,parameter  ANW             =   clogb2(ANT_NUM-1)
,parameter  SNW             =   clogb2(SF_NUM-1)
,parameter  SANW            =   clogb2(SF_ADDR_NUM-1)
//,parameter  ADNW            =   clogb2(SF_ADDR_NUM*ANT_NUM-1)
,parameter  ADNW            =   SANW + ANW
)
(
	 input	wire            reset
	,input	wire            clk
	,input	wire			i_fram_hd
	,input	wire	[31:0]	i_data

	,input	wire			         trig
	,input	wire			         clk_rd
	,input	wire	[ADNW:0]	i_pow_dect_raddr
	,output	wire	[31:0]	         o_pow_dect_rdata
);

wire            clr;
wire	[ADNW-1:0]	waddr;
wire			wren;
reg	[12:0]	wren_reg = 0;
reg	[10:0]	clr_reg = 0;
reg	[ADNW-1:0]	waddr_reg	[12:0]= '{default: '0};
wire	[63:0]	w_data;

///////////////ctrl
pd_timer
#(
 .FRAM_NUM(FRAM_NUM)
,.SF_TIME(SF_TIME)
,.SF_NUM(SF_NUM)
,.SF_ADDR_NUM(SF_ADDR_NUM)
,.ANT_NUM(ANT_NUM)
,.ANW(ANW)
,.SNW(SNW)
,.SANW(SANW)
,.MODE(MODE)
)
pd_timer
(
 .clk			(	clk			)
,.reset			(	reset		)
,.i_hd          (	i_fram_hd	)
,.trig          (	trig		)
,.start_clr     (	clr			)
,.get_end_wr    (	wren		)
,.get_end_addr  (	waddr		)
);

///////////data add
pd_adder_pipeline
#(
 .MODE(MODE)
,.SF_ADDR_NUM(SF_ADDR_NUM)
,.ANT_NUM(ANT_NUM)
,.ANW(ANW)
,.SNW(SNW)
,.SANW(SANW)
,.ADNW(ADNW)
)
pd_adder_pipeline
(
 .clk        	(	clk			)
,.i_data     	(	i_data		)
,.lo_clr        (	clr_reg[1]	)
,.hi_clr        (	clr_reg[3]	)
,.lo_waddr		(	waddr_reg[3])
,.lo_raddr		(	waddr_reg[0])
,.hi_waddr		(	waddr_reg[4])
,.hi_raddr		(	waddr_reg[1])
,.o_data     	(	w_data		)
);

always	@	(posedge clk)
begin
	wren_reg <= {wren_reg[12:0],wren};
	waddr_reg <= {waddr_reg[11:0],waddr};
	clr_reg <= {clr_reg[9:0],clr};
end

////////////assign

wire    [ADNW-1:0]       ram_waddr = waddr_reg[5];
wire                ram_wren = wren_reg[6];
wire    [63:0]      ram_wdata = w_data;
wire    [ADNW:0]       ram_raddr = i_pow_dect_raddr;

///////////ram

reg [63:0]  dout;
reg [31:0]  dout_d;
reg [31:0]  dout_d2;
assign    o_pow_dect_rdata = dout_d2;

//(*ram_style="block"*)reg	[63:0]	ram	[SF_ADDR_NUM*ANT_NUM-1:0]= '{default: '0};
(* ram_style="distributed" *)reg	[63:0]	ram	[SF_ADDR_NUM*ANT_NUM-1:0]= '{default: '0};
always	@	(posedge clk)
begin
	if	(ram_wren)
		ram[ram_waddr] <= ram_wdata;
	dout <= ram[ram_raddr[ADNW:1]];
	dout_d <= ram_raddr[0] ? dout[63:32] : dout[31:0];
	dout_d2 <= dout_d;
end

///////funtion

function integer clogb2;
  input integer depth;
    for (clogb2=0; depth>0; clogb2=clogb2+1)
      depth = depth >> 1;
endfunction

endmodule