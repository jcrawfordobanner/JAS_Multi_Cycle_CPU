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

module Multiplexer2Furious
(
    output out,
    input address,
    input in0, in1
);
wire na;
wire ap0;
wire ap1;
wire and0;
wire and1;
  `NOT (na,address);
  `AND (and0,in0,na);
  `AND (and1,in1,address);
  `OR (out,and0,and1);
//   `OR (out,orb,and2);
endmodule
