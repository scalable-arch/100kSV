// A transistor-level model of a 2-input NOR gate
module NOR2 (
    output  wire                        Y,
    input   wire                        A,
    input   wire                        B
);

    wire                                w1;
    supply1                             vdd;
    supply0                             gnd;

    // VDD      -----------+-----
    //                  p1 |
    //               a --o|
    //                  p2 | w1
    //               b --*|
    //                     |
    //                 +---+---+--- Y
    //              n1 |    n2 |
    //           a ---|  b ---|
    //                 |       |
    // GND      -------+-------+----

    pmos    p1(w1, vdd, A);
    pmos    p2(Y, w1, B);
    nmos    n1(Y, gnd, A);
    nmos    n2(Y, gnd, B);

endmodule
