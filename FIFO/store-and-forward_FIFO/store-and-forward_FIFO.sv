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

    localparam  FIFO_DEPTH              = (1<<DEPTH_LG2);

    reg     [DATA_WIDTH-1:0]            mem[FIFO_DEPTH];

    reg                                 full,        full_n,
                                        empty,       empty_n;
    reg                                 empty_in, empty_in_n;

    reg     [DEPTH_LG2:0]               wrptr_tmp,   wrptr_tmp_n,
                                        wrptr_store, wrptr_store_n,
                                        rdptr,       rdptr_n;

    reg     [3:0]                       dataSize,    dataSize_n;
    reg     [3:0]                       wrSize,      wrSize_n;
    reg     [3:0]                       rdSize,      rdSize_n;

    always_ff @(posedge clk)
        if (!rst_n & RST_MEM) begin
            for (int i=0; i<FIFO_DEPTH; i++) begin
                mem[i]                      <= {DATA_WIDTH{1'b0}};
            end
        end
        else begin
            if (wren_i) begin
                mem[wrptr_tmp[DEPTH_LG2-1:0]]   <= wdata_i;
            end
        end

    always_ff @(posedge clk)
        if (!rst_n) begin
            full                        <= 1'b0;
            empty                       <= 1'b1;// empty after as reset
            empty_in                    <= 1'b1;

            wrptr_tmp                   <= {(DEPTH_LG2+1){1'b0}};
            wrptr_store                 <= {(DEPTH_LG2+1){1'b0}};
            rdptr                       <= {(DEPTH_LG2+1){1'b0}};

            dataSize                    <= {(DEPTH_LG2){1'b0}};
            wrSize                      <= {(DEPTH_LG2){1'b0}};
            rdSize                      <= {(DEPTH_LG2){1'b0}};
        end
        else begin
            full                        <= full_n;
            empty                       <= empty_n;
            empty_in                    <= empty_in_n;

            wrptr_tmp                   <= wrptr_tmp_n;
            wrptr_store                 <= wrptr_store_n;
            rdptr                       <= rdptr_n;

            dataSize                    <= dataSize_n;
            wrSize                      <= wrSize_n;
            rdSize                      <= rdSize_n;
        end

    always_comb begin
        wrptr_tmp_n                     = wrptr_tmp;
        wrptr_store_n                   = wrptr_store;
        rdptr_n                         = rdptr;

        dataSize_n                      = dataSize;
        wrSize_n                        = wrSize;
        rdSize_n                        = rdSize;
        empty_in_n                      = empty_in;

        if (wren_i & empty_in) begin                                                     // first 4B write (header(dataSize))
            wrptr_tmp_n                     = wrptr_tmp + 'd1;
            dataSize_n                      = wdata_i[31:28];
            empty_in_n                      = 'd0;
        end else if (wren_i & !empty_in) begin
            if ((wrSize == dataSize) & (wdata_i[31:24] == 'd0)) begin          // last 4B write and CRC no error
                wrptr_tmp_n                     = wrptr_tmp + 'd1;
                wrptr_store_n                   = wrptr_tmp + 'd1;
                //dataSize_n                      = 'd0;
                wrSize_n                        = 'd0; 
            end else if ((wrSize == dataSize) & (wdata_i[31:24] != 8'd0)) begin // last 4B write and CRC error
                wrptr_tmp_n                     = wrptr_store;
                //dataSize_n                      = 'd0;
                wrSize_n                        = 'd0;
                empty_in_n                      = 'd1;          
            end else begin                                                            // not first and not last write                                                             
                wrptr_tmp_n                     = wrptr_tmp + 'd1;
                wrSize_n                        = wrSize + 'd1;
            end
        end

        if (rden_i) begin
            rdptr_n                     = rdptr + 'd1;
            rdSize_n                     = rdSize + 'd1;
            if (rdSize == (dataSize + 'd1)) begin
                empty_in_n = 'd1;
                rdSize_n = 'd0;
            end
        end

        empty_n                     = !((wrptr_tmp_n == wrptr_store_n) & (wrptr_tmp_n != rdptr_n));
        full_n                      = ((wrptr_tmp_n[DEPTH_LG2]!=rdptr_n[DEPTH_LG2])
                                     &(wrptr_tmp_n[DEPTH_LG2-1:0]==rdptr_n[DEPTH_LG2-1:0]))
                                     |((wrptr_tmp_n == wrptr_store_n) & (wrptr_tmp_n != rdptr_n));
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
    assign  rdata_o                     = mem[rdptr[DEPTH_LG2-1:0]];

endmodule