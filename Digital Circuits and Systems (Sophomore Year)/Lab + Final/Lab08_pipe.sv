module pipe(
  // Input signals
  clk,
  rst_n,
  in_valid,
  in_data1,
  in_data2,
  
  // Output signals
  out_valid,
  out_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [2:0] in_data1,in_data2;
input in_valid,rst_n,clk;

output logic [7:0] out_data;
output logic out_valid;

logic in_valid1, in_valid2, in_valid3;
logic [2:0] in_data1_reg1, in_data2_reg1, in_data2_reg2;
logic [6:0] result1;
logic [7:0] result2;

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    out_valid <= 0;
    out_data <= 0;
    in_data1_reg1 <= 0;
    in_data2_reg1 <= 0;
    in_valid1 <= 0;
    in_valid2 <= 0;
    in_valid3 <= 0;
    result1 <= 0;
    result2 <= 0;
    in_data2_reg2 <= 0;
  end
  else begin
    in_data1_reg1 <= in_data1;
    in_data2_reg1 <= in_data2;
    in_valid1 <= in_valid;

    in_data2_reg2 <= in_data2_reg1;
    result1 <= in_data1_reg1 * in_data2_reg1;
    in_valid2 <= in_valid1;

    out_data <= result1 + in_data2_reg2;
    out_valid <= in_valid2;

    //out_data <= result2;
    //out_valid <= in_valid3;
  end

end

endmodule
