// control_tb.v — self-checking testbench for the control unit.
`timescale 1ns/1ps
module control_tb;
    reg  [6:0] op;
    reg  [2:0] funct3;
    reg        funct7b5, zero;
    wire       reg_write, alu_src, mem_write, pc_src;
    wire [1:0] imm_src, result_src;
    wire [2:0] alu_ctrl;
    integer    errors = 0;

    control dut (.op(op), .funct3(funct3), .funct7b5(funct7b5), .zero(zero),
                 .reg_write(reg_write), .imm_src(imm_src), .alu_src(alu_src),
                 .mem_write(mem_write), .result_src(result_src),
                 .alu_ctrl(alu_ctrl), .pc_src(pc_src));

    // All outputs packed: {reg_write, imm_src, alu_src, mem_write, result_src, alu_ctrl, pc_src}
    wire [10:0] got = {reg_write, imm_src, alu_src, mem_write, result_src, alu_ctrl, pc_src};

    // mask bit = 1 -> output must match;  0 -> "don't care" for this instruction
    task check(input [6:0] o, input [2:0] f3, input f7, input z,
               input [10:0] exp, input [10:0] mask, input [8*24-1:0] what);
        begin
            op = o; funct3 = f3; funct7b5 = f7; zero = z; #1;
            if ((got & mask) !== (exp & mask)) begin
                $display("FAIL: %0s", what);
                $display("      got      reg_write=%b imm_src=%b alu_src=%b mem_write=%b result_src=%b alu_ctrl=%b pc_src=%b",
                         reg_write, imm_src, alu_src, mem_write, result_src, alu_ctrl, pc_src);
                $display("      expected reg_write=%b imm_src=%b alu_src=%b mem_write=%b result_src=%b alu_ctrl=%b pc_src=%b",
                         exp[10], exp[9:8], exp[7], exp[6], exp[5:4], exp[3:1], exp[0]);
                errors = errors + 1;
            end else
                $display("pass: %0s", what);
        end
    endtask

    localparam ALL      = 11'b1_11_1_1_11_111_1;
    localparam NO_IMM   = 11'b1_00_1_1_11_111_1;   // R-type: imm_src unused
    localparam NO_RES   = 11'b1_11_1_1_00_111_1;   // sw/beq: result_src unused
    localparam JAL_MASK = 11'b1_11_0_1_11_000_1;   // jal: alu_src/alu_ctrl unused

    initial begin
        //    op          f3      f7    zero   rw imm as mw res alu pcs     mask      name
        check(7'b0000011, 3'b010, 1'b0, 1'b0, 11'b1_00_1_0_01_000_0, ALL,      "lw");
        check(7'b0100011, 3'b010, 1'b0, 1'b0, 11'b0_01_1_1_00_000_0, NO_RES,   "sw");
        check(7'b0110011, 3'b000, 1'b0, 1'b0, 11'b1_00_0_0_00_000_0, NO_IMM,   "add");
        check(7'b0110011, 3'b000, 1'b1, 1'b0, 11'b1_00_0_0_00_001_0, NO_IMM,   "sub");
        check(7'b0110011, 3'b111, 1'b0, 1'b0, 11'b1_00_0_0_00_010_0, NO_IMM,   "and");
        check(7'b0110011, 3'b110, 1'b0, 1'b0, 11'b1_00_0_0_00_011_0, NO_IMM,   "or");
        check(7'b0110011, 3'b010, 1'b0, 1'b0, 11'b1_00_0_0_00_101_0, NO_IMM,   "slt");
        check(7'b0010011, 3'b000, 1'b0, 1'b0, 11'b1_00_1_0_00_000_0, ALL,      "addi");
        check(7'b0010011, 3'b000, 1'b1, 1'b0, 11'b1_00_1_0_00_000_0, ALL,      "addi (instr[30]=1)");
        check(7'b1100011, 3'b000, 1'b0, 1'b1, 11'b0_10_0_0_00_001_1, NO_RES,   "beq taken");
        check(7'b1100011, 3'b000, 1'b0, 1'b0, 11'b0_10_0_0_00_001_0, NO_RES,   "beq not taken");
        check(7'b1101111, 3'b000, 1'b0, 1'b0, 11'b1_11_0_0_10_000_1, JAL_MASK, "jal");

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $finish;
    end
endmodule
