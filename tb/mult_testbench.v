module mult_testbench();

parameter demention_dataa = 5;
parameter demention_datab = 10;

reg iEn;
reg[demention_dataa-1:0]  iDataa;
reg[demention_datab-1:0]  iDatab;
wire [demention_dataa+demention_datab-2:0] oResult;

MULT #(.demention_dataa(demention_dataa),.demention_datab(demention_datab))i1 (
	.iDataa(iDataa), 
	.iDatab(iDatab),
	.oResult(oResult)
);
initial                                                
begin   
	#5 iDataa = 5'b01000;
	#10 iDatab = 10'b1000001001;
	#10 iDataa = 5'b11010;
	iDatab = 10'b1000001101;
	#5 iDataa = 5'b01111;
	iDatab = 10'b0000000000;
end                                                    



endmodule