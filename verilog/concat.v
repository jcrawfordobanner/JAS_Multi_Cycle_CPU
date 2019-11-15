module concatinate(
  input [25:0] notconcatinated,
  input [31:0] PC,
  output [31:0] concatinated
);
  assign concatinated = {PC[31:28],notconcatinated};
 endmodule

 module shift(
   input [25:0] notshifted,
   output [31:0] shifted
 );
   assign shifted = {notshifted,2'b0};
  endmodule
