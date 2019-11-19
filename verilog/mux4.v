`include "comps/IFUcomps/multiplexer.v"
module Multiplexer4doubletime
(
    output reg [31:0] out,
    input [1:0] address,
    input [31:0] in0, in1, in2, in3
);
  always @(address) begin
    case(address)
      2'd0:begin assign out=in0; end
      2'd1:begin assign out=in1; end
      2'd2:begin assign out=in2; end
      2'd3:begin assign out=in3; end
    endcase
  end

  endmodule
