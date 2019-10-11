module summ_norm(
    iClk,
    iDataa,
    iDatab,

    oResult
);

parameter demention = 1;

input iClk;
input [demention-1:0] iDataa;
input [demention-1:0] iDatab;

output [demention:0] oResult;

reg [demention:0] temp;

assign oResult = temp;

always @(iClk) begin
    if (iDataa[demention-1] == iDatab[demention-1]) begin
        temp[demention] = iDataa[demention-1];
        temp[demention-1:0] = iDataa[demention-2:0] + iDatab[demention-2:0];
    end else begin
        if(iDataa[demention-2:0] > iDatab[demention-2:0]) begin
            temp[demention] = iDataa[demention-1];
            temp[demention-1:0] = iDataa[demention-2:0] - iDatab[demention-2:0];
        end else if(iDatab[demention-2:0] > iDataa[demention-2:0]) begin
            temp[demention] = iDatab[demention-1];
            temp[demention-1:0] = iDatab[demention-2:0] - iDataa[demention-2:0];
        end else begin
            temp = 0;
        end
    end
end

endmodule