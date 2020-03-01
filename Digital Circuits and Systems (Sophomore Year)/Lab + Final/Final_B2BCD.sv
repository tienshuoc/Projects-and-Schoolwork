module B2BCD(
  // Input signals
  clk,
  rst_n,
  in_valid,
  in_data,
  // Output signals
  out_valid,
  seg_100,
  seg_10,
  seg_1
);


input clk,rst_n,in_valid;
input  [3:0]in_data;
output logic [6:0] seg_100,seg_10,seg_1;
output logic out_valid;

parameter IDLE = 0,
          SORT = 1,
          MUL  = 2,
          BCD_SHIFT = 3,
          BCD_ADD = 4,
          OUT = 5;

logic [2:0] state, next;
logic [3:0] A, B, C, D;
logic [7:0] multiplication_result;
logic [19:0] answer; //store multiplication answer and so shift operations
logic [3:0] hundreds, tens, units;
logic [7:0] binary;
logic [3:0] shift_count;

assign binary = answer[7:0];
assign units = answer[11:8];
assign tens = answer[15:12];
assign hundreds = answer[19:16];

//next state logic
logic out_valid_next;
logic [3:0] shift_count_next;
logic [3:0] hundreds_next, tens_next, units_next;
logic [6:0] seg_100_next, seg_10_next, seg_1_next;

//FSM
always_comb begin
  next = state;
  case(state)
    IDLE: next = SORT;
    SORT: if(!in_valid) next = MUL;
    MUL: next = BCD_SHIFT;
    BCD_SHIFT: begin
      if(shift_count==8) next = OUT;
      else if(hundreds>4||tens>4||units>4) next = BCD_ADD;
    end
    BCD_ADD: next = BCD_SHIFT;
    OUT: next = IDLE;

  endcase
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) state <= IDLE;
  else state <= next;
end

//next state
always_comb begin
  out_valid_next = 0;
  shift_count_next = shift_count;
  hundreds_next = hundreds;
  tens_next = tens;
  units_next = units;
  case(state)
  //  IDLE: 
  //  SORT:
  //  MUL:
    BCD_SHIFT: begin
        if(shift_count == 8) out_valid_next = 1;
        shift_count_next = shift_count + 1;
        if(next == BCD_ADD) begin
          if(hundreds > 4) hundreds_next = hundreds + 3;
          if(tens > 4) tens_next = tens + 3;
          if(units > 4) units_next = units + 3;
        end
    end
  // BCD_ADD:
    OUT: shift_count_next = 0;
  endcase
end


always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    A <= 0;
    B <= 0;
    C <= 0;
    D <= 0;
    answer <= 0;
    shift_count <= 0;
    out_valid <= 0;
    seg_1 <= 0;
    seg_10 <= 0;
    seg_100 <= 0;
  end
  else begin
    shift_count <= shift_count_next;
    out_valid <= out_valid_next;
    case(state)
      //IDLE: 
      SORT: begin   //read and sort
        if(in_valid) begin
          if(in_data > A) begin
            A <= in_data;
            B <= A;
            C <= B;
            D <= C;
          end
          else if(in_data > B) begin
            A <= A;
            B <= in_data;
            C <= B;
            D <= C;
          end
          else if(in_data > C) begin
            A <= A;
            B <= B;
            C <= in_data;
            D <= C;
          end
          else D <= in_data;
        end
      end
      MUL: answer <= multiplication_result;
      BCD_SHIFT: begin
        if(next == BCD_SHIFT) answer <= answer << 1;
        else if(next == BCD_ADD) begin
          answer[19:16] <= hundreds_next;
          answer[15:12] <= tens_next;
          answer[11:8] <= units_next;
        end
        if(next == OUT) begin
          seg_100 <= seg_100_next;
          seg_10 <= seg_10_next;
          seg_1 <= seg_1_next;
        end
      end
      BCD_ADD: begin
        if(next == BCD_SHIFT) answer <= answer << 1;
        if(next == OUT) begin
          seg_100 <= seg_100_next;
          seg_10 <= seg_10_next;
          seg_1 <= seg_1_next;
        end
      end
      OUT: begin
        A <= 0;
        B <= 0;
        C <= 0;
        D <= 0;
      end
    endcase
  end
end

//multiplication
always_comb begin
  multiplication_result = (D*10 + B) * (C*10 + A);
end

//sev_seg port connections
sev_seg_code_converter hundreds_dis(.in_number(hundreds), .display_code(seg_100_next));
sev_seg_code_converter tens_dis(.in_number(tens), .display_code(seg_10_next));
sev_seg_code_converter units_dis(.in_number(units), .display_code(seg_1_next));

endmodule

//7-seg display
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
		default: display_code = 7'bxxxxxxx;
	endcase
end

endmodule



