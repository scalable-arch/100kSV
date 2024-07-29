// A testbench for an inverter
`timescale 1ns/10ps

module INV_TB;
    reg                                 a;
    wire                                y;

    INV                                 dut(y, a);

    initial begin
        $monitor($time, "ns\tA = %b, Y = %b", a, y);
    end

    initial begin
        a = 0;
        #1

        a = 1;
        #1

        $finish;
    end
endmodule
