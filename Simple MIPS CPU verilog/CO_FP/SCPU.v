module SCPU(
    // Input signals
    clk,
    rst_n,
    in_valid,
    instruction,
    MEM_out,
    // Output signals
    busy,
    out_valid,
    out0,
    out1,
    out2,
    out3,
    out4,
    out5,
    out6,
    out7,
    out8,
    out9,
    out10,
    out11,
    out12,
    out13,
    out14,
    out15,
    WEN,
    ADDR,
    MEM_in
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [18:0] instruction;
output reg busy, out_valid;
output reg signed [15:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15;

input signed [15:0] MEM_out;
output reg WEN;
output reg signed [15:0] MEM_in;
output reg [12:0] ADDR;

//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//   Design Description
//---------------------------------------------------------------------


endmodule