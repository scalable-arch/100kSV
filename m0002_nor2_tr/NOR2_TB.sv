// A testbench for 2-input NOR gate
`timescale 1ns/10ps

module NOR2_TB;
    reg                                 a, b;
    wire                                y;

    NOR2                                dut(y, a, b);

    initial begin
        $monitor($time, "ns\tA = %b, B = %b, Y = %b", a, b, y);
    end

    initial begin
        a = 0;
        b = 0;
        #1

        a = 1;
        b = 0;
        #1

        a = 0;
        b = 1;
        #1

        a = 1;
        b = 1;
        #1

        $finish;
    end
endmodule
