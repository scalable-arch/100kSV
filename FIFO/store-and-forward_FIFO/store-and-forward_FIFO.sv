module FIFO #(
    parameter       DEPTH_LG2           = 4,
    parameter       DATA_WIDTH          = 32,
    parameter       RST_MEM             = 0     // 0: do not apply reset to the memory
)
(
    input   wire                        clk,
    input   wire                        rst_n,

    output  wire                        full_o,
    input   wire                        wren_i,
    input   wire    [DATA_WIDTH-1:0]    wdata_i,

    output  wire                        empty_o,
    input   wire                        rden_i,
    output  wire    [DATA_WIDTH-1:0]    rdata_o
);

    wire                                full;
    wire                                empty;
    wire            [DATA_WIDTH-1:0]    rdata;
    wire                                error;
    wire                                eop;

    sf_FIFO #(
        .DEPTH_LG2           (DEPTH_LG2),
        .DATA_WIDTH          (DATA_WIDTH),
        .RST_MEM             (RST_MEM)     // 0: do not apply reset to the memory
    )
    sf_FIFO
    (
        .clk             (clk),
        .rst_n           (rst_n),

        .error           (error),

        .full_o          (full),
        .wren_i          (wren_i),
        .wdata_i         (wdata_i),

        .empty_o         (empty),
        .rden_i          (rden_i),
        .rdata_o         (rdata),

        .eop             (eop),
        .error           (error)
    );
   
   error_check error_check(
        .clk             (clk),
        .rst_n           (rst_n),
        
        .wdata_i         (wdata_i),
        .error_o         (error)
   );

    eop_check eop_check(
        .clk             (clk),
        .rst_n           (rst_n),
        
        .wdata_i         (wdata_i),
        .eop_o           (eop)
   );
 
    assign  full_o                      = full;
    assign  empty_o                     = empty;
    assign  rdata_o                     = rdata;

endmodule