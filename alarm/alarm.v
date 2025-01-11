module alarm //top level
(
	input alarmMode, setAlarm, StartStop, clock, reset, setSec, setMin, setHour,
	output [0:6] Mout, Nout, Oout, Pout, Qout, Rout,
	output reg alarm,
	output setAlarmLED
);

wire [0:6] Aout, Bout, Cout, Dout, Eout, Fout,
				Gout, Hout, Iout, Jout, Kout, Lout;
				
// set alarm/set time
//Determines time of alarm and timer/clock based on alarm mode(Key5)
assign secTime = (alarmMode) ? setSec : 1;
assign secAlarm = (alarmMode) ? 1 : setSec;
assign minTime = (alarmMode) ? setMin : 1;
assign minAlarm = (alarmMode) ? 1 : setMin;
assign hourTime = (alarmMode) ? setHour : 1;
assign hourAlarm = (alarmMode) ? 1 : setHour;

//Timer 
timer Clock
(
	.StartStop (StartStop) ,// StartStop PB
	.clock (clock) , // 50 MHz clock in
	.reset(reset),
	.setSec(secTime),
	.setMin(minTime),
	.setHour(hourTime),
	.Aout(Aout),
	.Bout(Bout),
	.Cout(Cout),
	.Dout(Dout),
	.Eout(Eout),
	.Fout(Fout)
	
);

//Alarm
alarmTime Alarm
(
	.reset(reset),
	.setSec(secAlarm),
	.setMin(minAlarm),
	.setHour(hourAlarm),
	.Gout(Gout),
	.Hout(Hout),
	.Iout(Iout),
	.Jout(Jout),
	.Kout(Kout),
	.Lout(Lout)
	
);

//alarm/time mode
//determines which display to use depending on the alarm mode(key5)
assign Mout = (alarmMode) ? Aout : Gout;
assign Nout = (alarmMode) ? Bout : Hout;
assign Oout = (alarmMode) ? Cout : Iout;
assign Pout = (alarmMode) ? Dout : Jout;
assign Qout = (alarmMode) ? Eout : Kout;
assign Rout = (alarmMode) ? Fout : Lout;



//If the Alarm display and Timer display equal then set alarm.
always @(*)
begin
if((Aout == Gout) && (Bout == Hout) && (Cout == Iout) && (Dout == Jout) 
&& (Eout == Kout) && (Fout == Lout) && (setAlarm == 1) && (alarm == 0))
alarm = 1;

else if(alarm == 1 && setAlarm == 1) alarm = 1;
else alarm = 0;
end

//set Alarm LED indicator
assign setAlarmLED = (setAlarm) ? 1 : 0;

endmodule
