// immgen.v — Immediate generator (sign-extension unit)
// RISC-V hides the immediate (a constant) inside the instruction, at different bit
// positions depending on the instruction format. This module collects those bits
// and sign-extends them to 32 bits.
//
//  imm_src  format  used by      immediate bits (from the RISC-V spec)
//  -------  ------  -----------  ---------------------------------------------------
//  2'b00    I       addi, lw     imm[11:0]  = instr[31:20]
//  2'b01    S       sw           imm[11:5]  = instr[31:25],   imm[4:0]   = instr[11:7]
//  2'b10    B       beq          imm[12]    = instr[31],      imm[11]    = instr[7],
//                                imm[10:5]  = instr[30:25],   imm[4:1]   = instr[11:8],
//                                imm[0]     = 0
//  2'b11    J       jal          imm[20]    = instr[31],      imm[19:12] = instr[19:12],
//                                imm[11]    = instr[20],      imm[10:1]  = instr[30:21],
//                                imm[0]     = 0
//
// Sign extension = fill every upper bit with the sign bit (always instr[31]),
// using replication like HDLBits Vector4:  {20{instr[31]}}  = 20 copies of instr[31].
// Every line must add up to exactly 32 bits.
module immgen (
    input  wire [31:0] instr,
    input  wire [1:0]  imm_src,
    output reg  [31:0] imm_ext
);
    always @(*) begin
        case (imm_src)
            2'b00:   imm_ext = { {20{instr[31]}}, instr[31:20] };   // I-type (example: 20 + 12 = 32)
            // TODO 2'b01: S-type
            2'b01:   imm_ext = { {20{instr[31]}} , instr[31:25] , instr[11:7]};
            // TODO 2'b10: B-type
            2'b10:   imm_ext = { {19{instr[31]}}, instr[31], instr[7],instr[30:25], instr[11:8], 1'b0 };
            // TODO 2'b11: J-type
            2'b11:   imm_ext = { {12{instr[31]}} , instr[19:12] , instr[20] , instr[30:21] , 1'b0 };
            default: imm_ext = 32'b0;
        endcase
    end
endmodule
