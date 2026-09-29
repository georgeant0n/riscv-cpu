// control.v — Control unit (instruction decoder)
// Looks at the instruction's opcode (and funct3/funct7 for ALU ops) and produces the
// control signals that steer the whole datapath.
//
// ---------------------------------------------------------------------------------
// Part 1 — MAIN DECODER (from op)
//
//  signal       meaning
//  ----------   ----------------------------------------------------------------
//  reg_write    1 = write the result into register rd
//  imm_src      which immediate format ImmGen should build (00 I, 01 S, 10 B, 11 J)
//  alu_src      ALU input b:  0 = register rd2,  1 = immediate
//  mem_write    1 = write to data memory (sw)
//  result_src   what is written back to rd: 00 ALU result, 01 memory data (lw), 10 PC+4 (jal)
//  branch       1 = this is a beq
//  jump         1 = this is a jal
//  alu_op       hint for the ALU decoder: 00 add, 01 sub, 10 "look at funct3/funct7"
//
//  instr   op        reg_write imm_src alu_src mem_write result_src branch jump alu_op
//  ------  -------   --------- ------- ------- --------- ---------- ------ ---- ------
//  lw      0000011       1       00       1        0         01       0     0    00
//  sw      0100011       0       01       1        1         00       0     0    00
//  R-type  0110011       1       00       0        0         00       0     0    10
//  beq     1100011       0       10       0        0         00       1     0    01
//  addi    0010011       1       00       1        0         00       0     0    10
//  jal     1101111       1       11       0        0         10       0     1    00
//
// ---------------------------------------------------------------------------------
// Part 2 — ALU DECODER (alu_op + funct3 + funct7b5 -> alu_ctrl, same codes as alu.v)
//
//  alu_op  funct3  (op[5] & funct7b5)  alu_ctrl  meaning
//  ------  ------  ------------------  --------  ------------------------------
//  00      -       -                   000       add  (lw/sw address)
//  01      -       -                   001       sub  (beq compare)
//  10      000     0                   000       add / addi
//  10      000     1                   001       sub
//  10      010     -                   101       slt
//  10      110     -                   011       or
//  10      111     -                   010       and
//
//  Why op[5]?  addi also has funct3 = 000, and for addi instr[30] is part of the
//  immediate (it can be 1). op[5] is 1 only for R-type, so "sub" needs both.
// ---------------------------------------------------------------------------------
// Part 3 — NEXT PC:  pc_src = 1 means "jump to the branch/jump target" instead of PC+4.
//           Take it when (branch AND zero) OR jump.
// ---------------------------------------------------------------------------------
module control (
    input  wire [6:0] op,         // instr[6:0]
    input  wire [2:0] funct3,     // instr[14:12]
    input  wire       funct7b5,   // instr[30]
    input  wire       zero,       // from the ALU
    output reg        reg_write,
    output reg  [1:0] imm_src,
    output reg        alu_src,
    output reg        mem_write,
    output reg  [1:0] result_src,
    output reg  [2:0] alu_ctrl,
    output wire       pc_src
);
    reg       branch, jump;
    reg [1:0] alu_op;

    // ---------------- Part 1: main decoder ----------------
    always @(*) begin
        // Defaults: everything off. Each instruction only overrides what differs.
        // (Setting defaults first also guarantees no latches.)
        reg_write = 1'b0; imm_src = 2'b00; alu_src = 1'b0; mem_write = 1'b0;
        result_src = 2'b00; branch = 1'b0; jump = 1'b0; alu_op = 2'b00;

        case (op)
            7'b0000011: begin                 // lw  (example)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                result_src = 2'b01;
            end
            // TODO 1: sw, R-type, beq, addi, jal  (use the table above)
            7'b0100011: begin 
            imm_src = 2'b01 ;
            alu_src = 1'b1; 
            mem_write = 1'b1;
            end
            7'b0110011: begin 
            reg_write = 1'b1;
            alu_op = 2'b10;
            end
            7'b1100011: begin
            imm_src = 2'b10;
            branch = 1'b1;
            alu_op = 2'b01;
            end
            7'b0010011: begin 
            reg_write = 1'b1;
            alu_src = 1'b1;
            alu_op = 2'b10;
            end
            7'b1101111: begin 
            reg_write = 1'b1;
            imm_src = 2'b11;
            result_src = 2'b10;
            jump = 1'b1;
            end 

        endcase
    end

    // ---------------- Part 2: ALU decoder ----------------
    always @(*) begin
        case (alu_op)
    2'b00: alu_ctrl = 3'b000;              // add  (lw/sw)
    2'b01: alu_ctrl = 3'b001;             // sub  (beq)
    2'b10: begin
        case (funct3)
            3'b000: begin
                if ( op[5] == 1 && funct7b5 == 1)
                    alu_ctrl = 3'b001;
                else
                    alu_ctrl = 3'b000;
            end
            3'b010:  alu_ctrl = 3'b101;
            3'b110:  alu_ctrl = 3'b011;
            3'b111:  alu_ctrl = 3'b010;
            default: alu_ctrl = 3'b000;
        endcase
    end
    default: alu_ctrl = 3'b000;
endcase
    end

    // ---------------- Part 3: next-PC select ----------------
    // TODO 3: one assign statement for pc_src.
   assign pc_src = (branch & zero) | jump;

endmodule
