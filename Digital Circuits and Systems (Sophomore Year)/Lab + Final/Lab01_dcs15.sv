module Lab01(
  // Input signals
  in_number1,
  in_number2,
  in_number3,
  in_number4,
  // Output signals
  out_number1,
  out_number2
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [3:0] in_number1,in_number2,in_number3,in_number4;

output logic [4:0] out_number1,out_number2;

logic [4:0] sumA;
logic [4:0] sumB;

assign sumA = in_number1 + in_number2;
assign sumB = in_number3 + in_number4;

always_comb
begin
	if(sumA>sumB) begin
	assign out_number1 = sumA;
	assign out_number2 = sumB;
	end
	else begin
	assign out_number1 = sumB;
	assign out_number2 = sumA;
	end
end
endmodule

