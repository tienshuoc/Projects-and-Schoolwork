module relu_pool(
  // Input signals
	clk,
	rst_n,
    in_valid,
    in,
  // Output signals
	out_valid,
	out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input signed[3:0] in;
output logic signed[3:0] out;
output logic out_valid;
//---------------------------------------------------------------------
//   LOGIC DECLARATION                         
//---------------------------------------------------------------------
logic [1:0] CS, NS;
logic signed [3:0] in_reg, in_relu, in_pooling_reg; //changed
logic [3:0] shift_reg_0, shift_reg_1, shift_reg_2, shift_reg_3,shift_reg_4;
logic [2:0] count, out_count;

//---------------------------------------------------------------------
//   State DECLARATION                         
//---------------------------------------------------------------------
parameter IDLE = 2'd0;
parameter RELU_POOL = 2'd1;
parameter OUT = 2'd2;
//---------------------------------------------------------------------
//   Finite State Machine                        
//---------------------------------------------------------------------
//State Register
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        CS <= IDLE;
    else
        CS <= NS;
end
//Next state logic (Hint: Some error in here)
always_comb
begin

    NS = CS;
    if(!rst_n) NS = IDLE;
    case(CS)
    IDLE: begin
        if(in_valid == 1) NS = RELU_POOL;
    end
    RELU_POOL: begin
        if(!in_valid) NS = OUT; //change
    end
    OUT: begin
        if(out_count == 4) NS = IDLE; //change
    end
    endcase
end

//---------------------------------------------------------------------
//   Main                        
//---------------------------------------------------------------------
//Input Register
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_reg <= 0;
    else
        in_reg <= in;
end

//ReLU (Hint: Some error in here)
always_comb
begin
    in_relu = 0;
   // if(CS == RELU_POOL)  begin
        if(in_reg > 0)
            in_relu = in_reg;
    //end
end

//Pooling
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_pooling_reg <= 0;
    else if(count == 3)
        in_pooling_reg <= 0;
    else if(in_relu > in_pooling_reg)
        in_pooling_reg <= in_relu;
end


//Counter to control 4 cycle relu and pooling
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        count <= 0;
    else if(CS == RELU_POOL && count < 3)
        count <= count + 1;
    else
        count <= 0;
end

//Shift register 0 to store pooling result
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        shift_reg_0 <= 0;   
    end
    else if(count == 3 || CS == OUT) begin
        if(in_relu > in_pooling_reg)
        shift_reg_0 <= in_relu;     
        else 
        shift_reg_0 <= in_pooling_reg;
    end    
end

//Shift register 1-4 to store pooling result
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        shift_reg_1 <= 0;
        shift_reg_2 <= 0;
        shift_reg_3 <= 0;
        shift_reg_4 <= 0;    
    end
    else if(count == 3 || CS == OUT) begin
        shift_reg_1 <= shift_reg_0;
        shift_reg_2 <= shift_reg_1;
        shift_reg_3 <= shift_reg_2;
        shift_reg_4 <= shift_reg_3;        
    end    
end


//Output signal
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        out_valid <= 0;
        out <= 0;
    end
    else if(CS == OUT) begin
        out_valid <= 1;
        out <= shift_reg_4; //change
    end
    else if(NS == IDLE) begin
        out_valid <= 0;
        out <= 0;
    end    
end

//Out counter to control output signal
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_count <= 0;
    else if(CS == OUT)
        out_count <= out_count + 1;
    else out_count <= 0;
end
endmodule

