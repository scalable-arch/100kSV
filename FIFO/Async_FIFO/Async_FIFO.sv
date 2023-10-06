module Async_FIFO #(
    parameter       DEPTH_LG2           = 4,
    parameter       DATA_WIDTH          = 32,
    parameter       RST_MEM             = 0       // 0: do not apply reset to the memory
)
(
    input   wire                        wrclk,
    input   wire                        rdclk,
    input   wire                        wrrst_n,
    input   wire                        rdrst_n,

    // synchronized to wrclk
    output  wire                        full_o,   
    input   wire                        wren_i,
    input   wire    [DATA_WIDTH-1:0]    wdata_i,  

    // synchronized to rdclk
    output  wire                        empty_o, 
    input   wire                        rden_i,   
    output  wire    [DATA_WIDTH-1:0]    rdata_o
);

    localparam  FIFO_DEPTH              = (1<<DEPTH_LG2);  // 2^(DEPTH_LG2)

    reg     [DATA_WIDTH-1:0]            mem[FIFO_DEPTH];

    reg                                 full,       full_n,
                                        empty,      empty_n;

    reg     [DEPTH_LG2:0]               wrbptr,      wrbptr_n,
                                        rdbptr,      rdbptr_n;

    reg     [DEPTH_LG2:0]               wrgptr,      wrgptr_n,
                                        rdgptr,      rdgptr_n;
    reg     [DEPTH_LG2:0]               wrgptr1,      wrgptr2,
                                        rdgptr1,      rdgptr2;

    // Write or reset the memory
    always_ff @(posedge wrclk)
        if ((!wrrst_n) & RST_MEM) begin
            for (int i=0; i<FIFO_DEPTH; i++) begin
                mem[i]                      <= {DATA_WIDTH{1'b0}};  // reset
            end
        end
        else begin
            if (wren_i) begin
                mem[wrbptr[DEPTH_LG2-1:0]]   <= wdata_i;             // write
            end
        end

    // Change the value of write pointer
    always_ff @(posedge wrclk)
        if (!wrrst_n) begin
            wrbptr                       <= {(DEPTH_LG2+1){1'b0}};   // reset
            wrgptr                       <= {(DEPTH_LG2+1){1'b0}};   
        end
        else begin
            wrbptr                       <= wrbptr_n;
            wrgptr                       <= wrgptr_n;
        end

    // Change the value of read pointer
    always_ff @(posedge rdclk)
        if (!wrrst_n) begin
            rdbptr                       <= {(DEPTH_LG2+1){1'b0}};   // reset
            rdgptr                       <= {(DEPTH_LG2+1){1'b0}};
        end
        else begin
            rdbptr                       <= rdbptr_n;
            rdgptr                       <= rdgptr_n;
        end

    // Change the value of full flag
    always_ff @(posedge wrclk)
        if (!wrrst_n) begin
            full                        <= 1'b0;
        end
        else begin
            full                        <= full_n;
        end

    // Change the value of empty flag
    always_ff @(posedge rdclk)
        if (!rdrst_n) begin
            empty                       <= 1'b1;    // empty after reset
        end
        else begin
            empty                       <= empty_n;
        end

    // Synchronize write pointer to the read clock
    always_ff @(posedge rdclk)
        if (!rdrst_n) begin
            wrgptr1                      <= {(DEPTH_LG2+1){1'b0}};  // reset
            wrgptr2                      <= {(DEPTH_LG2+1){1'b0}};  // reset
        end
        else begin
            wrgptr1                      <= wrgptr;
            wrgptr2                      <= wrgptr1;
        end

    // Synchronize read pointer to the write clock
    always_ff @(posedge wrclk)
        if (!wrrst_n) begin
            rdgptr1                      <= {(DEPTH_LG2+1){1'b0}};  // reset
            rdgptr2                      <= {(DEPTH_LG2+1){1'b0}};  // reset
        end
        else begin
            rdgptr1                      <= rdgptr;
            rdgptr2                      <= rdgptr1;
        end

    // Set the next values for registers
    always_comb begin
        wrbptr_n                     = wrbptr;
        rdbptr_n                     = rdbptr;
        wrgptr_n                     = wrgptr;
        rdgptr_n                     = rdgptr;

        if (wren_i) begin
            wrbptr_n                     = wrbptr + 'd1;
            wrgptr_n                     = wrbptr_n ^ (wrbptr_n >> 1);  // gray-encoding
        end

        if (rden_i) begin
            rdbptr_n                     = rdbptr + 'd1;
            rdgptr_n                     = rdbptr_n ^ (rdbptr_n >> 1);  // gray-encoding
        end

        empty_n                     = (wrgptr2 == rdgptr_n);
        full_n                      = (wrgptr_n[DEPTH_LG2:DEPTH_LG2-1]==(~rdgptr2[DEPTH_LG2:DEPTH_LG2-1]))
                                     &(wrgptr_n[DEPTH_LG2-2:0]==rdgptr2[DEPTH_LG2-2:0]);
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

    assign  full_o                      = full;
    assign  empty_o                     = empty;
    assign  rdata_o                     = mem[rdbptr[DEPTH_LG2-1:0]];

endmodule
