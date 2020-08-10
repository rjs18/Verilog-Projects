//Code for  serial adder

module serialadder(clk,si,la,lb,A,B,out);


input clk,la,lb,si;	//defining input values
input [22:0] A,B;	
output reg[22:0] out;	//output in the form of a 23 bit register
reg[22:0] A1=0,B1=0;		//registers for keeoing values of input A and B


reg siA=0,sftctrl=0;reg[4:0] count=0;	//sftctrl for controlling the shift
//siA is serial input for A and is sum output of adder
reg c_in,s,c_out;	//c_in is carry in and cout is carry out
reg Q=0,D=0;	



always@(posedge clk)
begin
if(la||lb)	//IF the load signal is on for either A or B
begin
sftctrl=0;count=0;	//sftctrl made low deactivating the shift register and count made 0
A1=A;B1=B;		
c_in=0;s=0;c_out=0;	//Initialized the values of c_in,s and c_out
end
else if(count==23)
begin
out=A1;		//send the output
sftctrl=0;	//deactivating the shift register
end
else 
begin
sftctrl=1'b1;		//enables the shift operation
{c_out,s}=A1[0]+B1[0]+c_in;	
siA=s;		//taking in serial input
A1=A1>>1;	//right shift
B1=B1>>1;	
//loading the values of serial inputs
A1[22]=siA;
B1[22]=si;


D=sftctrl?c_out:Q;	//mux
Q=D;			//flip_flop
c_in=Q;		//c_in is the output of the flip_flop
count=count+1;		//Increment in count
end
end

endmodule



//testbench code
module serialadder_testbench();
reg clk,si,la,lb;
reg[22:0] A,B;
wire [22:0] out;

serialadder sa(clk,si,la,lb,A,B,out);
initial
clk=1'b0;

always
#10 clk=~clk;

initial
begin
la=1;lb=1;
A=1;B=12;
si=0;
#20 la=0;lb=0;
#550 la=1;lb=1;
A=12;B=14;
#20 la=0;lb=0; 
end
endmodule
