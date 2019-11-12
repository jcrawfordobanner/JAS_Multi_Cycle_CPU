// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register32zero
(
 output [31:0] q,
 input [31:0] 		 d,
 input 						 wrenable,
 input 						 clk
);
	 assign q = 32'b0;
endmodule
