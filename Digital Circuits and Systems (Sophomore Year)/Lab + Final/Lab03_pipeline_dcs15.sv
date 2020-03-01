module pipeline(
  // Input signals
	clk,
	rst_n,
    in,
    in_valid,
  // Output signals
	out,
	out_valid

);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input [3:0] in;
output logic [31:0] out;
output logic out_valid;

//---------------------------------------------------------------------
//   Logic DECLARATION                         
//---------------------------------------------------------------------
logic [31:0]multiply1, multiply2, multiply3, second_power, fourth_power;
logic [3:0]in_catch;

//---------------------------------------------------------------------
//   Design                        
//---------------------------------------------------------------------

	assign multiply1 = in_catch*in_catch;
	assign multiply2 = second_power*second_power;
	assign multiply3 = fourth_power*fourth_power;

always@(posedge clk or negedge rst_n) begin
	if(rst_n == 0) begin
		out <= 32'd0;	//delay?
		out_valid <= 32'd0;
		second_power <= 32'd0;
		fourth_power <= 32'd0;
		in_catch <= 32'd0;
	end
	
	else begin 
		if(in_valid == 1) in_catch <= in;
		else begin
			in_catch <= 4'd0;
		end
		
		if(fourth_power != 0) out_valid <= 1;
			else out_valid <= 0;
		
		second_power <= multiply1;
		fourth_power <= multiply2;
		out <= multiply3;
	end 

end

endmodule

