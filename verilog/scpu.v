`include "alu.v"
`include "regfile.v"
`include "LUT.v"
`include "memory.v"
`include "IFU.v"


module SCPU
(
 input clk,
 input reset
);
	 wire zim, zero, nzim, nzero, cout, oflow, // 1-bit outputs of the ALU
				rfwren, mwren, // Wr Enables of the regfile and memory
				alusrc, mtoreg, regdst, // Multiplexer selects
				jump, rgimm, // Jump and regor immu
				jalc, bnec, beqc, buttcheek; // JAL, BNE, and BEQ command checks
	 wire [2:0] aluOps; // ALU Operations
	 wire [4:0] rs, rd, rt, rw; // Regfile read addresses
	 // dA -> from regfile to: ALU
	 // dB -> from regfile to: mux to ALU, dIn of memory
	 // dW -> from MemToReg mux to: dW of regfile
	 // imm32 -> from sign extender to: mux to ALU
	 // tdB -> from mux to ALU to: ALU
	 // aluO -> from ALU to: Addr of memory, MemToReg mux
	 // dOut -> from dOut of memory to: MemToReg mux
	 wire [15:0] imm16;
	 wire [25:0] jAddress;
	 wire [31:0] dA, dB, dW, imm32, tdB, tdW, aluO, dOut, butt;
	 wire [31:0] pci, pco, pcjal; // pci -> instruction, pco -> command

	 programcounter instructionfetch(.pcaddress(pci),
																	 .Reg_31(pcjal),
																	 .branchaddress(imm16),
																	 .jumpaddress(jAddress),
																	 .jump(jump),
																	 .beq(zero),
																	 .bne(nzero),
																	 .regorimm(rgimm),
																	 .Reg_rs(dA),
																	 .clk(clk),
																	 .reset(reset));
	 InstructionparselLUT lut(.rs(rs),
														.rd(rd),
														.rt(rt),
														.imm(imm16),
														.address(jAddress),
														.alucntrl(aluOps),
														.regwr(rfwren),
														.memwr(mwren),
														.regdst(regdst),
														.alusrc(alusrc),
														.memtoreg(mtoreg),
														.jump(jump),
														.regorimmu(rgimm),
														.jayall(jalc),
														.bne(bnec),
														.beq(beqc),
                            .buttcheek(buttcheek),
														.instruction(pco));
	 ALU alu(.result(aluO),
					 .carryout(cout),
					 .zero(zim),
					 .overflow(oflow),
					 .operandA(dA),
					 .operandB(tdB),
					 .command(aluOps));
	 memory memo(.PC(pci),
							.instruction(pco),
							.data_out(dOut),
							.data_in(dB),
							.clk(clk),
							.data_addr(butt),
							.wr_en(mwren));
	 regfile regf(.ReadData1(dA),
								.ReadData2(dB),
								.WriteData(tdW),
								.ReadRegister1(rs),
								.ReadRegister2(rt),
								.WriteRegister(rw),
								.RegWrite(rfwren),
								.Clk(clk));
	 muxnto1byn #(5) rdstmux(.out(rw),
													 .address(regdst),
													 .input0(rd),
													 .input1(rt)); // RegDst mux
	 muxnto1byn #(32) mtrmux(.out(dW),
													 .address(mtoreg),
													 .input0(aluO),
													 .input1(dOut)); // MemToReg mux
	 muxnto1byn #(32) alumux(.out(tdB),
													 .address(alusrc),
													 .input1(dB),
													 .input0(imm32)); // ALUSrc mux
	 muxnto1byn #(32) jalmux(.out(tdW),
													 .address(jalc),
													 .input0(dW),
													 .input1(pcjal)); // JAL/PC mux
   muxnto1byn #(32) memmux(.out(butt),
                           .address(buttcheek),
                           .input0(aluO),
                           .input1(32'b00000000000000000010000000000000)); // JAL/PC mux
	 signextend16 immse(.in(imm16),
											.extended(imm32));
	 and zerosig(zero, beqc, zim);
	 not nzimsig(nzim, zim);
	 and nzerosig(nzero, bnec, nzim);
endmodule
