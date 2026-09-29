// regfile.v — RV32I register file
//   - 32 registers x 32 bits (x0 .. x31)
//   - 2 combinational read ports:  rs1 -> rd1,  rs2 -> rd2
//   - 1 synchronous write port:    on rising clk edge, if we == 1 then x[rd] <= wd
//   - x0 is hardwired to zero:     writes to x0 are ignored, reading x0 returns 0
module regfile (
    input  wire        clk,
    input  wire        we,     // write enable
    input  wire [4:0]  rs1,    // read address 1
    input  wire [4:0]  rs2,    // read address 2
    input  wire [4:0]  rd,     // write address (destination register)
    input  wire [31:0] wd,     // write data
    output wire [31:0] rd1,    // read data 1
    output wire [31:0] rd2     // read data 2
);
    // Storage: an array of 32 registers, each 32 bits wide.
    reg [31:0] regs [0:31];

    always@ (posedge clk) begin
    if (we == 1 && rd !=0) begin 
    regs[rd] <= wd;
    end
    end
    
    assign rd1 = (rs1 == 0) ? 32'b0 : regs[rs1];
    assign rd2 = (rs2 == 0) ? 32'b0 : regs[rs2];


endmodule
