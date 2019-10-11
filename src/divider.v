module divider(
    iDivisor,
    iDividend,
    iStart,
    iClk,

    oQuotient,
    oComplete
);

parameter Q = 15;
parameter N = 32;

input   [N-1:0]   iDividend;
input   [N-1:0]   iDivisor;
input             iStart;
input             iClk;

output            oComplete;
output  [2*N:0]   oQuotient;


reg [2*N+Q-3:0]   reg_working_quotient; //  Our working copy of the quotient
reg [2*N-1:0]     reg_quotient;       //  Final quotient
reg [N-2+Q:0]     reg_working_dividend; //  Working copy of the dividend
reg [2*N+Q-3:0]   reg_working_divisor;    // Working copy of the divisor
reg [N-1:0]       reg_count;    //  This is obviously a lot bigger than it needs to be, as we only need 
                        //    count to N-1+Q but, computing that number of bits requires a 
                        //    logarithm (base 2), and I don't know how to do that in a 
                        //    way that will work for everyone     
reg               reg_done;     //  Computation completed flag
reg               reg_sign;     //  The quotient's sign bit
 
initial reg_done = 1'b1;        //  Initial state is to not be doing anything
initial reg_sign = 1'b0;        //    And the sign should be positive
initial reg_working_quotient = 0; 
initial reg_quotient = 0;       
initial reg_working_dividend = 0; 
initial reg_working_divisor = 0;    
initial reg_count = 0;    

assign oQuotient[N*2-1:0] = reg_quotient[N*2-1:0];  //  The division results
assign oQuotient[N*2] = reg_sign;           //  The sign of the quotient
assign oComplete = reg_done;
 
always @( posedge iClk ) begin
    if( reg_done && iStart ) begin                    //  This is our startup condition
        //  Need to check for a divide by zero right here, I think....
        reg_done <= 1'b0;                       //  We're not done      
        reg_count <= N+Q-1;                     //  Set the count
        reg_working_quotient = 0;                 //  Clear out the quotient register
        reg_working_dividend = 0;                 //  Clear out the dividend register 
        reg_working_divisor <= 0;                 //  Clear out the divisor register 
        reg_working_dividend[N+Q-2:Q] = iDividend[N-2:0];       //  Left-align the dividend in its working register
        reg_working_divisor[2*N+Q-3:N+Q-1] <= iDivisor[N-2:0];    //  Left-align the divisor into its working register
        reg_sign <= iDividend[N-1] ^ iDivisor[N-1];   //  Set the sign bit
    end else if(!reg_done) begin
        reg_working_divisor <= reg_working_divisor >> 1;  //  Right shift the divisor (that is, divide it by two - aka reduce the divisor)
        reg_count <= reg_count - 1;               //  Decrement the count
        //  If the dividend is greater than the divisor
        if(reg_working_dividend >= reg_working_divisor) begin
            reg_working_quotient[reg_count] = 1'b1;                   //  Set the quotient bit
            reg_working_dividend = reg_working_dividend - reg_working_divisor;  //    and subtract the divisor from the dividend
        end
        //stop condition
        if(reg_count == 0) begin
            reg_done <= 1'b1;                   //  If we're done, it's time to tell the calling process
            reg_quotient = reg_working_quotient;      //  Move in our working copy to the outside world
        end else begin
            reg_count <= reg_count - 1; 
        end
    end
end

endmodule