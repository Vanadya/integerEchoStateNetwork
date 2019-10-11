module item_memory(
    addr,
    iClk, 
    q
);

parameter DATA_WIDTH = 4; 
parameter ADDR_WIDTH = 2;

input [(ADDR_WIDTH-1):0] addr;
input iClk; 
output reg [(DATA_WIDTH-1):0] q;

reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];

initial begin
    $readmemb("single_port_rom_init.txt", rom);
end

always @ (posedge iClk) begin
    q <= rom[addr];
end

endmodule
