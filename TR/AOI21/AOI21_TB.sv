
module AOI21_TB;
    reg a, b, c;
    wire y;

    AOI21   dut(y, a, b, c);

    initial begin
        $monitor($time, "ns\tA = %b, B = %b, C = %b, Y = %b", a, b, c, y);
    end

    initial begin
        a = 0; b = 0; c = 0;
        #1
        a = 0; b = 0; c = 1;
        #1
        a = 0; b = 1; c = 0;
        #1
        a = 0; b = 1; c = 1;
        #1
        a = 1; b = 0; c = 0;
        #1
        a = 1; b = 0; c = 1;
        #1
        a = 1; b = 1; c = 0;
        #1
        a = 1; b = 1; c = 1;
        #1

        $finish;
    end
endmodule
