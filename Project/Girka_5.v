module pushing (
	input key,
	input clk,
	output push
);

reg but_r;
reg but_rr;

always @(posedge clk)
begin
	but_r <= key;
	but_rr <= but_r;
end
assign push = but_rr & ~but_r;

endmodule

module Girka_5 (
	input KEY0,
	input KEY1,
	input clk,
	input [7:0] SW1,
	input [7:0] SW2,
	output [7:0] LEDR1,
	output [7:0] LEDR2,
	output [7:0] LEDG,
	output LEDG8
);

wire reset_push, plus_push;
reg [7:0] count1;
reg [7:0] count2;
reg [8:0] sum;
reg oversize;

pushing pushing_write (
	.key (KEY1),
	.clk (clk),
	.push (plus_push)
);

pushing pushing_reset (
	.key (KEY0),
	.clk (clk),
	.push (reset_push)
);
always @(posedge clk) 
begin
	count1 <= SW1;
	count2 <= SW2;
	if (plus_push) sum <= count1 + count2;
	if (reset_push) sum <= 1'b0;
end

assign LEDR1 = count1;
assign LEDR2 = count2;
assign LEDG = sum[7:0];
assign LEDG8 = sum[8];
				  
endmodule
