`define AND and
`define NAND nand
`define NOT not
`define NOR nor
`define OR or
// Because CMOS structure of both XOR and XNOR only need 4 FETs, both are 20
`define XOR xor
`define XNOR xnor

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

module Multiplexer4
(
    output out,
    input address0, address1,
    input in0, in1, in2, in3
);
wire selUp;
wire selDown;
Multiplexer2Furious baby1(.out(selUp), .in0(in0), .in1(in1), .address(address0));
Multiplexer2Furious baby2(.out(selDown), .in0(in2), .in1(in3), .address(address0));
Multiplexer2Furious parent(.out(out), .in0(selUp), .in1(selDown), .address(address1));
// wire na0;
// wire na1;
// wire ap0;
// wire ap1;
// wire ap2;
// wire ap3;
// wire and0;
// wire and1;
// wire and2;
// wire and3;
// wire orb;
// wire orm;
// `NOT (na0,address0);
// `NOT (na1,address1);
// `AND (ap0,na0,na1);
// `AND (ap3,address0,address1);
// `AND (ap1,address0,na1);
// `AND (ap2,na0,address1);
// `AND (and0,in0,ap0);
// `AND (and1,in1,ap1);
// `AND (and2,in2,ap2);
// `AND (and3,in3,ap3);
// `OR (orb,and0,and1);
// `OR (orm,orb,and2);
// `OR (out,orm,and3);
endmodule

module Multiplexer8
(
    output out,
    input address0, address1, address2,
    input in0, in1, in2, in3, in4, in5, in6, in7
);
wire fout1;
wire fout2;
Multiplexer4 bad(
.out(fout1),
.address0(address0),
.address1(address1),
.in0(in0),
.in1(in1),
.in2(in2),
.in3(in3));

Multiplexer4 good(
.out(fout2),
.address0(address0),
.address1(address1),
.in0(in4),
.in1(in5),
.in2(in6),
.in3(in7));

Multiplexer2Furious micheal(
.out(out),
.address(address2),
.in0(fout1),
.in1(fout2));
endmodule
