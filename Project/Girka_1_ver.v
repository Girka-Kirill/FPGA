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

module Girka_1_ver (
	input KEY0,
	input KEY1,
	input KEY2,
	input clk,
	output [6:0] HEX0
	
);

wire reset_push, plus_push, minus_push;
reg [3:0] count;

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
	if (plus_push) count <= (count == 9) ? 0 : count + 1;
	else if (minus_push) count <= (count == 0) ? 9 : count - 1;
	else if (reset_push) count <= 4'h0;
end


assign HEX0 = (count == 4'h0) ? 7'b1000000 :
				  (count == 4'h1) ? 7'b1111001 :
				  (count == 4'h2) ? 7'b0100100 :
				  (count == 4'h3) ? 7'b0110000 :
				  (count == 4'h4) ? 7'b0011001 :
				  (count == 4'h5) ? 7'b0010010 :
				  (count == 4'h6) ? 7'b0000010 :
				  (count == 4'h7) ? 7'b1111000 :
				  (count == 4'h8) ? 7'b0000000 : 7'b0010000 ;
				  
endmodule
