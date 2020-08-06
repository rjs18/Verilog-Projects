
module vendB(clock,reset,coin,vend,state,change);
input clock;
input reset;
input [2:0]coin;
output vend;
output [3:0]state;
output [2:0]change;

reg vend;
reg [2:0]change;
wire [2:0]coin;

parameter [2:0]TEN=3'b001;
parameter [2:0]TWENTY=3'b010;
parameter [2:0]FIFTY=3'b101;

parameter [3:0]IDLE=4'b0000;
parameter [3:0]S10=4'b0001;
parameter [3:0]S20=4'b0010;
parameter [3:0]S30=4'b0011;
parameter [3:0]S40=4'b0100;
parameter [3:0]S50=4'b0101;
parameter [3:0]S60=4'b0110;
parameter [3:0]S70=4'b0111;
parameter [3:0]S80=4'b1000;
parameter [3:0]S90=4'b1001;
parameter [3:0]S100=4'b1010;
parameter [3:0]S110=4'b1011;
parameter [3:0]S120=4'b1100;

reg [3:0]state,next_state;

always @(state or coin)
begin
next_state=0;
case(state)
IDLE: case(coin) 
TEN: next_state=S10;
TWENTY: next_state=S20;
FIFTY: next_state=S50;
default: next_state=IDLE;
endcase
S10: case(coin) 
TEN: next_state=S20;
TWENTY: next_state=S30;
FIFTY: next_state=S60;
default: next_state=S10;
endcase
S20: case(coin) 
TEN: next_state=S30;
TWENTY: next_state=S40;
FIFTY: next_state=S70;
default: next_state=S20;
endcase
S30: case(coin) 
TEN: next_state=S40;
TWENTY: next_state=S50;
FIFTY: next_state=S80;
default: next_state=S30;
endcase
S40: case(coin) 
TEN: next_state=S50;
TWENTY: next_state=S60;
FIFTY: next_state=S90;
default: next_state=S40;
endcase
S50: case(coin) 
TEN: next_state=S60;
TWENTY: next_state=S70;
FIFTY: next_state=S100;
default: next_state=S50;
endcase
S60: case(coin) 
TEN: next_state=S70;
TWENTY: next_state=S80;
FIFTY: next_state=S110;
default: next_state=IDLE;
endcase
S70: case(coin) 
TEN: next_state=S80;
TWENTY: next_state=S90;
FIFTY: next_state=S120;
default: next_state=IDLE;
endcase
S80: begin
vend <= 1'b1;
change <= 3'd0;
#2;
next_state=IDLE;
end
S90: begin
vend <= 1'b1;
change <= 3'd1;
#2;
next_state=IDLE;
end
S100: begin
vend <= 1'b1;
change <= 3'd2;
#2;
next_state=IDLE;
end
S110: begin
vend <= 1'b1;
change <= 3'd3;
#2;
next_state=IDLE;
end
S120: begin
vend = 1'b1;
change = 3'd4;
#2;
next_state=IDLE;
end
default: next_state=IDLE;
endcase
end

always@(clock)
begin
if(reset) begin
case(state)
IDLE: change<= 3'd0;
S10: change<= 3'd1;
S20: change<= 3'd2;
S30: change<= 3'd3;
S40: change<= 3'd4;
S50: change<= 3'd5;
S60: change<= 3'd6;
S70: change<= 3'd7;
default: change<= 3'd0;
endcase 
state <= IDLE;
vend <= 1'b0;
change <= 3'd0;
end
else state <= next_state;
end
endmodule

//testbench code
module vendB_test;

reg clock,reset;
reg [2:0]coin;

wire vend;
wire [3:0]state;
wire [2:0]change;

parameter [3:0]IDLE=4'b0000;
parameter [3:0]S10=4'b0001;
parameter [3:0]S20=4'b0010;
parameter [3:0]S30=4'b0011;
parameter [3:0]S40=4'b0100;
parameter [3:0]S50=4'b0101;
parameter [3:0]S60=4'b0110;
parameter [3:0]S70=4'b0111;
parameter [3:0]S80=4'b1000;
parameter [3:0]S90=4'b1001;
parameter [3:0]S100=4'b1010;
parameter [3:0]S110=4'b1011;
parameter [3:0]S120=4'b1100;

parameter [2:0]TEN=3'b001;
parameter [2:0]TWENTY=3'b010;
parameter [2:0]FIFTY=3'b101;

vendB ex1(clock,reset,coin,vend,state,change);

initial begin

$dumpvars; $dumpfile("file.vcd");

clock=0;
reset=1; //FIRST LETS RESET THE MACHINE
#2 reset=0;
coin=TEN; //CHECK FOR STATE 1
#2 reset=1; coin=2'b00;
#2 reset=0;
coin=TWENTY;
//RESET AGAIN AND CHECK FOR STATE 2
#2 reset=1; coin=2'b00;
#2 reset=0;
//RESET AGAIN AND CHECK FOR STATE 5
coin=FIFTY;
#2 reset=1; coin=2'b00;
#2 reset=0;
//RESET AGAIN AND CHECK FOR STATE 5
coin=TEN;
#2 coin=TEN;
#2 coin=TEN;
#2 coin=TEN;
#2 coin=TEN;
#2 reset=1; coin=2'b00;
#2 reset=0;
//RESET AGAIN AND CHECK FOR STATE 5 AND SO ON
coin=TEN;
#2 coin=TWENTY;
#2 coin=TWENTY;
#2 reset=1; coin=2'b00;
#2 reset=0;
coin=TEN;
#2 coin=TWENTY;
#2 coin=FIFTY;
#2 reset=1; coin=2'b00;
#2 reset=0;
coin=TEN;
#2 coin=TEN;
#2 coin=TEN;
#2 coin=TWENTY;
#2 reset=1; coin=2'b00;
#2 reset=0;
coin=TEN;
#2 coin=TEN;
#2 coin=TEN;
#2 coin=TEN;
#2 coin=TWENTY;
#2 reset=1; coin=2'b00;
#2 reset=0;
coin=TEN;
#2 coin=TEN;
#2 coin=FIFTY;#2 reset=1; coin=2'b00;
#2 reset=0;
coin=TEN;
#2 coin=FIFTY;
#2 reset=1; coin=2'b00;end

always
#1 clock=~clock;

initial begin
if (reset)
coin=2'b00;
end

endmodule

