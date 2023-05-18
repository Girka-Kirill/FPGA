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

module Girka_8 (
	input KEY0,
	input KEY1,
	input KEY2,
	input KEY3,
	input clk,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5
);

reg start;
reg [3:0] count1;
reg [3:0] count2;
reg [3:0] count3;
reg [3:0] memory1 [3:0];
reg [3:0] memory2 [3:0];
wire [9:0] shown_num;
reg [2:0] mem_size;
reg [1:0] mem_num;
wire reset_push, start_push, write_push, show_push;

pushing pushing_reset (
	.key (KEY0),
	.clk (clk),
	.push (reset_push)
);

pushing pushing_start (
	.key (KEY1),
	.clk (clk),
	.push (start_push)
);
pushing pushing_write (
	.key (KEY2),
	.clk (clk),
	.push (write_push)
);

pushing pushing_show (
	.key (KEY3),
	.clk (clk),
	.push (show_push)
);

always @(posedge clk)
begin
	if (start_push) start <= ~start;
	if (reset_push) 
	begin
		memory1[0] <= 0;
		memory1[1] <= 0;
		memory1[2] <= 0;
		memory1[3] <= 0;
		memory2[0] <= 0;
		memory2[1] <= 0;
		memory2[2] <= 0;
		memory2[3] <= 0;
		mem_size <= 0;
		start <= 0;
	end
	if (write_push) 
	begin
		if (start == 1)
			begin
				if (mem_size != 4)
					begin
						memory1[mem_size] <= count2;
						memory2[mem_size] <= count3;
						mem_size <= mem_size + 1;
					end
			end
		else 
			begin
				memory1[0] <= 0;
				memory1[1] <= 0;
				memory1[2] <= 0;
				memory1[3] <= 0;
				memory2[0] <= 0;
				memory2[1] <= 0;
				memory2[2] <= 0;
				memory2[3] <= 0;
				mem_size <= 0;
			end
	end
	if (show_push) mem_num <= (mem_num == mem_size - 1 || mem_size == 0) ? 0 : mem_num + 1;
end


reg [22:0] time_500hz;


always @(posedge clk)
begin
	time_500hz <= (time_500hz == 5000000) ? 0 : time_500hz + 1;
	if (time_500hz == 5000000 && start == 1)
	begin
		if (count1 == 4'd9)
		begin
			count1 <= 1'd0;
			if (count2 == 4'd9)
			begin
				count2 <= 1'd0;
				count3 <= (count3 == 4'd9) ? 1'd0 : count3 + 1'd1;
			end
			else count2 <= count2 + 1'd1;
		end
		else count1 <= count1 + 1'd1;
	end
	if (reset_push)
	begin
		count1 <= 0;
		count2 <= 0;
		count3 <= 0;
	end
end	

set_hex set_hex1 (
	.count (count1),
	.hex (HEX1)
);

set_hex set_hex2 (
	.count (count2),
	.hex (HEX2)
);

set_hex set_hex3 (
	.count (count3),
	.hex (HEX3)
);
	
set_hex set_hex4 (g
	.count (memory1[mem_num]),
	.hex (HEX4)
);
set_hex set_hex5 (
	.count (memory2[mem_num]),
	.hex (HEX5)
);	

endmodule

