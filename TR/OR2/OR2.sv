// A transistor-level model of a 2-input OR gate
module OR2 (
    output  wire                        Y,
    input   wire                        A,
    input   wire                        B
);

    wire                                w1, w2;
    supply1                             vdd;
    supply0                             gnd;

    // VDD      -----------+---------------+-----
    //                  p1 |            p3 |
    //               a --o|           ---o|
    //                  p2 | w1       |    |
    //               b --o|           |    |
    //                     |          |    |
    //                 +---+---+--w2--+    +---- Y
    //              n1 |    n2 |      | n3 |
    //           a ---|  b ---|       ----|
    //                 |       |           |
    // GND      -------+-------+-----------+----

    pmos    p1(w1, vdd, A);
    pmos    p2(w2, w1, B);
    pmos    p3(Y, vdd, w2);
    nmos    n1(w2, gnd, A);
    nmos    n2(w2, gnd, B);
    nmos    n3(Y, gnd, w2);

endmodule
