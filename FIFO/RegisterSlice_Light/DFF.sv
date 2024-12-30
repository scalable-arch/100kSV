`timescale  1ns/10ps


module DFF(
    input   wire                            clk,
    input   wire                            rstn, 
    input   wire                            D,
    output  reg                             Q
);

    always_ff@(posedge clk) begin
        if(!rstn)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule



