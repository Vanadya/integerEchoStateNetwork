`timescale 1 ps/1 ps
module multiplier_testbench();


parameter 		data_width = 3;
parameter 		weight_size = 2;
parameter 		reservoir_size = 4;

reg 		iClk;
reg			[reservoir_size*data_width-1:0]	iData;
wire		[(data_width+weight_size-1)*reservoir_size-1:0] oValue;

multiplier #(
.data_width(data_width),
.weight_size(weight_size),
.reservoir_size(reservoir_size)
) u1
(
	.iClk(iClk),
	.iData(iData),
	.oValue(oValue)
);


initial
begin
iClk <= 0;
iData <= 12'b011001000010;
end

always 
begin
	#5 iClk = !iClk;
end

endmodule