`include "comps/IFUcomps/multiplexer.v" // multiplexer
`include "comps/IFUcomps/signextend.v" // sign extend
`include "comps/IFUcomps/adder.v" // adder
`include "comps/IFUcomps/register.v"

module programcounter(
  output [31:0] pcaddress, // Output of Program Counter
  output [31:0] Reg_31, // Register 31
  input[15:0] branchaddress, // given branch address
  input[25:0] jumpaddress, // given branch address
  input jump, // is there a jump? yes or no. if not, just increment by 4
  input beq, // is BEQ true?
  input bne, // is BNE true?
  input regorimm, // is the incoming command from a register or immediate?
  input [31:0] Reg_rs, // Reg[rs]
  input reset, // reset command
  input clk

);
wire[31:0] alutomux; // line between ALU and mux
wire [31:0] muxtopc;// from mux to PC
wire [31:0] pctoalu;// PC to ALU
wire[31:0] beqbneadd; // adding branch address with PC + 4
wire[31:0] signextbranchaddr; // sign extended branch address
wire[31:0] signextjumpaddr; // sign extended jump address
wire[31:0] boutput; // output of mux that tests for BNE or BEQ
wire[31:0] intoOGmux; // wire entering main loop from regorimm output
wire outputofor; // input to BNE/BEQ multiplexer
reg[31:0] zeroinput; // 32-bit input of all zeros
reg[31:0] fourinput; // 32-bit input of just four (the number four in decimal)
reg resetreg; // address for reset multiplexer
wire[31:0] inputtopc; // output of reset multiplexer

// things that should be set initially
initial begin
  assign zeroinput = 32'b0;
  assign fourinput = 32'd4;
  assign resetreg = 1'b1;
end
// add output of PC with  4
adder #(.width(32)) addwithPC(.out(alutomux), .in0(fourinput), .in1(pctoalu));
// create a sign extended branch address
signextend16bne signextendbranchaddress(.extended(signextbranchaddr), .in(branchaddress));
// for bne and beq, doing PC + 4 + branchaddress
adder #(.width(32)) addPCwithbranchadd(.out(beqbneadd), .in0(signextbranchaddr), .in1(alutomux));
// seeing if beq or bne are on
or checkBNEBEQ(outputofor,beq, bne);
// sign extending jump address
signextend26 signextendjumpaddress(.extended(signextjumpaddr), .in(jumpaddress));
//setting the beq/bne or not multiplexer
muxnto1byn #(.width(32)) bnemulti(.out(boutput), .address(outputofor), .input0(alutomux),.input1(beqbneadd));
// setting multiplexer that checks if its a reg or an immediate
muxnto1byn #(.width(32)) regorimmmulti(.out(intoOGmux), .address(regorimm), .input0(signextjumpaddr),.input1(Reg_rs));
//setting OG multiplexer
muxnto1byn #(.width(32)) jumpmulti(.out(muxtopc), .address(jump), .input1(intoOGmux),.input0(boutput));
// setting the output of reg_31
assign Reg_31 = alutomux;
// creating the Program Counter (PC)
regPC pc(.pctoalu(pctoalu), .muxtopc(inputtopc),   .clk(clk));
// reset multiplexer, to reset the whole PC
muxnto1byn #(.width(32)) resetmulti(.out(inputtopc), .address(resetreg), .input1(zeroinput),.input0(muxtopc));
// Creating the output wire (output of PC) from an intermediate wire
assign  pcaddress = pctoalu;

//setting d flip-flop only on positive edge of clk
// to control reset
always @(reset) begin
  if(reset==1) begin
    //pcaddress <= 32'b0;
    assign resetreg = 1'b1;
  end
  else  begin
    assign resetreg = 1'b0;
  end
end
endmodule
