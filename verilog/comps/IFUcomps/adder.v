module adder
#(parameter width = 8)
(
    output[width-1:0] out,
    input[width-1:0] in0, in1
);

assign out = in0+in1;

endmodule
