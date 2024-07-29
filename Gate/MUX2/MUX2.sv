// A transistor-level model of a 2:1 MUX
module MUX2 (
    output wire     Y,
    input wire      D0,
    input wire      D1,
    input wire      S
);

    wire    S_bar;
    wire    w1, w2;

    //  Y = (S&D1) | (!S&D0)
    //    = !( !(S&D1) & !(!S&D0))
    not     u1(S_bar, S);

    nand    u2(w1, S, D1);
    nand    u3(w2, S_bar, D0);

    nand    u4(Y, w1, w2);

endmodule
