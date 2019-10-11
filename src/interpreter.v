module interpreter
(
	iClk,
	iEn,
	iData,
	oValue,
	oIntRdy
);

parameter 		layer = 1;
parameter 		data_width = 3;
parameter 		weight_size = 16;
parameter 		reservoir_size = 4;
parameter 		WAIT  		= 4'b0001, 
					MULTIPLIER 	= 4'b0010, 
					SUMMARISE 	= 4'b0100, 
					ACTIVATION 	= 4'b1000;

input 		iClk;
input			iEn;
input			[reservoir_size*data_width-1:0]	iData;
output		[(data_width+weight_size+layer)*2:0] oValue;
output		oIntRdy;

wire [(data_width+weight_size-1)*reservoir_size-1:0] weightedValues;
wire summ_rdy, act_rdy;
wire multEn;
reg actEn;
wire [data_width+weight_size+layer-1:0] normValues;

reg [3:0] state;
reg [layer:0] norm_counter;

multiplier #(.reservoir_size(reservoir_size)
,.data_width(data_width)
,.weight_size(weight_size)) u1(
.iClk(iClk),
.iData(iData),
.oValue(weightedValues)
);
normaliser #(
.reservoir_size(reservoir_size),
.data_width(data_width),
.weight_size(weight_size),
.layer(layer)) u2(
	.iClk(iClk),
	.iData(weightedValues),
	.oValue(normValues)
);
actuator #(
.demention(data_width+weight_size+layer),
.weight_size(weight_size)) u3(
	.iData(normValues),
	.oData(oValue),
	.iClk(iClk),
	.iEn(actEn),
	.oComplete(act_rdy)
);
assign oIntRdy = act_rdy;

always @( posedge iClk)
begin
	case(state)
		WAIT:				if(iEn)
							begin
								state <= MULTIPLIER;
								norm_counter <= 0;
							end
		MULTIPLIER:			state <= SUMMARISE;
		SUMMARISE:		if(norm_counter>=layer+1)
							begin
								state <= ACTIVATION;
								actEn <= 1;
								norm_counter <= 0;
							end
							else
							begin
								norm_counter <=norm_counter+1;
							end
		ACTIVATION:		if(act_rdy)
							begin
								state <= WAIT;
								actEn <= 0;
							end
		default state <= WAIT;
	endcase
end


endmodule