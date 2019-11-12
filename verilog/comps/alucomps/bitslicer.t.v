// ALU testbench
`timescale 1 ns / 1 ps
`include "bitslicer.v"

module testBitSlicer();
	 reg A, B, Cin; // Input values
	 reg [1:0] ctls; // The two control lines for the bit slice
	 wire 		 oAnd, oNand, oOr, oNor, oXor, oAdd, oSub, oSLT, cout; // Outputted values

	 BitSlice dut(.oAnd(oAnd),
								.oNand(oNand),
								.oOr(oOr),
								.oNor(oNor),
								.oXor(oXor),
								.oAdd(oAdd),
								.oSub(oSub),
								.oSLT(oSLT),
								.cout(cout),
								.A(A), .B(B), .cin(Cin),
								.ctl1(ctls[0]), .ctl2(ctls[1]));

	 initial begin
			$display("Truth table test of the ALU's Bit Slice");
			$display();
			$display("A | B | Cin | Output | Expected");

			// ADD tests
			$display("  |   |     | S Cout | S Cout (expected) <- Testing addition");
			A=1'b1;B=1'b0;Cin=1'b0;ctls=2'b01; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oAdd,cout,1'b1,1'b0);
			A=1'b1;B=1'b0;Cin=1'b1;ctls=2'b01; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oAdd,cout,1'b0,1'b1);
			A=1'b0;B=1'b1;Cin=1'b0;ctls=2'b01; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oAdd,cout,1'b1,1'b0);
			A=1'b0;B=1'b1;Cin=1'b1;ctls=2'b01; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oAdd,cout,1'b0,1'b1);
			A=1'b1;B=1'b1;Cin=1'b0;ctls=2'b01; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oAdd,cout,1'b0,1'b1);
			A=1'b1;B=1'b1;Cin=1'b1;ctls=2'b01; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oAdd,cout,1'b1,1'b1);
			A=1'b0;B=1'b0;Cin=1'b0;ctls=2'b01; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oAdd,cout,1'b0,1'b0);
			A=1'b0;B=1'b0;Cin=1'b1;ctls=2'b01; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oAdd,cout,1'b1,1'b0);
			$display();
			// SUBTRACT tests
			$display("A | B | Cin | S Cout | S Cout (expected) <- Testing subtraction");
			A=1'b1;B=1'b0;Cin=1'b0;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b0,1'b1);
			A=1'b1;B=1'b0;Cin=1'b1;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b1,1'b1);
			A=1'b0;B=1'b1;Cin=1'b0;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b0,1'b0);
			A=1'b0;B=1'b1;Cin=1'b1;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b1,1'b0);
			A=1'b1;B=1'b1;Cin=1'b0;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b1,1'b0);
			A=1'b1;B=1'b1;Cin=1'b1;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b0,1'b1);
			A=1'b0;B=1'b0;Cin=1'b0;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b1,1'b0);
			A=1'b0;B=1'b0;Cin=1'b1;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b0,1'b1);
			$display();
			// SLT tests -- Same unit behavior as subtract!
			$display("A | B | Cin | S Cout | S Cout (expected) <- Testing SLT");
			A=1'b1;B=1'b0;Cin=1'b0;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b0,1'b1);
			A=1'b1;B=1'b0;Cin=1'b1;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b1,1'b1);
			A=1'b0;B=1'b1;Cin=1'b0;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b0,1'b0);
			A=1'b0;B=1'b1;Cin=1'b1;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b1,1'b0);
			A=1'b1;B=1'b1;Cin=1'b0;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b1,1'b0);
			A=1'b1;B=1'b1;Cin=1'b1;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b0,1'b1);
			A=1'b0;B=1'b0;Cin=1'b0;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b1,1'b0);
			A=1'b0;B=1'b0;Cin=1'b1;ctls=2'b11; #400
			$display("%b | %b | %b   | %b %b    | %b %b",A,B,Cin,oSub,cout,1'b0,1'b1);
			$display();
			// LOGIC GATE TESTS
			// Use standard logic gate tests for 1-bit inputs
			// Keep carryin as 1 - if carryin blocking is done right, it should have no effect on output
			// XOR
			$display("A | B | Cin | S | S (expected) <- Testing XOR");
			A=1'b0;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oXor,1'b0);
			A=1'b0;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oXor,1'b1);
			A=1'b1;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oXor,1'b1);
			A=1'b1;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oXor,1'b0);
			$display();
			// NAND
			$display("A | B | Cin | S | S (expected) <- Testing NAND");
			A=1'b0;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oNand,1'b1);
			A=1'b0;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oNand,1'b1);
			A=1'b1;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oNand,1'b1);
			A=1'b1;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oNand,1'b0);
			$display();
			// AND
			$display("A | B | Cin | S | S (expected) <- Testing AND");
			A=1'b0;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oAnd,1'b0);
			A=1'b0;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oAnd,1'b0);
			A=1'b1;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oAnd,1'b0);
			A=1'b1;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oAnd,1'b1);
			$display();
			// NOR
			$display("A | B | Cin | S | S (expected) <- Testing NOR");
			A=1'b0;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oNor,1'b1);
			A=1'b0;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oNor,1'b0);
			A=1'b1;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oNor,1'b0);
			A=1'b1;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oNor,1'b0);
			$display();
			// OR
			$display("A | B | Cin | S | S (expected) <- Testing OR");
			A=1'b0;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oOr,1'b0);
			A=1'b0;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oOr,1'b1);
			A=1'b1;B=1'b0;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oOr,1'b1);
			A=1'b1;B=1'b1;ctls=2'b00; #400
			$display("%b | %b | %b   | %b | %b",A,B,Cin,oOr,1'b1);
			$display();
	 end
endmodule // testALU
