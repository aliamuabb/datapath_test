//Module Name:              ddc_agc.v
//Department:               Beijing R&D Center FPGA Design Dept
//Function Description:
//--------------------------------------------------------------
//Version       Design       Coding         Simulate          Review          Reldata
//V1.0          zhangshihao  zhangshiaho                                                      2018-06-12
//-----------------------------------------------------------------
//Version               Modified History
//V1.0
//--------------------------------Key words--------------------------
//
`timescale 1ns / 100ps
//`include "agc_round.v"
module ddc_agc (
input wire [1:0] ddc_agc_6db_sel,
input wire signed [17:0] ddc_data_i,
input wire signed [17:0] ddc_data_q,
input wire signed [16:0] ddc_agc_value,
input wire ddc_agc_rst,
input wire ddc_agc_clk,
output wire signed [14:0] ddc_agc_data_i,
output wire signed [14:0] ddc_agc_data_q
);

wire signed [35:0] mult_out_i;
wire signed [35:0] mult_out_q;

ddc_agc_dsp48 DSP48_i0 (
    .A       (ddc_data_i            ),      //   input,  width = 18,
    .B       ({1'b0, ddc_agc_value} ),      //   input,  width = 18,
    .CLK     (ddc_agc_clk           ),      //   input,   width = 1,
    .SCLR    (ddc_agc_rst           ),      //   input,   width = 1,
    .CE      (1'b1                  ),      //   input,   width = 1,
    .P       (mult_out_i            )       //  output,  width = 36,
);

ddc_agc_dsp48 DSP48_q0 (
    .A       (ddc_data_q            ),      //   input,  width = 18,
    .B       ({1'b0, ddc_agc_value} ),      //   input,  width = 18,
    .CLK     (ddc_agc_clk           ),      //   input,   width = 1,
    .SCLR    (ddc_agc_rst           ),      //   input,   width = 1,
    .CE      (1'b1                  ),      //   input,   width = 1,
    .P       (mult_out_q            )       //  output,  width = 36,
);

agc_round_i agc_round_i0(
    .clk        (ddc_agc_clk    ),      //   input,   width = 1
    .db_sel     (ddc_agc_6db_sel),      //   input,   width = 3
    .data_in    (mult_out_i     ),      //   input,   width = 36
    .data_out   (ddc_agc_data_i )       //   input,   width = 15
);
agc_round_q agc_round_q0(
    .clk        (ddc_agc_clk    ),      //   input,   width = 1
    .db_sel     (ddc_agc_6db_sel),      //   input,   width = 3
    .data_in    (mult_out_q     ),      //   input,   width = 36
    .data_out   (ddc_agc_data_q )       //   input,   width = 15
);
endmodule

module agc_round_i (
input wire clk,
input wire [1:0] db_sel,
input wire signed [35:0] data_in,
output reg signed [14:0] data_out
);

reg [35:0] data_out_reg;
wire overflow_0;
wire overflow_1;
wire overflow_2;
wire b;
wire c;
wire overflow_out;

//db_sel:
//2'b00: 0  db
//2'b01: 6  db 
//2'b10: 12 db 
//2'b11: 18 db
always @ (posedge clk)
begin
    case( db_sel )
        2'h0:
            data_out_reg <= data_in[35:0];
        2'h1:
            data_out_reg <= {data_in[35], data_in[33:0], 1'h0};
        2'h2:
            data_out_reg <= {data_in[35], data_in[32:0], 2'h0};
        2'h3:
            data_out_reg <= {data_in[35], data_in[31:0], 3'h0};
        default:
            data_out_reg <= data_in[35:0];
    endcase
end

//round mode :unbiased
//overflow mode : saturate
assign b = !(|data_out_reg[17:0])&(&data_out_reg[19:18]);
assign c = (|data_out_reg[17:0])&data_out_reg[18];
assign overflow_out = (data_out_reg[35]^data_out_reg[34]) | (data_out_reg[35]^data_out_reg[33]) | (!data_out_reg[35]&(&data_out_reg[32:19]));
always @ (posedge clk)
begin
    if (overflow_out)
        data_out <= {data_out_reg[35], {14{data_out_reg[35]}}^14'h3fff};
    else
        if (b|c)
            data_out <= ({data_out_reg[35], data_out_reg[32:19]} + 1'b1);
        else
            data_out <= {data_out_reg[35], data_out_reg[32:19]};
end

endmodule

module agc_round_q (
input wire clk,
input wire [1:0] db_sel,
input wire signed [35:0] data_in,
output reg signed [14:0] data_out
);

reg [35:0] data_out_reg;
wire overflow_0;
wire overflow_1;
wire overflow_2;
wire b;
wire c;
wire overflow_out;

//db_sel:
//2'b00: 0  db
//2'b01: 6  db 
//2'b10: 12 db 
//2'b11: 18 db
always @ (posedge clk)
begin
    case( db_sel )
        2'h0:
            data_out_reg <= data_in[35:0];
        2'h1:
            data_out_reg <= {data_in[35], data_in[33:0], 1'h0};
        2'h2:
            data_out_reg <= {data_in[35], data_in[35], data_in[31:0], 2'h0};
        2'h3:
            data_out_reg <= {data_in[35], data_in[31:0], 3'h0};
        default:
            data_out_reg <= data_in[35:0];
    endcase
end

//round mode :unbiased
//overflow mode : saturate
assign b = !(|data_out_reg[17:0])&(&data_out_reg[19:18]);
assign c = (|data_out_reg[17:0])&data_out_reg[18];
assign overflow_out = (data_out_reg[35]^data_out_reg[34]) | (data_out_reg[35]^data_out_reg[33]) | (!data_out_reg[35]&(&data_out_reg[32:19]));
always @ (posedge clk)
begin
    if (overflow_out)
        data_out <= {data_out_reg[35], {14{data_out_reg[35]}}^14'h3fff};
    else
        if (b|c)
            data_out <= ({data_out_reg[35], data_out_reg[32:19]} + 1'b1);
        else
            data_out <= {data_out_reg[35], data_out_reg[32:19]};
end

endmodule