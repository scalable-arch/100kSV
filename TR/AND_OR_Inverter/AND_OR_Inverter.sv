// 2-1 AOI
// operation: (A+ BC)'
module AND_OR_Inverter(
    output      wire Y,
    input       wire A,
    input       wire B,
    input       wire C
);
    wire w1, w2;
    supply0 gnd;
    supply1 vdd;

    // pmos modulename(Drain, Source, Gate) where source is upside (conventionally vdd)
    // nmos modulename(Drain, Source, Gate) where source is downside (conventionally gnd)

    pmos    p1(w1, vdd, B);
    pmos    p2(w1, vdd, C);
    pmos    p3(Y, w1, A);

    nmos    n1(Y, gnd, A);
    nmos    n2(w2, gnd, B);
    nmos    n3(Y, w2, C);

endmodule