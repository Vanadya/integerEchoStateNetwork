`timescale 1ps/1ps
module intESN_testbench();

parameter 		reservoir_size = 4;
parameter 		data_width = 3;
parameter 		weight_size = 16;
parameter 		idata_demention = 2;
parameter		layer =1;
reg iClk;
reg [idata_demention-1:0]iItem;
reg iEn;
reg iRst_n;
reg iStart;
wire [(data_width+weight_size+layer)*2:0] oValue;

intESN #(.reservoir_size(reservoir_size),
.data_width(data_width),
.weight_size(weight_size),
.idata_demention(idata_demention),
.layer(layer)) u1
(
	.iClk(iClk),
	.iItem(iItem),
	.iEn(iEn),
	.iRst_n(iRst_n),
	.iStart(iStart),
	.oValue(oValue)
);
initial
begin
	iClk = 0;
	iEn = 0;
	iRst_n = 0;
	iItem = 2'b10;
	#10 iRst_n = 1;
	iStart = 1;
	#10 iEn = 1;
end

always
begin
	#5 iClk = ~iClk;
end


endmodule