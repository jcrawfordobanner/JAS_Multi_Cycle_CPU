module muxnto1byn
#(parameter width = 8)
(
output reg[width-1:0]   out,
input    address,
input[width-1:0]   input0, input1
);

always @ (input0 or input1 or address) begin
      case (address)
         0 : out <= input0;
         1 : out <= input1;
      endcase
end
endmodule
