`timescale 1 ns / 1 ps
`include "mulittest.v"

//module testMultiplexer ();
//    wire out;
//    reg address;
//    reg in0, in1;
//
//    //behavioralMultiplexer multiplexer (out,address0, address1,in0, in1, in2, in3);
//    Multiplexer2Furious multiplexer (out,address, in0, in1); // Swap after testing
//
//    initial begin
//    $dumpfile("multi.vcd");
//    $dumpvars();
//    $display("S I0 I1 | Out | Expected Output");
//    address=0;in0=0;in1=0; #1000
//    $display("%b  %b  | %b | False", address, in0, out);
//    address=0;in0=1;in1=0; #1000
//    $display("%b  %b  | %b | True", address, in0, out);
//    address=1;in0=0;in1=0; #1000
//    $display("%b  %b  | %b | False", address, in1,out);
//    address=1;in0=0;in1=1; #1000
//    $display("%b  %b  | %b | True", address, in1,out);
//    end
//endmodule

module testMultiplexer ();
    wire out;
    reg address0, address1, address2;
    reg in0, in1, in2, in3, in4,  in5, in6, in7;

    //behavioralMultiplexer multiplexer (out,address0, address1, address2, in0, in1, in2, in3, in4, in5, in6, in7);
    Multiplexer8 multiplexer (out,address0, address1, address2, in0, in1, in2, in3, in4, in5, in6, in7); // Swap after testing

    initial begin
    $dumpfile("multi.vcd");
    $dumpvars();
    $display("S0 S1 S2 I0 I1 I2 I3 I4 I5 I6 I7 | Out | Expected Output");
    address0=0;address1=0;address2=0;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  %b  x  x  x  x  x  x  x | %b | False", address0, address1, address2, in0, out);
    address0=0;address1=0;address2=0;in0=1;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  %b  x  x  x  x  x  x  x | %b | True", address0, address1, address2, in0, out);
    address0=1;address1=0;address2=0;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  %b  x  x  x  x  x  x | %b | False", address0, address1, address2, in1,out);
    address0=1;address1=0;address2=0;in0=0;in1=1;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  %b  x  x  x  x  x  x | %b | True", address0, address1, address2, in1,out);
    address0=0;address1=1;address2=0;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  %b  x  x  x  x  x | %b | False", address0, address1, address2, in2, out);
    address0=0;address1=1;address2=0;in0=0;in1=0;in2=1;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  %b  x  x  x  x  x | %b | True", address0, address1, address2, in2, out);
    address0=1;address1=1;address2=0;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  x  %b  x  x  x  x | %b | False", address0, address1, address2, in3, out);
    address0=1;address1=1;address2=0;in0=0;in1=0;in2=0;in3=1;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  x  %b  x  x  x  x | %b | True", address0, address1, address2, in3, out);
    address0=0;address1=0;address2=1;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  x  x  %b  x  x  x | %b | False", address0, address1, address2, in4, out);
    address0=0;address1=0;address2=1;in0=0;in1=0;in2=0;in3=0;in4=1;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  x  x  %b  x  x  x | %b | True", address0, address1, address2, in4, out);
    address0=1;address1=0;address2=1;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  x  x  x  %b  x  x | %b | False", address0, address1, address2, in5, out);
    address0=1;address1=0;address2=1;in0=0;in1=0;in2=0;in3=0;in4=0;in5=1;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  x  x  x  %b  x  x | %b | True", address0, address1, address2, in5, out);
    address0=0;address1=1;address2=1;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  x  x  x  x  %b  x | %b | False", address0, address1, address2, in6, out);
    address0=0;address1=1;address2=1;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=1;in7=0; #1000
    $display("%b  %b  %b  x  x  x  x  x  x  %b  x | %b | True", address0, address1, address2, in6, out);
    address0=1;address1=1;address2=1;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=0; #1000
    $display("%b  %b  %b  x  x  x  x  x  x  x  %b | %b | False", address0, address1, address2, in7, out);
    address0=1;address1=1;address2=1;in0=0;in1=0;in2=0;in3=0;in4=0;in5=0;in6=0;in7=1; #1000
    $display("%b  %b  %b  x  x  x  x  x  x  x  %b | %b | True", address0, address1, address2, in7, out);
    end
endmodule
