module abs( // signed x = |x|
	iData,
	oData
);
parameter			demention = 1;

input signed 	[demention-1:0]	iData;
output   [demention-1:0]	oData;

assign oData = iData[demention-1] ? (iData * 2'sb11) : iData;
	
endmodule