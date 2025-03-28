// A gate-lvel model of full-adder
module FULL_ADDER(
        output  wire    S,
        output  wire    Cout,
        input   wire    A,
        input   wire    B,
        input  wire    Cin
    );


    wire    w1, w2, w3;

    // Truth Table
    // A  B  Cin   S  Cout
    // 0  0   0    0   0
    // 0  0   1    1   0
    // 0  1   0    1   0 
    // 0  1   1    0   1
    // 1  0   0    1   0
    // 1  0   1    0   1
    // 1  1   0    0   1
    // 1  1   1    1   1

    // Cout = A'BCin + AB'Cin + ABCin' + ABCin
    //      = Cin(A'B + AB') + AB
    //      = Cin(A xor B) + AB = !(!(Cin(A xor B)&!(AB))
    xor     u1(w1, A, B);
    nand    u2(w2, Cin, w1);
    nand    u3(w3, A, B);
    nand    u4(Cout, w2, w3);

    // S = A xor B xor C 
    xor     u5(S, w1, Cin);


endmodule

