`include "alu.v"
`include "regfile.v"
`include "memory.v"
`include "signextend.v"
`include "register.v"
`include "mux4.v"
`include "LUT_biggie.v"
`include "concat.v"

module MCPU
	(
	 input clk,
	 input reset
	 );

	 reg [5:0] current;
	 reg [31:0]zeroinput;
	 wire  zim, zero, nzim, nzero, cout, oflow, // 1-bit outputs of the ALU
				 reg_we, mem_we,// Wr Enables of the regfile and memory
         pc_we, ir_we, a_we, b_we, ben, jal,// d-flip flop enables
				 memin, immer, regin, dst,bneBEQ, bnechosen,jelly,pcdoit,realmemmy,gambino,cheese; // Multiplexer selects
	 wire [1:0]  alusrca, alusrcb,PCSrc; // two bit instruction for 4 input mux
	 wire [2:0] aluOps; // ALU Operations
	 wire [4:0] rs, rd, rt, rw, shamt,aw; // Regfile read addresses
   wire [5:0] funct,status,actualstate;
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

	 wire [15:0] imm16, immer16out;
	 wire [25:0] jAddress;
	 wire [31:0] dA, dB, A_input, B_input, dAheld, dBheld, shifted, pcout, memout, irout, imm32, data_addr,
							 concat_out, mdrout,alu_out,alu_reg,ben_out,pcSrcout, pcSrcB4, mdr_or_alu,pci, pco,inputtopc,pc4;
	 //wire [31:0] pci, pco, pcjal; // pci -> instruction, pco -> command

	 initial begin
	 	zeroinput = 32'd0;
		// resetreg=1;
		current=5'd0;
	 end

	 ALU alu(.result(alu_out),
					 .carryout(cout),
					 .zero(zim),
					 .overflow(oflow),
					 .operandA(A_input),
					 .operandB(B_input),
					 .command(aluOps));

	 memory memo(.PC(pcout), //doesnt belong
							 .instruction(pco), // doesnt belong
							 .data_out(memout),
							 .data_in(dBheld),
							 .clk(clk),
							 .data_addr(data_addr),
							 .wr_en(mem_we));

	 regfile regf(.ReadData1(dA),
								.ReadData2(dB),
								.WriteData(mdr_or_alu),
								.ReadRegister1(rs),
								.ReadRegister2(rt),
								.WriteRegister(aw),
								.RegWrite(reg_we),
								.Clk(clk));
	 //always @* begin
	 //	current<=status;
	 //end
	 // always @(negedge resetreg)begin
	 // 	current<=5'd0;
	 // end
   InstructionparselLUT looker (.rs(rs),
																.rt(rt),
																.rd(rd),
																.shamt(shamt),
																.funct(funct),
																.imm(imm16),
																.address(jAddress),
																.instruction(irout),
																.PC_WE(pc_we),
																.MemIn(memin),
																.Mem_WE(mem_we),
																.IR_WE(ir_we),
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
																.jal(jal),
																.BEN(ben),
																.BEQBNE(bneBEQ),
																.clk(clk),
																.cheese(cheese),
																.reset(reset)
																);

	 // RegDst mux
	 muxnto1byn #(5) rdstmux(.out(rw),
													 .address(dst),
													 .input0(rd),
													 .input1(rt));
	 // MemToReg mux
	 muxnto1byn #(32) mdrmux(.out(mdr_or_alu),
													 .address(regin),
													 .input0(alu_reg),
													 .input1(mdrout));
	 //BNE/BEQ mux
   muxnto1byn #(1) bnebeqmux(.out(bnechosen),
															.address(bneBEQ),
															.input0(zim), // beq
															.input1(nzim)); // bne

   muxnto1byn #(32) bmux2(.out(pcSrcB4),
													.address(bnechosen),
													.input0(ben_out), // beq
													.input1(alu_reg)); // bne
	// Jal mux
   muxnto1byn #(5) jalmux(.out(aw),
													.address(jal),
													.input0(rw),
													.input1(5'd31));
	 // immediate 16 mux
   muxnto1byn #(16) immermux(.out(immer16out),
														 .address(immer),
														 .input0(imm16),
														 .input1(16'b0)); // immediate16 or 0
	 // signextend
   signextend16 immse(.in(imm16),
											.extended(imm32));

	 // concat
   concatinate concat(.notconcatinated(jAddress),
											.PC(pcout), .concatinated(concat_out));
	 // << 2
   shift shifter(.notshifted(imm32),
								 .shifted(shifted));
	 // ALU reg
	 regboi ALUreg(
								 .in(alu_out),
								 .out(alu_reg),
								 .clk(clk)
								 );
	 // Benny
	 register32 Bennyreg(
									 .d(alu_reg),
									 .q(ben_out),
									 .clk(clk),
	 								.wrenable(ben)
									 );
	 // Benny
 	register32 savereg(
 									.d(alu_out),
 									.q(pc4),
 									.clk(clk),
 								 .wrenable(cheese)
 									);
	 // PC
	 register32 PCreg(
								.d(inputtopc),
								.q(pcout),
								.clk(clk),
								.wrenable(pc_we)
								);
	 // MDR reg
	 regboi MDRreg(
								 .in(memout),
								 .out(mdrout),
								 .clk(clk)
								 );
	 // IR reg
	 register32 IRreg(
								.d(pco),
								.q(irout),
								.clk(clk),
								.wrenable(ir_we)
								);
	 // A reg
	 register32 regA(
							 .d(dA),
							 .q(dAheld),
							 .clk(clk),
							 .wrenable(a_we)
							 );
	 // B reg
	 register32 regB(
							 .d(dB),
							 .q(dBheld),
							 .clk(clk),
							 .wrenable(b_we)
							 );
		// Memin mux
		muxnto1byn #(32) MemInmux(.out(data_addr),
																						.address(memin),
																						.input0(pcout), .input1(alu_reg)
																						);
	 // ALU A 4 input mux
	 Multiplexer4doubletime ALU_A(
																.out(A_input),
																.address(alusrca),
																.in0(pcout), .in1(dAheld), .in2(ben_out), .in3(32'b0)
																);
	 // ALU B 4 input mux
	 Multiplexer4doubletime ALU_B(
																.out(B_input),
																.address(alusrcb),
																.in0(shifted), .in1(imm32), .in2(dBheld), .in3(32'd4)
																);
	 // PCSrc 4 input mux
	 Multiplexer4doubletime pcsrcboi(
																	 .out(pcSrcout),
																	 .address(PCSrc),
																	 .in0(pcSrcB4), .in1(concat_out), .in2(pc4), .in3(alu_reg)
																	 );


	 not nzimsig(nzim, zim);

	 muxnto1byn #(.width(32)) resetmulti(.out(inputtopc), .address(reset), .input1(zeroinput),.input0(pcSrcout));
	 //muxnto1byn #(.width(6)) resetti(.out(actualstate), .address(resetreg), .input1(5'd0),.input0(current));
	 //muxnto1byn #(.width(1)) sdadaddad(.out(pcdoit), .address(resetreg), .input1(1),.input0(pc_we));
	 //muxnto1byn #(.width(1)) resetto(.out(realmemmy), .address(resetreg), .input1(0),.input0(memin));
	 //muxnto1byn #(.width(1)) cuppo(.out(gambino), .address(resetreg), .input1(1),.input0(ir_we));


endmodule
