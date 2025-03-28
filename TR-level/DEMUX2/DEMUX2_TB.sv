// A testbench for 2:1 DEMUX
// Copyright (c) 2021 Sunkyunkwan University
`timescale 1ns/10ps

module DEMUX2_TB;
    reg     d, s;
    wire    y0, y1;
    
    DEMUX2    dut(y0, y1, d, s);

    initial begin
        $monitor($time, "ns\tD = %b, S = %b, Y0 = %b, Y1 = %b", d, s, y0, y1);
    end

    initial begin
        s = 0;
        d = 0;
        #1

        d = 1;
        #1

        s = 1;
        d = 0;
        #1

        d = 1;
        #1

        $finish;
    end

endmodule
