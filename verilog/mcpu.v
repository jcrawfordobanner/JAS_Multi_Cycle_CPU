`include "alu.v"
`include "regfile.v"
`include "memory.v"
`include "IFU.v"
`include "register.v"
`include "mux4.v"
`include "LUT_biggie.v"
`include "concat.v"

module MCPU
(
 input clk,
 input reset
);
	 wire zim, zero, nzim, nzero, cout, oflow, // 1-bit outputs of the ALU
				reg_we, mem_we,// Wr Enables of the regfile and memory
        pc_we, ir_we, a_we, b_we, ben,// d-flip flop enables
				memin, immer, regin, dst, alusrca, alusrcb, bneBEQ, PCSrc; // Multiplexer selects

	 wire [2:0] aluOps; // ALU Operations
	 wire [4:0] rs, rd, rt, rw, shamt; // Regfile read addresses
   wire [5:0] funct;
	 // dA -> from regfile to: A reg
	 // dB -> from regfile to: A reg
   // dAheld -> from A reg to: ALU
   // dBheld -> from B reg : ALU
   // pcout -> output of PC
   // memout -> output of memory
   // irout -> output of IR
   // decoder2concat -> decode logic to concat
   // concat_out -> output of concat
   // mdrout -> output of MDR
   // alu_out -> output of ALU, before ALU_reg
   // alu_reg -> output of alu_reg
   // ben_out -> output of second register (with Ben enable)
   // pcSrcout -> output of PCSrc
   // pcSrcB4 -> input into PCSrc

	 wire [15:0] imm16;
	 wire [25:0] jAddress;
	 wire [31:0] dA, dB, A_input, B_input, dAheld, dBheld, shifted, pcout, memout, irout, imm32,
    concat_out, mdrout,alu_out,alu_reg,ben_out,pcSrcout, pcSrcB4, mdr_or_alu, bnechosen, immer16out,pci, pco,pcjal;
	 //wire [31:0] pci, pco, pcjal; // pci -> instruction, pco -> command


	 ALU alu(.result(alu_out),
					 .carryout(cout),
					 .zero(zim),
					 .overflow(oflow),
					 .operandA(dAheld),
					 .operandB(dBheld),
					 .command(aluOps));

	 memory memo(.PC(pci), //doesnt belong
							.instruction(pco), // doesnt belong
							.data_out(memout),
							.data_in(dBheld),
							.clk(clk),
							.data_addr(memin),
							.wr_en(mem_we));

	 regfile regf(.ReadData1(dA),
								.ReadData2(dB),
								.WriteData(mdr_or_alu),
								.ReadRegister1(rs),
								.ReadRegister2(rt),
								.WriteRegister(rw),
								.RegWrite(reg_we),
								.Clk(clk));

  InstructionparselLUT looker (.rs(rs),
                               .rt(rt),
                               .rd(rd),
                               .shamt(shamt),
                               .funct(funct),
                               .imm(imm16),
                               .address(jAddress),
                               .instruction(pco),
                               .state(),
                               .PC_WE(pc_we),
                               .MemIn(memin),
                               .Mem_WE(mem_we),
                               .IR_We(ir_we),
                               .Dst(dst),
                               .RegIn(regin),
                               .Immer(immer),
                               .Reg_WE(reg_we),
                               .A_WE(a_we),
                               .B_WE(b_we),
                               .ALUSrcA(alusrca),
                               .ALUSrcB(alusrcb),
                               .ALUOp(aluOps),
                               .PCSrc(PCSrc),
                               .jal(),
                               .BEN(ben),
                               .BEQBNE(bneBEQ)
                              );

// RegDst mux
	 muxnto1byn #(5) rdstmux(.out(rw),
													 .address(dst),
													 .input0(rd),
													 .input1(rt));
// MemToReg mux
	 muxnto1byn #(32) mdrmux(.out(mdr_or_alu),
													 .address(regin),
													 .input0(mdrout),
													 .input1(alu_reg));
//BNE/BEQ mux
   muxnto1byn #(32) bnebeqmux(.out(bnechosen),
													 .address(bneBEQ),
													 .input0(zim), // beq
													 .input1(nzim)); // bne
//  mux for PCSrc input
   muxnto1byn #(32) pcsrc(.out(pcSrcB4),
													 .address(bnechosen),
													 .input0(ben_out), // beq
													 .input1(alu_reg)); // bne
// immediate 16 mux
   muxnto1byn #(32) immermux(.out(immer16out),
                           .address(immer),
                           .input0(imm16),
                           .input1(32'b0)); // immediate16 or 0
// signextend
   signextend16 immse(.in(imm16),
											.extended(imm32));

// concat
  concatinate concat(.notconcatinated(jAddress),
                     .PC(pcout));
// << 2
  shift shifter(.notshifted(imm32),
              .shifted(shifted));
// ALU reg
regboi ALUreg(
  .in(alu_out),
  .out(alu_reg)
  );
// Benny
regboi Bennyreg(
  .in(alu_reg),
  .out(ben_out)
  );
// PC
regboi PCreg(
  .in(alu_reg),
  .out(ben_out)
  );
// MDR reg
regboi MDRreg(
  .in(memout),
  .out(mdrout)
  );
// IR reg
regboi IRreg(
  .in(memout),
  .out(irout)
  );
// A reg
regboi regA(
  .in(dA),
  .out(dAheld)
  );
// B reg
regboi regB(
  .in(dB),
  .out(dBheld)
  );
// ALU A 4 input mux
Multiplexer4doubletime ALU_A(
  .out(A_input),
  .address0(), .address1(),
  .in0(pcout), .in1(dAheld), .in2(ben_out), .in3(32'b0)
  );
// ALU B 4 input mux
Multiplexer4doubletime ALU_B(
  .out(B_input),
  .address0(), .address1(),
  .in0(shifted), .in1(imm32), .in2(dBheld), .in3(32'd4)
  );
// PCSrc 4 input mux
Multiplexer4doubletime pcsrcboi(
  .out(pcSrcout),
  .address0(), .address1(),
  .in0(pcSrcB4), .in1(concat_out), .in2(alu_out), .in3(alu_reg)
  );



	 not nzimsig(nzim, zim);

endmodule
