`timescale 1ns/10ps
module pattern(
  // Input signals
  clk,
  rst_n,
  in_valid,
  in_data1,
  in_data2,
  // Output signals
  out_valid,
  out_data
);
//================================================================
// wire & registers 
parameter PATNUM = 100;
parameter CYCLE = 5;
integer patcount;
integer lat;
integer k1;
integer k2;
integer k3;
integer input_file;
integer output_file;

//================================================================

output logic  clk,rst_n,in_valid;
output reg [2:0]   in_data1,in_data2;
input [7:0]	out_data;
input out_valid;

always #(CYCLE/2.0) clk = ~clk;
initial clk = 0;

logic [7:0] out [0:PATNUM];
integer out_count;


initial begin
  input_file = $fopen("input.txt", "r");
  output_file = $fopen("output.txt", "r");
  rst_n = 1;
  in_valid = 0;
  in_data1 = 3'bx;
  in_data2 = 3'bx;
  reset_task;
  out_count = 0;

  for(patcount = 0; patcount < PATNUM; patcount = patcount + 1) begin
    @(negedge clk);
    in_valid = 1;
    k1 = $fscanf(input_file, "%d", in_data1);
    k2 = $fscanf(input_file, "%d", in_data2);
    k3 = $fscanf(output_file, "%d", out[patcount]);
  end

  in_valid = 0;
    #(100.0);
    $display("--------------------------------------- \n YOU  PASS! \n ----------------------------------------");
    $finish;
end

always @(negedge clk) begin
  if(out_count < PATNUM && out_valid) begin
      if(out_data !== out[out_count]) begin
        $display("-----------------------------------\noutput should be %d\n, your output is: %d at %t\n-------------------------------------", out[out_count], out_data, $time);
         #(100);
        $finish;
        end
      else out_count <= out_count + 1;
  end
end

task reset_task; begin
  rst_n = 1;
  #(0.5); rst_n = 0;
  #(2.0);
  if((out_valid !== 0) || (out_data !== 0)) begin
    $display("------------------------------------");
    $display("reset signal! \n-----------------------------");
    #(100);
    $finish;
  end
  #(1.0) rst_n = 1;
end endtask

endmodule


