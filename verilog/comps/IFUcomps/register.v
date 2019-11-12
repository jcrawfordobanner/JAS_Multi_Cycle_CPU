module regPC(
  output[31:0] pctoalu,
  input[31:0] muxtopc,

  //output reg[31:0] PCaddress,
  input clk
);
reg [31:0]  memory={31'b0};
assign pctoalu = memory;
always @(posedge clk) begin
        memory <= muxtopc;
    end

endmodule
