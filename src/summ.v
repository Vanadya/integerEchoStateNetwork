module summ(
iBitU, //0,1 - 0=-1; 1 = 1;
//iBitY, // -1 ; 0 ; 1
iTerm, // подается значение соседней ячейки резервуара 
oSum, // сумма, обрезаная
iClk,
iEn,
iRst_n
);

parameter data_width = 3; // один разряд под знак, остальные под значащую часть.
// отрицательные числа в обратном коде

input iBitU;
//input signed [1:0] iBitY;
input signed [data_width-1:0]iTerm;
input iClk;
input iRst_n;
input iEn;
output signed[data_width-1:0]oSum;


reg signed[data_width-1:0]Sum;

wire [data_width-1:0]VarMax;
wire [data_width-1:0]VarMin;
wire Word;//signed [2:0] Word;
//генерация мксимальной и минимальной константы для сравнения

genvar i;
generate 
	assign VarMin[0] =	1;
	for(i=1; i<data_width-1;i = i+1)
	begin : varMinDef
		assign VarMin[i] =	0;
	end
	assign VarMin[data_width-1] =	1;
endgenerate
genvar j;
generate 
	for(j=0; j<data_width-1;j = j+1)
	begin : varMaxDef
		assign VarMax[j] =	1;
	end
	assign VarMax[data_width-1] =	0;
endgenerate

assign oSum = Sum;
/*assign Word = (iBitU) ? iBitY + 2'sb01 : iBitY - 2'sb01;
always @(posedge iClk or negedge iRst_n)
begin
//	Sum = (iBitU) ? 
						((iTerm == VarMax) ? iTerm : iTerm + 2'sb01) 
						:((iTerm == VarMin) ? iTerm : iTerm - 2'sb01 );
	if(!iRst_n)
	begin
		Sum = 0;
	end else if(iEn)
	begin
		case(Word)
		3'sb100: Sum = Sum;
		3'sb101: Sum = Sum;
		3'sb110: Sum = (iTerm == VarMin) ? iTerm : (iTerm == VarMin + 2'sb01) ? iTerm - 2'sb01 : iTerm - 3'sb010;
		3'sb111: Sum = (iTerm == VarMin) ? iTerm : iTerm - 2'sb01;
		3'sb000: Sum = Sum;
		3'sb001: Sum = (iTerm == VarMax) ? iTerm : (iTerm + 2'sb01);
		3'sb010: Sum = (iTerm == VarMax) ? iTerm : (iTerm == VarMax - 2'sb01) ? iTerm + 2'sb01 : iTerm + 3'sb010;
		3'sb011: Sum = Sum;
		endcase
	end
end
*/
assign Word = iBitU;
always @(posedge iClk or negedge iRst_n)
begin
	if(!iRst_n)
	begin
		Sum = 0;
	end else if(iEn)
	begin
		case(Word)
		1'b0: Sum = (iTerm == VarMin) ? Sum : Sum - 1'sb1;
		1'b1: Sum = (iTerm == VarMax) ? Sum : Sum + 1'sb1;
		endcase
	end
end
endmodule