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

module div_10 (
	input [19:0] divident,
	output [3:0] ones,
	output [3:0] decades,
	output [3:0] hundreds
);

genvar i;

wire [19:0] divs [8:0];
wire [3:0] ones1 [8:0];
wire [3:0] decades1 [8:0];
wire [19:0] tmp [8:0];
assign divs[0] = divident;

generate for (i = 1; i < 9; i = i + 1)
begin: division
	assign tmp[i] = divs[i - 1];
	assign ones1[i] = tmp[i][11:8];
	assign decades1[i] = tmp[i][15:12];
	assign divs[i] = (divs[i - 1] + ((ones1[i] >= 4'b0101) ? (4'b0011 << 8) : 0) + ((decades1[i] >= 4'b0101) ? (4'b0011 << 12) : 0)) << 1;  
end
endgenerate

assign ones = divs[8][11:8];
assign decades = divs[8][15:12];
assign hundreds = divs[8][19:16];

endmodule
		
module Girka_7 (
	input KEY0,
	input KEY1,
	input clk,
	input [7:0] SW,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7,
	output LEDG8
);


wire reset_push, input_push;
reg [7:0] count;
reg [3:0] numb0;
reg [3:0] numb1;
reg [3:0] numb2;
reg [3:0] numb3;

pushing pushing_input (
	.key (KEY1),
	.clk (clk),
	.push (input_push)
);

pushing pushing_reset (
	.key (KEY0),
	.clk (clk),
	.push (reset_push)
);

wire [4:0] ones, decades, hundreds;

div_10 divid (
	.divident (SW),
	.ones (ones),
	.decades (decades),
	.hundreds (hundreds)
);

always @ (posedge clk)
begin
	if (input_push) begin
		numb0 <= SW[3:0];
		numb1 <= SW[7:4];
		numb2 <= ones;
		numb3 <= decades;
	end	
	if (reset_push) begin
		numb0 <= 0;
		numb1 <= 0;
		numb2 <= 0;
		numb3 <= 0;
	end
end

assign LEDG8 = (hundreds > 0) ? 1 : 0;



set_hex set_hex1 (
	.count (numb0),
	.hex (HEX4)
);

set_hex set_hex2 (
	.count (numb1),
	.hex (HEX5)
);

set_hex set_hex3 (
	.count (numb2),
	.hex (HEX6)
);

set_hex set_hex4 (
	.count (numb3),
	.hex (HEX7)
);

endmodule