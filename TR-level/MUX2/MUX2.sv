// A transistor-level model of a 2:1 MUX
module MUX2 (
    output wire     Y,
    input wire      D0,
    input wire      D1,
    input wire      S
);

    wire    n_S;
    supply1 vdd;
    supply0 gnd;

    // S_BAR
    pmos    p1(n_S, vdd, S);
    nmos    n1(n_S, gnd, S);

    // Transmission Gate Mux
    pmos    p2(Y, D0, S);
    nmos    n2(Y, D0, n_S);

    pmos    p3(Y, D1, n_S);
    nmos    n3(Y, D1, S);

endmodule
