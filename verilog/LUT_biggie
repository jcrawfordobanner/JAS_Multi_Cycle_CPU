`define LW 6'b100011
`define SW 6'b101011
`define J 6'b000010
`define RTYPE 6'b000000
`define JAL 6'b000011
`define BEQ 6'b000100
`define BNE 6'b000101
`define XORI 6'b001110
`define ADDI 6'b001000

`define tADD 6'b100000
`define tSUB 6'b100010
`define tSLT 6'b101010
`define tJR 6'b001000

`define iADD 3'b000
`define iSUB 3'b001
`define iXOR 3'b010
`define iSLT 3'b011

module InstructionparselLUT
(
output [4:0] rs, // Instruction
output reg [4:0] rd, // Instruction from R-Type Signals
output [4:0] shamt, // Instruction from R-Type Signals
output [5:0] funct, // Instruction from R-Type Signals
output [4:0] rt, // Reg[rt]
output [15:0] imm, // immediate value
output [25:0] address, // mux address
output reg [2:0] alucntrl, // ALU control signal
output reg regwr, // RegWrite (Enable Writing to Register)
output reg memwr, // MemWrite (Enable Writing to Memory)
output reg regdst, // Chooses Destination rd or rt
output reg alusrc, // Chooses imm or Db as Input B to ALU
output reg memtoreg, // Writing to Register from Memory
output reg jump, // Control Signal for IFU
output reg regorimmu, // Control Signal for IFU
output reg jayall, // Control Signal for IFU
output reg bne,// Control Signal for IFU
output reg beq, // Control Signal for IFU
output reg buttcheek,
input [31:0] instruction // The instruction itself, from assembly
);
  wire [4:0] linker;
  assign linker = 5'd31;
  // Decomposing the different parts of the instruction
  assign rt=instruction[20:16];
  assign rs=instruction[25:21];
  assign imm = instruction[15:0];
  assign address=instruction[25:0];
  assign shamt=instruction[10:6];
  assign funct=instruction[5:0];
  always @(instruction) begin
    rd<=instruction[15:11];
    case(instruction[31:26])
    `LW: begin alucntrl =`iADD; regwr=1; memwr=0; regdst=1; alusrc=0; memtoreg=1; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=0; end
    `SW: begin alucntrl =`iADD; regwr=0; memwr=1; regdst=1; alusrc=0; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=0; end
    `J: begin alucntrl =`iADD; regwr=0; memwr=0; regdst=0; alusrc=0; memtoreg=0; jump=1; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
    `RTYPE: begin
      case(instruction[5:0])
      `tADD: begin alucntrl=`iADD; regwr=1; memwr=0; regdst=0; alusrc=1; memtoreg=0; jump=0; regorimmu=0;  jayall=0; bne=0; beq=0; buttcheek=1; end
      `tSUB: begin alucntrl=`iSUB; regwr=1; memwr=0; regdst=0; alusrc=1; memtoreg=0; jump=0; regorimmu=0;  jayall=0; bne=0; beq=0; buttcheek=1; end
      `tSLT: begin alucntrl=`iSLT; regwr=1; memwr=0; regdst=0; alusrc=1; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
      `tJR: begin alucntrl=`iADD; regwr=0; memwr=0; regdst=0; alusrc=0; memtoreg=0; jump=1;  regorimmu=1; jayall=0; bne=0; beq=0; buttcheek=1; end
      endcase
    end
    `JAL: begin alucntrl=`iADD; regwr=1; memwr=0; regdst=0; alusrc=0; memtoreg=0; jump=1; regorimmu=0; jayall=1; bne=0; beq=0; buttcheek=1; rd<=linker; end
    `BEQ: begin alucntrl=`iSUB; regwr=0; memwr=0; regdst=1; alusrc=1; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=1; buttcheek=1; end
    `BNE: begin alucntrl=`iSUB; regwr=0; memwr=0; regdst=1; alusrc=1; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=1; beq=0; buttcheek=1; end
    `XORI: begin alucntrl=`iXOR; regwr=1; memwr=0; regdst=1; alusrc=0; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
    `ADDI: begin alucntrl=`iADD; regwr=1; memwr=0; regdst=1; alusrc=0; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
    endcase
  end
endmodule
