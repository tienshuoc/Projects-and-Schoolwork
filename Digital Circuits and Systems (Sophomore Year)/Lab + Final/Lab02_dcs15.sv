module Counter(
  // Input signals
	clk,
	rst_n,
  // Output signals
	clk2,
	out_valid

);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n;

output logic clk2,out_valid;

logic count;


always@(posedge clk or negedge rst_n) begin
	if(rst_n == 0) begin
		out_valid <= 0;
		clk2 <= 0;
		count <= 2'b00;
	end
	else begin
		count <= count + 1;
		if(count == 1) begin
		clk2 <= ~clk2;
		out_valid <= 1'b1;
		end
	end
end

endmodule
