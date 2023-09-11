// A transistor-level model of a 2:1 MUX
module MUX_2to1(
    output wire     Y,
    input wire      A,
    input wire      B,
    input wire      S
    );

    wire    n_S;
    supply1 vdd;
    supply0 gnd;

    // Inverting S for n_S
    pmos    p1(n_S, vdd, S);
    nmos    n1(n_S, gnd, S);

    // Transmission Gate Mux
    pmos    p2(Y, A, S);
    nmos    n2(Y, A, n_S);

    pmos    p3(Y, B, n_S);
    nmos    n3(Y, B, S);

endmodule
