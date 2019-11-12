`define AND and
`define NAND nand
`define NOT not
`define NOR nor
`define OR or
// Because CMOS structure of both XOR and XNOR only need 4 FETs, both are 20
`define XOR xor
`define XNOR xnor

`include "comps/alucomps/mulittest.v"

module OneBitAdder(
input a,
input b,
input carryin,
output sum,
output carryout
);
	 wire AxorB;
	 wire AB;
	 wire AxorBC;
	 `XOR(AxorB,a,b);
	 `AND(AB,a,b);
	 `AND(AxorBC, AxorB,carryin);
	 `XOR(sum,AxorB, carryin);
	 `OR(carryout, AxorBC,AB);
endmodule

module BitSlice(
// Named them o-function, because `and` and other terms are overloaded
 output oAnd,
 output oNand,
 output oOr,
 output oNor,
 output oXor,
// The next three are the same value
// They are split to satisfy the later 8-bit multiplexer reqs
 output oAdd,
 output oSub,
 output oSLT, // This in particular is a useless value - treat as dummy val
 output cout,
 input 	A,
 input 	B,
 input 	cin,
 input 	ctl1, // Logic line
 input 	ctl2 // Subtract/SLT line
);
	 // Change B's input if subtracting (2's complement style)
	 wire notB;
	 wire trueB;
	 `NOT noB(notB, B);

	 // Determine proper carryin (0 if logic, otherwise use provided cin)
	 wire trueCin;
	 `AND findCin(trueCin, ctl1, cin);

	 // Do adding (/subtracting/SLTing)
	 wire sum;
	 Multiplexer2Furious tmtf(.out(trueB), .address(ctl2), .in0(B), .in1(notB));
	 OneBitAdder oba(.sum(sum), .carryout(cout), .a(A), .b(trueB), .carryin(trueCin));

	 // Connects sum to three different lines (reason mentioned above)
	 buf toAdd(oAdd, sum);
	 buf toSub(oSub, sum);

	 // Begin logic handling
	 buf toXor(oXor, sum);
	 buf toAnd(oAnd, cout);
	 `NOT toNand(oNand, oAnd);
	 `NOR toNor(oNor, sum, cout); // Did Nor gate first to reduce redundant negations
	 `NOT toOr(oOr, oNor);
endmodule
