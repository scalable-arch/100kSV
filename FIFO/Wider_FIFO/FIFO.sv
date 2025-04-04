module FIFO #(
    parameter       DEPTH_LG2           = 4,
    parameter       WRDATA_WIDTH        = 16,
    parameter       RDDATA_WIDTH        = 32,
    parameter       RST_MEM             = 0     // 0: do not apply reset to the memory
)
(
    input   wire                        rst_n,

    input   wire                        wrclk,
    input   wire                        wren_i,
    input   wire    [WRDATA_WIDTH-1:0]  wdata_i,
    output  wire                        full_o,

    input   wire                        rdclk,
    input   wire                        rden_i,
    output  wire    [RDDATA_WIDTH-1:0]  rdata_o,
    output  wire                        empty_o
);

    localparam  FIFO_DEPTH              = (1<<DEPTH_LG2);
    localparam  WIDTH_RATIO             = RDDATA_WIDTH/WRDATA_WIDTH;
    localparam  RATIO_LG2               = $clog2(WIDTH_RATIO);

    reg     [RDDATA_WIDTH-1:0]          mem[0:FIFO_DEPTH-1];

    reg     [(DEPTH_LG2+RATIO_LG2):0]   wrptr,      wrptr_n;
    reg                                 full,       full_n;

    reg     [RDDATA_WIDTH-1:0]          rdata,      rdata_n;
    reg     [DEPTH_LG2:0]               rdptr,      rdptr_n;
    reg                                 empty,      empty_n;

    always_ff @(posedge wrclk)
        if (!rst_n & RST_MEM) begin
            for (int i=0; i<FIFO_DEPTH; i++) begin
                mem[i]                      <= {RDDATA_WIDTH{1'b0}};
            end
        end
        else begin
            if (wren_i) begin
                mem[wrptr[DEPTH_LG2+RATIO_LG2-1:RATIO_LG2]][WRDATA_WIDTH * wrptr[RATIO_LG2-1] +: WRDATA_WIDTH] <= wdata_i;
            end
        end

    always_ff @(posedge wrclk)
        if (!rst_n) begin
            wrptr                       <= {(DEPTH_LG2+RATIO_LG2){1'b0}};
            full                        <= 1'b0;
        end
        else begin
            wrptr                       <= wrptr_n;
            full                        <= full_n;
        end
    
    always_ff @(posedge rdclk)
        if (!rst_n) begin
            rdptr                       <= {(DEPTH_LG2){1'b0}};
            empty                       <= 1'b1;    // empty after as reset
            rdata                       <= rdata_n;
        end
        else begin
            rdptr                       <= rdptr_n;
            empty                       <= empty_n;
            rdata                       <= rdata_n;
        end

    always_comb begin
        wrptr_n                         = wrptr;
        rdptr_n                         = rdptr;

        if (wren_i) begin
            wrptr_n                     = wrptr + 'd1;
        end

        if (rden_i) begin
            rdata_n                     = mem[rdptr[DEPTH_LG2-1:0]];
            rdptr_n                     = rdptr + 'd1;
        end

        if (!rden_i) begin
            full_n                      = (wrptr_n[DEPTH_LG2+RATIO_LG2]!=rdptr_n[DEPTH_LG2])
                                          &(wrptr_n[DEPTH_LG2+RATIO_LG2-1:RATIO_LG2] == rdptr_n[DEPTH_LG2-1:0]);
        end

        if (!wren_i) begin
            empty_n                     = ((wrptr_n >> RATIO_LG2) == rdptr_n);
        end
    end

    // synthesis translate_off
    always @(posedge wrclk) begin
        if (full_o & wren_i) begin
            $display("FIFO overflow");
            @(posedge wrclk);
            $finish;
        end
    end

    always @(posedge rdclk) begin
        if (empty_o & rden_i) begin
            $display("FIFO underflow");
            @(posedge rdclk);
            $finish;
        end
    end
    // synthesis translate_on
    
    assign  empty_o                     = empty;
    assign  full_o                      = full;

    assign  rdata_o                     = rdata;

endmodule
