// A transistor-level model of a 2-input NAND gate
module NAND2 (
    output  wire                        Y,
    input   wire                        A,
    input   wire                        B
);

    wire                                w1;
    supply1                             vdd;
    supply0                             gnd;

    // VDD      -------+------+--------
    //              p1 |   p2 |
    //           a --o|  b--o|
    //                 |      |
    //                 +--+---+-------- Y
    //                 n1 |
    //              a ---|
    //                 n2 | w1
    //              b ---|
    //                    |
    // GND      ----------+------------

    pmos    p1(Y, vdd, A);
    pmos    p2(Y, vdd, B);
    nmos    n1(Y, w1, A);
    nmos    n2(w1, gnd, B);

endmodule
