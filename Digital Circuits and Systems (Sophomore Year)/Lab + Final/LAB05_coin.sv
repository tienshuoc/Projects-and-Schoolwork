module coin(
  // Input signals
	clk,
	rst_n,
    in_coin,
    in_valid,
  // Output signals
	out_valid,
	out_one_coin,
    out_five_coin,
    out_ten_coin

);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input [5:0] in_coin;
output logic [2:0] out_one_coin, out_five_coin, out_ten_coin;
output logic out_valid;
//---------------------------------------------------------------------
//   LOGIC DECLARATION                         
//---------------------------------------------------------------------
logic [2:0] state, next;
logic [5:0] in_coin_reg;
logic [2:0] one_coin_reg, five_coin_reg, ten_coin_reg;
//---------------------------------------------------------------------
//   State DECLARATION                         
//---------------------------------------------------------------------
parameter
IDLE = 3'b000,
CHECK = 3'b001,
ONE = 3'b010,
FIVE = 3'b011,
TEN = 3'b100,
OUT = 3'b101;
//---------------------------------------------------------------------
//   Finite State Machine                        
//---------------------------------------------------------------------
//State Register
always_ff@(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 0;
		out_one_coin <= 0;
		out_five_coin <=0;
		out_ten_coin <= 0;
		in_coin_reg <= 0;

		state <= IDLE;
	end
	else begin
		state <= next;
		if(in_valid) in_coin_reg <= in_coin;
		
		if(state == IDLE) begin
			one_coin_reg <= 0;
			five_coin_reg <= 0;
			ten_coin_reg <= 0;
		end
		
		if(state == ONE) begin
		in_coin_reg <= in_coin_reg - 1;
		one_coin_reg <= one_coin_reg + 1;
		end
		
		if(state == FIVE) begin
		in_coin_reg <= in_coin_reg - 5;
		five_coin_reg <= five_coin_reg + 1;
		end
		
		if(state == TEN) begin
		in_coin_reg <= in_coin_reg - 10;
		ten_coin_reg <= ten_coin_reg + 1;
		end
		
		if(state == OUT) begin
			out_valid <= 1;
			out_one_coin <= one_coin_reg;
			out_five_coin <= five_coin_reg;
			out_ten_coin <= ten_coin_reg;
		end	
		else begin
			out_valid <= 0;
			out_one_coin <= 0;
			out_five_coin <= 0;
			out_ten_coin <= 0;
		end	
	end
end
//Next state logic
always_comb begin
	next = 'bx;
	case(state)
		IDLE: begin
			if(in_valid) next = CHECK;
			else next = IDLE;
			end
		CHECK: begin
			if(in_coin_reg == 0) next = OUT;
			else if(in_coin_reg >= 10) next = TEN;
			else if(in_coin_reg >= 5) next = FIVE;
			else if(in_coin_reg < 5) next = ONE;
		end
		ONE: next = CHECK;
		FIVE: next = CHECK;
		TEN: next = CHECK;
		OUT: next = IDLE;
	endcase
end
endmodule

