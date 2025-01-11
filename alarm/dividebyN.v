// Divide by N counter using M state variables
module dividebyN #(parameter N=10, parameter M=4)
(
	input CLK, CLEAR,
	output reg [M-1:0] COUNT, // COUNT is defined as a M-bit register
	output reg OUT
);

always @ (negedge CLK, negedge CLEAR)
	if (CLEAR==1'b0) COUNT <= 0; // COUNT is loaded with all 0's
	else
	begin
		if (COUNT == N-2'd2)
			begin
			OUT <= 1'b1; COUNT <= N-1'd1; // Once COUNT = N-2 OUT = 1
			end
		else if (COUNT == N-1'd1)
			begin //Once COUNT = N-1 OUT=0
				OUT <=1'b0; COUNT <= 0;
			end
		else
			begin // COUNT is incremented
				OUT <= 1'b0; COUNT <= COUNT + 1'b1;
			end
	end
endmodule
