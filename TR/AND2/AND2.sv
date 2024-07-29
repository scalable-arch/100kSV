// A transistor-level model of a 2-input AND gate
module AND2 (
    output  wire                        Y,
    input   wire                        A,
    input   wire                        B
);

    wire                                w1;
    supply1                             vdd;
    supply0                             gnd;

    // VDD      -------+------+----------+-----
    //              p1 |   p2 |       p3 |
    //           a --o|  b--o|       --o|
    //                 |      |      |   |
    //                 +--+---+--w2--+   +----- Y
    //                 n1 |          |   |
    //              a ---|           ---|
    //                 n2 | w1           |
    //              b ---|               |
    //                    |              |
    // GND      ----------+-------------+------

    pmos    p1(w2, vdd, A);
    pmos    p2(w2, vdd, B);
    pmos    p3(Y, vdd, w2);
    nmos    n1(w2, w1, A);
    nmos    n2(w1, gnd, B);
    nmos    n3(Y, gnd, w2);

endmodule
