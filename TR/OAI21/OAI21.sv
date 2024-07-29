// 2-1 OR-AND-Inverter
// operation: (A & (B | C)'
module OAI21 (
    output      wire Y,
    input       wire A,
    input       wire B,
    input       wire C
);

    wire        w1, w2;
    supply1     vdd;
    supply0     gnd;

    // VDD      -------+-----------+----------
    //              p3 |           | p1
    //           a --o|             |o-- b
    //                 |        w2 | p2
    //                 |            |o-- c
    //                 |           |
    //                 +-----------+--------- Y
    //              n2 |           | n3
    //           b ---|             |--- c
    //                 | w1     w1 | 
    //                 +-----+-----+
    //                    n1 |
    //                 a ---|       
    //                       |
    // GND      -------------+---------------


    pmos    p1(w2, vdd, B);
    pmos    p2(Y, w2, C);
    pmos    p3(Y, vdd, A);

    nmos    n1(w1, gnd, A);
    nmos    n2(Y, w1, B);
    nmos    n3(Y, w1, C);

endmodule
