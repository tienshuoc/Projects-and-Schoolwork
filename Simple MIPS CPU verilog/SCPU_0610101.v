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
output reg signed [15:0] out0, out1, out2, out3, out4, out5, out6, out7,
                         out8, out9, out10, out11, out12, out13, out14, out15;  //corresponds and checks the registers

input signed [15:0] MEM_out;
output reg WEN;  //load data from memory when high, write data to memory when low
output reg signed [15:0] MEM_in;    //used to write into memory
output reg [12:0] ADDR;     //memory address

//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------

wire [2:0] opcode = instruction[18:16];
wire [3:0] rs = instruction[15:12];
wire [3:0] rt = instruction[11:8];
wire [3:0] rd = instruction[7:4];
wire [3:0] rl = instruction[3:0];
wire [3:0] func = instruction[3:0];
wire signed [7:0] immediate = instruction[7:0];

reg signed [31:0] ALUresult;  //made wide enough for MULT and SQUARE


//16 registers
reg signed [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,
           reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15,
           rs_value, rt_value, rd_value, rl_value;


//DFF
reg DFF1out_valid, DFF2out_valid, DFF3out_valid, DFF4out_valid;
reg signed [15:0] DFF1rs_value, DFF1rt_value;
reg signed [7:0] DFF1immediate;
reg [7:0] DFF1immediate_unsigned;
reg signed [31:0] DFF2ALUresult, DFF3ALUresult;
reg [2:0] DFF1opcode, DFF2opcode, DFF3opcode;
reg [3:0] DFF1func;
reg [3:0] DFF1rd, DFF2rd, DFF3rd,
          DFF1rl, DFF2rl, DFF3rl,
          DFF1rt, DFF2rt, DFF3rt;

wire [12:0] base = DFF1rs_value[12:0];

//---------------------------------------------------------------------
//   Design Description
//---------------------------------------------------------------------

//combinational
always@(*) begin
//decoding registers, getting values of registers, rd & rl are not used for read
    case(rs)
        0: rs_value = reg0;  1: rs_value = reg1;  2: rs_value = reg2;  3: rs_value = reg3;
        4: rs_value = reg4;  5: rs_value = reg5;  6: rs_value = reg6;  7: rs_value = reg7;
        8: rs_value = reg8;  9: rs_value = reg9;  10: rs_value = reg10;  11: rs_value = reg11;
        12: rs_value = reg12;  13: rs_value = reg13;  14: rs_value = reg14;  15: rs_value = reg15;
    endcase
    case(rt)
        0: rt_value = reg0;  1: rt_value = reg1;  2: rt_value = reg2;  3: rt_value = reg3;
        4: rt_value = reg4;  5: rt_value = reg5;  6: rt_value = reg6;  7: rt_value = reg7;
        8: rt_value = reg8;  9: rt_value = reg9;  10: rt_value = reg10;  11: rt_value = reg11;
        12: rt_value = reg12;  13: rt_value = reg13;  14: rt_value = reg14;  15: rt_value = reg15;
    endcase
//ALU combinational circuit
    case(DFF1opcode)
        3'b000: begin
            case(DFF1func)
                4'b0000: ALUresult = DFF1rs_value & DFF1rt_value;
                4'b0001: ALUresult = DFF1rs_value | DFF1rt_value;
                4'b0010: ALUresult = DFF1rs_value ^ DFF1rt_value;
                4'b0011: ALUresult = DFF1rs_value + DFF1rt_value;
                4'b0100: ALUresult = DFF1rs_value - DFF1rt_value;
            endcase
        end
        3'b001: begin
            ALUresult = DFF1rs_value * DFF1rt_value;
        end
        3'b010: begin
            ALUresult = DFF1rs_value * DFF1rs_value;
        end
        3'b011: begin
            ALUresult = DFF1rs_value + DFF1immediate;
        end
        3'b100: begin
            ALUresult = DFF1rs_value - DFF1immediate;
        end
        3'b101: begin
            ALUresult = base + DFF1immediate_unsigned;      //the location of memory    
        end
        3'b110: begin
            ALUresult = base + DFF1immediate_unsigned;
        end
        default: ALUresult = 0;
    endcase
end
//sequential
always@(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin //reset and clear all outputs and DFFs
        //outputs
        busy <= 0;
        out_valid <= 0;
        out0 <= 0; out1 <= 0; out2 <= 0; out3 <= 0; out4 <= 0; out5 <= 0; out6 <= 0; out7 <= 0;
        out8 <= 0; out9 <= 0; out10 <= 0; out11 <= 0; out12 <= 0; out13 <= 0; out14 <= 0; out15 <=0;
        MEM_in <= 0;
        WEN <= 1;
        ADDR <= 0;
        //DFFs
        rs_value <= 0;
        rt_value <= 0;
        rd_value <= 0;
        rl_value <= 0;
        DFF1out_valid <= 0;
        DFF2out_valid <= 0;
        DFF3out_valid <= 0;
        DFF4out_valid <= 0;

        DFF1rs_value <= 0;
        DFF1rt_value <= 0;
        DFF1immediate <= 0;
        DFF1immediate_unsigned <= 0;
        DFF2ALUresult <= 0;
        DFF3ALUresult <= 0;
        DFF1opcode <= 0;
        DFF2opcode <= 0;
        DFF3opcode <= 0;
        DFF1func <= 0;
        DFF1rd <= 0; DFF2rd <= 0; DFF3rd <= 0;
        DFF1rl <= 0; DFF2rl <= 0; DFF3rl <= 0;
        DFF1rt <= 0; DFF2rt <= 0; DFF3rt <= 0;   
        ALUresult <= 0;

        //registers
        reg0 <= 0; reg1 <= 0; reg2 <= 0; reg3 <= 0; reg4 <= 0; reg5 <= 0; reg6 <= 0; reg7 <= 0;
        reg8 <= 0; reg9 <= 0; reg10 <= 0; reg11 <= 0; reg12 <= 0; reg13 <= 0; reg14 <= 0; reg15 <= 0;

    end
    else begin
        busy <= 0;
        //pipelining
        //DFFout_valid
        DFF1out_valid <= in_valid;
        DFF2out_valid <= DFF1out_valid;
        DFF3out_valid <= DFF2out_valid;
        DFF4out_valid <= DFF3out_valid;
        out_valid <= DFF4out_valid;

        out0 <= reg0; out1 <= reg1; out2  <= reg2;  out3  <= reg3;  out4  <= reg4;  out5  <= reg5;   out6 <= reg6;   out7 <= reg7;
        out8 <= reg8; out9 <= reg9; out10 <= reg10; out11 <= reg11; out12 <= reg12; out13 <= reg13; out14 <= reg14; out15 <= reg15;

        //first stage
        DFF1rs_value <= rs_value;
        DFF1rt_value <= rt_value;
        DFF1immediate <= immediate;
        DFF1immediate_unsigned <= immediate;
        DFF1opcode <= opcode;
        DFF1func <= func;
        DFF1rd <= rd;
        DFF1rl <= rl;
        DFF1rt <= rt;
        //second stage
        DFF2opcode <= DFF1opcode;
        DFF2rd <= DFF1rd;
        DFF2rl <= DFF1rl;
        DFF2rt <= DFF1rt;
        //third stage
        DFF3ALUresult <= DFF2ALUresult;
        DFF3opcode <= DFF2opcode;
        DFF3rd <= DFF2rd;
        DFF3rl <= DFF2rl;
        DFF3rt <= DFF2rt;

        //pre-MEM stage
        case(DFF1opcode)
            3'b000:
            begin
                DFF2ALUresult <= ALUresult;
            end
            3'b001:
            begin
                DFF2ALUresult <= ALUresult;
            end
            3'b010:
            begin
                DFF2ALUresult <= ALUresult; 
            end
            3'b011:
            begin
                DFF2ALUresult <= ALUresult; 
            end
            3'b100:
            begin
                DFF2ALUresult <= ALUresult; 
            end
            3'b101:
            begin
                WEN <= 0;   //store to memory
                ADDR <= ALUresult; //give memory address
                MEM_in <= DFF1rt_value;  //give value to store in memory
            end
            3'b110:
            begin
                WEN <= 1;
                ADDR <= ALUresult; //give memory address
            end
            default: DFF2ALUresult <= ALUresult;
        endcase

        //write to registers
        case(DFF3opcode)
            3'b000: begin
                case(DFF3rd)
                    0: reg0 <= DFF3ALUresult[15:0];
                    1: reg1 <= DFF3ALUresult[15:0];
                    2: reg2 <= DFF3ALUresult[15:0];
                    3: reg3 <= DFF3ALUresult[15:0];
                    4: reg4 <= DFF3ALUresult[15:0];
                    5: reg5 <= DFF3ALUresult[15:0];
                    6: reg6 <= DFF3ALUresult[15:0];
                    7: reg7 <= DFF3ALUresult[15:0];
                    8: reg8 <= DFF3ALUresult[15:0];
                    9: reg9 <= DFF3ALUresult[15:0];
                    10: reg10 <= DFF3ALUresult[15:0]; 
                    11: reg11 <= DFF3ALUresult[15:0];
                    12: reg12 <= DFF3ALUresult[15:0];
                    13: reg13 <= DFF3ALUresult[15:0];
                    14: reg14 <= DFF3ALUresult[15:0];
                    15: reg15 <= DFF3ALUresult[15:0];
                endcase
            end
            3'b001: begin
                case(DFF3rd)
                    0: reg0 <= DFF3ALUresult[31:16];
                    1: reg1 <= DFF3ALUresult[31:16];
                    2: reg2 <= DFF3ALUresult[31:16];
                    3: reg3 <= DFF3ALUresult[31:16];
                    4: reg4 <= DFF3ALUresult[31:16];
                    5: reg5 <= DFF3ALUresult[31:16];
                    6: reg6 <= DFF3ALUresult[31:16];
                    7: reg7 <= DFF3ALUresult[31:16];
                    8: reg8 <= DFF3ALUresult[31:16];
                    9: reg9 <= DFF3ALUresult[31:16];
                    10: reg10 <= DFF3ALUresult[31:16]; 
                    11: reg11 <= DFF3ALUresult[31:16];
                    12: reg12 <= DFF3ALUresult[31:16];
                    13: reg13 <= DFF3ALUresult[31:16];
                    14: reg14 <= DFF3ALUresult[31:16];
                    15: reg15 <= DFF3ALUresult[31:16];
                endcase
                case(DFF3rl)
                    0: reg0 <= DFF3ALUresult[15:0];
                    1: reg1 <= DFF3ALUresult[15:0];
                    2: reg2 <= DFF3ALUresult[15:0];
                    3: reg3 <= DFF3ALUresult[15:0];
                    4: reg4 <= DFF3ALUresult[15:0];
                    5: reg5 <= DFF3ALUresult[15:0];
                    6: reg6 <= DFF3ALUresult[15:0];
                    7: reg7 <= DFF3ALUresult[15:0];
                    8: reg8 <= DFF3ALUresult[15:0];
                    9: reg9 <= DFF3ALUresult[15:0];
                    10: reg10 <= DFF3ALUresult[15:0]; 
                    11: reg11 <= DFF3ALUresult[15:0];
                    12: reg12 <= DFF3ALUresult[15:0];
                    13: reg13 <= DFF3ALUresult[15:0];
                    14: reg14 <= DFF3ALUresult[15:0];
                    15: reg15 <= DFF3ALUresult[15:0];
                endcase
            end
            3'b010: begin
                case(DFF3rd)
                    0: reg0 <= DFF3ALUresult[31:16];
                    1: reg1 <= DFF3ALUresult[31:16];
                    2: reg2 <= DFF3ALUresult[31:16];
                    3: reg3 <= DFF3ALUresult[31:16];
                    4: reg4 <= DFF3ALUresult[31:16];
                    5: reg5 <= DFF3ALUresult[31:16];
                    6: reg6 <= DFF3ALUresult[31:16];
                    7: reg7 <= DFF3ALUresult[31:16];
                    8: reg8 <= DFF3ALUresult[31:16];
                    9: reg9 <= DFF3ALUresult[31:16];
                    10: reg10 <= DFF3ALUresult[31:16]; 
                    11: reg11 <= DFF3ALUresult[31:16];
                    12: reg12 <= DFF3ALUresult[31:16];
                    13: reg13 <= DFF3ALUresult[31:16];
                    14: reg14 <= DFF3ALUresult[31:16];
                    15: reg15 <= DFF3ALUresult[31:16];
                endcase
                case(DFF3rl)
                    0: reg0 <= DFF3ALUresult[15:0];
                    1: reg1 <= DFF3ALUresult[15:0];
                    2: reg2 <= DFF3ALUresult[15:0];
                    3: reg3 <= DFF3ALUresult[15:0];
                    4: reg4 <= DFF3ALUresult[15:0];
                    5: reg5 <= DFF3ALUresult[15:0];
                    6: reg6 <= DFF3ALUresult[15:0];
                    7: reg7 <= DFF3ALUresult[15:0];
                    8: reg8 <= DFF3ALUresult[15:0];
                    9: reg9 <= DFF3ALUresult[15:0];
                    10: reg10 <= DFF3ALUresult[15:0]; 
                    11: reg11 <= DFF3ALUresult[15:0];
                    12: reg12 <= DFF3ALUresult[15:0];
                    13: reg13 <= DFF3ALUresult[15:0];
                    14: reg14 <= DFF3ALUresult[15:0];
                    15: reg15 <= DFF3ALUresult[15:0];
                endcase
            end
            3'b011: begin
                case(DFF3rt)
                    0: reg0 <= DFF3ALUresult[15:0];
                    1: reg1 <= DFF3ALUresult[15:0];
                    2: reg2 <= DFF3ALUresult[15:0];
                    3: reg3 <= DFF3ALUresult[15:0];
                    4: reg4 <= DFF3ALUresult[15:0];
                    5: reg5 <= DFF3ALUresult[15:0];
                    6: reg6 <= DFF3ALUresult[15:0];
                    7: reg7 <= DFF3ALUresult[15:0];
                    8: reg8 <= DFF3ALUresult[15:0];
                    9: reg9 <= DFF3ALUresult[15:0];
                    10: reg10 <= DFF3ALUresult[15:0]; 
                    11: reg11 <= DFF3ALUresult[15:0];
                    12: reg12 <= DFF3ALUresult[15:0];
                    13: reg13 <= DFF3ALUresult[15:0];
                    14: reg14 <= DFF3ALUresult[15:0];
                    15: reg15 <= DFF3ALUresult[15:0];
                endcase
            end
            3'b100: begin
                case(DFF3rt)
                    0: reg0 <= DFF3ALUresult[15:0];
                    1: reg1 <= DFF3ALUresult[15:0];
                    2: reg2 <= DFF3ALUresult[15:0];
                    3: reg3 <= DFF3ALUresult[15:0];
                    4: reg4 <= DFF3ALUresult[15:0];
                    5: reg5 <= DFF3ALUresult[15:0];
                    6: reg6 <= DFF3ALUresult[15:0];
                    7: reg7 <= DFF3ALUresult[15:0];
                    8: reg8 <= DFF3ALUresult[15:0];
                    9: reg9 <= DFF3ALUresult[15:0];
                    10: reg10 <= DFF3ALUresult[15:0]; 
                    11: reg11 <= DFF3ALUresult[15:0];
                    12: reg12 <= DFF3ALUresult[15:0];
                    13: reg13 <= DFF3ALUresult[15:0];
                    14: reg14 <= DFF3ALUresult[15:0];
                    15: reg15 <= DFF3ALUresult[15:0];
                endcase
            end
            // 3'b101: 
            3'b110: begin
                case(DFF3rt)
                    0: reg0 <= MEM_out;
                    1: reg1 <= MEM_out;
                    2: reg2 <= MEM_out;
                    3: reg3 <= MEM_out;
                    4: reg4 <= MEM_out;
                    5: reg5 <= MEM_out;
                    6: reg6 <= MEM_out;
                    7: reg7 <= MEM_out;
                    8: reg8 <= MEM_out;
                    9: reg9 <= MEM_out;
                    10: reg10 <= MEM_out; 
                    11: reg11 <= MEM_out;
                    12: reg12 <= MEM_out;
                    13: reg13 <= MEM_out;
                    14: reg14 <= MEM_out;
                    15: reg15 <= MEM_out;
                endcase
            end
            default: begin
                reg0 <= reg0;
                reg1  <= reg1;  
                reg2  <= reg2; 
                reg3  <= reg3; 
                reg4  <= reg4; 
                reg5  <= reg5; 
                reg6  <= reg6; 
                reg7  <= reg7; 
                reg8  <= reg8; 
                reg9  <= reg9; 
                reg10 <= reg10; 
                reg11 <= reg11; 
                reg12 <= reg12; 
                reg13 <= reg13; 
                reg14 <= reg14; 
                reg15 <= reg15;                 
            end  
        endcase 
    end
end
endmodule