// regfile_tb.v — self-checking testbench for regfile.
// Prints "pass"/"FAIL" per check and a final summary in the Tcl console.
`timescale 1ns/1ps
module regfile_tb;
    reg         clk = 0;
    reg         we;
    reg  [4:0]  rs1, rs2, rd;
    reg  [31:0] wd;
    wire [31:0] rd1, rd2;
    integer     errors = 0;

    regfile dut (.clk(clk), .we(we), .rs1(rs1), .rs2(rs2), .rd(rd),
                 .wd(wd), .rd1(rd1), .rd2(rd2));

    always #5 clk = ~clk;

    // Write one register; the value is stored on the rising edge in between.
    task write_reg(input [4:0] addr, input [31:0] data);
        begin
            @(negedge clk);
            we = 1; rd = addr; wd = data;
            @(negedge clk);
            we = 0;
        end
    endtask

    // Compare a read value against the expected value.
    task check(input [31:0] got, input [31:0] exp, input [8*24-1:0] what);
        begin
            if (got !== exp) begin
                $display("FAIL: %0s  got=%h  expected=%h", what, got, exp);
                errors = errors + 1;
            end else
                $display("pass: %0s = %h", what, got);
        end
    endtask

    initial begin
        we = 0; rs1 = 0; rs2 = 0; rd = 0; wd = 0;

        write_reg(5'd1,  32'hDEADBEEF);
        write_reg(5'd2,  32'h00000042);
        write_reg(5'd31, 32'hFFFFFFFF);
        write_reg(5'd0,  32'h12345678);   // x0 must ignore this write

        rs1 = 5'd1;  rs2 = 5'd2;  #1;
        check(rd1, 32'hDEADBEEF, "x1");
        check(rd2, 32'h00000042, "x2");

        rs1 = 5'd31; rs2 = 5'd0;  #1;
        check(rd1, 32'hFFFFFFFF, "x31");
        check(rd2, 32'h00000000, "x0 stays zero");

        // With we = 0 the register must NOT change.
        @(negedge clk); we = 0; rd = 5'd1; wd = 32'h0;
        @(negedge clk);
        rs1 = 5'd1; #1;
        check(rd1, 32'hDEADBEEF, "x1 unchanged (we=0)");

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $finish;
    end
endmodule
