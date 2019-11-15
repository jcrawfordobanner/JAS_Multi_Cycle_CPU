module regboi(
  output[31:0] out,
  input[31:0] in,

  //output reg[31:0] PCaddress,
  input clk
);
reg [31:0]  memory={31'b0};
assign out = memory;
always @(posedge clk) begin
        memory <= in;
    end

endmodule
