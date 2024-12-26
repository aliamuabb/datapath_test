//wangshuyi@2020-11-03
//RAM_LATENCY depands on uram cascade chain length
//RAM_LATENCY = URAM_NUM + 1;


module	uram_data_joint_wiro
#(
 parameter	FIBRE_LATERCY = 125
,parameter	OPT_FREQUENCY = 368.64
,parameter	RD_START_ADDR = 0
,parameter	WR_START_ADDR = 0
//,parameter	R_ADDR_WIDTH = 16
,parameter	W_ADDR_WIDTH = 16
,parameter	INOUT_DATA_WIDTH = 60
,parameter	STORAGE_DATA_WIDTH = 72
//,parameter	STORAGE_ADDR_WIDTH = 14
)
(
 input							clka
,input							clkb
,input							rsta 
,input							i_frame_hd
,input	[INOUT_DATA_WIDTH-1:0]	i_data
,input							i_en
,output							i_pause
,input							o_frame_hd
,output	[INOUT_DATA_WIDTH-1:0]	o_data
,output	[W_ADDR_WIDTH-1:0]		o_addr
,output							o_en
);

localparam	integer FIBRE_DELAY_CLK_NUM = FIBRE_LATERCY*OPT_FREQUENCY*INOUT_DATA_WIDTH/STORAGE_DATA_WIDTH;
localparam	URAM_NUM = FIBRE_DELAY_CLK_NUM/4096 + ((FIBRE_DELAY_CLK_NUM%4096 != 0) ? 1 : 0);
//localparam	URAM_NUM = FIBRE_DELAY_CLK_NUM/4096 + ((FIBRE_DELAY_CLK_NUM[11:0] != 0) ? 1 : 0);
localparam	STORAGE_ADDR_WIDTH = clogb2(FIBRE_DELAY_CLK_NUM) + 1;
localparam	FIFO_DATA_WIDTH = 1+STORAGE_ADDR_WIDTH+STORAGE_DATA_WIDTH;
localparam	RAM_LATENCY = URAM_NUM + 1;

shift_regs	#(1,1)	shreg_frame_hd	(clka,rsta,i_frame_hd,i_start);


 wire[STORAGE_DATA_WIDTH-1:0]	ov_rdata
//;wire							i_renb
;wire[STORAGE_ADDR_WIDTH-1:0]	iv_raddr
;wire[STORAGE_DATA_WIDTH-1:0]	iv_wdata
;wire[STORAGE_ADDR_WIDTH-1:0]	iv_waddr
;wire							i_wena
;wire[STORAGE_DATA_WIDTH-1:0]	iv_wdata_pre
;wire[STORAGE_ADDR_WIDTH-1:0]	iv_waddr_pre
;wire							i_wena_pre
;

data_joint_split
#(
 .INPUT_WIDTH(INOUT_DATA_WIDTH)
,.OUTPUT_WIDTH(STORAGE_DATA_WIDTH)
,.WR_START_ADDR(0)
,.FIBRE_DELAY_CLK_NUM(FIBRE_DELAY_CLK_NUM)
,.W_ADDR_WIDTH(STORAGE_ADDR_WIDTH)
)
data_joint_split
(
 .clk		(clka		)
,.i_data    (i_data		)
,.i_start   (i_start	)
,.i_en      (i_en		)
,.i_wait	(i_pause	)
,.o_data    (iv_wdata	)
,.o_addr    (iv_waddr	)
,.o_en		(i_wena		)
);


cdc_bus
#(
 .FIFO_DATA_WIDTH(FIFO_DATA_WIDTH)
)
cdc_bus
(
 .clka	(	clka									)
,.rsta	(	rsta									)
,.dina	(	{i_wena,iv_waddr,iv_wdata}				)
,.clkb	(	clkb									)
,.doutb	(	{i_wena_pre,iv_waddr_pre,iv_wdata_pre}	)
);

uram_Nx72
#(
 .URAM_NUM(URAM_NUM)
,.STORAGE_ADDR_WIDTH(STORAGE_ADDR_WIDTH)
)
uram_Nx72
(
 .clk      (clkb      	    	)
//,.rst      (1'b0      			)
,.iv_waddr (iv_waddr_pre		)
,.iv_wdata (iv_wdata_pre		)
,.i_wena   (i_wena_pre			)
,.w_biten  (9'h1ff  			)
,.i_renb   (~i_wait   			)
,.iv_raddr (iv_raddr 			)
,.ov_rdata (ov_rdata 			)
);


data_joint_split_ram
#(
 .INPUT_WIDTH(STORAGE_DATA_WIDTH)
,.OUTPUT_WIDTH(INOUT_DATA_WIDTH)
,.RAM_LATENCY(RAM_LATENCY)
,.FIBRE_DELAY_CLK_NUM(FIBRE_DELAY_CLK_NUM)
,.W_ADDR_WIDTH(W_ADDR_WIDTH)
,.R_ADDR_WIDTH(STORAGE_ADDR_WIDTH)
,.WR_START_ADDR(WR_START_ADDR)
,.RD_START_ADDR(0)
)
data_joint_split_ram
(
 .clk        (clkb       )
,.i_data     (ov_rdata   )
,.i_start    (o_frame_hd )
,.i_wait     (i_wait     )
,.i_addr     (iv_raddr   )
,.o_data     (o_data     )
,.o_addr     (o_addr     )
,.o_en       (o_en       )
);

`include	"clogb2.v"

//function integer clogb2;
//  input integer depth;
//    for (clogb2=0; depth>0; clogb2=clogb2+1)
//      depth = depth >> 1;
//endfunction

endmodule
