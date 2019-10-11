module intESN(
    iClk,
    iItem,
    iEn,
    iRst_n,
    iStart,

    oValue
);

parameter     reservoir_size = 4;
parameter     data_width = 3;
parameter     weight_size = 16;
parameter     idata_demention = 2;
parameter     layer = 1;

input iClk;
input iEn;
input [idata_demention-1:0] iItem;
input iRst_n;
input iStart;
output [(data_width+weight_size+layer)*2:0] oValue;

wire [reservoir_size-1:0] reservoir_word;
wire [data_width*reservoir_size-1:0] reservoir_out;
wire EnInterpreter;
wire EnReserv;
wire IntRdy;

reservoir #(
  .reservoir_size(reservoir_size),
  .data_width(data_width)) 
u1(
  .iClk(iClk),
  .iWord(reservoir_word),
  .iRst_n(iRst_n),
  //.iY(iItem),

  .oOut(reservoir_out),
  .iEn(EnReserv)
);

interpreter #(
    .reservoir_size(reservoir_size),
    .data_width(data_width),
    .weight_size(weight_size),
    .layer(layer)) 
u2(
    .iClk(iClk),
    .iEn(EnInterpreter),
    .iData(reservoir_out),

    .oIntRdy(IntRdy),
    .oValue(oValue)
);

handler u3(
    .iClk(iClk),
    .iStart(iStart),
    .iRst_n(iRst_n),
    .iIntRdy(IntRdy),

    .oEnReserv(EnReserv),
    .oEnIterpreter(EnInterpreter)
);

item_memory #(.DATA_WIDTH(reservoir_size),.ADDR_WIDTH(idata_demention))u4(
    .iClk(iClk),
    .addr(iItem),

    .q(reservoir_word)
);
endmodule