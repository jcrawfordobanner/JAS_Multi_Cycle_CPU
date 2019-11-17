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

`define ID 3'd0
`define IF 3'd1
`define EXEC 3'd2
`define MEM 3'd3
`define WB 3'd4

module InstructionparselLUT
(
output [4:0] rs, // Instruction
output reg [4:0] rd, // Instruction from R-Type Signals
output [4:0] shamt, // Instruction from R-Type Signals
output [5:0] funct, // Instruction from R-Type Signals
output [4:0] rt, // Reg[rt]
output [15:0] imm, // immediate value
output [25:0] address, // mux address
input [31:0] instruction, // The instruction itself, from assembly
input [2:0] state, // The instruction itself, from assembly
output reg PC_WE,
output reg MemIn,
output reg Mem_WE,
output reg IR_WE,
output reg Dst,
output reg RegIn,
output reg Immer,
output reg Reg_WE,
output reg A_WE,
output reg B_WE,
output reg [1:0] ALUSrcA,
output reg [1:0] ALUSrcB,
output reg [1:0]ALUOp,
output reg [1:0] PCSrc,
output reg jal,
output reg BEN,
output reg BEQBNE
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
    `LW: begin
          case(state)
            `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd1; ALUSrcB=2'd1; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `MEM: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `WB: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
          endcase
         end
    `SW: begin
          case(state)
            `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd1; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `MEM: begin PC_WE=0; MemIn=1; Mem_WE=1; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            endcase
         end
    `J: begin
          case(state)
            `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd1; jal=0; BEN=0; BEQBNE=0; end
          endcase
         end
    `RTYPE: begin
      case(instruction[5:0])
        `tADD: begin
              case(state)
                `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
                `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
                `WB: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; end
              endcase
             end
        `tSUB: begin
              case(state)
                `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
                `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
                `WB: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; end
              endcase
             end
        `tSLT: begin alucntrl=`iSLT; regwr=1; memwr=0; regdst=0; alusrc=1; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
        `tSLT: begin
              case(state)
                `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
                `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
                `WB: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; end
              endcase
             end
        `tJR: begin
              case(state)
                `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=0; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
                `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=0; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd1; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
              endcase
             end
      endcase
    end
    `JAL: begin
          case(state)
            `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=1; BEN=0; BEQBNE=0; end
            `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=1; BEN=0; BEQBNE=0; end
            `MEM: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd1; jal=1; BEN=0; BEQBNE=0; end
          endcase
         end
    `BEQ: begin
          case(state)
            `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd3; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `MEM: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd2; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=1; BEQBNE=0; end
            `WB: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd1; ALUSrcB=2'd2; ALUOp=`iSUB; PCSrc=2'd0; jal=0; BEN=0; BEQBNE=0; end
          endcase
         end
    `BEQ: begin
          case(state)
            `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd3; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `MEM: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd2; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=1; BEQBNE=1; end
            `WB: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd1; ALUSrcB=2'd2; ALUOp=`iSUB; PCSrc=2'd0; jal=0; BEN=0; BEQBNE=1; end
          endcase
         end
    `XORI: begin
          case(state)
            `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iXOR; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `WB: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; end
          endcase
         end
    `ADDI: begin
          case(state)
            `ID: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `EXEC: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; end
            `WB: begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; end
          endcase
         end
    endcase
  end
endmodule
