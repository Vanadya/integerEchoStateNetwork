`timescale 1ps/1ps
module actuator_testbench();

parameter		weight_size = 5;
parameter		demention = 10;

reg iEn;
reg  [demention-1:0] iData;
wire  [demention-1:0] oData;
wire							oComplete;
reg							iRst_n;
reg							iClk;

actuator #(
.weight_size(weight_size),
.demention(demention))u1
(
	.iEn(iEn),
	.iData(iData),
	.oData(oData),
	.iRst_n(iRst_n),
	.iClk(iClk),
	.oComplete(oComplete)
);

initial
begin
	iRst_n = 0;
	iEn = 0;
	iClk = 1;
	#5 iRst_n = 1;
	#10 iData = 10'sb1000001000;
	#5 iEn = 1;
	#5 iEn = 0;
	#50 iEn = 1;
	
end
always #5 iClk = ~iClk;
endmodule