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

`define ID 3'd1
`define IF 3'd0
`define EXEC 3'd2
`define MEM 3'd3
`define WB 3'd4

module reggie(
							output [5:0] out,
							input [5:0]  in,

							//output reg[31:0] PCaddress,
							input 			 clk,
							input 			 reset
							);
	 reg [5:0] 							 memory={5'd0};
	 assign out = memory;
	 always @(posedge clk) begin
			if(reset) begin
				 memory <= 5'd0;
			end
			else begin
         memory <= in;
			end
	 end
endmodule

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
output reg [2:0]ALUOp,
output reg [1:0] PCSrc,
output reg jal,
output reg BEN,
output reg BEQBNE,
output reg cheese,
input clk,
input reset
);
  wire [4:0] linker;
  assign linker = 5'd31;
  reg [5:0] state; // The instruction itself, from assembly
  wire [5:0] newstatus; // The instruction itself, from assembly
  reggie statereg(.in(state),.out(newstatus),.clk(clk),.reset(reset));
  // Decomposing the different parts of the instruction
  assign rt=instruction[20:16];
  assign rs=instruction[25:21];
  assign imm = instruction[15:0];
  assign address=instruction[25:0];
  assign shamt=instruction[10:6];
  assign funct=instruction[5:0];
  always @(newstatus) begin
    case(newstatus)
      `IF:begin state=`ID; end
      `ID: begin
        case(instruction[31:26])
          `LW:begin state=`EXEC; end
          `SW:begin state=`EXEC; end
          `J:begin state=`IF; end
          `RTYPE:begin
            case(instruction[5:0])
              `tADD:begin state=`EXEC; end
              `tSUB:begin state=`EXEC; end
              `tSLT:begin state=`EXEC; end
              `tJR:begin state=`EXEC; end
            endcase
          end
          `JAL:begin state=`EXEC; end
          `BEQ:begin state=`EXEC;end
          `BNE:begin state=`EXEC; end
          `XORI:begin state=`EXEC; end
          `ADDI:begin state=`EXEC; end
        endcase
      end
      `EXEC: begin
        case(instruction[31:26])
          `LW:begin state=`MEM; end
          `SW:begin state=`MEM; end
          `J:begin state=`IF; end
          `RTYPE:begin
            case(instruction[5:0])
              `tADD:begin state=`WB; end
              `tSUB:begin state=`WB; end
              `tSLT:begin state=`WB; end
              `tJR:begin state=`IF; end
            endcase
          end
          `JAL:begin state=`WB; end
          `BEQ:begin state=`MEM; end
          `BNE:begin state=`MEM; end
          `XORI:begin state=`WB; end
          `ADDI:begin state=`WB; end
        endcase
      end
      `MEM: begin
        case(instruction[31:26])
          `LW:begin state=`WB; end
          `SW:begin state=`IF; end
          `J:begin state=`IF; end
          `RTYPE:begin
            case(instruction[5:0])
              `tADD:begin state=`IF; end
              `tSUB:begin state=`IF; end
              `tSLT:begin state=`IF; end
              `tJR:begin state=`IF; end
            endcase
          end
          `JAL:begin state=`IF; end
          `BEQ:begin state=`MEM; end
          `BNE:begin state=`MEM; end
          `XORI:begin state=`IF; end
          `ADDI:begin state=`IF; end
        endcase
      end
      `WB: begin state=`IF; end
    endcase
  end
  always @(newstatus,instruction) begin
    rd<=instruction[15:11];
    case(newstatus)
      `IF:begin PC_WE=1; MemIn=0; Mem_WE=0; IR_WE=1; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd3; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=1; end
      `ID: begin
        case(instruction[31:26])
          `LW:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `SW:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `J:begin PC_WE=1; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd1; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `RTYPE:begin
            case(instruction[5:0])
              `tADD:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
              `tSUB:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
              `tSLT:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
              `tJR:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=0; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
            endcase
          end
          `JAL:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=1; BEN=0; BEQBNE=0; cheese=0; end
          `BEQ:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd3; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `BNE:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd3; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `XORI:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `ADDI:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
        endcase
      end
      `EXEC: begin
        case(instruction[31:26])
          `LW:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd1; ALUSrcB=2'd1; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `SW:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd1; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `RTYPE:begin
            case(instruction[5:0])
              `tADD:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
              `tSUB:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
              `tSLT:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
              `tJR:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=0; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd1; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
            endcase
          end
          `JAL:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd3; ALUOp=`iADD; PCSrc=2'd2; jal=1; BEN=0; BEQBNE=0; cheese=0; end
          `BEQ:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `BNE:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `XORI:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iXOR; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `ADDI:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=1; B_WE=1; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
        endcase
      end
      `MEM: begin
        case(instruction[31:26])
          `LW:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `SW:begin PC_WE=0; MemIn=1; Mem_WE=1; IR_WE=0; Dst=1; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `BEQ:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd2; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=1; BEQBNE=0; cheese=0; end
          `BNE:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd2; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=1; BEQBNE=1; cheese=0; end
        endcase
      end
      `WB: begin
        case(instruction[31:26])
          `LW:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=1; RegIn=1; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `RTYPE:begin
            case(instruction[5:0])
              `tADD:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; cheese=0; end
              `tSUB:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; cheese=0; end
              `tSLT:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; cheese=0; end
            endcase
          end
          `JAL:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=1; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd1; jal=1; BEN=0; BEQBNE=0; cheese=0; end
          `BEQ:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd1; ALUSrcB=2'd2; ALUOp=`iSUB; PCSrc=2'd0; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `BNE:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=0; A_WE=0; B_WE=0; ALUSrcA=2'd1; ALUSrcB=2'd2; ALUOp=`iSUB; PCSrc=2'd0; jal=0; BEN=0; BEQBNE=1; cheese=0; end
          `XORI:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd3; jal=0; BEN=0; BEQBNE=0; cheese=0; end
          `ADDI:begin PC_WE=0; MemIn=0; Mem_WE=0; IR_WE=0; Dst=0; RegIn=0; Immer=1; Reg_WE=1; A_WE=0; B_WE=0; ALUSrcA=2'd0; ALUSrcB=2'd0; ALUOp=`iADD; PCSrc=2'd2; jal=0; BEN=0; BEQBNE=0; cheese=0; end
        endcase
      end
    endcase
  end
endmodule
