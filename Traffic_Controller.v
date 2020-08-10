//Verilog Traffic Controller for 2 streets, with sensors and 1 street given priority
//Street A (Hostels-Labs) is given priority above Street B (Dining - Fields)
//The controller in its default state gives Street A a Green Light always. If the Street B gets traffic, then it turns on the Green light for B until no traffic is present.

module traffic_light(light_A, light_B, sensor_A, sensor_B, clk, reset);

parameter Agreen_Bred = 2'b00;// A green and B red
parameter Ayellow_Bred = 2'b01;// A yellow and B red
parameter Ared_Bgreen = 2'b10;// A red and B green
parameter Ared_Byellow = 2'b11;// A red and B yellow

input sensor_A, sensor_B, clk, reset;

output reg[2:0] light_A, light_B;

reg[1:0] state, next_state;

//reset logic
always @(posedge clk, posedge reset)
begin
if(reset)
 state <= 2'b00;
else 
 state <= next_state; 
end

//next state FSM
always @(*)
begin
case(state)
Agreen_Bred: begin // green on A and red on B
 light_A = 3'b001;
 light_B = 3'b100;
  if(sensor_B) next_state = Ayellow_Bred;
  else next_state = Agreen_Bred;
 end

Ayellow_Bred: begin // yellow on A and red on B
 light_A = 3'b010;
 light_B = 3'b100;
 next_state = Ared_Bgreen;
 end

Ared_Bgreen: begin // red on A and green on B
 light_A = 3'b100;
 light_B = 3'b001;
  if(sensor_B) next_state = Ared_Bgreen;
  else next_state = Ared_Byellow;
 end

Ared_Byellow: begin // red on A and yellow on B
 light_A = 3'b100;
 light_B = 3'b010;
 next_state = Agreen_Bred;
 end

default: begin
 light_A = 3'b001;
 light_B = 3'b100;
 end
endcase
end
endmodule

//testbench code
module traffic_light_testbench;

reg clk, reset, TA, TB;
wire LA, LB;

traffic_light test(LA, LB, TA, TB, clk, reset);

initial begin clk = 1'b0;
forever #5 clk = ~clk;
end

initial begin
reset = 1;
#5	TA = 0; TB = 0; reset = 0;
#5	TA = 0; TB = 1;
#5	TA = 0; TB = 1;
#5	TA = 1; TB = 1;
#5	TA = 1; TB = 0;
#5	TA = 1; TB = 0;
#5	TA = 1; TB = 1;
#5 	TA = 1; TB = 1;
#5	TA = 0; TB = 1;
#5	TA = 0; TB = 0;
#5	TA = 0; TB = 0;

end
endmodule
