//shift register to store the two inputs a and b to be added
module shift(y,d,clk);
input [3:0] d;
input clk;
output [3:0] y;
reg [3:0] y;
initial begin
assign y=d;
end
always @(posedge clk)
begin
assign y=y>>1;
end
endmodule

//serial in parallel out register to store the 4 bit sum
module sipo(y,s,clk);
input  s;
input clk;
output [3:0] y;
reg [3:0] y;
always @(posedge clk)
begin
assign y={s,y[3:1]};
end
endmodule

//1 bit full adder
module fa(s,cout,a,b,cin);
input a,b,cin;
output s,cout;
assign {cout,s}=a+b+cin;
endmodule

//d flipflop to store the cout of each stage
module dff(q,d,clk);
input d,clk;
output q;
reg q;
initial begin
q=1'b0;
end
always @(posedge clk)
begin
q=d;
end
endmodule

//main module serial adder//
module serial(sum,cout,a,b,clk);
input [3:0] a,b;
input clk;
wire [3:0] x,z;
output [3:0] sum; 
output cout;
wire s,cin;
//input cin;
//initial begin
//cin=cinp;
//end
fa k(s,cout,x[0],z[0],cin);              //1 bit full adder
dff q(cin,cout,clk);                     //d flipflop to store the cout value after each 1 bit full adder operation
sipo m(sum,s,clk);                        //serial sum(s) converted to parallel output(4 bit sum)///
shift g(x,a,clk);                      //shifts the input a
shift h(z,b,clk);                      //shifts the input b
endmodule

//testbench
module serialtb;
reg [3:0] a, b;
reg clk;
wire [3:0] sum;
wire cout;

serial sl(sum,cout,a,b,clk);

initial clk = 1'b0;
always #10 clk = ~clk;

initial begin
a= 4'b0111;
b= 4'b0110;
end

endmodule


