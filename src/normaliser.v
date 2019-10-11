module normaliser(
	iClk,
	iData,
	oValue
);
parameter 		data_width = 3;
parameter 		weight_size = 2;
parameter 		reservoir_size = 4;
parameter		demention = data_width+weight_size-1;
parameter		layer = 1;
/* Необходито расчитать размер массива темп, t:
integer t=0;
	for(k=1;k<=norm_clocks;k=k+1)
	begin:tempVal
		//t = t + (demention+k)*(reservoir_size/(2*k));
	end
*/

input iClk;
input  [demention*reservoir_size-1:0] iData;
output  [(demention+layer):0] oValue;

wire [(demention+1)*(reservoir_size/2)-1:0] temp;
//wire [(demention+layer)-1:0]tempOut;
genvar i;
generate
	
	for(i=1;i<=reservoir_size/2;i=i+1)
	begin:summa
		summ_norm #(.demention(demention))el(
		.iClk(iClk),
		.iDataa(iData[demention*(2*i)-demention-1 -:demention]),
		.iDatab(iData[demention*(2*i)-1 -:demention]),
		.oResult(temp[i*(demention+1)-1-:(demention+1)])
		);
		end
	
	
	if(layer > 0)
		begin
			normaliser #(.layer(layer-1),
			.data_width(data_width+1),
			.reservoir_size(reservoir_size/2),
			.weight_size(weight_size)
			)element(
			.iClk(iClk),
			.iData(temp),
			.oValue(oValue)
			);
		end
	else
		begin
			assign oValue = temp;
		end

endgenerate
//assign oValue = tempOut;
endmodule