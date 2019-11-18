`include "comps/IFUcomps/multiplexer.v"
module Multiplexer4doubletime
(
    output [31:0] out,
    input address0, address1,
    input [31:0] in0, in1, in2, in3
);
  wire [31:0] intermed0, intermed1;
  muxnto1byn #(32) inter0(.out(intermed0),
                       .address(address0),
                       .input0(in0),
                       .input1(in2));

  muxnto1byn #(32) inter1(.out(intermed1),
                      .address(address0),
                      .input0(in1),
                      .input1(in3));
  muxnto1byn #(32) final(.out(out),
                      .address(address1),
                      .input0(intermed0),
                      .input1(intermed1));
  endmodule
