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
logic signed [6:0] A_real_ff [0:1] [0:1], A_image_ff [0:1] [0:1], B_real_ff [0:1] [0:1], B_image_ff [0:1][0:1];
logic signed [6:0] A_real_reg, B_real_reg, A_image_reg, B_image_reg;
logic [2:0] in_count;
logic signed [14:0] real_cal_comb, image_cal_comb;
logic signed [14:0] real_ans_reg, image_ans_reg;
logic signed [14:0] real_ans, image_ans;
logic [8:0] hold;
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
        hold[8] <= hold[7];   
    end
end

//-----------OUTPUT SIGNAL----------//
//----------------------------------//
//--------------------------------------------------------

//scan into array A, B
always_ff@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 0;
        real_ans_reg <= 0;
        image_ans_reg <= 0;
    end
    else begin
        out_valid <= 0;
        case(in_count)
        //c1
            0: begin
                A_real_ff[0][0] <= in_real;
                A_image_ff[0][0] <= in_image;

                if(hold[8]) out_valid <= 1;

                //if(hold[6]) begin
                    A_real[0][0] <= A_real_ff[0][0];
                    A_real[0][1] <= A_real_ff[0][1];
                    A_real[1][0] <= A_real_ff[1][0];
                    A_real[1][1] <= A_real_ff[1][1];
                    B_real[0][0] <= B_real_ff[0][0];
                    B_real[0][1] <= B_real_ff[0][1];
                    B_real[1][0] <= B_real_ff[1][0];
                    B_real[1][1] <= B_real_ff[1][1];
                    A_image[0][0] <= A_image_ff[0][0];
                    A_image[0][1] <= A_image_ff[0][1];
                    A_image[1][0] <= A_image_ff[1][0];
                    A_image[1][1] <= A_image_ff[1][1];
                    B_image[0][0] <= B_image_ff[0][0];
                    B_image[0][1] <= B_image_ff[0][1];
                    B_image[1][0] <= B_image_ff[1][0];
                    B_image[1][1] <= B_image_ff[1][1];
                //end
               /* else begin
                    A_real[0][0] <= 0; 
                    A_real[0][1] <= 0; 
                    A_real[1][0] <= 0; 
                    A_real[1][1] <= 0; 
                    B_real[0][0] <= 0; 
                    B_real[0][1] <= 0; 
                    B_real[1][0] <= 0; 
                    B_real[1][1] <= 0; 
                    A_image[0][0] <= 0;
                    A_image[0][1] <= 0;
                    A_image[1][0] <= 0;
                    A_image[1][1] <= 0;
                    B_image[0][0] <= 0;
                    B_image[0][1] <= 0;
                    B_image[1][0] <= 0;
                    B_image[1][1] <= 0;
                end
                */
                A_real_reg <= A_real[0][0];
                A_image_reg <= A_image[0][0];
                B_real_reg <= B_real[0][0];
                B_image_reg <= B_image[0][0];
                //if(hold[8]) out_valid <= 1;
            end
            1: begin
                A_real_ff[0][1] <= in_real;
                A_image_ff[0][1] <= in_image;
                if(hold[8]) begin
                    A_real_reg  <= A_real[0][1]; 
                    A_image_reg <= A_image[0][1];
                    B_real_reg  <= B_real[1][0];
                    B_image_reg <= B_image[1][0];

                    real_ans_reg <= real_cal_comb;
                    image_ans_reg <= image_cal_comb;

                    //out_valid <= 1;
                end
            end
            //c2
            2: begin
                A_real_ff[1][0] <= in_real;
                A_image_ff[1][0] <= in_image;
                
                if(hold[8]) begin
                    A_real_reg  <= A_real[0][0]; 
                    A_image_reg <= A_image[0][0];
                    B_real_reg  <= B_real[0][1];
                    B_image_reg <= B_image[0][1];

                    out_valid <= 1;
                end
            end
            3: begin
                A_real_ff[1][1] <= in_real;
                A_image_ff[1][1] <= in_image;

                if(hold[8]) begin
                    A_real_reg  <= A_real[0][1]; 
                    A_image_reg <= A_image[0][1];
                    B_real_reg  <= B_real[1][1];
                    B_image_reg <= B_image[1][1];

                    real_ans_reg <= real_cal_comb;
                    image_ans_reg <= image_cal_comb;

                    //out_valid <= 1;
                end
            end
            //c3
            4: begin
                B_real_ff[0][0] <= in_real;
                B_image_ff[0][0] <= in_image;

                if(hold[8]) begin
                    A_real_reg  <= A_real[1][0]; 
                    A_image_reg <= A_image[1][0];
                    B_real_reg  <= B_real[0][0];
                    B_image_reg <= B_image[0][0];

                    out_valid <= 1;
                end
            end
            5: begin
                B_real_ff[0][1] <= in_real;
                B_image_ff[0][1] <= in_image;

                if(hold[8]) begin
                    A_real_reg  <= A_real[1][1]; 
                    A_image_reg <= A_image[1][1];
                    B_real_reg  <= B_real[1][0];
                    B_image_reg <= B_image[1][0];

                    real_ans_reg <= real_cal_comb;
                    image_ans_reg <= image_cal_comb;

                    //out_valid <= 1;
                end
            end
            //c4
            6: begin
                B_real_ff[1][0] <= in_real;
                B_image_ff[1][0] <= in_image;

                if(hold[8]) begin
                    A_real_reg  <= A_real[1][0]; 
                    A_image_reg <= A_image[1][0];
                    B_real_reg  <= B_real[0][1];
                    B_image_reg <= B_image[0][1];

                    out_valid <= 1;
                end
            end
            7: begin
                B_real_ff[1][1] <= in_real;
                B_image_ff[1][1] <= in_image;

                if(hold[8]) begin
                    A_real_reg  <= A_real[1][1]; 
                    A_image_reg <= A_image[1][1];
                    B_real_reg  <= B_real[1][1];
                    B_image_reg <= B_image[1][1];

                    real_ans_reg <= real_cal_comb;
                    image_ans_reg <= image_cal_comb;

                    //out_valid <= 1;
                end
            end
        endcase
    end
end

//arithmetic operation
always_comb begin
    real_cal_comb = A_real_reg * B_real_reg - A_image_reg * B_image_reg;
    image_cal_comb = A_real_reg * B_image_reg + A_image_reg * B_real_reg;

    real_ans = real_cal_comb + real_ans_reg;
    image_ans = image_cal_comb + image_ans_reg;
end
   

always_ff@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        busy <= 0;
        out_real <= 0;
        out_image <= 0;
    end
    else begin
        busy <= 0;
        out_real <= real_ans[14:6];
        out_image <= image_ans[14:6];
    end
end

endmodule
