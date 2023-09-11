// A testbench for 2:1 MUX
// Copyright (c) 2021 Sunkyunkwan University
`timescale 1ns/10ps

module MUX_2to1_TB;
    reg     a, b, s;
    wire    y;
    
    MUX_2to1     dut(y, a, b, s);

    initial begin
        $monitor($time, "ns\tA = %b, B = %b, S = %b, Y = %b", a, b, s, y);
    end

    initial begin
        s = 0;

        a = 0;
        b = 0;
        #1

        a = 0;
        b = 1;
        #1

        a = 1;
        b = 0;
        #1

        a = 1;
        b = 1;
        #1 

        s = 1;

        a = 0;
        b = 0;
        #1

        a = 0;
        b = 1;
        #1

        a = 1;
        b = 0;
        #1

        a = 1;
        b = 1;
        #1


        $finish;
    end
endmodule


