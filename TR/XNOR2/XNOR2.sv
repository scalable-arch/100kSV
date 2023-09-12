module XNOR2(
    output  wire             Y,
    input   wire             A,
    input   wire             B
);
    supply0             gnd;
    supply1             vdd;

    // inverter generation
    wire                abar, bbar;
    pmos                pabar(abar, vdd, A);
    nmos                nabar(abar, gnd, A);

    pmos                pbbar(bbar, vdd, B);
    nmos                nbbar(bbar, gnd, B);

    wire                w1, w2, w3, w4;
    pmos                p1(w1, vdd, abar);
    pmos                p2(Y, w1, bbar);
    pmos                p3(w2, vdd, A);
    pmos                p4(Y, w2, B);

    nmos                n1(Y, w3, A);
    nmos                n2(w3, gnd, bbar);
    nmos                n3(w4, gnd, B);
    nmos                n4(Y, w4, abar);
endmodule