module actuator(
	iData,
	iEn,
	oData,
	oComplete,
	iRst_n,
	iClk
);

parameter		demention = 1;
parameter		weight_size = 32;
parameter 		WAIT  = 3'b001, 
					CONVERTION = 3'b010, 
					DIVIDING = 3'b100;

input  			[demention-1:0] 		iData;
input											iEn;
input											iClk;
input											iRst_n;
output										oComplete;
output 			[demention*2:0]		oData;

//wire  [demention-1:0] 	absValue;
wire 	[demention-1:0]	weightShift;
//wire 	[demention-1:0]	forwardTemp;
wire							div_rdy;
reg 							divStart;
reg						reg_div_done;
reg [2:0] state;

genvar i;
generate
	
	for(i=0;i<demention;i=i+1)
	begin:init
		if(i != weight_size-1)
		begin
			assign weightShift[i] = 1'b0;
		end
		else
		begin
			assign weightShift[i] = 1'b1;
		end
	end
endgenerate
/*
abs #(.demention(demention))u1(
	.iData(iData),
	.oData(absValue)
);
additional_forward_converter #(.demention(demention)) u2(
	.iData(iData),
	.oData(forwardTemp)
);*/
divider #(.N(demention),.Q(weight_size)) u3(
	.iDividend(iData),
	.iDivisor(weightShift + {1'b0,iData[demention-2:0]}),
	.iClk(iClk),
	.iStart(divStart),
	.oQuotient(oData),
	.oComplete(div_rdy)
);
assign oComplete = reg_div_done;

always @(posedge iClk, negedge iRst_n)
begin
	if(!iRst_n)
	begin
		state <= WAIT;
		divStart <= 0;
		
	end
	else case(state)
		WAIT:				if(iEn)
							begin
								state <= CONVERTION;
								reg_div_done <=0;
							end
		CONVERTION:		begin
								state <= DIVIDING;
								divStart <= 1;
							end
		DIVIDING:		begin
								if(div_rdy)
									begin
										divStart <= 0;
										state <= WAIT;
										reg_div_done <=1;
									end
							end
		default begin
				state <=WAIT;
				end
	endcase
end

endmodule