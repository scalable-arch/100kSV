// A testbench for 2-input AND gate
`timescale 1ns/10ps

module AND2_TB;
    reg                                 a, b;
    wire                                y;

    AND2                                dut(y, a, b);

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
