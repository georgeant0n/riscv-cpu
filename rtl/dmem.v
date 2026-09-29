// dmem.v — Data memory (read/write), used by lw and sw.
// Same idea as the register file, only bigger and with byte addresses:
//   - synchronous write:    on rising clk edge, if we == 1 then mem[word] <= wd
//   - combinational read:   rd = mem[word]
//   - word index = byte address / 4  (same as imem)
module dmem #(
    parameter DEPTH = 64               // number of 32-bit words
) (
    input  wire        clk,
    input  wire        we,             // write enable (from control: mem_write)
    input  wire [31:0] addr,           // byte address (from the ALU)
    input  wire [31:0] wd,             // data to write (register rs2 for sw)
    output wire [31:0] rd              // data read (goes to the register file for lw)
);
    reg [31:0] mem [0:DEPTH-1];

    // TODO 1 — write port (like the register file, but no special "x0" rule)
    always@(posedge clk) begin
    if(we)
    mem[addr[31:2]] <= wd;
    end

    // TODO 2 — read port (one assign)
    assign rd = mem[addr[31:2]];

endmodule
