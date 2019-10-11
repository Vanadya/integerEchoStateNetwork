module handler(
    iClk,
    iStart,
    iRst_n,
    iIntRdy,

    oEnReserv,
    oEnIterpreter
);

parameter     SIZE = 3;
parameter     START  = 3'b001,
              RESERVOIR = 3'b010,
              INTERPRETER = 3'b100;

input iClk;
input iRst_n;
input iIntRdy;
input iStart;

output reg oEnReserv;
output reg oEnIterpreter;

reg [SIZE-1:0] state;

always @ (posedge iClk, negedge iRst_n) begin : FSM
    if (!iRst_n) begin
        state <= START;
        oEnReserv <= 0;
        oEnIterpreter <= 0;
    end else begin
        case(state)
            START:
            if (iStart == 1'b1) begin
                state <=  RESERVOIR;
                oEnReserv <= 0;
                oEnIterpreter <= 0;
            end 
            RESERVOIR:
            begin
                state <= INTERPRETER;
                oEnReserv <= 1;
                oEnIterpreter <=0;
            end
            INTERPRETER: 
            if (iIntRdy) begin
                state <= RESERVOIR;
            end else begin
                oEnReserv <= 0;
                oEnIterpreter <= 1;
            end
            default: state <= START;
        endcase
    end
end

endmodule