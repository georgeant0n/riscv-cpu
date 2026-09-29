// imem.v — Instruction memory (read-only)
// Holds the program. Its contents are loaded from a hex file at the start of simulation
// ($readmemh), one 32-bit instruction per line.
//
// Addressing: the PC is a BYTE address and every instruction is 4 bytes, so the PC goes
// 0, 4, 8, 12, ...  The memory array is indexed by WORD (0, 1, 2, 3, ...).
//   word index = byte address / 4   -> in hardware: just drop the two lowest bits.
module imem #(
    parameter DEPTH     = 64,          // number of 32-bit words
    parameter INIT_FILE = ""           // hex file with the program
) (
    input  wire [31:0] addr,           // byte address (from the PC)
    output wire [31:0] instr
);
    reg [31:0] mem [0:DEPTH-1];

    initial begin
        if (INIT_FILE != "") $readmemh(INIT_FILE, mem);
    end

    // TODO: one assign statement — read the word at (byte address / 4).
    //       Hint: dividing by 4 = taking addr from bit 2 upward.
assign instr = mem[ addr[31:2] ];
endmodule
