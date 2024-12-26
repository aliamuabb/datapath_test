//============================================================
// Created by         : dtmobile
// Filename           : uram_Nx72.v
// Author             : wangshuyi
// Created On         : 2020-11-06
// Last Modified      :
// Update Count       :
// Description        : Cascade N URAMs, read latency: 5 clock
//                      
//                      
//============================================================

module uram_Nx72
#(
 parameter	URAM_NUM = 10
,parameter	STORAGE_ADDR_WIDTH = 14
)
 (
input								clk			,
//input								rst			,
input	[STORAGE_ADDR_WIDTH-1:0]	iv_waddr	,
input	[71:0]						iv_wdata	,
input								i_wena		,
input	[8:0]						w_biten		,
input								i_renb		,
input	[STORAGE_ADDR_WIDTH-1:0]	iv_raddr	,
output	[71:0]						ov_rdata
);

//registers declaration
wire   [22:0]      CAS_OUT_ADDR_A    [0:URAM_NUM-2];
wire   [22:0]      CAS_OUT_ADDR_B    [0:URAM_NUM-2];
wire   [ 8:0]      CAS_OUT_BWE_A     [0:URAM_NUM-2];
wire   [ 8:0]      CAS_OUT_BWE_B     [0:URAM_NUM-2];
wire               CAS_OUT_DBITERR_A [0:URAM_NUM-2];
wire               CAS_OUT_DBITERR_B [0:URAM_NUM-2];
wire   [71:0]      CAS_OUT_DIN_A     [0:URAM_NUM-2];
wire   [71:0]      CAS_OUT_DIN_B     [0:URAM_NUM-2];
wire   [71:0]      CAS_OUT_DOUT_A    [0:URAM_NUM-2];
wire   [71:0]      CAS_OUT_DOUT_B    [0:URAM_NUM-2];
wire               CAS_OUT_EN_A      [0:URAM_NUM-2];
wire               CAS_OUT_EN_B      [0:URAM_NUM-2];
wire               CAS_OUT_RDACCESS_A[0:URAM_NUM-2];
wire               CAS_OUT_RDACCESS_B[0:URAM_NUM-2];
wire               CAS_OUT_RDB_WR_A  [0:URAM_NUM-2];
wire               CAS_OUT_RDB_WR_B  [0:URAM_NUM-2];
wire               CAS_OUT_SBITERR_A [0:URAM_NUM-2];
wire               CAS_OUT_SBITERR_B [0:URAM_NUM-2];

wire   [71:0]      doutb;

assign  ov_rdata = doutb[71:0];


// URAM288: 288K-bit High-Density Memory Building Block
//          Virtex UltraScale+
// Xilinx HDL Language Template, version 2016.2

// Port A is in wirte mode, Port B is in read mode
URAM288 #(
.AUTO_SLEEP_LATENCY      ( 8                        ), // Latency requirement to enter sleep mode
.AVG_CONS_INACTIVE_CYCLES( 10                       ), // Average concecutive inactive cycles when is SLEEP mode for power estimation
.BWE_MODE_A              ( "PARITY_INTERLEAVED"     ), // Port A Byte write control
.BWE_MODE_B              ( "PARITY_INTERLEAVED"     ), // Port B Byte write control
.CASCADE_ORDER_A         ( "FIRST"                  ), // Port A position in cascade chain
.CASCADE_ORDER_B         ( "FIRST"                  ), // Port B position in cascade chain
.EN_AUTO_SLEEP_MODE      ( "FALSE"                  ), // Enable to automatically enter sleep mode
.EN_ECC_RD_A             ( "FALSE"                  ), // Port A ECC encoder
.EN_ECC_RD_B             ( "FALSE"                  ), // Port B ECC encoder
.EN_ECC_WR_A             ( "FALSE"                  ), // Port A ECC decoder
.EN_ECC_WR_B             ( "FALSE"                  ), // Port B ECC decoder
.IREG_PRE_A              ( "TRUE"                   ), // Optional Port A input pipeline registers
.IREG_PRE_B              ( "FALSE"                  ), // Optional Port B input pipeline registers
.IS_CLK_INVERTED         ( 1'b0                     ), // Optional inverter for CLK
.IS_EN_A_INVERTED        ( 1'b0                     ), // Optional inverter for Port A enable
.IS_EN_B_INVERTED        ( 1'b0                     ), // Optional inverter for Port B enable
.IS_RDB_WR_A_INVERTED    ( 1'b0                     ), // Optional inverter for Port A read/write select
.IS_RDB_WR_B_INVERTED    ( 1'b0                     ), // Optional inverter for Port B read/write select
.IS_RST_A_INVERTED       ( 1'b0                     ), // Optional inverter for Port A reset
.IS_RST_B_INVERTED       ( 1'b0                     ), // Optional inverter for Port B reset
.MATRIX_ID               ( "NONE"                   ),
.NUM_UNIQUE_SELF_ADDR_A  ( 1                        ),
.NUM_UNIQUE_SELF_ADDR_B  ( 1                        ),
.NUM_URAM_IN_MATRIX      ( 1                        ),
.OREG_A                  ( "FALSE"                  ), // Optional Port A output pipeline registers
.OREG_B                  ( "TRUE"                   ), // Optional Port B output pipeline registers
.OREG_ECC_A              ( "FALSE"                  ), // Port A ECC decoder output
.OREG_ECC_B              ( "FALSE"                  ), // Port B output ECC decoder
.REG_CAS_A               ( "TRUE"                   ), // Optional Port A cascade register
.REG_CAS_B               ( "TRUE"                   ), // Optional Port B cascade register
.RST_MODE_A              ( "SYNC"                   ), // Port A reset mode
.RST_MODE_B              ( "SYNC"                   ), // Port B reset mode
.SELF_ADDR_A             ( 11'h000                  ), // Port A self-address value
.SELF_ADDR_B             ( 11'h000                  ), // Port B self-address value
.SELF_MASK_A             ( 11'h7ff                  ), // Port A self-address mask
.SELF_MASK_B             ( 11'h7ff                  ), // Port B self-address mask
.USE_EXT_CE_A            ( "FALSE"                  ), // Enable Port A external CE inputs for output registers
.USE_EXT_CE_B            ( "FALSE"                  )  // Enable Port B external CE inputs for output registers
)
URAM288_inst_first (
.CAS_OUT_ADDR_A          ( CAS_OUT_ADDR_A    [0]    ), // 23-bit output: Port A cascade output address
.CAS_OUT_ADDR_B          ( CAS_OUT_ADDR_B    [0]    ), // 23-bit output: Port B cascade output address
.CAS_OUT_BWE_A           ( CAS_OUT_BWE_A     [0]    ), // 9-bit output: Port A cascade Byte-write enable output
.CAS_OUT_BWE_B           ( CAS_OUT_BWE_B     [0]    ), // 9-bit output: Port B cascade Byte-write enable output
.CAS_OUT_DBITERR_A       ( CAS_OUT_DBITERR_A [0]    ), // 1-bit output: Port A cascade double-bit error flag output
.CAS_OUT_DBITERR_B       ( CAS_OUT_DBITERR_B [0]    ), // 1-bit output: Port B cascade double-bit error flag output
.CAS_OUT_DIN_A           ( CAS_OUT_DIN_A     [0]    ), // 72-bit output: Port A cascade output write mode data
.CAS_OUT_DIN_B           ( CAS_OUT_DIN_B     [0]    ), // 72-bit output: Port B cascade output write mode data
.CAS_OUT_DOUT_A          ( CAS_OUT_DOUT_A    [0]    ), // 72-bit output: Port A cascade output read mode data
.CAS_OUT_DOUT_B          ( CAS_OUT_DOUT_B    [0]    ), // 72-bit output: Port B cascade output read mode data
.CAS_OUT_EN_A            ( CAS_OUT_EN_A      [0]    ), // 1-bit output: Port A cascade output enable
.CAS_OUT_EN_B            ( CAS_OUT_EN_B      [0]    ), // 1-bit output: Port B cascade output enable
.CAS_OUT_RDACCESS_A      ( CAS_OUT_RDACCESS_A[0]    ), // 1-bit output: Port A cascade read status output
.CAS_OUT_RDACCESS_B      ( CAS_OUT_RDACCESS_B[0]    ), // 1-bit output: Port B cascade read status output
.CAS_OUT_RDB_WR_A        ( CAS_OUT_RDB_WR_A  [0]    ), // 1-bit output: Port A cascade read/write select output
.CAS_OUT_RDB_WR_B        ( CAS_OUT_RDB_WR_B  [0]    ), // 1-bit output: Port B cascade read/write select output
.CAS_OUT_SBITERR_A       ( CAS_OUT_SBITERR_A [0]    ), // 1-bit output: Port A cascade single-bit error flag output
.CAS_OUT_SBITERR_B       ( CAS_OUT_SBITERR_B [0]    ), // 1-bit output: Port B cascade single-bit error flag output
.DBITERR_A               (                          ), // 1-bit output: Port A double-bit error flag status
.DBITERR_B               (                          ), // 1-bit output: Port B double-bit error flag status
.DOUT_A                  (                          ), // 72-bit output: Port A read data output
.DOUT_B                  (                          ), // 72-bit output: Port B read data output
.RDACCESS_A              (                          ), // 1-bit output: Port A read status
.RDACCESS_B              (                          ), // 1-bit output: Port B read status
.SBITERR_A               (                          ), // 1-bit output: Port A single-bit error flag status
.SBITERR_B               (                          ), // 1-bit output: Port B single-bit error flag status
.ADDR_A                  ( {'b0,iv_waddr}          ), // 23-bit input: Port A address
.ADDR_B                  ( {'b0,iv_raddr}          ), // 23-bit input: Port B address
//.BWE_A                   ( 9'h0ff                   ), // 9-bit input: Port A Byte-write enable
.BWE_A                   ( w_biten                  ), // 9-bit input: Port A Byte-write enable
.BWE_B                   ( 9'd0                     ), // 9-bit input: Port B Byte-write enable
.CAS_IN_ADDR_A           ( 23'd0                    ), // 23-bit input: Port A cascade input address
.CAS_IN_ADDR_B           ( 23'd0                    ), // 23-bit input: Port B cascade input address
.CAS_IN_BWE_A            ( 9'd0                     ), // 9-bit input: Port A cascade Byte-write enable input
.CAS_IN_BWE_B            ( 9'd0                     ), // 9-bit input: Port B cascade Byte-write enable input
.CAS_IN_DBITERR_A        ( 1'b0                     ), // 1-bit input: Port A cascade double-bit error flag input
.CAS_IN_DBITERR_B        ( 1'b0                     ), // 1-bit input: Port B cascade double-bit error flag input
.CAS_IN_DIN_A            ( 72'd0                    ), // 72-bit input: Port A cascade input write mode data
.CAS_IN_DIN_B            ( 72'd0                    ), // 72-bit input: Port B cascade input write mode data
.CAS_IN_DOUT_A           ( 72'd0                    ), // 72-bit input: Port A cascade input read mode data
.CAS_IN_DOUT_B           ( 72'd0                    ), // 72-bit input: Port B cascade input read mode data
.CAS_IN_EN_A             ( 1'b0                     ), // 1-bit input: Port A cascade enable input
.CAS_IN_EN_B             ( 1'b0                     ), // 1-bit input: Port B cascade enable input
.CAS_IN_RDACCESS_A       ( 1'b0                     ), // 1-bit input: Port A cascade read status input
.CAS_IN_RDACCESS_B       ( 1'b0                     ), // 1-bit input: Port B cascade read status input
.CAS_IN_RDB_WR_A         ( 1'b0                     ), // 1-bit input: Port A cascade read/write select input
.CAS_IN_RDB_WR_B         ( 1'b0                     ), // 1-bit input: Port A cascade read/write select input
.CAS_IN_SBITERR_A        ( 1'b0                     ), // 1-bit input: Port A cascade single-bit error flag input
.CAS_IN_SBITERR_B        ( 1'b0                     ), // 1-bit input: Port B cascade single-bit error flag input
.CLK                     ( clk                      ), // 1-bit input: Clock source
.DIN_A                   ( iv_wdata          		), // 72-bit input: Port A write data input
.DIN_B                   ( 72'd0                    ), // 72-bit input: Port B write data input
.EN_A                    ( i_wena                   ), // 1-bit input: Port A enable
.EN_B                    ( i_renb                   ), // 1-bit input: Port B enable
.INJECT_DBITERR_A        ( 1'b0                     ), // 1-bit input: Port A double-bit error injection
.INJECT_DBITERR_B        ( 1'b0                     ), // 1-bit input: Port B double-bit error injection
.INJECT_SBITERR_A        ( 1'b0                     ), // 1-bit input: Port A single-bit error injection
.INJECT_SBITERR_B        ( 1'b0                     ), // 1-bit input: Port B single-bit error injection
.OREG_CE_A               ( 1'b0                     ), // 1-bit input: Port A output register clock enable
.OREG_CE_B               ( 1'b1                     ), // 1-bit input: Port B output register clock enable
.OREG_ECC_CE_A           ( 1'b0                     ), // 1-bit input: Port A ECC decoder output register clock enable
.OREG_ECC_CE_B           ( 1'b0                     ), // 1-bit input: Port B ECC decoder output register clock enable
.RDB_WR_A                ( 1'b1                     ), // 1-bit input: Port A read/write select
.RDB_WR_B                ( 1'b0                     ), // 1-bit input: Port B read/write select
.RST_A                   ( 1'b0                      ), // 1-bit input: Port A asynchronous or synchronous reset for output registers
.RST_B                   ( 1'b0                      ), // 1-bit input: Port B asynchronous or synchronous reset for output registers
.SLEEP                   ( 1'b0                    )); // 1-bit input: Dynamic power gating control

genvar i;
generate
  for(i=1; i<=URAM_NUM-2; i=i+1) begin: URAM288_loop
    URAM288 #(
    .AUTO_SLEEP_LATENCY      ( 8                                  ), // Latency requirement to enter sleep mode
    .AVG_CONS_INACTIVE_CYCLES( 10                                 ), // Average concecutive inactive cycles when is SLEEP mode for power estimation
    .BWE_MODE_A              ( "PARITY_INTERLEAVED"               ), // Port A Byte write control
    .BWE_MODE_B              ( "PARITY_INTERLEAVED"               ), // Port B Byte write control
    .CASCADE_ORDER_A         ( "MIDDLE"                           ), // Port A position in cascade chain
    .CASCADE_ORDER_B         ( "MIDDLE"                           ), // Port B position in cascade chain
    .EN_AUTO_SLEEP_MODE      ( "FALSE"                            ), // Enable to automatically enter sleep mode
    .EN_ECC_RD_A             ( "FALSE"                            ), // Port A ECC encoder
    .EN_ECC_RD_B             ( "FALSE"                            ), // Port B ECC encoder
    .EN_ECC_WR_A             ( "FALSE"                            ), // Port A ECC decoder
    .EN_ECC_WR_B             ( "FALSE"                            ), // Port B ECC decoder
    .IREG_PRE_A              ( "TRUE"                             ), // Optional Port A input pipeline registers
    .IREG_PRE_B              ( "FALSE"                            ), // Optional Port B input pipeline registers
    .IS_CLK_INVERTED         ( 1'b0                               ), // Optional inverter for CLK
    .IS_EN_A_INVERTED        ( 1'b0                               ), // Optional inverter for Port A enable
    .IS_EN_B_INVERTED        ( 1'b0                               ), // Optional inverter for Port B enable
    .IS_RDB_WR_A_INVERTED    ( 1'b0                               ), // Optional inverter for Port A read/write select
    .IS_RDB_WR_B_INVERTED    ( 1'b0                               ), // Optional inverter for Port B read/write select
    .IS_RST_A_INVERTED       ( 1'b0                               ), // Optional inverter for Port A reset
    .IS_RST_B_INVERTED       ( 1'b0                               ), // Optional inverter for Port B reset
    .MATRIX_ID               ( "NONE"                             ),
    .NUM_UNIQUE_SELF_ADDR_A  ( 1                                  ),
    .NUM_UNIQUE_SELF_ADDR_B  ( 1                                  ),
    .NUM_URAM_IN_MATRIX      ( 1                                  ),
    .OREG_A                  ( "FALSE"                            ), // Optional Port A output pipeline registers
    .OREG_B                  ( "TRUE"                             ), // Optional Port B output pipeline registers
    .OREG_ECC_A              ( "FALSE"                            ), // Port A ECC decoder output
    .OREG_ECC_B              ( "FALSE"                            ), // Port B output ECC decoder
    .REG_CAS_A               ( "TRUE"                             ), // Optional Port A cascade register
    .REG_CAS_B               ( "TRUE"                             ), // Optional Port B cascade register
    .RST_MODE_A              ( "SYNC"                             ), // Port A reset mode
    .RST_MODE_B              ( "SYNC"                             ), // Port B reset mode
    .SELF_ADDR_A             ( i[10:0]                            ), // Port A self-address value
    .SELF_ADDR_B             ( i[10:0]                            ), // Port B self-address value
    .SELF_MASK_A             ( 11'h7ff                            ), // Port A self-address mask
    .SELF_MASK_B             ( 11'h7ff                            ), // Port B self-address mask
    .USE_EXT_CE_A            ( "FALSE"                            ), // Enable Port A external CE inputs for output registers
    .USE_EXT_CE_B            ( "FALSE"                            )  // Enable Port B external CE inputs for output registers
    )
    URAM288_inst_middle (
    .CAS_OUT_ADDR_A          ( CAS_OUT_ADDR_A    [i]              ), // 23-bit output: Port A cascade output address
    .CAS_OUT_ADDR_B          ( CAS_OUT_ADDR_B    [i]              ), // 23-bit output: Port B cascade output address
    .CAS_OUT_BWE_A           ( CAS_OUT_BWE_A     [i]              ), // 9-bit output: Port A cascade Byte-write enable output
    .CAS_OUT_BWE_B           ( CAS_OUT_BWE_B     [i]              ), // 9-bit output: Port B cascade Byte-write enable output
    .CAS_OUT_DBITERR_A       ( CAS_OUT_DBITERR_A [i]              ), // 1-bit output: Port A cascade double-bit error flag output
    .CAS_OUT_DBITERR_B       ( CAS_OUT_DBITERR_B [i]              ), // 1-bit output: Port B cascade double-bit error flag output
    .CAS_OUT_DIN_A           ( CAS_OUT_DIN_A     [i]              ), // 72-bit output: Port A cascade output write mode data
    .CAS_OUT_DIN_B           ( CAS_OUT_DIN_B     [i]              ), // 72-bit output: Port B cascade output write mode data
    .CAS_OUT_DOUT_A          ( CAS_OUT_DOUT_A    [i]              ), // 72-bit output: Port A cascade output read mode data
    .CAS_OUT_DOUT_B          ( CAS_OUT_DOUT_B    [i]              ), // 72-bit output: Port B cascade output read mode data
    .CAS_OUT_EN_A            ( CAS_OUT_EN_A      [i]              ), // 1-bit output: Port A cascade output enable
    .CAS_OUT_EN_B            ( CAS_OUT_EN_B      [i]              ), // 1-bit output: Port B cascade output enable
    .CAS_OUT_RDACCESS_A      ( CAS_OUT_RDACCESS_A[i]              ), // 1-bit output: Port A cascade read status output
    .CAS_OUT_RDACCESS_B      ( CAS_OUT_RDACCESS_B[i]              ), // 1-bit output: Port B cascade read status output
    .CAS_OUT_RDB_WR_A        ( CAS_OUT_RDB_WR_A  [i]              ), // 1-bit output: Port A cascade read/write select output
    .CAS_OUT_RDB_WR_B        ( CAS_OUT_RDB_WR_B  [i]              ), // 1-bit output: Port B cascade read/write select output
    .CAS_OUT_SBITERR_A       ( CAS_OUT_SBITERR_A [i]              ), // 1-bit output: Port A cascade single-bit error flag output
    .CAS_OUT_SBITERR_B       ( CAS_OUT_SBITERR_B [i]              ), // 1-bit output: Port B cascade single-bit error flag output
    .DBITERR_A               (                                    ), // 1-bit output: Port A double-bit error flag status
    .DBITERR_B               (                                    ), // 1-bit output: Port B double-bit error flag status
    .DOUT_A                  (                                    ), // 72-bit output: Port A read data output
    .DOUT_B                  (                                    ), // 72-bit output: Port B read data output
    .RDACCESS_A              (                                    ), // 1-bit output: Port A read status
    .RDACCESS_B              (                                    ), // 1-bit output: Port B read status
    .SBITERR_A               (                                    ), // 1-bit output: Port A single-bit error flag status
    .SBITERR_B               (                                    ), // 1-bit output: Port B single-bit error flag status
    .ADDR_A                  ( {'b0,iv_waddr}                    ), // 23-bit input: Port A address
    .ADDR_B                  ( {'b0,iv_raddr}                    ), // 23-bit input: Port B address
    .BWE_A                   ( 9'h1ff                             ), // 9-bit input: Port A Byte-write enable
    .BWE_B                   ( 9'd0                               ), // 9-bit input: Port B Byte-write enable
    .CAS_IN_ADDR_A           ( CAS_OUT_ADDR_A    [i-1]            ), // 23-bit input: Port A cascade input address
    .CAS_IN_ADDR_B           ( CAS_OUT_ADDR_B    [i-1]            ), // 23-bit input: Port B cascade input address
    .CAS_IN_BWE_A            ( CAS_OUT_BWE_A     [i-1]            ), // 9-bit input: Port A cascade Byte-write enable input
    .CAS_IN_BWE_B            ( CAS_OUT_BWE_B     [i-1]            ), // 9-bit input: Port B cascade Byte-write enable input
    .CAS_IN_DBITERR_A        ( CAS_OUT_DBITERR_A [i-1]            ), // 1-bit input: Port A cascade double-bit error flag input
    .CAS_IN_DBITERR_B        ( CAS_OUT_DBITERR_B [i-1]            ), // 1-bit input: Port B cascade double-bit error flag input
    .CAS_IN_DIN_A            ( CAS_OUT_DIN_A     [i-1]            ), // 72-bit input: Port A cascade input write mode data
    .CAS_IN_DIN_B            ( CAS_OUT_DIN_B     [i-1]            ), // 72-bit input: Port B cascade input write mode data
    .CAS_IN_DOUT_A           ( CAS_OUT_DOUT_A    [i-1]            ), // 72-bit input: Port A cascade input read mode data
    .CAS_IN_DOUT_B           ( CAS_OUT_DOUT_B    [i-1]            ), // 72-bit input: Port B cascade input read mode data
    .CAS_IN_EN_A             ( CAS_OUT_EN_A      [i-1]            ), // 1-bit input: Port A cascade enable input
    .CAS_IN_EN_B             ( CAS_OUT_EN_B      [i-1]            ), // 1-bit input: Port B cascade enable input
    .CAS_IN_RDACCESS_A       ( CAS_OUT_RDACCESS_A[i-1]            ), // 1-bit input: Port A cascade read status input
    .CAS_IN_RDACCESS_B       ( CAS_OUT_RDACCESS_B[i-1]            ), // 1-bit input: Port B cascade read status input
    .CAS_IN_RDB_WR_A         ( CAS_OUT_RDB_WR_A  [i-1]            ), // 1-bit input: Port A cascade read/write select input
    .CAS_IN_RDB_WR_B         ( CAS_OUT_RDB_WR_B  [i-1]            ), // 1-bit input: Port A cascade read/write select input
    .CAS_IN_SBITERR_A        ( CAS_OUT_SBITERR_A [i-1]            ), // 1-bit input: Port A cascade single-bit error flag input
    .CAS_IN_SBITERR_B        ( CAS_OUT_SBITERR_B [i-1]            ), // 1-bit input: Port B cascade single-bit error flag input
    .CLK                     ( clk                                ), // 1-bit input: Clock source
    .DIN_A                   ( iv_wdata          				  ), // 72-bit input: Port A write data input
    .DIN_B                   ( 72'd0                              ), // 72-bit input: Port B write data input
    .EN_A                    ( i_wena                             ), // 1-bit input: Port A enable
    .EN_B                    ( i_renb                             ), // 1-bit input: Port B enable
    .INJECT_DBITERR_A        ( 1'b0                               ), // 1-bit input: Port A double-bit error injection
    .INJECT_DBITERR_B        ( 1'b0                               ), // 1-bit input: Port B double-bit error injection
    .INJECT_SBITERR_A        ( 1'b0                               ), // 1-bit input: Port A single-bit error injection
    .INJECT_SBITERR_B        ( 1'b0                               ), // 1-bit input: Port B single-bit error injection
    .OREG_CE_A               ( 1'b0                               ), // 1-bit input: Port A output register clock enable
    .OREG_CE_B               ( 1'b1                               ), // 1-bit input: Port B output register clock enable
    .OREG_ECC_CE_A           ( 1'b0                               ), // 1-bit input: Port A ECC decoder output register clock enable
    .OREG_ECC_CE_B           ( 1'b0                               ), // 1-bit input: Port B ECC decoder output register clock enable
    .RDB_WR_A                ( 1'b1                               ), // 1-bit input: Port A read/write select
    .RDB_WR_B                ( 1'b0                               ), // 1-bit input: Port B read/write select
    .RST_A                   ( 1'b0                                ), // 1-bit input: Port A asynchronous or synchronous reset for output registers
    .RST_B                   ( 1'b0                                ), // 1-bit input: Port B asynchronous or synchronous reset for output registers
    .SLEEP                   ( 1'b0                              )); // 1-bit input: Dynamic power gating control
  end
endgenerate


URAM288 #(
.AUTO_SLEEP_LATENCY      ( 8                        ), // Latency requirement to enter sleep mode
.AVG_CONS_INACTIVE_CYCLES( 10                       ), // Average concecutive inactive cycles when is SLEEP mode for power estimation
.BWE_MODE_A              ( "PARITY_INTERLEAVED"     ), // Port A Byte write control
.BWE_MODE_B              ( "PARITY_INTERLEAVED"     ), // Port B Byte write control
.CASCADE_ORDER_A         ( "LAST"                   ), // Port A position in cascade chain
.CASCADE_ORDER_B         ( "LAST"                   ), // Port B position in cascade chain
.EN_AUTO_SLEEP_MODE      ( "FALSE"                  ), // Enable to automatically enter sleep mode
.EN_ECC_RD_A             ( "FALSE"                  ), // Port A ECC encoder
.EN_ECC_RD_B             ( "FALSE"                  ), // Port B ECC encoder
.EN_ECC_WR_A             ( "FALSE"                  ), // Port A ECC decoder
.EN_ECC_WR_B             ( "FALSE"                  ), // Port B ECC decoder
.IREG_PRE_A              ( "TRUE"                   ), // Optional Port A input pipeline registers
.IREG_PRE_B              ( "FALSE"                  ), // Optional Port B input pipeline registers
.IS_CLK_INVERTED         ( 1'b0                     ), // Optional inverter for CLK
.IS_EN_A_INVERTED        ( 1'b0                     ), // Optional inverter for Port A enable
.IS_EN_B_INVERTED        ( 1'b0                     ), // Optional inverter for Port B enable
.IS_RDB_WR_A_INVERTED    ( 1'b0                     ), // Optional inverter for Port A read/write select
.IS_RDB_WR_B_INVERTED    ( 1'b0                     ), // Optional inverter for Port B read/write select
.IS_RST_A_INVERTED       ( 1'b0                     ), // Optional inverter for Port A reset
.IS_RST_B_INVERTED       ( 1'b0                     ), // Optional inverter for Port B reset
.MATRIX_ID               ( "NONE"                   ),
.NUM_UNIQUE_SELF_ADDR_A  ( 1                        ),
.NUM_UNIQUE_SELF_ADDR_B  ( 1                        ),
.NUM_URAM_IN_MATRIX      ( 1                        ),
.OREG_A                  ( "FALSE"                  ), // Optional Port A output pipeline registers
.OREG_B                  ( "TRUE"                   ), // Optional Port B output pipeline registers
.OREG_ECC_A              ( "FALSE"                  ), // Port A ECC decoder output
.OREG_ECC_B              ( "FALSE"                  ), // Port B output ECC decoder
.REG_CAS_A               ( "TRUE"                   ), // Optional Port A cascade register
.REG_CAS_B               ( "TRUE"                   ), // Optional Port B cascade register
.RST_MODE_A              ( "SYNC"                   ), // Port A reset mode
.RST_MODE_B              ( "SYNC"                   ), // Port B reset mode
.SELF_ADDR_A             ( URAM_NUM-1                  ), // Port A self-address value
.SELF_ADDR_B             ( URAM_NUM-1                  ), // Port B self-address value
.SELF_MASK_A             ( 11'h7ff                  ), // Port A self-address mask
.SELF_MASK_B             ( 11'h7ff                  ), // Port B self-address mask
.USE_EXT_CE_A            ( "FALSE"                  ), // Enable Port A external CE inputs for output registers
.USE_EXT_CE_B            ( "FALSE"                  )  // Enable Port B external CE inputs for output registers
)
URAM288_inst_last (
.CAS_OUT_ADDR_A          (                          ), // 23-bit output: Port A cascade output address
.CAS_OUT_ADDR_B          (                          ), // 23-bit output: Port B cascade output address
.CAS_OUT_BWE_A           (                          ), // 9-bit output: Port A cascade Byte-write enable output
.CAS_OUT_BWE_B           (                          ), // 9-bit output: Port B cascade Byte-write enable output
.CAS_OUT_DBITERR_A       (                          ), // 1-bit output: Port A cascade double-bit error flag output
.CAS_OUT_DBITERR_B       (                          ), // 1-bit output: Port B cascade double-bit error flag output
.CAS_OUT_DIN_A           (                          ), // 72-bit output: Port A cascade output write mode data
.CAS_OUT_DIN_B           (                          ), // 72-bit output: Port B cascade output write mode data
.CAS_OUT_DOUT_A          (                          ), // 72-bit output: Port A cascade output read mode data
.CAS_OUT_DOUT_B          (                          ), // 72-bit output: Port B cascade output read mode data
.CAS_OUT_EN_A            (                          ), // 1-bit output: Port A cascade output enable
.CAS_OUT_EN_B            (                          ), // 1-bit output: Port B cascade output enable
.CAS_OUT_RDACCESS_A      (                          ), // 1-bit output: Port A cascade read status output
.CAS_OUT_RDACCESS_B      (                          ), // 1-bit output: Port B cascade read status output
.CAS_OUT_RDB_WR_A        (                          ), // 1-bit output: Port A cascade read/write select output
.CAS_OUT_RDB_WR_B        (                          ), // 1-bit output: Port B cascade read/write select output
.CAS_OUT_SBITERR_A       (                          ), // 1-bit output: Port A cascade single-bit error flag output
.CAS_OUT_SBITERR_B       (                          ), // 1-bit output: Port B cascade single-bit error flag output
.DBITERR_A               (                          ), // 1-bit output: Port A double-bit error flag status
.DBITERR_B               (                          ), // 1-bit output: Port B double-bit error flag status
.DOUT_A                  (                          ), // 72-bit output: Port A read data output
.DOUT_B                  ( doutb                    ), // 72-bit output: Port B read data output
.RDACCESS_A              (                          ), // 1-bit output: Port A read status
.RDACCESS_B              (                          ), // 1-bit output: Port B read status
.SBITERR_A               (                          ), // 1-bit output: Port A single-bit error flag status
.SBITERR_B               (                          ), // 1-bit output: Port B single-bit error flag status
.ADDR_A                  ( {'b0,iv_waddr}          ), // 23-bit input: Port A address
.ADDR_B                  ( {'b0,iv_raddr}          ), // 23-bit input: Port B address
.BWE_A                   ( 9'h1ff                   ), // 9-bit input: Port A Byte-write enable
.BWE_B                   ( 9'd0                     ), // 9-bit input: Port B Byte-write enable
.CAS_IN_ADDR_A           ( CAS_OUT_ADDR_A    [URAM_NUM-2]    ), // 23-bit input: Port A cascade input address
.CAS_IN_ADDR_B           ( CAS_OUT_ADDR_B    [URAM_NUM-2]    ), // 23-bit input: Port B cascade input address
.CAS_IN_BWE_A            ( CAS_OUT_BWE_A     [URAM_NUM-2]    ), // 9-bit input: Port A cascade Byte-write enable input
.CAS_IN_BWE_B            ( CAS_OUT_BWE_B     [URAM_NUM-2]    ), // 9-bit input: Port B cascade Byte-write enable input
.CAS_IN_DBITERR_A        ( CAS_OUT_DBITERR_A [URAM_NUM-2]    ), // 1-bit input: Port A cascade double-bit error flag input
.CAS_IN_DBITERR_B        ( CAS_OUT_DBITERR_B [URAM_NUM-2]    ), // 1-bit input: Port B cascade double-bit error flag input
.CAS_IN_DIN_A            ( CAS_OUT_DIN_A     [URAM_NUM-2]    ), // 72-bit input: Port A cascade input write mode data
.CAS_IN_DIN_B            ( CAS_OUT_DIN_B     [URAM_NUM-2]    ), // 72-bit input: Port B cascade input write mode data
.CAS_IN_DOUT_A           ( CAS_OUT_DOUT_A    [URAM_NUM-2]    ), // 72-bit input: Port A cascade input read mode data
.CAS_IN_DOUT_B           ( CAS_OUT_DOUT_B    [URAM_NUM-2]    ), // 72-bit input: Port B cascade input read mode data
.CAS_IN_EN_A             ( CAS_OUT_EN_A      [URAM_NUM-2]    ), // 1-bit input: Port A cascade enable input
.CAS_IN_EN_B             ( CAS_OUT_EN_B      [URAM_NUM-2]    ), // 1-bit input: Port B cascade enable input
.CAS_IN_RDACCESS_A       ( CAS_OUT_RDACCESS_A[URAM_NUM-2]    ), // 1-bit input: Port A cascade read status input
.CAS_IN_RDACCESS_B       ( CAS_OUT_RDACCESS_B[URAM_NUM-2]    ), // 1-bit input: Port B cascade read status input
.CAS_IN_RDB_WR_A         ( CAS_OUT_RDB_WR_A  [URAM_NUM-2]    ), // 1-bit input: Port A cascade read/write select input
.CAS_IN_RDB_WR_B         ( CAS_OUT_RDB_WR_B  [URAM_NUM-2]    ), // 1-bit input: Port A cascade read/write select input
.CAS_IN_SBITERR_A        ( CAS_OUT_SBITERR_A [URAM_NUM-2]    ), // 1-bit input: Port A cascade single-bit error flag input
.CAS_IN_SBITERR_B        ( CAS_OUT_SBITERR_B [URAM_NUM-2]    ), // 1-bit input: Port B cascade single-bit error flag input
.CLK                     ( clk                      ), // 1-bit input: Clock source
.DIN_A                   ( iv_wdata			        ), // 72-bit input: Port A write data input
.DIN_B                   ( 72'd0                    ), // 72-bit input: Port B write data input
.EN_A                    ( i_wena                   ), // 1-bit input: Port A enable
.EN_B                    ( i_renb                   ), // 1-bit input: Port B enable
.INJECT_DBITERR_A        ( 1'b0                     ), // 1-bit input: Port A double-bit error injection
.INJECT_DBITERR_B        ( 1'b0                     ), // 1-bit input: Port B double-bit error injection
.INJECT_SBITERR_A        ( 1'b0                     ), // 1-bit input: Port A single-bit error injection
.INJECT_SBITERR_B        ( 1'b0                     ), // 1-bit input: Port B single-bit error injection
.OREG_CE_A               ( 1'b0                     ), // 1-bit input: Port A output register clock enable
.OREG_CE_B               ( 1'b1                     ), // 1-bit input: Port B output register clock enable
.OREG_ECC_CE_A           ( 1'b0                     ), // 1-bit input: Port A ECC decoder output register clock enable
.OREG_ECC_CE_B           ( 1'b0                     ), // 1-bit input: Port B ECC decoder output register clock enable
.RDB_WR_A                ( 1'b1                     ), // 1-bit input: Port A read/write select
.RDB_WR_B                ( 1'b0                     ), // 1-bit input: Port B read/write select
.RST_A                   ( 1'b0                      ), // 1-bit input: Port A asynchronous or synchronous reset for output registers
.RST_B                   ( 1'b0                      ), // 1-bit input: Port B asynchronous or synchronous reset for output registers
.SLEEP                   ( 1'b0                    )); // 1-bit input: Dynamic power gating control

endmodule