module cdc(
  // Input signals
	clk1,
    clk2,
	rst_n,
    in_valid,
    in,
  // Output signals
	out_valid,
    out_valid_back,
	out,
    out_back
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk1,clk2,rst_n,in_valid;
input [3:0] in;
output logic [3:0] out;
output logic [4:0] out_back;
output logic out_valid,out_valid_back;
//---------------------------------------------------------------------
//   LOGIC DECLARATION                         
//---------------------------------------------------------------------
logic in_val_nor, out_back_nor, out_en_nor;
logic p, a1, a2, q, b1, b2, b3;
logic [4:0] add_result;

always_comb begin
  in_val_nor = in_valid ^ p;
  out_en_nor = a2 ^ q;
  out_back_nor = b3 ^ b2;
  add_result = out + 5;
end

always_ff@(posedge clk1 or negedge rst_n) begin
  if(!rst_n) begin
    out_valid_back <= 0;
    out_back <= 0;
    p <= 0;
    b1 <= 0;
    b2 <= 0;
    b3 <= 0;
  end
  else begin
    p <= in_val_nor;
    b1 <= q;
    b2 <= b1;
    b3 <= b2;
    out_valid_back <= out_back_nor;
    if(out_back_nor) out_back <= add_result;
  end
end

always_ff@(posedge clk2 or negedge rst_n) begin
  if(!rst_n) begin
    a1 <= 0;
    a2 <= 0;
    q <= 0;
    out_valid <= 0;
    out <= 0;
  end
  else begin
    a1 <= p;
    a2 <= a1;
    q <= a2;
    out_valid <= out_en_nor;
    if(out_en_nor) out <= in;
  end
end

endmodule

