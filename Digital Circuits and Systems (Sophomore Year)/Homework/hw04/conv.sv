module conv(
  // Input signals
  clk,
  rst_n,
  image_valid,
  filter_valid,
  in_data,
  // Output signals
  out_valid,
  out_data
);

input clk, rst_n, image_valid, filter_valid;
input signed [3:0] in_data;
output logic signed [10:0] out_data;
output logic out_valid;

//filter first, image second

logic signed [3:0] filter [0:2] [0:2];
logic signed [3:0] image [0:6] [0:6];
logic [4:0] out_count;
logic [5:0] image_count;

integer k;

//read filter and image, shift image during calculation
always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    image_count <= 0;
  end
  else begin
    if(filter_valid) begin
      filter[2][2] <= in_data;
      filter[2][1] <= filter[2][2];
      filter[2][0] <= filter[2][1];
      filter[1][2] <= filter[2][0];
      filter[1][1] <= filter[1][2];
      filter[1][0] <= filter[1][1];
      filter[0][2] <= filter[1][0];
      filter[0][1] <= filter[0][2];
      filter[0][0] <= filter[0][1];
    end
    if(out_count == 4 || out_count == 9 || out_count == 14 || out_count == 19 || out_count == 24) begin
          for(k = 0; k < 4; k++) image[6][k] <= image[6][k+3]; 
          image[5][4] <= image[6][0];
          image[5][5] <= image[6][1];
          image[5][6] <= image[6][2];
          for(k = 0; k < 4; k++) image[5][k] <= image[5][k+3];
          image[4][4] <= image[5][0];
          image[4][5] <= image[5][1];
          image[4][6] <= image[5][2];
          for(k = 0; k < 4; k++) image[4][k] <= image[4][k+3];
          image[3][4] <= image[4][0];
          image[3][5] <= image[4][1];
          image[3][6] <= image[4][2];
          for(k = 0; k < 4; k++) image[3][k] <= image[3][k+3];
          image[2][4] <= image[3][0];
          image[2][5] <= image[3][1];
          image[2][6] <= image[3][2];
          for(k = 0; k < 4; k++) image[2][k] <= image[2][k+3];
          image[1][4] <= image[2][0];
          image[1][5] <= image[2][1];
          image[1][6] <= image[2][2];
          for(k = 0; k < 4; k++) image[1][k] <= image[1][k+3];
          image[0][4] <= image[1][0];
          image[0][5] <= image[1][1];
          image[0][6] <= image[1][2];
          for(k = 0; k < 4; k++) image[0][k] <= image[0][k+3];
    end
    else if(out_count >= 25) image_count <= 0;
    else if(image_valid || out_count < 25) begin
        if(image_valid) begin
          image_count <= image_count + 1;
          image[6][6] <= in_data;
        end
        
        for(k = 0; k < 6; k++) image[6][k] <= image[6][k+1]; 
        image[5][6] <= image[6][0];
        for(k = 0; k < 6; k++) image[5][k] <= image[5][k+1];
        image[4][6] <= image[5][0];
        for(k = 0; k < 6; k++) image[4][k] <= image[4][k+1];
        image[3][6] <= image[4][0];
        for(k = 0; k < 6; k++) image[3][k] <= image[3][k+1];
        image[2][6] <= image[3][0];
        for(k = 0; k < 6; k++) image[2][k] <= image[2][k+1];
        image[1][6] <= image[2][0];
        for(k = 0; k < 6; k++) image[1][k] <= image[1][k+1];
        image[0][6] <= image[1][0];
        for(k = 0; k < 6; k++) image[0][k] <= image[0][k+1];
    end
  end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      out_data <= 0;
      out_valid <= 0;
      out_count <= 0;
    end
    else begin
      if(out_count >= 25) begin
        out_valid <= 0;
        out_count <= 0;
        out_data <= 0;
      end
      else if(image_count == 49) begin
        out_valid <= 1;
        out_count <= out_count + 1;
        out_data <= filter[0][0] * image[0][0] + filter[0][1] * image[0][1] + filter[0][2] * image[0][2] + filter[1][0] * image[1][0] + filter[1][1] * image[1][1] + filter[1][2] * image[1][2] + filter[2][0] * image[2][0] + filter[2][1] * image[2][1] + filter[2][2] * image[2][2];
      end
      else out_data <= 0;
    end
end

endmodule