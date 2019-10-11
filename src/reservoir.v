module reservoir (
	iClk,
	iWord,
	//iY,
	iRst_n,
	iEn,
	oOut
);
parameter 	reservoir_size = 3;
parameter		data_width = 3;

input iClk;
input iRst_n;
input iEn;
input [reservoir_size-1:0] iWord;
//input [reservoir_size*2-1:0] iY;

output [(data_width*reservoir_size-1):0]oOut;

reg [(reservoir_size-1)*data_width:0]reservoir_mem;

wire [data_width*reservoir_size-1:0]Term;
//объединение ячеек резервуара, вход iTerm текущего = выход oSum предыдущего

summ #(.data_width(data_width))element0(
	.iBitU(iWord[0]),
	//.iBitY(iY[1:0]),
	.iTerm(Term[data_width*reservoir_size-1 -: data_width]),
	.iClk(iClk),
	.iRst_n(iRst_n),
	.iEn(iEn),
	.oSum(Term[data_width-1:0])
);
genvar i;
generate 
	for(i=1;i<reservoir_size;i=i+1)
	begin : gen
		summ #(.data_width(data_width)) element(
		.iBitU(iWord[i]),
		//.iBitY(iY[i*2+1:i*2]),
		.iTerm(Term[i*data_width-1 -: data_width]),
		.iClk(iClk),
		.iRst_n(iRst_n),
		.iEn(iEn),
		.oSum(Term[i*data_width+data_width-1 : i*data_width])
		);
	end

endgenerate
assign oOut = Term;

always @(iRst_n)
begin
	if(!iRst_n)
	reservoir_mem = 0;
end

endmodule