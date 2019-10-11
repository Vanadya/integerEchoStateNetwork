`timescale 1ps/1ps
module normaliser_testbench();
parameter demention = 4;
reg iClk;
reg  [15:0] iData;
wire  [5:0] oValue;

normaliser #(
.demention(demention)) u1
	(
	.iClk(iClk),
	.iData(iData),
	.oValue(oValue)
);

initial
begin
	iClk = 0;
	iData = 16'b1001100111101010;
end

always
begin
	#10 iClk = ~iClk;
end
endmodule