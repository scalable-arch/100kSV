module eop_check #(
    DEPTH_LG2           = 4,
    DATA_WIDTH          = 32
)
(
    input   wire                        clk,
    input   wire                        rst_n,

    input   wire    [DATA_WIDTH-1:0]    wdata_i,

    output   wire                       eop_o
);

    reg                                 eop;

// ***********************************************************************
    always_comb begin
        if (wdata_i[31:1] == 31'd0) begin                 // write last data with no error
            eop               = 1'd1;
        end else if (wdata_i[31:1] != 31'd0) begin
            eop               = 1'd0;
        end 
    end
    
    assign  eop_o = eop;

endmodule