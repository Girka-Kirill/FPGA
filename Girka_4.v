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
	input count,
	output hex
);

assign hex = (count == 4'h0) ? 7'b1000000 :
				  (count == 4'hF) ? 7'b1111001 :
				  (count == 4'hE) ? 7'b0100100 :
				  (count == 4'hD) ? 7'b0110000 :
				  (count == 4'hC) ? 7'b0011001 :
				  (count == 4'hB) ? 7'b0010010 :
				  (count == 4'hA) ? 7'b0000010 :
				  (count == 4'h9) ? 7'b1111000 :
				  (count == 4'h8) ? 7'b0000000 :
				  (count == 4'h7) ? 7'b0010000 :
				  (count == 4'h6) ? 7'b0001000 :
				  (count == 4'h5) ? 7'b0000011 :
				  (count == 4'h4) ? 7'b1000110 :
				  (count == 4'h3) ? 7'b0100001 :
				  (count == 4'h2) ? 7'b0000110 : 7'b0001110 ;
				  
endmodule
				  
module Girka_4 (
	input KEY0,
	input KEY1,
	input KEY2,
	input clk,
	input [7:0] SW,
	input SW8,
	output [15:0] LED,
	output [6:0] HEX0,
	output [6:0] HEX1
);

wire reset_push, write_push, send_push;
reg [15:0] count;
reg [7:0] acount;
reg [3:0] number0;
reg [3:0] number1;

pushing pushing_write (
	.key (KEY1),
	.clk (clk),
	.push (write_push)
);

pushing pushing_send (
	.key (KEY2),
	.clk (clk),
	.push (send_push)
);

pushing pushing_reset (
	.key (KEY0),
	.clk (clk),
	.push (reset_push)
);
always @(posedge clk) 
begin
	if (write_push) 
	begin
		count <=  (SW << 8);
		acount <= SW;
	end
	else if (send_push) count <= (count >> 1) + ((SW8) ? 16'b1000000000000000 : 16'b0000000000000000);
	else if (reset_push) 
	begin
		count <= 1'b0;
		acount <= 1'b0;
	end
	number0 <= acount[3:0];
   number1 <= acount[7:4];
end


assign LED = count;

assign HEX0 = (number0 == 4'h0) ? 7'b1000000 :
				  (number0 == 4'h1) ? 7'b1111001 :
				  (number0 == 4'h2) ? 7'b0100100 :
				  (number0 == 4'h3) ? 7'b0110000 :
				  (number0 == 4'h4) ? 7'b0011001 :
				  (number0 == 4'h5) ? 7'b0010010 :
				  (number0 == 4'h6) ? 7'b0000010 :
				  (number0 == 4'h7) ? 7'b1111000 :
				  (number0 == 4'h8) ? 7'b0000000 :
				  (number0 == 4'h9) ? 7'b0010000 :
				  (number0 == 4'hA) ? 7'b0001000 :
				  (number0 == 4'hB) ? 7'b0000011 :
				  (number0 == 4'hC) ? 7'b1000110 :
				  (number0 == 4'hD) ? 7'b0100001 :
				  (number0 == 4'hE) ? 7'b0000110 : 7'b0001110 ;

assign HEX1 = (number1 == 4'h0) ? 7'b1000000 :
				  (number1 == 4'h1) ? 7'b1111001 :
				  (number1 == 4'h2) ? 7'b0100100 :
				  (number1 == 4'h3) ? 7'b0110000 :
				  (number1 == 4'h4) ? 7'b0011001 :
				  (number1 == 4'h5) ? 7'b0010010 :
				  (number1 == 4'h6) ? 7'b0000010 :
				  (number1 == 4'h7) ? 7'b1111000 :
				  (number1 == 4'h8) ? 7'b0000000 :
				  (number1 == 4'h9) ? 7'b0010000 :
				  (number1 == 4'hA) ? 7'b0001000 :
				  (number1 == 4'hB) ? 7'b0000011 :
				  (number1 == 4'hC) ? 7'b1000110 :
				  (number1 == 4'hD) ? 7'b0100001 :
				  (number1 == 4'hE) ? 7'b0000110 : 7'b0001110 ;
				  

endmodule