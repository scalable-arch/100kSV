module FIFO #(
    parameter       DEPTH_LG2           = 4,
    parameter       DATA_WIDTH          = 32,
    parameter       ALMOST_FULL_LEVEL   = 14,  // For example, 2 entries from being full
    parameter       ALMOST_EMPTY_LEVEL  = 2     // For example, 2 entries
)
(
    input   wire                        clk,
    input   wire                        rst_n,

    output  wire                        full_o,
    output  wire                        almost_full_o,
    input   wire                        wren_i,
    input   wire    [DATA_WIDTH-1:0]    wdata_i,

    output  wire                        empty_o,
    output  wire                        almost_empty_o,
    input   wire                        rden_i,
    output  wire    [DATA_WIDTH-1:0]    rdata_o
);

    localparam  FIFO_DEPTH              = (1<<DEPTH_LG2);

    reg     [DATA_WIDTH-1:0]            mem[FIFO_DEPTH];
    reg                                 full,   full_n,
                                        empty,  empty_n,
                                        almost_full, almost_full_n,
                                        almost_empty, almost_empty_n;
    reg     [DEPTH_LG2:0]               wrptr,  wrptr_n,
                                        rdptr,  rdptr_n;

    reg     [DEPTH_LG2:0]               counter,    counter_n;

    always_ff @(posedge clk)
        if (!rst_n) begin
            for (int i=0; i<FIFO_DEPTH; i++) begin
                mem[i]                      <= {DATA_WIDTH{1'b0}};
            end
        end
        else begin
            if (wren_i) begin
                mem[wrptr[DEPTH_LG2-1:0]]   <= wdata_i;
            end
        end

    always_ff @(posedge clk)
        if (!rst_n) begin
            full                        <= 1'b0;
            empty                       <= 1'b1;    // empty after as reset

            wrptr                       <= {(DEPTH_LG2+1){1'b0}};
            rdptr                       <= {(DEPTH_LG2+1){1'b0}};

            counter                     <= {(DEPTH_LG2+1){1'b0}};

            almost_full                 <= 1'b0;
            almost_empty                <= 1'b1;
        end
        else begin
            full                        <= full_n;
            empty                       <= empty_n;

            wrptr                       <= wrptr_n;
            rdptr                       <= rdptr_n;

            counter                     <= counter_n;

            almost_full                 <= almost_full_n;
            almost_empty                <= almost_empty_n;
        end

    always_comb begin
        wrptr_n                     = wrptr;
        rdptr_n                     = rdptr;
        counter_n                   = counter;

        if (wren_i & ~full) begin
            wrptr_n                 = wrptr + 'd1;
            counter_n               = counter_n + 'b1;
        end

        if (rden_i & ~empty) begin
            rdptr_n                 = rdptr + 'd1;
            counter_n               = counter_n - 'b1;
        end

        empty_n                     = (wrptr_n == rdptr_n);
        full_n                      = (wrptr_n[DEPTH_LG2]!=rdptr_n[DEPTH_LG2])
                                     &(wrptr_n[DEPTH_LG2-1:0]==rdptr_n[DEPTH_LG2-1:0]);

        almost_full_n               = (counter_n >= ALMOST_FULL_LEVEL);
        almost_empty_n              = (counter_n <= ALMOST_EMPTY_LEVEL);
    end

    // synthesis translate_off
    always @(posedge clk) begin
        if (full_o & wren_i) begin
            $display("FIFO overflow");
            @(posedge clk);
            $finish;
        end
    end

    always @(posedge clk) begin
        if (empty_o & rden_i) begin
            $display("FIFO underflow");
            @(posedge clk);
            $finish;
        end
    end
    // synthesis translate_on

    assign  full_o                      = full;
    assign  empty_o                     = empty;
    assign  almost_full_o               = almost_full;
    assign  almost_empty_o              = almost_empty;
    assign  rdata_o                     = mem[rdptr[DEPTH_LG2-1:0]];

endmodule
