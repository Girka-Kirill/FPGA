`timescale 1ns/1ps

module decoder3_8 (
	input [7:0]num,
	output [2:0]res
);

assign res = (num[7] == 1) ? 7 :
	     (num[6] == 1) ? 6 :
	     (num[5] == 1) ? 5 :
	     (num[4] == 1) ? 4 :
	     (num[3] == 1) ? 3 :
	     (num[2] == 1) ? 2 :
	     (num[1] == 1) ? 1 : 0;
endmodule

module top();
	reg [7:0]a;
	wire [2:0]b;
decoder3_8 dec(
	.num	(a),
	.res	(b)
);

initial begin
	a = 32;
	#5;
	$display("number=%d", a);
	$display("result=%d", b);
	#300;
	a = 7;
	#5;
	$display("number=%d", a);
	$display("result=%d", b);
	$stop;
end
endmodule