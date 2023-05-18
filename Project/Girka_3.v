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

module Girka_3 (
	input KEY0,
	input KEY1,
	input KEY2,
	input clk,
	input SW0,
	input SW1,
	output [7:0] LED
	
);

wire reset_push, left_push, right_push;
reg [7:0] count;

pushing pushing_left (
	.key (KEY1),
	.clk (clk),
	.push (left_push)
);

pushing pushing_minus (
	.key (KEY2),
	.clk (clk),
	.push (right_push)
);

pushing pushing_reset (
	.key (KEY0),
	.clk (clk),
	.push (reset_push)
);
always @(posedge clk) 
begin
	if (left_push) count <=  (count << 1) + SW0;
	else if (right_push) count <= (count >> 1) + ((SW1) ? 8'b10000000 : 8'b00000000);
	else if (reset_push) count <= 8'b00000000;
end


assign LED = count;
				  
endmodule
