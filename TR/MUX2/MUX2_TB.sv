// A testbench for 2:1 MUX
// Copyright (c) 2021 Sunkyunkwan University
`timescale 1ns/10ps

module MUX2_TB;
    reg     d0, d1, s;
    wire    y;
    
    MUX2    dut(y, d0, d1, s);

    initial begin
        $monitor($time, "ns\tD0 = %b, D1 = %b, S = %b, Y = %b", d0, d1, s, y);
    end

    initial begin
        s = 0;

        d0 = 0;
        d1 = 0;
        #1

        d0 = 0;
        d1 = 1;
        #1

        d0 = 1;
        d1 = 0;
        #1

        d0 = 1;
        d1 = 1;
        #1 

        s = 1;

        d0 = 0;
        d1 = 0;
        #1

        d0 = 0;
        d1 = 1;
        #1

        d0 = 1;
        d1 = 0;
        #1

        d0 = 1;
        d1 = 1;
        #1

        $finish;
    end

endmodule
