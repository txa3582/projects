module timer
(
	input StartStop, clock, reset, setSec, setMin, setHour,
	output [0:6] Aout, Bout, Cout, Dout, Eout, Fout
);
wire [3:0] A, B, C, D, E, F;
wire clock_out, one, sec0, sec1, min0, min1, hour0, hour1;
wire [3:0] count5, count10;
wire [9:0] count1000L, count1000M;
reg RST;

//instantiations
OnOffToggle ClockSwitch
(
	.OnOff (StartStop) ,// StartStop PB
	.IN (clock) , // 50 MHz clock in
	.OUT(clock_out) // 50 MHz clock out
);


oneHz OneHzClockGenerator
(
	.clock(clock_out) , // input 50-MHz clock
	.reset(RST) , // input reset
	.OneHz(one) // output OneHz clock k0
);

//Determine whether seconds should be from One Hz or user input(Key2).
assign secVar = (setSec) ? one : ~setSec;

//sec low
dividebyN #(4'd10, 3'd4) seconds_low
(
	.CLK(secVar) , // input 1Hz clock
	.CLEAR(RST) , // input reset
	.OUT(sec0) , // output every 10 input pulses
	.COUNT(F) // output [3:0] seconds low count
);
binary2seven seconds_low_display
(
	.BIN(F) , // input [3:0] seconds low count
	.SEV(Fout) // output [0:6] low seconds display
);
//sec high 
dividebyN #(3'd6, 2'd3) seconds_high
(
	.CLK(sec0) , // input from low seconds
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(sec1) , // output to low minutes
	.COUNT(E) // output [3:0] high seconds count
);

binary2seven seconds_high_display
(
	.BIN(E) , // input [3:0] high seconds count
	.SEV(Eout) // output [0:6] high seconds display
);

//set min
assign minVar = (setMin) ? sec1: ~setMin;

dividebyN #(4'd10, 3'd4) min_low
(

	.CLK(minVar) , // input from high sec
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(min0) , // output to high minutes
	.COUNT(D) // output [3:0] low min count
);


binary2seven min_low_display
(
	.BIN(D) , // input [3:0] high seconds count
	.SEV(Dout) // output [0:6] high seconds display
);
//min high
dividebyN #(3'd6, 2'd3) min_high
(
	.CLK(min0) , // input from high sec
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(min1) , // output to high minutes
	.COUNT(C) // output [3:0] low min count
);
binary2seven min_high_display
(
	.BIN(C) , // input [3:0] high minutes count
	.SEV(Cout) // output [0:6] high minutes display
);

//set hour
assign hourVar = (setHour) ? min1 : ~setHour;


//hour low
dividebyN #(4'd10, 3'd4) hour_low
(
	.CLK(hourVar) , // input from high min
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(hour0) , // output to low hour
	.COUNT(B) // output [3:0] low hour count
);
binary2seven hour_low_display
(
	.BIN(B) , // input [3:0] low hours count
	.SEV(Bout) // output [0:6] low hours display
);
//limit to 24 hours
//hour high
dividebyN #(4'd3, 3'd4) hour_high
(
	.CLK(hour0) , // input from low hour
	.CLEAR(RST) , // input CLEAR_sig
	.OUT(hour1) , // output to high hour
	.COUNT(A) // output [3:0] high hour count
);
binary2seven hour_high_display
(
	.BIN(A) , // input [3:0] high hours count
	.SEV(Aout) // output [0:6] high hours display
);


//Resets Clock at 24 hours
always@(*)
begin
	if((A == 2) && (B == 4))
	RST = 0;
	else RST = reset;
end



endmodule
