module summ(
    iBitU, //0,1 - 0=-1; 1 = 1;
    iTerm, // подается значение соседней ячейки резервуара 
    iClk,
    iEn,
    iRst_n,

    oSum // сумма, обрезаная
);

parameter data_width = 3; // один разряд под знак, остальные под значащую часть.
// отрицательные числа в обратном коде

input iBitU;
input signed [data_width-1:0] iTerm;
input iClk;
input iRst_n;
input iEn;

output signed [data_width-1:0] oSum;

wire [data_width-1:0]VarMax;
wire [data_width-1:0]VarMin;
wire Word;

reg signed [data_width-1:0] Sum;

//генерация максимальной и минимальной константы для сравнения
genvar i;
generate 
    assign VarMin[0] =  1;
    for(i=1; i<data_width-1;i = i+1) begin : varMinDef
        assign VarMin[i] =  0;
    end
    assign VarMin[data_width-1] = 1;
endgenerate

genvar j;
generate 
    for(j=0; j<data_width-1;j = j+1) begin : varMaxDef
        assign VarMax[j] =  1;
    end
    assign VarMax[data_width-1] = 0;
endgenerate

assign oSum = Sum;
assign Word = iBitU;

always @(posedge iClk or negedge iRst_n) begin
    if(!iRst_n) begin
        Sum = 0;
    end else if(iEn) begin
        case(Word)
            1'b0: Sum = (iTerm == VarMin) ? Sum : Sum - 1'sb1;
            1'b1: Sum = (iTerm == VarMax) ? Sum : Sum + 1'sb1;
        endcase
    end
end
endmodule