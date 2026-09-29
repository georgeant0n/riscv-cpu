// pc_tb.v — self-checking testbench for pc.
`timescale 1ns/1ps
module pc_tb;
    reg         clk = 0;
    reg         rst = 1;
    reg  [31:0] pc_next = 0;
    wire [31:0] pc_out;
    integer     errors = 0;

    pc dut (.clk(clk), .rst(rst), .pc_next(pc_next), .pc(pc_out));

    always #5 clk = ~clk;

    task check(input [31:0] exp, input [8*24-1:0] what);
        begin
            if (pc_out !== exp) begin
                $display("FAIL: %0s  got=%h  expected=%h", what, pc_out, exp);
                errors = errors + 1;
            end else
                $display("pass: %0s = %h", what, pc_out);
        end
    endtask

    initial begin
        pc_next = 32'h0000_0010;
        @(posedge clk); #1;                  // reset is high on this edge
        check(32'h0000_0000, "reset -> 0");

        rst = 0;
        @(posedge clk); #1;
        check(32'h0000_0010, "pc <= pc_next");

        pc_next = 32'h0000_0014;
        @(posedge clk); #1;
        check(32'h0000_0014, "pc <= pc_next (2)");

        pc_next = 32'h0000_0100;             // must NOT appear before the next edge
        #2;
        check(32'h0000_0014, "holds until clk edge");
        @(posedge clk); #1;
        check(32'h0000_0100, "jump target");

        rst = 1;
        @(posedge clk); #1;
        check(32'h0000_0000, "reset again -> 0");

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $finish;
    end
endmodule
