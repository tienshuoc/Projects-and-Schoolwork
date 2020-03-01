//synopsys translate_off 
//synopsys translate_on


module matrix(
    //Input 
    clk,
    rst_n,
    in_valid,
    in_real,
    in_image,
    //OUTPUT
    out_valid,
    out_real,
    out_image,
    busy
);

    //Input 
input clk;
input rst_n;
input in_valid;
input signed[6:0]in_real;
input signed[6:0]in_image;
    //OUTPUT
output logic out_valid;
output logic signed[8:0] out_real;
output logic signed[8:0] out_image;
output logic busy;
//---------------------------------------------------------------------
//  LOGIC DECLARATION                             
//---------------------------------------------------------------------
logic signed [6:0] A_real [0:1] [0:1];
logic signed [6:0] A_image [0:1] [0:1];
logic signed [6:0] B_real [0:1] [0:1];
logic signed [6:0] B_image [0:1] [0:1];
logic signed [6:0] A_real_reg [0:1][0:1], A_image_reg[0:1][0:1], B_real_reg[0:1][0:1], B_image_reg[0:1][0:1];
logic [2:0] in_count;
logic signed [14:0] real_ans, image_ans;
logic [7:0] hold;

//-----------COUNT SIGNAL----------//
//----------------------------------//
always_ff@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        in_count <= 0;
        hold <= 0;
    end
    else begin
        if(in_valid || hold[7]) in_count <= in_count + 1;
        hold[0] <= in_valid;
        hold[1] <= hold[0];
        hold[2] <= hold[1];
        hold[3] <= hold[2];
        hold[4] <= hold[3];
        hold[5] <= hold[4];
        hold[6] <= hold[5];
        hold[7] <= hold[6];   
    end
end

//-----------OUTPUT SIGNAL----------//
//----------------------------------//
//--------------------------------------------------------

//scan into array A, B
always_ff@(posedge clk or negedge rst_n) begin
    if(!rst_n) out_valid <= 0;
    else begin
        out_valid <= 0;
            case(in_count)  
                0: begin
                    A_real_reg[0][0] <= in_real;
                    A_image_reg[0][0] <= in_image;
                    //move reg into matrices
                    if(hold[6]) begin
                        A_real[0][0] <= A_real_reg[0][0];
                        A_real[0][1] <= A_real_reg[0][1];
                        A_real[1][0] <= A_real_reg[1][0];
                        A_real[1][1] <= A_real_reg[1][1];
                        B_real[0][0] <= B_real_reg[0][0];
                        B_real[0][1] <= B_real_reg[0][1];
                        B_real[1][0] <= B_real_reg[1][0];
                        B_real[1][1] <= B_real_reg[1][1];
                        A_image[0][0] <= A_image_reg[0][0];
                        A_image[0][1] <= A_image_reg[0][1];
                        A_image[1][0] <= A_image_reg[1][0];
                        A_image[1][1] <= A_image_reg[1][1];
                        B_image[0][0] <= B_image_reg[0][0];
                        B_image[0][1] <= B_image_reg[0][1];
                        B_image[1][0] <= B_image_reg[1][0];
                        B_image[1][1] <= B_image_reg[1][1];
                    end
                end
                1: begin 
                    A_real_reg[0][1] <= in_real;
                    A_image_reg[0][1] <= in_image;
                    if(hold[7]) out_valid <= 1;
                end
                2: begin
                    A_real_reg[1][0] <= in_real;
                    A_image_reg[1][0] <= in_image;
                    //shift B
                    if(hold[7]) begin
                        B_real[0][0] <= B_real[0][1];
                        B_real[1][0] <= B_real[1][1];
                        B_real[0][1] <= B_real[0][0];
                        B_real[1][1] <= B_real[1][0];
                        B_image[0][0] <= B_image[0][1];
                        B_image[1][0] <= B_image[1][1];
                        B_image[0][1] <= B_image[0][0];
                        B_image[1][1] <= B_image[1][0];
                    end
                end
                3: begin
                    A_real_reg[1][1] <= in_real;
                    A_image_reg[1][1] <= in_image;
                    if(hold[7]) out_valid <= 1;
                end
                4: begin 
                    B_real_reg[0][0] <= in_real;
                    B_image_reg[0][0] <= in_image;
                    //shift A, B
                    if(hold[7]) begin
                        B_real[0][0] <= B_real[0][1];
                        B_real[1][0] <= B_real[1][1];
                        B_real[0][1] <= B_real[0][0];
                        B_real[1][1] <= B_real[1][0];
                        B_image[0][0] <= B_image[0][1];
                        B_image[1][0] <= B_image[1][1];
                        B_image[0][1] <= B_image[0][0];
                        B_image[1][1] <= B_image[1][0];
                        A_real[0][0] <= A_real[1][0];
                        A_real[0][1] <= A_real[1][1];
                        A_image[0][0] <= A_image[1][0];
                        A_image[0][1] <= A_image[1][1];
                    end

                end
                5: begin 
                    B_real_reg[0][1] <= in_real;
                    B_image_reg[0][1] <= in_image;
                    if(hold[7]) out_valid <= 1;
                end
                6: begin 
                    B_real_reg[1][0] <= in_real;
                    B_image_reg[1][0] <= in_image;
                    //shift B
                    if(hold[7]) begin
                        B_real[0][0] <= B_real[0][1];
                        B_real[1][0] <= B_real[1][1];
                        B_real[0][1] <= B_real[0][0];
                        B_real[1][1] <= B_real[1][0];
                        B_image[0][0] <= B_image[0][1];
                        B_image[1][0] <= B_image[1][1];
                        B_image[0][1] <= B_image[0][0];
                        B_image[1][1] <= B_image[1][0];
                    end
                end
                7: begin 
                    B_real_reg[1][1] <= in_real;
                    B_image_reg[1][1] <= in_image;
                    if(hold[7]) out_valid <= 1;
                end
            endcase
    end
end

//arithmetic operation
always_comb begin
    real_ans = (A_real[0][0] * B_real[0][0] + A_real[0][1] * B_real[1][0]) - (A_image[0][0] * B_image[0][0] + A_image[0][1] * B_image[1][0]);
    image_ans = (A_real[0][0] * B_image[0][0] + A_image[0][0] * B_real[0][0] + A_real[0][1] * B_image[1][0] + A_image[0][1] * B_real[1][0]);
end

always_ff@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_real <= 0;
        out_image <= 0;
        busy <= 0;
    end
    else begin
        busy <= 0;
        if(!out_valid && hold[7]) begin
            out_real <= real_ans[14:6];
            out_image <= image_ans[14:6];
        end
        else begin
            out_real <= 0;
            out_image <= 0;
        end
    end
end

endmodule
