// A transistor-level model of an inverter
module INV (
    output  wire                        Y,
    input   wire                        A
);

    supply1                             vdd;
    supply0                             gnd;

    // VDD      -------+----
    //              p1 |
    //           a --o|
    //                 |
    //                 +---- Y
    //              n1 |
    //           a ---|
    //                 |
    // GND      -------+----

    pmos    p1(Y, vdd, A);
    nmos    n1(Y, gnd, A);

endmodule
