`timescale 1ns / 100ps
module clk_div
(
	input wire clk,
	input wire reset,
	output reg result
);
reg [1:0] register = 0;
always @(posedge clk)
if (reset)
	result <= 0;
else begin
	register <= (register == 2) ? 0 : register + 1;
	result <= (register == 2) ? ~result : result;
end
endmodule

module top();
	reg clk;
	reg reset;
	wire result;
always #1 clk=~clk;
initial begin
	clk = 0;
	reset = 0;
	@(posedge clk);
	reset <= 1;
	repeat(3) @(negedge clk);
	reset <= 0;
end

clk_div c_d (
	.clk (clk),
	.reset (reset),
	.result (result)
);
endmodule