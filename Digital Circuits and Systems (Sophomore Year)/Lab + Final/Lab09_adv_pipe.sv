module adv_pipe(
  // Input signals
	clk,
	rst_n,
    in_valid,
    in_1,
    in_2,
    in_3,
  // Output signals
	out_valid,
	out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input [30:0] in_1,in_2;
input [31:0] in_3;
output logic [63:0] out;
output logic out_valid;
//---------------------------------------------------------------------
//   LOGIC DECLARATION                         
//---------------------------------------------------------------------

logic [30:0] in_1_f1, in_2_f1;
logic [31:0] in_3_f1, a_f2, b_f2, a_f3, b_f3, a_f4, b_f4, a_f5, b_f5, field1_comb, field2_comb, field3_comb, p2, field5_comb;
logic [32:0] field4_comb;
logic [15:0] out1_f3, out1_f4, out1_f5, p1_f3, out2_f5;
logic [16:0] p3;
logic invalid1, invalid2, invalid3, invalid4, invalid5;

always_comb begin
  field1_comb = in_1_f1 + in_2_f1;
  field2_comb = a_f2[15:0] * b_f2[15:0];
  field3_comb = a_f3[15:0] * b_f3[31:16] + p1_f3;
  field4_comb = a_f4[31:16] * b_f4[15:0] + p2;
  field5_comb = a_f5[31:16] * b_f5[31:16] + p3;
end

always_ff@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    invalid1 <= 0;
    invalid2 <= 0;
    invalid3 <= 0;
    invalid4 <= 0;
    invalid5 <= 0;
    out_valid <= 0;
  end
  else
  begin
    invalid1 <= in_valid;
    invalid2 <= invalid1;
    invalid3 <= invalid2;
    invalid4 <= invalid3;
    invalid5 <= invalid4;
    out_valid <= invalid5;
  end
end



//f1
always_ff@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    in_1_f1 <= 0;
    in_2_f1 <= 0;
    in_3_f1 <= 0;
  end
  else begin
    in_1_f1 <= in_1;
    in_2_f1 <= in_2;
    in_3_f1 <= in_3;
  end
end

//f2
always_ff@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    a_f2 <= 0;
    b_f2 <= 0;
  end
  else begin
    a_f2 <= field1_comb;
    b_f2 <= in_3_f1;
  end
end

//f3
always_ff@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    a_f3 <= 0;
    b_f3 <= 0;
    out1_f3 <= 0;
    p1_f3 <= 0;
  end
  else begin
    a_f3 <= a_f2;
    b_f3 <= b_f2;
    out1_f3 <= field2_comb[15:0];
    p1_f3 <= field2_comb[31:16];
  end
end

//f4
always_ff@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    a_f4 <= 0;
    b_f4 <= 0;
    out1_f4 <= 0;
    p2 <= 0;
  end
  else begin
    a_f4 <= a_f3;
    b_f4 <= b_f3;
    out1_f4 <= out1_f3;
    p2 <= field3_comb;
  end
end

//f5
always_ff@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    a_f5 <= 0;
    b_f5 <= 0;
    out1_f5 <= 0;
    out2_f5 <= 0;
  end
  else begin
    a_f5 <= a_f4;
    b_f5 <= b_f4;
    out1_f5 <= out1_f4;
    out2_f5 <= field4_comb[15:0];
    p3 <= field4_comb[32:16];
  end
end

//output
always_ff@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    out <= 0;
  end
  else begin
   out[15:0] <= out1_f5;
   out[31:16] <= out2_f5;
   out[63:32] <= field5_comb;
  end
end


endmodule

