// immgen_tb.v — self-checking testbench for immgen, using real RV32I encodings.
`timescale 1ns/1ps
module immgen_tb;
    reg  [31:0] instr;
    reg  [1:0]  imm_src;
    wire [31:0] imm_ext;
    integer     errors = 0;

    immgen dut (.instr(instr), .imm_src(imm_src), .imm_ext(imm_ext));

    task check(input [1:0] src, input [31:0] ins, input [31:0] exp, input [8*22-1:0] what);
        begin
            imm_src = src; instr = ins; #1;
            if (imm_ext !== exp) begin
                $display("FAIL: %0s  got=%h  expected=%h", what, imm_ext, exp);
                errors = errors + 1;
            end else
                $display("pass: %0s -> imm = %h", what, imm_ext);
        end
    endtask

    initial begin
        //    src    instruction    expected imm   assembly
        check(2'b00, 32'h00500093, 32'h00000005, "I: addi x1,x0,5");
        check(2'b00, 32'hFFF00093, 32'hFFFFFFFF, "I: addi x1,x0,-1");
        check(2'b00, 32'h0080A103, 32'h00000008, "I: lw x2,8(x1)");
        check(2'b01, 32'h0020A623, 32'h0000000C, "S: sw x2,12(x1)");
        check(2'b01, 32'hFE20AE23, 32'hFFFFFFFC, "S: sw x2,-4(x1)");
        check(2'b10, 32'h00208463, 32'h00000008, "B: beq x1,x2,+8");
        check(2'b10, 32'hFE208CE3, 32'hFFFFFFF8, "B: beq x1,x2,-8");
        check(2'b11, 32'h010000EF, 32'h00000010, "J: jal x1,+16");
        check(2'b11, 32'hFFDFF06F, 32'hFFFFFFFC, "J: jal x0,-4");

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $finish;
    end
endmodule
