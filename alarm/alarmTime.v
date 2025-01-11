//Similar to the Timer Moduel except the user input is directly
//used for the dividers instead of One Hz

module alarmTime 
(
	input reset, setSec, setMin, setHour,
	output [0:6] Gout, Hout, Iout, Jout, Kout, Lout
);
wire [3:0] G, H, I, J, K, L;
wire clock_out, one, sec0, sec1, min0, min1, hour0, hour1;
wire [3:0] count5, count10;
wire [9:0] count1000L, count1000M;

reg RST;

//instantiations

//sec low
dividebyN #(4'd10, 3'd4) seconds_low
(
	.CLK(setSec) , 
	.CLEAR(RST) , // input reset
	.OUT(sec0) , // output every 10 input pulses
	.COUNT(L) // output [3:0] seconds low count
);
binary2seven seconds_low_display
(
	.BIN(L) , // input [3:0] seconds low count
	.SEV(Lout) // output [0:6] low seconds display
);
//sec high 
dividebyN #(3'd6, 2'd3) seconds_high
(
	.CLK(sec0) , // input from low seconds
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(sec1) , // output to low minutes
	.COUNT(K) // output [3:0] high seconds count
);

binary2seven seconds_high_display
(
	.BIN(K) , // input [3:0] high seconds count
	.SEV(Kout) // output [0:6] high seconds display
);

//set min

dividebyN #(4'd10, 3'd4) min_low
(

	.CLK(setMin) , // input from high sec
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(min0) , // output to high minutes
	.COUNT(J) // output [3:0] low min count
);


binary2seven min_low_display
(
	.BIN(J) , // input [3:0] high seconds count
	.SEV(Jout) // output [0:6] high seconds display
);
//min high
dividebyN #(3'd6, 2'd3) min_high
(
	.CLK(min0) , // input from high sec
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(min1) , // output to high minutes
	.COUNT(I) // output [3:0] low min count
);
binary2seven min_high_display
(
	.BIN(I) , // input [3:0] high minutes count
	.SEV(Iout) // output [0:6] high minutes display
);

//set hour


//hour low
dividebyN #(4'd10, 3'd4) hour_low
(
	.CLK(setHour) , // input from high min
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(hour0) , // output to low hour
	.COUNT(H) // output [3:0] low hour count
);
binary2seven hour_low_display
(
	.BIN(H) , // input [3:0] low hours count
	.SEV(Hout) // output [0:6] low hours display
);
//limit to 24 hours
//hour high
dividebyN #(4'd3, 3'd4) hour_high
(
	.CLK(hour0) , // input from low hour
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(hour1) , // output to high hour
	.COUNT(G) // output [3:0] high hour count
);

binary2seven hour_high_display
(
	.BIN(G) , // input [3:0] high hours count
	.SEV(Gout) // output [0:6] high hours display
);

//Resets Clock at 24 hours
always@(*)
begin
	if((G == 2) && (H == 4))
	RST = 0;
	else RST = reset;
end

endmodule
