module FIFO_ARRAY #(
    parameter   N_CH        =   4,
    parameter   DEPTH_LG2   =   4,
    parameter   DATA_WIDTH  =   32,
    parameter   RST_MEM     =   0
)
(
    input   wire        clk,
    input   wire        rst_n,

    input   wire    [$clog2(N_CH) - 1:0]    ch_id,

    output  wire                            full_o,
    input   wire                            wren_i,
    input   wire    [DATA_WIDTH-1:0]        wdata_i,
    
    output  wire                            empty_o,
    input   wire                            rden_i,
    output  wire    [DATA_WIDTH-1:0]        rdata_o

);

    wire                        full_vec[N_CH];
    wire                        empty_vec[N_CH];
    wire    [DATA_WIDTH-1:0]    rdata_vec[N_CH];

    genvar ch;
    generate
        for (ch=0; ch<N_CH; ch++) begin: channel
            FIFO #(
                .DEPTH_LG2   (DEPTH_LG2),
                .DATA_WIDTH   (DATA_WIDTH),
                .RST_MEM      (RST_MEM)
                )
            u_fifo(
                .clk        (clk),
                .rst_n      (rst_n),

                .full_o     (full_vec[ch]),
                .wren_i     (wren_i & (ch_id == ch)),
                .wdata_i    (wdata_i),

                .empty_o    (empty_vec[ch]),
                .rden_i     (rden_i & (ch_id == ch)),
                .rdata_o    (rdata_vec[ch])
            );
        end
    endgenerate


    assign  full_o  =   full_vec[ch_id];
    assign  empty_o =   empty_vec[ch_id];
    assign  rdata_o =   rdata_vec[ch_id];
    
endmodule

