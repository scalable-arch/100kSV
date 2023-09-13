// A testbench for half-adder

`timescale 1ns/10ps

module HALF_ADDER_TB;

    reg a, b;
    wire s, c;

    HALF_ADDER  dut(s, c, a, b);
    
    initial begin
        $monitor($time, "ns\tA = %b, B = %b, S = %b, C = %b", a , b, s, c);
    end

    initial begin
        a = 0; b = 0;
        #1

        a = 0; b = 1;
        #1

        a = 1; b = 0;
        #1

        a = 1; b = 1;
        #1

        $finish;

    end

endmodule
