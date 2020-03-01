module mips_pipe(
  // Input signals
  clk,
  rst_n,
  in_valid,
  instruction,
  output_reg,
  // Output signals
  out_valid,
  intruction_fail,
  out_1,
  out_2,
  out_3
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input [31:0]instruction; 
input [14:0]output_reg; 
output logic out_valid,intruction_fail;

output logic [31:0] out_1,out_2,out_3;

//flip flops
logic [31:0] instruction1, instruction2, rt_value1, rs_value1, rt_value, rs_value,
answer, out_1_ff, out_2_ff, out_3_ff;
logic [14:0] output_reg_ff1, output_reg_ff2, output_reg_ff3;
logic [5:0] out1_reg, out2_reg, out3_reg;
logic opcode, in_valid1, in_valid2, in_valid3, instruction_fail1, instruction_fail2, instruction_fail3;
////////////////////////////
logic [31:0] value1, value2, value3, value4, value5, value6;
//-----------------------------------
// Design
//-----------------------------------

//combinational design

always_comb begin
	case(instruction2[25:21])
		5'b10001: rs_value = value1;
		5'b10010: rs_value = value2;
		5'b01000: rs_value = value3;
		5'b10111: rs_value = value4;
		5'b11111: rs_value = value5;
		5'b10000: rs_value = value6;
		default: rs_value = 32'd0;
	endcase
	
	case(instruction2[20:16])
		5'b10001: rt_value = value1;
		5'b10010: rt_value = value2;
		5'b01000: rt_value = value3;
		5'b10111: rt_value = value4;
		5'b11111: rt_value = value5;
		5'b10000: rt_value = value6;
		default: rt_value = 32'd0;
	endcase
	
	case(output_reg_ff3[4:0])
		5'b10001: out_1_ff = value1;
		5'b10010: out_1_ff = value2;
		5'b01000: out_1_ff = value3;
		5'b10111: out_1_ff = value4;
		5'b11111: out_1_ff = value5;
		5'b10000: out_1_ff = value6;
		default: out_1_ff = 32'd0;
	endcase
	
	case(output_reg_ff3[9:5])
		5'b10001: out_2_ff = value1;
		5'b10010: out_2_ff = value2;
		5'b01000: out_2_ff = value3;
		5'b10111: out_2_ff = value4;
		5'b11111: out_2_ff = value5;
		5'b10000: out_2_ff = value6;
		default: out_2_ff = 32'd0;
	endcase
	
	case(output_reg_ff3[14:10])
		5'b10001: out_3_ff = value1;
		5'b10010: out_3_ff = value2;
		5'b01000: out_3_ff = value3;
		5'b10111: out_3_ff = value4;
		5'b11111: out_3_ff = value5;
		5'b10000: out_3_ff = value6;
		default: out_3_ff = 32'd0;
	endcase
end

always_comb begin
		case(instruction2[29])
			0: 
			begin
				case(instruction2[5:0])
					6'b100000: answer = rs_value + rt_value;
					6'b100100: answer = rs_value & rt_value;
					6'b100101: answer = rs_value | rt_value;
					6'b100111: answer = ~(rs_value | rt_value);
					6'b000000: answer = rt_value << instruction2[10:6];
					6'b000010: answer = rt_value >> instruction2[10:6];
					default: answer = 0;
				endcase
			end
			1: answer = rs_value + instruction2[15:0];
		endcase
end

//sequential design
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 0) begin
		value1 <= 0;
		value2 <= 0;
		value3 <= 0;
		value4 <= 0;
		value5 <= 0;
		value6 <= 0;
		out_valid <= 0;
		out_1 <= 0;
		out_2 <= 0;
		out_3 <= 0;
		intruction_fail <= 0;
		instruction_fail1 <= 0;
		instruction_fail2 <= 0;
		instruction_fail3 <= 0;
		//reset flip flops
		output_reg_ff1 <= 0;
		output_reg_ff2 <= 0;
		output_reg_ff3 <= 0;
		instruction1 <= 0;
		instruction2 <= 0;
		in_valid1 <= 0;
		in_valid2 <= 0;
		in_valid3 <= 0;
	end
	else begin
		if(
		((instruction[31:26] == 6'b000000) &&
		((instruction[5:0] == 6'b100100)||(instruction[5:0] == 6'b100101)||
		(instruction[5:0] == 6'b100111)||(instruction[5:0] == 6'b000000)||
		(instruction[5:0] == 6'b000010)||(instruction[5:0] == 6'b100000)))||
		(instruction[31:26] == 6'b001000)
		)
		instruction_fail1 <= 0;
		else instruction_fail1 <= 1;
	
		intruction_fail <= instruction_fail3;
		instruction_fail3 <= instruction_fail2;
		instruction_fail2 <= instruction_fail1;
		
		if(in_valid == 0) begin
			instruction1 <= 0;
			output_reg_ff1 <= 0;
		end
		else begin
		//first blue flip flop
			output_reg_ff1 <= output_reg;
			instruction1 <= instruction;
		end
		//second blue flip flop
		if(in_valid1 != 0) begin	
			output_reg_ff2 <= output_reg_ff1;
			instruction2 <= instruction1;
		end
		//third blue flip flop
		if(in_valid2 != 0) begin 
		
			output_reg_ff3 <= output_reg_ff2;	
			
			if(instruction_fail2 == 0) begin
				if(instruction2[29] == 0) begin
					case(instruction2[15:11])
						5'b10001: value1 <= answer;
						5'b10010: value2 <= answer;
						5'b01000: value3 <= answer;
						5'b10111: value4 <= answer;
						5'b11111: value5 <= answer;
						5'b10000: value6 <= answer;
					endcase
				end
				else begin
					case(instruction2[20:16])
						5'b10001: value1 <= answer;
						5'b10010: value2 <= answer;
						5'b01000: value3 <= answer;
						5'b10111: value4 <= answer;
						5'b11111: value5 <= answer;
						5'b10000: value6 <= answer;
					endcase
				end
			end
		end
		//fourth blue flip flop
		if(in_valid3 != 0) begin
			if(instruction_fail3 == 1) begin
				out_1 <= 0;
				out_2 <= 0;
				out_3 <= 0;
			end
			else begin
				out_1 <= out_1_ff;
				out_2 <= out_2_ff;
				out_3 <= out_3_ff;
			end
		end
		else begin
			out_1 <= 0;
			out_2 <= 0;
			out_3 <= 0;
		end
		in_valid1 <= in_valid;
		in_valid2 <= in_valid1;
		in_valid3 <= in_valid2;
		out_valid <= in_valid3;
	end	

end
endmodule

