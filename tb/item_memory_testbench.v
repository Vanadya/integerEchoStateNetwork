`timescale 1ps/1ps
module item_meory_testbench();

parameter DATA_WIDTH=4;
parameter ADDR_WIDTH=2;

reg [(ADDR_WIDTH-1):0] addr;
reg iClk; 
wire [(DATA_WIDTH-1):0] q;

item_memory #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) u1(
.addr(addr),
.iClk(iClk),
.q(q)
);

initial
begin
	addr = 0;
	iClk = 1;
	#20 addr = 1;
	#20 addr = 3;
	#20 addr = 2;
	
end

always #5 iClk = ~iClk;
endmodule