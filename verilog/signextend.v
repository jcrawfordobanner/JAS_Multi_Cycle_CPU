module signextend16

(
  input[15:0] in,
  output[31:0] extended
);
assign extended = {16'b0,in};
endmodule

module signextend26
(
   input [25:0]  in,
   output [31:0] extended
 );
	 // wire [29:0] 	 inter;
	 assign extended = {4'b0,in,2'b0};
	 // assign extended = {inter, 2'b0};
endmodule

module signextend16bne

(
  input[15:0] in,
  output[31:0] extended
);
assign extended = {14'b0,in,2'b0};
endmodule
