//wangshuyi@2019-11-15

module  matrix_ram
#(
 parameter  DATA_WIDTH = 64
,parameter  ADDR_NUM = 32
,parameter  ADNW = 6
)
(
 input   clk
,input   we
,input  [DATA_WIDTH-1:0] dina
,input  [ADNW-1:0] addra
,output  [DATA_WIDTH-1:0] doutb
,input  [ADNW-1:0] addrb
);

reg [DATA_WIDTH-1:0] dout;
reg [DATA_WIDTH-1:0] dout_d;
reg [DATA_WIDTH-1:0] dout_d2;
(*ram_style="distributed"*)reg	[DATA_WIDTH-1:0]	ram	[ADDR_NUM-1:0] = '{default: '0};

assign  doutb = dout_d;

always	@	(posedge clk)
begin
	if	(we)
		ram[addra] <= dina;
	dout <= ram[addrb];
	dout_d <= dout;
	dout_d2 <= dout_d;
end




endmodule