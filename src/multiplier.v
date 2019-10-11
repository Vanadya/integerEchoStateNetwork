module multiplier(
    iClk,
    iData,

    oValue
);

parameter     data_width = 3;
parameter     weight_size = 32;
parameter     reservoir_size = 3;

input iClk;
input [reservoir_size*data_width-1:0] iData;
output [(data_width+weight_size-1)*reservoir_size-1:0] oValue;

wire [(data_width+weight_size-1)*reservoir_size-1:0] weightedValues;
wire summ_rdy, reset_rdy, act_rdy;
wire [data_width*reservoir_size-1:0]  temp_forward;
wire [reservoir_size*weight_size-1:0] weights;

assign oValue = weightedValues;

weights_memory #(
    .weight_size(weight_size),
    .reservoir_size(reservoir_size)) 
u4(
    .oWeights(weights)
);

genvar i;
generate 
    for(i=0;i<reservoir_size;i=i+1) begin : gen
        additional_forward_converter #(
            .demention(data_width)) 
        conv(
            .iData(iData[(i+1)*data_width-1:i*data_width]),
            .oData(temp_forward[(i+1)*data_width-1:i*data_width])
        );
        multy #(
            .demention_dataa(data_width),
            .demention_datab(weight_size))
        element(
            .iDataa(temp_forward[(i+1)*data_width-1:i*data_width]),
            .iDatab(weights[(i+1)*weight_size-1:i*weight_size]),
            .oResult(weightedValues[(i+1)*(weight_size+data_width-1)-1:i*(weight_size+data_width-1)])
        );
    end
endgenerate

endmodule