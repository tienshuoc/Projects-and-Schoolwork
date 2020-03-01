//synopsys translate_off 
//synopsys translate_on


module VM(
    //Input 
    clk,
    rst_n,
    price_in_valid,
    in_coin_valid,
    coin_in,
    btn_coin_rtn,
    btn_buy_item,
    price_in,
    //OUTPUT
    monitor,
    out_valid,
    out
);

    //Input 
input clk;
input rst_n;
input price_in_valid;
input in_coin_valid;
input [5:0] coin_in;
input btn_coin_rtn;
input [2:0] btn_buy_item;
input [4:0] price_in;
    //OUTPUT
output logic [8:0] monitor;
output logic out_valid;
output logic [3:0] out;
//---------------------------------------------------------------------
//  LOGIC DECLARATION                             
//---------------------------------------------------------------------
logic [2:0] out_count, item_num;
logic [8:0] change;
logic [4:0] item0, item1, item2, item3, item4, item5, item6, item_price; //store price of item
logic [3:0] state, next;
//------------FSM------------//
//---------------------------//
parameter
IDLE = 4'b0000,
OUT = 4'b0111;

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 0;
		change <= 9'd0;
		state <= IDLE;
		out_count <= 3'd0;
		out <= 4'd0;
	end
	else begin
		state <= next;

		if(((btn_buy_item != 'd0) && (monitor >= item_price))||(btn_coin_rtn)) begin
			change <= monitor - item_price;
			item_num <= btn_buy_item;
		end
		if(state == IDLE)	out_count <= 'd0;
		if(state == OUT) begin
			out_valid <= 1;
			case(out_count)
				3'd0: out <= item_num;
				3'd1: begin
					out <= (change/50);
					change <= change - 50 * (change/50);
				end
				3'd2: begin
					if(change >= 40) begin
						out <= 'd2;
						change <= change - 40;
					end
					else if(change >= 20) begin
						out <= 'd1;
						change <= change - 20;
					end
					else begin
						out <= 'd0;
						change <= change;
					end
				end
				3'd3: begin
					if(change >= 10) begin
						out <= 'd1;
						change <= change - 10;
					end
					else begin
						out <= 'd0;
						change <= change;
					end	
				end
				3'd4: begin
					if(change >= 5) begin
						out <= 'd1;
						change <= change - 5;
					end
					else begin
						out <= 'd0;
						change <= change;
					end
				end
				3'd5: begin
					out <= change;
					change <= 'd0;
					item_num <= 'd0;
				end
			endcase
			out_count <= out_count + 1;
		end
		else begin 
			out_valid <= 0;
			out <= 0;
		end
	end
end

//next state logic
always_comb begin
	next = 'bx;
	case(state)
		IDLE: begin
			if((btn_buy_item != 'd0) && (item_price > monitor)) next = OUT;
			else if(((btn_buy_item != 'd0) && (item_price <= monitor))||(btn_coin_rtn)) next = OUT;
			else	next = IDLE;
		end
		OUT: begin
			if(out_count > 3'd4) next = IDLE;
			else next = OUT;
		end
	endcase
end

//read price
always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		item6 <= 0;
		item5 <= 0;
		item4 <= 0;
		item3 <= 0;
		item2 <= 0;
		item1 <= 0;
		item0 <= 0;
	end
	else begin
		if(price_in_valid) begin
			item6 <= price_in;
			item5 <= item6;
			item4 <= item5;
			item3 <= item4;
			item2 <= item3;
			item1 <= item2;
			item0 <= item1;
		end
	end
end

//enter coin, rtn, buy item
always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		monitor <= 9'd0;
	end
	else begin
		if(in_coin_valid) monitor <= monitor + coin_in;
		else if((btn_buy_item != 'd0) && (item_price <= monitor)||(btn_coin_rtn)) monitor <= 9'd0;
		else monitor <= monitor;
	end
end

always_comb begin //read buy_item_price
	case(btn_buy_item)
		3'd1: item_price = item0;
		3'd2: item_price = item1;
		3'd3: item_price = item2;
		3'd4: item_price = item3;
		3'd5: item_price = item4;
		3'd6: item_price = item5;
		3'd7: item_price = item6;
		default: item_price = 3'd0;
	endcase
end

endmodule