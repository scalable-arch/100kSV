module FIFO #(
    parameter       DEPTH_LG2           = 4,
    parameter       DATA_WIDTH          = 32,
    parameter       RST_MEM             = 0,    // 0: do not apply reset to the memory
    parameter       READER_NUM          = 2
)
(
    input   wire                        clk,
    input   wire                        rst_n,

    output  wire                        full_o,
    input   wire                        wren_i,
    input   wire    [DATA_WIDTH-1:0]    wdata_i,

    output  wire                        empty_o[READER_NUM],
    input   wire                        rden_i[READER_NUM],
    output  wire    [DATA_WIDTH-1:0]    rdata_o[READER_NUM]
);

    localparam  FIFO_DEPTH              = (1<<DEPTH_LG2);

    reg     [DATA_WIDTH-1:0]            mem[FIFO_DEPTH];

    reg                                 full,       full_n,
                                        empty[READER_NUM],
                                        empty_n[READER_NUM];
    reg     [DEPTH_LG2:0]               wrptr,      wrptr_n,
                                        rdptr[READER_NUM],
                                        rdptr_n[READER_NUM];


    always_ff @(posedge clk)
        if (!rst_n & RST_MEM) begin
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
            for (int i=0; i<READER_NUM; i++) begin
                empty[i]                       <= 1'b1;    // empty after as reset
            end            

            wrptr                       <= {(DEPTH_LG2+1){1'b0}};
            for (int i=0; i<READER_NUM; i++) begin
                rdptr[i]                       <= {(DEPTH_LG2+1){1'b0}};
            end            

        end
        else begin
            full                        <= full_n;
            for (int i=0; i<READER_NUM; i++) begin
                empty[i]                       <= empty_n[i];    // empty after as reset
            end  

            wrptr                       <= wrptr_n;
            for (int i=0; i<READER_NUM; i++) begin
                rdptr[i]                       <= rdptr_n[i];
            end 
        end

    always_comb begin
        wrptr_n                     = wrptr;
        for (int i=0; i<READER_NUM; i++) begin
            rdptr_n[i]                = rdptr[i];
        end 

        if (wren_i) begin
            wrptr_n                     = wrptr + 'd1;
        end

        for (int i=0; i<READER_NUM; i++) begin
            if (rden_i[i]) begin
                rdptr_n[i]                     = rdptr[i] + 'd1;
            end
        end


        for (int i=0; i<READER_NUM; i++) begin
            empty_n[i]                     = (wrptr_n == rdptr_n[i]);
        end  
        full_n                      = ((wrptr_n[DEPTH_LG2]!=rdptr_n[0][DEPTH_LG2])
                                     &(wrptr_n[DEPTH_LG2-1:0]==rdptr_n[0][DEPTH_LG2-1:0]))||
                                     ((wrptr_n[DEPTH_LG2]!=rdptr_n[1][DEPTH_LG2])
                                     &(wrptr_n[DEPTH_LG2-1:0]==rdptr_n[1][DEPTH_LG2-1:0]));

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
        for (int i=0; i<READER_NUM; i++) begin
            if (empty_o[i] & rden_i[i]) begin
                $display("FIFO underflow(reader %d)", i);
                @(posedge clk);
                $finish;
            end
        end
    end
    // synthesis translate_on

    assign  full_o                      = full;
    assign  empty_o[0]                     = empty[0];
    assign  empty_o[1]                     = empty[1];
    assign  rdata_o[0]                     = mem[rdptr[0][DEPTH_LG2-1:0]];
    assign  rdata_o[1]                     = mem[rdptr[1][DEPTH_LG2-1:0]];


endmodule
