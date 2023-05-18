`timescale 1ns / 100ps
module clk_div
(
	input wire clk,
	input wire reset,
	output reg clk_div2,
	output reg clk_div4,
	output reg clk_div8
);
reg tmp2;
reg tmp4;
always @(posedge clk)
if (reset)
	{clk_div2, clk_div4, clk_div8} <= 0;
else begin
	clk_div2 <= ~clk_div2;
	clk_div4 <= clk_div2 ? ~clk_div4: clk_div4; 
	clk_div8 <= (clk_div2 & clk_div4)? ~clk_div8: clk_div8; 
end
endmodule

module top();
	reg clk = 0;
	reg reset = 0;
	wire clk_div2;
	wire clk_div4;
	wire clk_div8;
	wire [2:0] clk_div;
always #1 clk=~clk;
always begin
	@(posedge clk)
	reset <= 1;
	repeat(3) @(negedge clk);
	reset <= 0;
end

clk_div c_d (
	.clk (clk),
	.reset (reset),
	.clk_div2 (clk_div2),
	.clk_div4 (clk_div4),
	.clk_div8 (clk_div8)
);
clk_div c_d1 (
	.clk (clk),
	.reset (reset),
	.clk_div2 (clk_div[0]),
	.clk_div4 (clk_div[1]),
	.clk_div8 (clk_div[2])
);
endmodule