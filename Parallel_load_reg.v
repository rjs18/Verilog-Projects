//4 bit register with parallel load and asynchronus clear
`define TICK #2 //flipflop delay
module plreg (inp, clk, reset, out);
input clk, reset;
input [3:0] inp;
output reg [3:0] out;

always @ (posedge clk or posedge reset)
  begin
    if (~reset) begin
      out <= `TICK inp;
      end
    else begin
      out <= 4'b0000;
      end
end
endmodule

//testbench
module plregtb;
reg clk, reset;
reg [3:0] inp;
wire [3:0] out;

plreg q1(inp, clk, reset, out);

initial begin
  forever begin
	clk <=0;
	#5
	clk <=1;
	#5
	clk <=0;
  end
end

initial begin
reset = 1;
#12
reset = 0;
#90
reset = 1;
#12
reset = 0;
end

initial begin
inp = 4'b1100;
#50
inp = 4'b1000;
#30
inp = 4'b0100;
#40
inp = 4'b1111;
end
endmodule
