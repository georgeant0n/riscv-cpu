// pc.v — Program Counter
// Holds the address of the instruction currently being executed.
//   - On reset:                  pc = 0
//   - On every rising clk edge:  pc <= pc_next
module pc (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] pc_next,
    output reg  [31:0] pc
);
    // TODO: one always block — same shape as the state register of an FSM.
    always@ (posedge clk) begin 
    if (rst)
    pc <=0;
    else 
    pc <= pc_next ;
    end 

endmodule
