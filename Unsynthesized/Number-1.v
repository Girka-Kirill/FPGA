`timescale 1ns/1ps

module check_even (
 	input [31:0] num,
	output res
);
	assign res = ~(num[0]);
endmodule

module top();
reg [31:0] a;
wire b;
check_even check
(
	.num	(a),
	.res	(b)
);
initial begin
	a = 4;
	#5
	$display("number = %d", a);
	$display("result = %d", b);
	a = 31;
	#5
	$display("number = %d", a);
	$display("result = %d", b);
end
endmodule

