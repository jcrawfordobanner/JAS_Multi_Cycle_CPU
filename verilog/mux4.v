module Multiplexer4doubletime
(
    output [31:0] out,
    input address0, address1,
    input [31:0] in0, in1, in2, in3
);
wire selUp;
wire selDown;
Multiplexer2Furious baby1(.out(selUp), .in0(in0), .in1(in1), .address(address0));
Multiplexer2Furious baby2(.out(selDown), .in0(in2), .in1(in3), .address(address0));
Multiplexer2Furious parent(.out(out), .in0(selUp), .in1(selDown), .address(address1));
endmodule
