
`include "GATE_LIB.v"
module MAC4 (//input
             A,
             B,
             MODE,
             ACC,
             //output
             OUT);

input  signed [3:0]  A,B;
input  signed [7:0] ACC;
input  MODE;
output signed [8:0] OUT;


///// Write your design here /////

//behavioural design
// reg [8:0] C;

// assign OUT = C;

// always@(*) begin
// if(MODE == 0) begin
//     C = ((A * B) + ACC);
// end
// else begin
//     C = ((A * B) - ACC);
// end
// end

/*
notes:

IS '0' INPUT SAME AS NO INPUT??
*/
wire [7:0] C; //C = A*B

FourBitMult G1(.Z(C) ,.X(A), .Y(B));
EightBitAddSub G2(.OUT(OUT), .A(C), .B(ACC), .Mode(MODE));

endmodule






///// Write your design (other modules) here /////

module FA(
    //input
    input A,
    input B,
    input CIN,
    //output
    output COUT,
    output SUM
);
wire XOR0out, AND0out, AND1out;

VLSI_XOR2 XOR0(.OUT(XOR0out), .INA(A), .INB(B));
VLSI_XOR2 XOR1(.OUT(SUM), .INA(XOR0out), .INB(CIN));
VLSI_AND2 AND0(.OUT(AND0out), .INA(A), .INB(B));
VLSI_AND2 AND1(.OUT(AND1out), .INA(CIN), .INB(XOR0out));
VLSI_OR2 OR0(.OUT(COUT), .INA(AND0out), .INB(AND1out));
endmodule

module HA(
    //input
    input A,
    input B,
    //output
    output COUT,
    output SUM
);
VLSI_XOR2 G1(.OUT(SUM), .INA(A), .INB(B));
VLSI_AND2 G2(.OUT(COUT), .INA(A), .INB(B));
endmodule

//need flipped bit!!!!!
module FourBitMult(
    //input
    input signed [3:0] X,
    input signed [3:0] Y,
    //output
    output signed [7:0] Z
);
wire X1Y0out, X2Y0out, X3Y0out,
     X0Y1out, X1Y1out, X2Y1out, X3Y1out,
     X0Y2out, X1Y2out, X2Y2out, X3Y2out,
     X0Y3out, X1Y3out, X2Y3out, X3Y3out,
     L00carry, L01carry, L02carry, L03carry,
     L10carry, L11carry, L12carry, L13carry,
     L20carry, L21carry, L22carry, L23carry,
     L01out, L02out, L03out, L11out, L12out, L13out;

//AND, NAND Gates
VLSI_AND2  X0Y0(.OUT(Z[0]),    .INA(X[0]), .INB(Y[0]));
VLSI_AND2  X1Y0(.OUT(X1Y0out), .INA(X[1]), .INB(Y[0]));
VLSI_AND2  X2Y0(.OUT(X2Y0out), .INA(X[2]), .INB(Y[0]));
VLSI_NAND2 X3Y0(.OUT(X3Y0out), .INA(X[3]), .INB(Y[0]));

VLSI_AND2  X0Y1(.OUT(X0Y1out), .INA(X[0]), .INB(Y[1]));
VLSI_AND2  X1Y1(.OUT(X1Y1out), .INA(X[1]), .INB(Y[1]));
VLSI_AND2  X2Y1(.OUT(X2Y1out), .INA(X[2]), .INB(Y[1]));
VLSI_NAND2 X3Y1(.OUT(X3Y1out), .INA(X[3]), .INB(Y[1]));

VLSI_AND2  X0Y2(.OUT(X0Y2out), .INA(X[0]), .INB(Y[2]));
VLSI_AND2  X1Y2(.OUT(X1Y2out), .INA(X[1]), .INB(Y[2]));
VLSI_AND2  X2Y2(.OUT(X2Y2out), .INA(X[2]), .INB(Y[2]));
VLSI_NAND2 X3Y2(.OUT(X3Y2out), .INA(X[3]), .INB(Y[2]));

VLSI_NAND2 X0Y3(.OUT(X0Y3out), .INA(X[0]), .INB(Y[3]));
VLSI_NAND2 X1Y3(.OUT(X1Y3out), .INA(X[1]), .INB(Y[3]));
VLSI_NAND2 X2Y3(.OUT(X2Y3out), .INA(X[2]), .INB(Y[3]));
VLSI_AND2  X3Y3(.OUT(X3Y3out), .INA(X[3]), .INB(Y[3]));

//Full and Half Adders
HA L00(.SUM(Z[1]),   .COUT(L00carry),                 .A(X0Y1out), .B(X1Y0out));
FA L01(.SUM(L01out), .COUT(L01carry), .CIN(L00carry), .A(X1Y1out), .B(X2Y0out));
FA L02(.SUM(L02out), .COUT(L02carry), .CIN(L01carry), .A(X2Y1out), .B(X3Y0out));
FA L03(.SUM(L03out), .COUT(L03carry), .CIN(L02carry), .A(X3Y1out), .B(1'b1));

HA L10(.SUM(Z[2]),   .COUT(L10carry),                 .A(X0Y2out), .B(L01out));
FA L11(.SUM(L11out), .COUT(L11carry), .CIN(L10carry), .A(X1Y2out), .B(L02out));
FA L12(.SUM(L12out), .COUT(L12carry), .CIN(L11carry), .A(X2Y2out), .B(L03out));
FA L13(.SUM(L13out), .COUT(L13carry), .CIN(L12carry), .A(X3Y2out), .B(L03carry));

HA L20(.SUM(Z[3]), .COUT(L20carry),                 .A(X0Y3out), .B(L11out));
FA L21(.SUM(Z[4]), .COUT(L21carry), .CIN(L20carry), .A(X1Y3out), .B(L12out));
FA L22(.SUM(Z[5]), .COUT(L22carry), .CIN(L21carry), .A(X2Y3out), .B(L13out));
FA L23(.SUM(Z[6]), .COUT(L23carry), .CIN(L22carry), .A(X3Y3out), .B(L13carry));
// HA L24(.SUM(Z[7]), .COUT(),                 .A(1'b1), .B(L23carry));
VLSI_XOR2 L24(.OUT(Z[7]), .INA(L23carry), .INB(1'b1));

endmodule

module EightBitAddSub(
    //input
    input signed [7:0] A, B,  //A +/- B
    input Mode,
    //output
    output signed [8:0] OUT
);

wire A0B0out, A1B1out, A2B2out, A3B3out, A4B4out, A5B5out, A6B6out, A7B7out,
     MB0out, MB1out, MB2out, MB3out, MB4out, MB5out, MB6out, MB7out;


// wire temp, temp2;

//XOR gates
VLSI_XOR2 MB0(.OUT(MB0out), .INA(Mode), .INB(B[0]));
VLSI_XOR2 MB1(.OUT(MB1out), .INA(Mode), .INB(B[1]));
VLSI_XOR2 MB2(.OUT(MB2out), .INA(Mode), .INB(B[2]));
VLSI_XOR2 MB3(.OUT(MB3out), .INA(Mode), .INB(B[3]));
VLSI_XOR2 MB4(.OUT(MB4out), .INA(Mode), .INB(B[4]));
VLSI_XOR2 MB5(.OUT(MB5out), .INA(Mode), .INB(B[5]));
VLSI_XOR2 MB6(.OUT(MB6out), .INA(Mode), .INB(B[6]));
VLSI_XOR2 MB7(.OUT(MB7out), .INA(Mode), .INB(B[7]));
VLSI_XOR3 MB8(.OUT(OUT[8]), .INA(MB7out), .INB(A7B7out), .INC(A[7]));

//Full Adder
FA A0B0(.A(A[0]), .B(MB0out), .CIN(Mode), .COUT(A0B0out), .SUM(OUT[0]));
FA A1B1(.A(A[1]), .B(MB1out), .CIN(A0B0out), .COUT(A1B1out), .SUM(OUT[1]));
FA A2B2(.A(A[2]), .B(MB2out), .CIN(A1B1out), .COUT(A2B2out), .SUM(OUT[2]));
FA A3B3(.A(A[3]), .B(MB3out), .CIN(A2B2out), .COUT(A3B3out), .SUM(OUT[3]));
FA A4B4(.A(A[4]), .B(MB4out), .CIN(A3B3out), .COUT(A4B4out), .SUM(OUT[4]));
FA A5B5(.A(A[5]), .B(MB5out), .CIN(A4B4out), .COUT(A5B5out), .SUM(OUT[5]));
FA A6B6(.A(A[6]), .B(MB6out), .CIN(A5B5out), .COUT(A6B6out), .SUM(OUT[6]));
FA A7B7(.A(A[7]), .B(MB7out), .CIN(A6B6out), .COUT(A7B7out), .SUM(OUT[7]));
endmodule