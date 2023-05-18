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

module set_hex (
	input [3:0] count,
	output [6:0] hex
);

assign hex = (count == 4'h0) ? 7'b1000000 :
				  (count == 4'h1) ? 7'b1111001 :
				  (count == 4'h2) ? 7'b0100100 :
				  (count == 4'h3) ? 7'b0110000 :
				  (count == 4'h4) ? 7'b0011001 :
				  (count == 4'h5) ? 7'b0010010 :
				  (count == 4'h6) ? 7'b0000010 :
				  (count == 4'h7) ? 7'b1111000 :
				  (count == 4'h8) ? 7'b0000000 :
				  (count == 4'h9) ? 7'b0010000 :
				  (count == 4'hA) ? 7'b0001000 :
				  (count == 4'hB) ? 7'b0000011 :
				  (count == 4'hC) ? 7'b1000110 :
				  (count == 4'hD) ? 7'b0100001 :
				  (count == 4'hE) ? 7'b0000110 : 7'b0001110 ;
				  
endmodule

module Girka_6 (
	input KEY0,
	input KEY1,
	input clk,
	input [7:0] SW1,
	input [7:0] SW2,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7,
	output LEDG8
);

wire reset_push, plus_push;
reg [7:0] count1;
reg [7:0] count2;
reg [8:0] sum;
reg [3:0] hexs [5:0];
reg overflow;

pushing pushing_plus (
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
	if (reset_push) 
	begin
		sum <= 0;
		
	end
	hexs[0] <= count1[3:0];
	hexs[1] <= count1[7:4];
	hexs[2] <= count2[3:0];
	hexs[3] <= count2[7:4];
	hexs[4] <= sum[3:0];
	hexs[5] <= sum[7:4];
	
end

assign LEDG8 = sum[8];

set_hex set_hex1 (
	.count (hexs[0]),
	.hex (HEX2)
);

set_hex set_hex2 (
	.count (hexs[1]),
	.hex (HEX3)
);

set_hex set_hex3 (
	.count (hexs[2]),
	.hex (HEX4)
);

set_hex set_hex4 (
	.count (hexs[3]),
	.hex (HEX5)
);

set_hex set_hex5 (
	.count (hexs[4]),
	.hex (HEX6)
);

set_hex set_hex6 (
	.count (hexs[5]),
	.hex (HEX7)
);

endmodule
