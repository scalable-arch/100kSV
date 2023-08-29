// A transistor-level model of a 2-input XOR gate
module XOR2 (
    output  wire                        Y,
    input   wire                        A,
    input   wire                        B
);

    supply1                             vdd;
    supply0                             gnd;
    wire                                abar, bbar;
    wire                                w1, w2, w3, w4;

    // for generation of bar signals
    pmos    pabar(abar, vdd, A);
    nmos    nabar(abar, gnd, A);

    pmos    pbbar(bbar, vdd, a);
    nmos    nabar(bbar, gnd, A);

    // VDD      -------+-----------+----------
    //              p1 |           | p3
    //        abar --o|             |o-- a
    //              p2 | w1     w2 | p4
    //           b --o|             |o-- bbar
    //                 |           |
    //                 +-----------+--------- Y
    //              n1 |           | n3
    //        abar ---|             |--- a
    //              n2 | w3     w4 | n4
    //        bbar ---|             |--- b
    //                 |           |
    // GND      -------+-----------+---------

    pmos    p1(w1, vdd, abar);
    pmos    p2(Y, w1, B);
    pmos    p3(w2, vdd, A);
    pmos    p4(Y, w2, bbar);

    nmos    n1(Y, w3, abar);
    nmos    n2(w3, gnd, bbar);
    nmos    n3(
    pmos    p1(w1, vdd, A);
    pmos    p2(Y, w1, B);
    nmos    n1(Y, gnd, A);
    nmos    n2(Y, gnd, B);

endmodule
