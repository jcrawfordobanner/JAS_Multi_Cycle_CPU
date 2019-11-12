`define iADD 3'b000
`define iSUB 3'b001
`define iXOR 3'b010
`define iSLT 3'b011
`define iAND 3'b100
`define iNAND 3'b10
`define iNOR 3'b110
`define iOR 3'b111

`define AND and
`define NAND nand
`define NOT not
`define NOR nor
`define NORzero nor
`define OR or
// Because CMOS structure of both XOR and XNOR only need 4 FETs, both are 20
`define XOR xor
`define XNOR xnor

//`include "mulittest.v"
`include "comps/alucomps/bitslicer.v"

module ALU
	(
	 output [31:0] result,
	 output 			 carryout,
	 output 			 zero,
	 output 			 overflow,
	 input [31:0]  operandA,
	 input [31:0]  operandB,
	 input [2:0] 	 command
	 );
	 wire 				 CTL1;
	 wire 				 CTL2;
	 wire [2:0] 	 inputcommand;
	 wire [31:0] 	 oAnd;
	 wire [31:0] 	 oNand;
	 wire [31:0] 	 oOr;
	 wire [31:0] 	 oNor;
	 wire [31:0] 	 oXor;
	 wire [31:0] 	 oAdd;
	 wire [31:0] 	 oSub;
	 wire [31:0] 	 intercin;//intermediate c-in
	 wire [31:0] 	 oSLT;
	 wire 				 intSLT;
	 wire 				 intermediatezero;
	 wire 				 notoverflow;


	 ALUcontrolLUT alucontrol(
														.inputcommand(inputcommand),
														.CTL1(CTL1),
														.CTL2(CTL2),
														.ALUcommand(command));

   genvar 			 i;
   generate
			for (i =0; i<32; i= i +1) begin: gen1
				 if(i==0)  begin: gen1
						// generating first bit
						BitSlice firstbitslice(.oAnd(oAnd[i]),
																	 .oNand(oNand[i]),
																	 .oOr(oOr[i]),
																	 .oNor(oNor[i]),
																	 .oXor(oXor[i]),
																	 .oAdd(oAdd[i]),
																	 .oSub(oSub[i]),
																	 .oSLT(oSLT[i]),
																	 .cout(intercin[i]),
																	 .A(operandA[i]),
																	 .B(operandB[i]),
																	 .cin(CTL2),
																	 .ctl1(CTL1) ,
																	 .ctl2(CTL2));
						Multiplexer8 multiplex1(.out(result[i]),
																		.address0(command[0]),
																		.address1(command[1]),
																		.address2(command[2]),
																		.in0(oAdd[i]),
																		.in1(oSub[i]),
																		.in2(oXor[i]),
																		.in3(oSLT[i]),
																		.in4(oAnd[i]),
																		.in5(oNand[i]),
																		.in6(oNor[i]),
																		.in7(oOr[i]));
				 end else begin
						// generating rest of the bits
						BitSlice generatedbitslice(.oAnd(oAnd[i]),
																			 .oNand(oNand[i]),
																			 .oOr(oOr[i]),
																			 .oNor(oNor[i]),
																			 .oXor(oXor[i]),
																			 .oAdd(oAdd[i]),
																			 .oSub(oSub[i]),
																			 .oSLT(oSLT[i]),
																			 .cout(intercin[i]),
																			 .A(operandA[i]),
																			 .B(operandB[i]),
																			 .cin(intercin[i-1]),
																			 .ctl1(CTL1) ,
																			 .ctl2(CTL2));
  					Multiplexer8 multiplexother(.out(result[i]),
																				.address0(command[0]),
																				.address1(command[1]),
																				.address2(command[2]),
																				.in0(oAdd[i]),
																				.in1(oSub[i]),
																				.in2(oXor[i]),
																				.in3(oSLT[i]),
																				.in4(oAnd[i]),
																				.in5(oNand[i]),
																				.in6(oNor[i]),
																				.in7(oOr[i]));
         end
			end
	 endgenerate
	 // added functionality at last bit
	 // calculating overflow and carryout
	 buf (carryout,intercin[31]);
	 `XOR (overflow,intercin[30],carryout);
	 `XOR (intSLT, overflow, oSub[31]);
	 assign oSLT = {31'b0, intSLT};
	 // calculating zero
	 `NORzero (intermediatezero, result[0],result[1],result[2],result[3],result[4],result[5],result[6], result[7], result[8],result[9],result[10], result[11], result[12], result[13], result[14], result[15], result[16], result[17], result[18], result[19], result[20], result[21], result[22], result[23], result[24], result[25], result[26], result[27], result[28], result[29], result[30], result[31] );
	 `NOT (notoverflow, overflow);
	 `AND (zero, notoverflow, intermediatezero);
endmodule

module ALUcontrolLUT
	(
	 output reg [2:0] inputcommand,
	 output reg 			CTL1, // "usefulcontrolsignal"
	 output reg 			CTL2, // "othercontrolsignal"
	 input [2:0] 			ALUcommand
	 );

   always @(ALUcommand) begin
			case (ALUcommand)
				`iADD: begin inputcommand = 000; CTL1=1; CTL2 = 0; end
				`iSUB: begin inputcommand = 001; CTL1=1; CTL2 = 1; end
				`iXOR: begin inputcommand = 010; CTL1=0; CTL2 = 0; end
				`iSLT: begin inputcommand = 011; CTL1=1; CTL2 = 1; end
				`iAND: begin inputcommand = 100; CTL1=0; CTL2 = 0; end
				`iNAND: begin inputcommand = 101; CTL1=0; CTL2 = 0; end
				`iOR: begin inputcommand = 110; CTL1=0; CTL2 = 0; end
				`iNOR: begin inputcommand = 111; CTL1=0; CTL2 = 0; end
			endcase
   end
endmodule
