`timescale 1ps/1ps
module reservoir_testbench();

reg iClk;
reg iEn;
reg [2:0] iWord;
reg [5:0] iY;
wire [8:0] oOut;
reg iRst_n;

reservoir r1(
.iClk(iClk),
.iWord(iWord),
.iY(iY),
.iRst_n(iRst_n),
.iEn(iEn),
.oOut(oOut)
);
initial
begin
	iRst_n = 0;
	iClk = 1;
	iEn = 0;
	#5 iRst_n = 1;
	iWord = 0;
	iY = 0;
	#15 iEn = 1;
	//#9 
	//iWord = 3'b111;
	//iY = 0;
	//#10
	//iWord = 3'b111;
	//iY = 6'b010101;
end

always
begin 
  #5  iClk =  ! iClk;    //создание clk 
 end


endmodule