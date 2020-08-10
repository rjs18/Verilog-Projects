//Counter with binary sequence 0,1,2,4,6
module Counter01246 (counter, clk, reset);
input clk, reset;
output reg [2:0] counter;
reg [2:0] count;

always @ (posedge clk)
begin
  if (reset) count <= 0;
  else if (count == 6) count <= 0;
  else count <= count + 1;
end

always @ (count)
begin
  case (count)
  3'b000 : counter <= 3'b000;
  3'b001 : counter <= 3'b001;
  3'b010 : counter <= 3'b010;
  3'b011 : counter <= 3'b100;
  3'b100 : counter <= 3'b110;
  endcase
end
endmodule

//testbench for code
module Counter01246tb;
wire [2:0] counter;
reg clk, reset;

Counter01246 cnt(counter, clk, reset);

initial
begin
  clk =0; reset =1; #10; reset = 0; #200; $finish;
end

always #5 clk = ~clk;

initial begin
$dumpfile("dump.vcd"); $dumpvars;
end
endmodule 