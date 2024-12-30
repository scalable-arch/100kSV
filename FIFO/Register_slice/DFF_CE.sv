
`timescale  1ns/10ps

module DFF_CE #(  
    parameter   payload_len              =   67 
)(
    input   wire                            clk,
    input   wire                            rstn, 
    input   wire        [1:0]               CE,
    input   wire        [payload_len-1:0]   D,
    output  reg         [payload_len-1:0]   Q
);

    always_ff @(posedge clk) begin
        if(!rstn)
            Q <= 'x;
        else if(CE[1])
            Q <=  D;
        else if(!CE[0])
            Q <= 'x;
    end
endmodule



