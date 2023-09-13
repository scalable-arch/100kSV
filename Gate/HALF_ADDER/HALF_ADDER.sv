// A gate-lvel model of half-adder
module HALF_ADDER(
        output  wire    S,
        output  wire    C,
        input   wire    A,
        input   wire    B
    );


    // Truth Table
    // A  B  S  C
    // 0  0  0  0
    // 0  1  1  0
    // 1  0  1  0
    // 1  1  0  1

    // S = AB' + BA' 
    // C = A & B 
    xor     u1(S, A, B);
    and     u2(C, A, B);


endmodule

