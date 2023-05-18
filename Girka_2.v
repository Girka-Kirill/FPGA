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


module Girka_2
(
	input KEY0,
	input KEY1,
	input KEY2,
	input clk,
	output [6:0] LED
	
);

wire reset_push, plus_push, minus_push;
reg [2:0] count;
wire [2:0] acount;

pushing pushing_plus (
	.key (KEY1),
	.clk (clk),
	.push (plus_push)
);

pushing pushing_minus (
	.key (KEY2),
	.clk (clk),
	.push (minus_push)
);

pushing pushing_reset (
	.key (KEY0),
	.clk (clk),
	.push (reset_push)
);
always @(posedge clk) 
begin
	if (plus_push) count <=  count + 1;
	else if (minus_push) count <= count - 1;
	else if (reset_push) count <= 3'h0;
end


//assign LED = (1 << count) - 1;


genvar NUMB;
generate for (NUMB = 0; NUMB < 8; NUMB = NUMB + 1)
begin: setled 
	assign LED = count == NUMB ? {NUMB{1'b1}} : 0;
end
endgenerate
	

	
endmodule
				  
