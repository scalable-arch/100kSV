// A testbench for full-adder

`timescale 1ns/10ps

module FULL_ADDER_TB;

    reg a, b, cin;
    wire s, cout;

    FULL_ADDER  dut(s, cout, a, b, cin);
    
    initial begin
        $monitor($time, "ns\tA = %b, B = %b, Cin = %b, S = %b, Cout = %b", a , b, cin, s, cout);
    end

    initial begin
        a = 0; b = 0; cin = 0;
        #1

        a = 0; b = 0; cin = 1;
        #1

        a = 0; b = 1; cin = 0;
        #1

        a = 0; b = 1; cin = 1;
        #1

        a = 1; b = 0; cin = 0;
        #1

        a = 1; b = 0; cin = 1;
        #1

        a = 1; b = 1; cin = 0;
        #1

        a = 1; b = 1; cin = 1;
        #1

        $finish;

    end

endmodule
