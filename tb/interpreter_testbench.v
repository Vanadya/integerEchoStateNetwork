`timescale 1ps/1ps
module interpreter_testbench();
parameter reservoir_size = 4, data_width = 3, layer = 1;
parameter 		weight_size = 2;

reg iClk,iEn;
reg			[reservoir_size*data_width-1:0]	iData;
wire	[(data_width+weight_size+layer)*2:0]	oValue;
wire			oIntRdy;

interpreter 
#(.reservoir_size(reservoir_size),
.data_width(data_width),
.layer(layer),
.weight_size(weight_size)) i1
(
	.iClk(iClk),
	.iEn(iEn), 
	.iData(iData),
	.oValue(oValue),
	.oIntRdy(oIntRdy)
);

initial
begin
	iClk = 0;
	iEn = 0;
	iData = 12'b011110010001;
	#10 iEn = 1;
end

always
begin
	#5 iClk = ~iClk;
end
endmodule