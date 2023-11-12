module error_check #(
    DEPTH_LG2           = 4,
    DATA_WIDTH          = 32
)
(
    input   wire                        clk,
    input   wire                        rst_n,

    input   wire    [DATA_WIDTH-1:0]    wdata_i,

    output   wire                       error_o
);

    localparam  FIFO_DEPTH              = (1<<DEPTH_LG2);

    reg                                 error;

// ***********************************************************************
    always_comb begin
        if (wdata_i[0] == 1'd1) begin                 // write last data with no error
            error               = 1'd1;
        end else if (wdata_i[0] == 1'd0) begin
            error               = 1'd0;
        end 
    end

    assign  error_o = error;

endmodule