// One Hz clock. Input clock is 50 MHz.
module oneHz //top module
(
	input clock, reset,
	output OneHz
);
wire TenMHz, OneMHz, OneKHz;
//instantiations
dividebyN #(3'd5, 3'd3) div5 //module divideXn needs to be included only once in the project
(
	.CLK(clock) , // input 50MHz clock
	.CLEAR(reset) , // input reset
	.OUT(TenMHz) , // output 10-MHz clock
	.COUNT(count) // output [3:0] count bits
);
dividebyN #(4'd10, 4'd4) div10
(
	.CLK(TenMHz) , // input 10MHz clock
	.CLEAR(reset) , // input reset
	.OUT(OneMHz) , // output 1-MHz clock
	.COUNT(count) // output [3:0] count bits
);
dividebyN #(10'd1000, 4'd10) div1000L
(
	.CLK(OneMHz) , // input 1-MHz clock
	.CLEAR(reset) , // input reset
	.OUT(OneKHz) , // output 1-KHz clock
	.COUNT(count) // output [3:0] count bits
);
dividebyN #(10'd1000, 4'd10) div1000H
(
	.CLK(OneKHz) , // input 1-KHz clock
	.CLEAR(reset) , // input reset
	.OUT(OneHz) , // output 1-Hz clock
	.COUNT(count) // output [3:0] count bits
);
endmodule
