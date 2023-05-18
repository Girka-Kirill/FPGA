`timescale 1ns/ 1ns

module logar_2 (
	input [7:0]num,
	output [2:0]base
);

assign base = {3{num[0]}} & 3'd0|
	{3{num[1]}} & 3'd1|
	{3{num[2]}} & 3'd2|
	{3{num[3]}} & 3'd3|
	{3{num[4]}} & 3'd4|
	{3{num[5]}} & 3'd5|
	{3{num[6]}} & 3'd6|
	{3{num[7]}} & 3'd7;

endmodule

module top;
	reg [7:0]num;
	wire [2:0]res;
logar_2 log (
	.num (num),
	.base (res)
);
initial begin
	num = 2;
	#5
	$display("number=%d", num);
	$display("result=%d", res);
	#150
	num = 128;
	#5
	$display("number=%d", num);
	$display("result=%d", res);
	
end
endmodule