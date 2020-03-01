module mips(
    // Input signals
    instruction,
    // Output signals
    out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [31:0] instruction;

output logic [6:0] out;

//---------------------------------------------------------------------
//   Logic DECLARATION                         
//---------------------------------------------------------------------
logic [5:0] opcode, funct;
logic [4:0] rs, rt, shamt;
logic [15:0] rs_value, rt_value;
logic [15:0] rt_shift, R_out, I_out, immediate;
logic [3:0] four_bit_output;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign opcode = instruction[31:26];
assign rs = instruction[25:21];
assign rt = instruction[20:16];
assign shamt = instruction[10:6];
assign funct = instruction[5:0];
assign immediate = instruction[15:0];

register_file_for_rs get_rs_value(.address(rs), .read_port(rs_value)); //get rs value
register_file_for_rt get_rt_value(.address(rt), .read_port(rt_value)); //get rt value

assign I_out = rs_value + immediate;

shift rt_shifter(.in_value(rt_value), .shift_pos(shamt), .shift_direc(funct[1:0]), .out_value(rt_shift));

type_R_mux r_funct(.rs_value, .rt_value, .rt_shift, .funct, .out_value(R_out));
opcode_mux opcode_sel(.typeR(R_out), .typeI(I_out), .opcode(opcode), .last_four_bits(four_bit_output));
sev_seg_code_converter sev_dis(.in_number(four_bit_output), .display_code(out));

endmodule

//converts 4 bits to 7 bits for 7-seg
/*
 --6--
|	  |
1	  5
|	  |
 --0-- 	  
|	  |
2	  4
|	  |
 --3--
*/
module sev_seg_code_converter(
	in_number,
	display_code
);
input [3:0] in_number;
output logic [6:0] display_code;

always_comb begin
	case(in_number)
		4'h0: display_code = 7'b1111110;
		4'h1: display_code = 7'b0110000;
		4'h2: display_code = 7'b1101101;
		4'h3: display_code = 7'b1111001;
		4'h4: display_code = 7'b0110011;
		4'h5: display_code = 7'b1011011;
		4'h6: display_code = 7'b1011111;
		4'h7: display_code = 7'b1110000;
		4'h8: display_code = 7'b1111111;
		4'h9: display_code = 7'b1111011;
		4'hA: display_code = 7'b1110111;
		4'hB: display_code = 7'b0011111;
		4'hC: display_code = 7'b1001110;
		4'hD: display_code = 7'b0111101;
		4'hE: display_code = 7'b1001111;
		4'hF: display_code = 7'b1000111;
		default: display_code = 7'bxxxxxxx;
	endcase
end

endmodule

//2-to-1 mux with opcode as sel, clip to last four bits
module opcode_mux(
	typeR,
	typeI,
	opcode,
	last_four_bits
);
input [15:0] typeR, typeI;
input [5:0] opcode;
output logic [3:0]last_four_bits;

always_comb begin
	case(opcode)
	6'b000000: last_four_bits = typeR[3:0];
	6'b001000: last_four_bits = typeI[3:0];
	default: last_four_bits = 4'bxxxx;
	endcase
end

endmodule


module shift(
	in_value,
	shift_pos,
	shift_direc,
	out_value
);
input [15:0] in_value;
input [4:0] shift_pos;
input [1:0] shift_direc;
output logic [15:0] out_value;

always_comb begin
	case(shift_direc)
	2'b00: out_value = in_value << shift_pos;
	2'b10: out_value = in_value >> shift_pos;
	default: out_value = in_value;
	endcase
end

endmodule

//mux for type R operations
module type_R_mux(rs_value,
	rt_value,
	rt_shift,
	funct,
	out_value
);
input [15:0] rs_value, rt_value, rt_shift;
input [5:0] funct;
output logic [15:0] out_value;

always_comb begin
	case(funct)
	6'b100000: out_value = rs_value + rt_value;
	6'b100100: out_value = rs_value & rt_value;
	6'b100101: out_value = rs_value | rt_value;
	6'b100111: out_value = ~(rs_value | rt_value);
	default: out_value = rt_shift;
	endcase
end

endmodule



//---------------------------------------------------------------------
//   Register design from TA (RS)                        
//---------------------------------------------------------------------
module register_file_for_rs(
    address,
    read_port
);
input [4:0] address;
output logic [15:0] read_port;

always_comb begin
    case(address)
    5'b01101:read_port = 32'd12;
    5'b01110:read_port = 32'd38;
    5'b10001:read_port = 32'd27;
    5'b10010:read_port = 32'd150;
    5'b11011:read_port = 32'd379;
    5'b11101:read_port = 32'd142;
    5'b11111:read_port = 32'd1508;
    default: read_port = 0;
    endcase
end

endmodule

//---------------------------------------------------------------------
//   Register design from TA (RT)                        
//---------------------------------------------------------------------
module register_file_for_rt(
    address,
    read_port
);
input [4:0] address;
output logic [15:0] read_port;

always_comb begin
    case(address)
    5'b01101:read_port = 32'd12;
    5'b01110:read_port = 32'd38;
    5'b10001:read_port = 32'd27;
    5'b10010:read_port = 32'd150;
    5'b11011:read_port = 32'd379;
    5'b11101:read_port = 32'd142;
    5'b11111:read_port = 32'd1508;
    default: read_port = 0;
    endcase
end

endmodule
