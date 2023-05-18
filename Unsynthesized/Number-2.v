`timescale 1ns/1ps

module decoder3_8 (
	input [2:0]num,
	output [7:0]res
);

assign res = 1 << num;

endmodule

module top();
	reg [2:0]a;
	wire [7:0]b;
decoder3_8 dec(
	.num	(a),
	.res	(b)
);

initial begin
	a = 7;
	#5;
	$display("number=%d", a);
	$display("result=%d", b);
	#300;
	a = 2;
	#5;
	$display("number=%d", a);
	$display("result=%d", b);
	$stop;
end
endmodule