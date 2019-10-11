module multy (
    iDataa,
    iDatab,

    oResult
);

parameter demention_dataa = 1;
parameter demention_datab = 1;

input      [demention_dataa-1:0] iDataa;
input      [demention_datab-1:0] iDatab;

output     [demention_dataa+demention_datab-2:0] oResult;

reg [demention_dataa+demention_datab-2:0] r_result; 
reg [demention_dataa+demention_datab-2:0] r_RetVal;
  
assign oResult = r_RetVal;

always @(iDataa, iDatab) begin
    r_result <= iDataa[demention_dataa-2:0] * iDatab[demention_datab-2:0]; 
end
  
always @(r_result) begin                          //  Any time the result changes, we need to recompute the sign bit,
    r_RetVal[demention_dataa+demention_datab-2] <= iDataa[demention_dataa-1] ^ iDatab[demention_datab-1]; //    which is the XOR of the input sign bits...  (you do the truth table...)
    r_RetVal[demention_dataa+demention_datab-3:0] <= r_result[demention_dataa+demention_datab-3:0];               //  And we also need to push the proper N bits of result up to 
end

endmodule