module additional_forward_converter(
    iData,

    oData
);

parameter demention = 1;

input     [demention-1:0] iData;
output    [demention-1:0] oData;

assign oData = iData[demention-1] ? {1'b1, ~(iData[demention-2:0]-1'b1)} : iData;

endmodule