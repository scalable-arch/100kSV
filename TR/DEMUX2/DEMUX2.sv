// A transistor-level model of a 2:1 DEMUX
module DEMUX2 (
    output wire     Y0,
    output wire     Y1,
    input wire      D,
    input wire      S
);

    wire    n_S;
    supply1 vdd;
    supply0 gnd;

    // S_BAR
    pmos    p1(n_S, vdd, S);
    nmos    n1(n_S, gnd, S);

    // Transmission Gate Mux
    pmos    p2(Y0, D, S);
    nmos    n2(Y0, D, n_S);

    pmos    p3(Y1, D, n_S);
    nmos    n3(Y1, D, S);

endmodule
