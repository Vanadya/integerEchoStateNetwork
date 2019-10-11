`timescale 1ps/1ps
module summ_testbench();

reg iClk;
reg iRst_n;
reg iBitU;
reg [2:0]iTerm;

wire [2:0] oSum;
summ i1 (
	.iClk(iClk),
	.iBitU(iBitU), 
	.iTerm(iTerm),
	.iRst_n(iRst_n),
	.oSum(oSum)
);
initial                                                
begin   
	iRst_n = 0;
	iClk = 1;
	#5 iRst_n = 1;
	iBitU = 1;
	iTerm = 3'sb011;                                           
  $display("Running testbench"); 
	#20 iBitU = 1;
	iTerm = 3'sb100; 
	#20 iBitU = 1;
	//iTerm = 3'sb111;
	iTerm = oSum;
	 #20 iTerm = oSum;
	  #20 iTerm = oSum;
	   #20 iTerm = oSum;
		 #20 iTerm = oSum;
		  #20 iTerm = oSum;
		   #20 iTerm = oSum;
			
end                                                    

always
begin 
  #5  iClk =  !iClk;    //создание clk 
 end
 
 endmodule