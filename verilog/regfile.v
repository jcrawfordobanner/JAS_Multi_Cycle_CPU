//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

`include "comps/regfilecomps/decoders.v"
`include "comps/regfilecomps/mux32to1by32.v"
`include "comps/regfilecomps/register32.v"
`include "comps/regfilecomps/register32zero.v"

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);
	 // Wire carrying enable signals
	 wire[31:0] dwe;
	 // Decoder which provides enable input
	 decoder1to32 dcw(.out(dwe), .enable(RegWrite), .address(WriteRegister));

	 wire[31:0] mrw[31:0]; // 2D array of wires between register and muxes
	 // Muxes to select the output from registers
	 mux32to1by32 muxr1(.out(ReadData1), .address(ReadRegister1),
											.input0(mrw[0]),.input1(mrw[1]),.input2(mrw[2]),.input3(mrw[3]),
											.input4(mrw[4]),.input5(mrw[5]),.input6(mrw[6]),.input7(mrw[7]),
											.input8(mrw[8]),.input9(mrw[9]),.input10(mrw[10]),.input11(mrw[11]),
											.input12(mrw[12]),.input13(mrw[13]),.input14(mrw[14]),.input15(mrw[15]),
											.input16(mrw[16]),.input17(mrw[17]),.input18(mrw[18]),.input19(mrw[19]),
											.input20(mrw[20]),.input21(mrw[21]),.input22(mrw[22]),.input23(mrw[23]),
											.input24(mrw[24]),.input25(mrw[25]),.input26(mrw[26]),.input27(mrw[27]),
											.input28(mrw[28]),.input29(mrw[29]),.input30(mrw[30]),.input31(mrw[31]));
	 mux32to1by32 muxr2(.out(ReadData2), .address(ReadRegister2),
											.input0(mrw[0]),.input1(mrw[1]),.input2(mrw[2]),.input3(mrw[3]),
											.input4(mrw[4]),.input5(mrw[5]),.input6(mrw[6]),.input7(mrw[7]),
											.input8(mrw[8]),.input9(mrw[9]),.input10(mrw[10]),.input11(mrw[11]),
											.input12(mrw[12]),.input13(mrw[13]),.input14(mrw[14]),.input15(mrw[15]),
											.input16(mrw[16]),.input17(mrw[17]),.input18(mrw[18]),.input19(mrw[19]),
											.input20(mrw[20]),.input21(mrw[21]),.input22(mrw[22]),.input23(mrw[23]),
											.input24(mrw[24]),.input25(mrw[25]),.input26(mrw[26]),.input27(mrw[27]),
											.input28(mrw[28]),.input29(mrw[29]),.input30(mrw[30]),.input31(mrw[31]));

	 register32zero reg1(.q(mrw[0]), .d(WriteData), .wrenable(dwe[0]), .clk(Clk));
	 genvar 		 i;
	 generate
			for (i=1; i<32; i = i+1) begin: gen1
				register32 greg(.q(mrw[i]), .d(WriteData), .wrenable(dwe[i]), .clk(Clk));
			end
	 endgenerate
endmodule
