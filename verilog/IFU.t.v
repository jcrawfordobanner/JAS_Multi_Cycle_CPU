// create module which will create an instantiation of the instructionfetchunit
// and then run test cases
`include "IFU.v"

module IFUtestbench();
  wire[31:0] pcaddress;
  wire[31:0] Reg_31;
  reg[25:0] jumpaddress;
  reg jump, beq, bne, regorimm,reset,Clk;
  reg[31:0] Reg_rs;
  reg[15:0] branchaddress;
  reg begintest;
  reg endtest;
  reg dutpassed;

// Instantiating testbench
  programcounter dut(
    .pcaddress(pcaddress),
    .Reg_31(Reg_31),
    .branchaddress(branchaddress),
    .jumpaddress(jumpaddress),
    .jump(jump),
    .beq(beq),
    .bne(bne),
    .regorimm(regorimm),
    .reset(reset),

    .Reg_rs(Reg_rs),
    .clk(Clk)
    );

    initial begin
      $dumpfile("IFU.vcd");
      $dumpvars();
      // The whole test is comprised of smaller tests, which are given sufficient time to run
      begintest=0;
      #10;
      begintest=1;
      #5000;
    end

    always @(posedge endtest) begin
      $display("DUT passed?: %b", dutpassed);
    end

    always @(posedge begintest) begin
      endtest = 0;
      dutpassed = 1;
      #10

      // Test Case 1 : Incrementing By 4 (Normal Operation Like Addi)
      #5 Clk=0;
      // resetting it, in order to be sure that the results are not dependent on previous values
      reset= 1'b1;
      // Giving it time to take effect (Only happens at the positive edge of the clock)
      #5 Clk=1; #5 Clk=0;
      #5 Clk=1;

      jumpaddress = 26'b0;
      branchaddress = 16'b0;
      jump = 1'b0;
      beq = 1'b0;
      bne = 1'b0;
      regorimm = 1'b0;
      reset= 1'b0;
      Reg_rs = 32'b0;
      // Giving it time to take effect
      #5 Clk=0; #5 Clk=1;#5 Clk=0;

      if(pcaddress !== 4) begin
        dutpassed = 0;
        $display("Test Case 1 Failed");
        $display("%b", pcaddress);
      end
      // Test Case 2 : jump

      // resetting it, to get consistent results
      reset= 1'b1;
      #5 Clk=1; #5 Clk=0;
      #5 Clk=5;
      jumpaddress = 26'd2;
      branchaddress = 16'd0;
      jump = 1'b1;
      beq = 1'b0;
      bne = 1'b0;
      regorimm = 1'b0;
      reset= 1'b0;
      Reg_rs = 32'b0;
      #5 Clk=0; #5 Clk=1;#5 Clk=0;

      if(pcaddress !== 2) begin
        dutpassed = 0;
        $display("Test Case 2 Failed");
        $display("%b", pcaddress);
      end
      // Test Case 3 : jal

      // resetting it
      reset= 1'b1;
      #5 Clk=1; #5 Clk=0;
      #5 Clk=1;

      jumpaddress = 26'd6;
      branchaddress = 16'd0;
      jump = 1'b1;
      beq = 1'b0;
      bne = 1'b0;
      regorimm = 1'b0;
      reset= 1'b0;
      Reg_rs = 32'b0;


      if(Reg_31 !== 32'd4) begin //reg_31 should be 4, because previos PC is 0, by reset
        dutpassed = 0;
        $display("Test Case 3 Failed, reg");
        $display("%b", Reg_31);
      end
      #5 Clk=0;#5 Clk=1;#5 Clk=0;
      if(pcaddress !== 6) begin
        dutpassed = 0;
        $display("Test Case 3 Failed, pcaddress");
        $display("%b", pcaddress);
      end
      // Test Case 4: jr

      // resetting it
      reset= 1'b1;
      #5 Clk=1; #5 Clk=0;

      jumpaddress = 26'd0;
      branchaddress = 16'b0;
      jump = 1'b1;
      beq = 1'b0;
      bne = 1'b0;
      regorimm = 1'b1;
      reset= 1'b0;
      Reg_rs = 32'd3;
      #5 Clk=0; #5 Clk=1;#5 Clk=0;

      if(pcaddress !== 3) begin
        dutpassed = 0;
        $display("Test Case 4 Failed");
        $display("%b", pcaddress);
      end
      // Test Case 5: beq

      // resetting it
      reset= 1'b1;
      #5 Clk=1; #5 Clk=0;#5 Clk=1;

      jumpaddress = 26'd2;
      branchaddress = 16'd15;
      jump = 1'b1;
      beq = 1'b1;
      bne = 1'b0;
      regorimm = 1'b0;
      reset= 1'b0;
      Reg_rs = 32'b0;
      #5 Clk=0; #5 Clk=1;#5 Clk=0;

      if(pcaddress !== 19) begin
        dutpassed = 0;
        $display("Test Case 5 Failed");
        $display("%b", pcaddress);
      end
      // Test Case 6: bne

      // resetting it
      reset= 1'b1;
      #5 Clk=1; #5 Clk=0; #5 Clk=1;

      jumpaddress = 26'd2;
      branchaddress = 16'd20;
      jump = 1'b1;
      beq = 1'b0;
      bne = 1'b1;
      regorimm = 1'b0;
      reset= 1'b0;
      Reg_rs = 32'b0;
      #5 Clk=0; #5 Clk=1;#5 Clk=0;
      if(pcaddress !== 24) begin
        dutpassed = 0;
        $display("Test Case 5 Failed");
        $display("%b", pcaddress);
      end

      #5
      endtest = 1;
      end
      endmodule
