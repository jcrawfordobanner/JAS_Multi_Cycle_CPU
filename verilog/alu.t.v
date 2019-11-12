// ALU testbench
`timescale 1 ns / 1 ps
`include "alu.v"

module testALU();
	 reg[31:0] A, B; // Input values
	 reg [2:0] ctls;
	 wire [31:0] S; // Outputted values
	 wire 			 zero, cout, oflow;
	 wire[31:0] icin;
	 wire[31:0] trucin;
	 wire[31:0] add;

	 ALU dut(.result(S), .carryout(cout), .zero(zero), .overflow(oflow),
					 .operandA(A), .operandB(B), .command(ctls));

	 initial begin
			// Storing traces of signals as they pass through ALU
			$dumpfile("alu-dump.vcd");
			$dumpvars();
			$display("Truth table test of the ALU");
			$display();
			$display("Testing addition:");
			A='b01111111111111111111111111111111;B={31'b0, 1'b1};ctls=3'b0; #12800 // Oflow, no Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A+B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b1);

			A='b10000000000000000000000000000000;B='b11111111111111111111111111111111;ctls=3'b0; #12800 // Oflow, Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A+B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b1);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b1);
			A='b11111111111111111111111111111111;B='b11111111111111111111111111111110;ctls=3'b0; #12800 // No Oflow, Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A+B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b1);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			A='b01111111111111111111111111111111;B={32'b0};ctls=3'b0; #12800 // No Oflow, no Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A+B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			// SUBTRACT tests
			$display(" ");
			$display(" ");
			$display("Testing subtraction:");
			A='b10000000000000000000000000000000;B='b01111111111111111111111111111111;ctls=3'b001; #12800 // Oflow, Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A-B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b1);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b1);
			A='b01111111111111111111111111111111;B='b10000000000000000000000000000000;ctls=3'b001; #12800 // Oflow, no Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A-B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b1);
			A=-32'd3;B=32'd5;ctls=3'b001; #12800 // No Oflow, Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A-B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b1);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			A=32'd5;B=32'd3;ctls=3'b001; #12800 // No Oflow, no Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A-B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			A=32'd5;B=32'd5;ctls=3'b001; #12800 // No Oflow, no Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,A-B);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b1);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b1);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			// SLT tests
			$display(" ");
			$display(" ");
			$display("Testing SLT:");
			/// A<B
			A='b10000000000000000000000000000000;B='b01111111111111111111111111111111;ctls=3'b011; #12800 // Oflow, Cout, A neg B pos
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b1);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b1);
			A=-32'd3;B=32'd5;ctls=3'b011; #12800 // No Oflow, Cout, A neg B pos
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			A=-32'd3;B=-32'd2;ctls=3'b011; #12800 // Both negative
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			A=32'd3;B=32'd5;ctls=3'b011; #12800 // Both positive
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			/// A>B
			A='b01111111111111111111111111111111;B='b10000000000000000000000000000000;ctls=3'b011; #12800 // Oflow, no Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b1);
			A=32'd5;B=32'd3;ctls=3'b011; #128000 // No Oflow, no Cout
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,21'b0);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			A=-32'd2;B=-32'd3;ctls=3'b011; #128000 // Both negative
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			A=32'd5;B=32'd3;ctls=3'b011; #128000 // Both positive
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			$display("    Zero: %b (detected) | %b (expected)", zero, 1'b0);
			$display("Carryout: %b (detected) | %b (expected)", cout, 1'b0);
			$display("Overflow: %b (detected) | %b (expected)", oflow, 1'b0);
			// LOGIC GATE TESTS
			// Use standard logic gate tests for 1-bit inputs, extend for all 32 bits
			$display(" ");
			$display(" ");
			$display("Testing LOGIC:");
			// XOR
			$display(" ");
			$display("Testing XOR:");
			A=32'b0;B=32'b0;ctls=3'b010; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			A=32'b0;B='b11111111111111111111111111111111;ctls=3'b010; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			A='b11111111111111111111111111111111;B=32'b0;ctls=3'b010; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			A='b11111111111111111111111111111111;B='b11111111111111111111111111111111;ctls=3'b010; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			// NAND
			$display(" ");
			$display("Testing NAND:");
			A=32'b0;B=32'b0;ctls=3'b101; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			A=32'b0;B='b11111111111111111111111111111111;ctls=3'b101; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			A='b11111111111111111111111111111111;B=32'b0;ctls=3'b101; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			A='b11111111111111111111111111111111;B='b11111111111111111111111111111111;ctls=3'b101; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			// AND
			$display(" ");
			$display("Testing AND:");
			A=32'b0;B=32'b0;ctls=3'b100; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			A=32'b0;B='b11111111111111111111111111111111;ctls=3'b100; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			A='b11111111111111111111111111111111;B=32'b0;ctls=3'b100; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			A='b11111111111111111111111111111111;B='b11111111111111111111111111111111;ctls=3'b100; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			// NOR
			$display(" ");
			$display("Testing NOR:");
			A=32'b0;B=32'b0;ctls=3'b110; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			A=32'b0;B='b11111111111111111111111111111111;ctls=3'b110; #128000
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			A='b11111111111111111111111111111111;B=32'b0;ctls=3'b110; #128000
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			A='b11111111111111111111111111111111;B='b11111111111111111111111111111111;ctls=3'b110; #128000
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			// OR
			$display(" ");
			$display("Testing OR:");
			A=32'b0;B=32'b0;ctls=3'b111; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,32'b0);
			A=32'b0;B='b11111111111111111111111111111111;ctls=3'b111; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			A='b11111111111111111111111111111111;B=32'b0;ctls=3'b111; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			A='b11111111111111111111111111111111;B='b11111111111111111111111111111111;ctls=3'b111; #12800
			$display("------------------------------------------------");
			$display("%b <-- A\n%b <- B\n%b <-- Operation\n%b <-- S \n%b <-- S Expected",A,B,ctls,S,'b11111111111111111111111111111111);
			$finish();
	 end
endmodule // testALU
