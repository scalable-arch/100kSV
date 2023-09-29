module FIFO #(
    parameter       DEPTH_LG2           = 4,
    parameter       WRDATA_WIDTH        = 32,
    parameter       RDDATA_WIDTH        = 16,
    parameter       RST_MEM             = 0     // 0: do not apply reset to the memory
)
(
    input   wire                        rst_n,

    input   wire                        wrclk,
    input   wire                        wren_i,
    input   wire    [WRDATA_WIDTH-1:0]  wdata_i,
    output  wire                        wrempty_o,
    output  wire                        wrfull_o,

    input   wire                        rdclk,
    input   wire                        rden_i,
    output  wire    [RDDATA_WIDTH-1:0]  rdata_o,
    output  wire                        rdempty_o,
    output  wire                        rdfull_o
);

    localparam  FIFO_DEPTH              = (1<<DEPTH_LG2);
    localparam  WIDTH_RATIO             = WRDATA_WIDTH/RDDATA_WIDTH;
    localparam  RATIO_LG2               = $clog2(WIDTH_RATIO);

    reg     [WRDATA_WIDTH-1:0]          mem[FIFO_DEPTH];

    reg     [DEPTH_LG2:0]               wrptr,      wrptr_n;
    reg                                 wrempty,    wrempty_n,
                                        wrfull,     wrfull_n;
    
    reg     [RDDATA_WIDTH-1:0]          rdata,      rdata_n;
    reg     [DEPTH_LG2+RATIO_LG2:0]     rdptr,      rdptr_n;
    reg                                 rdempty,    rdempty_n,
                                        rdfull,     rdfull_n;

    always_ff @(posedge wrclk)
        if (!rst_n & RST_MEM) begin
            for (int i=0; i<FIFO_DEPTH; i++) begin
                mem[i]                      <= {WRDATA_WIDTH{1'b0}};
            end
        end
        else begin
            if (wren_i) begin
                mem[wrptr[DEPTH_LG2-1:0]]   <= wdata_i;
            end
        end

    always_ff @(posedge wrclk)
        if (!rst_n) begin
            wrptr                       <= 'b0;
            wrempty                     <= 1'b1;    // empty after as reset
            wrfull                      <= 1'b0;
        end
        else begin
            wrptr                       <= wrptr_n;
            wrempty                     <= wrempty_n;
            wrfull                      <= wrfull_n;
        end

    always_ff @(posedge rdclk)
        if (!rst_n) begin
            rdptr                       <= 'b0;
            rdempty                     <= 1'b1;    // empty after as reset
            rdfull                      <= 1'b0;
        end
        else begin
            rdata                       <= rdata_n;
            rdptr                       <= rdptr_n;
            rdempty                     <= rdempty_n;
            rdfull                      <= rdfull_n;
        end

    always_comb begin
        wrptr_n                         = wrptr;

        rdata_n                         = rdata;
        rdptr_n                         = rdptr;

        if (wren_i) begin
            wrptr_n                     = wrptr + 'd1;
        end

        if (rden_i) begin
            case (WIDTH_RATIO)
                1 : rdata_n             = mem[rdptr[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]][WRDATA_WIDTH-1:0];
                2 : case(rdptr[0])
                        'd0 : rdata_n   = mem[rdptr[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]][WRDATA_WIDTH/2-1:0];
                        'd1 : rdata_n   = mem[rdptr[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]][WRDATA_WIDTH-1:WRDATA_WIDTH/2];
                    endcase
                4 : case(rdptr[1:0])
                        'd0 : rdata_n   = mem[rdptr[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]][1*WRDATA_WIDTH/4-1:0];
                        'd1 : rdata_n   = mem[rdptr[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]][2*WRDATA_WIDTH/4-1:1*WRDATA_WIDTH/4];
                        'd2 : rdata_n   = mem[rdptr[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]][3*WRDATA_WIDTH/4-1:2*WRDATA_WIDTH/4];
                        'd3 : rdata_n   = mem[rdptr[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]][WRDATA_WIDTH-1:3*WRDATA_WIDTH/4];
                    endcase
            endcase
            rdptr_n                     = rdptr + 'd1;
        end

        if (!rden_i) begin
            wrempty_n                       = (wrptr_n == (rdptr_n>>RATIO_LG2));
            wrfull_n                        = (wrptr_n[DEPTH_LG2]!=rdptr_n[DEPTH_LG2+RATIO_LG2])
                                                    &(wrptr_n[DEPTH_LG2-1:0]==rdptr_n[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]);
        end
        if (!wren_i) begin
            rdempty_n                       = (wrptr_n == (rdptr_n>>RATIO_LG2));
            rdfull_n                        = (wrptr_n[DEPTH_LG2]!=rdptr_n[DEPTH_LG2+RATIO_LG2])
                                            &(wrptr_n[DEPTH_LG2-1:0]==rdptr_n[DEPTH_LG2-1+RATIO_LG2:RATIO_LG2]);
        end
    end

    // synthesis translate_off
    always @(posedge wrclk) begin
        if (wrfull_o & wren_i) begin
            $display("FIFO overflow");
            @(posedge wrclk);
            $finish;
        end
    end

    always @(posedge rdclk) begin
        if (rdempty_o & rden_i) begin
            $display("FIFO underflow");
            @(posedge rdclk);
            $finish;
        end
    end
    // synthesis translate_on

    assign  wrempty_o                   = wrempty;
    assign  wrfull_o                    = wrfull;

    assign  rdata_o                     = rdata;
    assign  rdempty_o                   = rdempty;
    assign  rdfull_o                    = rdfull;

endmodule
