`timescale 1ns/10ps

module FIFO (
    input   wire clk,
    input   wire rst_n,

    output  wire full_o,
    input   wire wren_i,
    input   wire [31:0] wdata_i,

    output  wire empty_o,
    input   wire rden_i,
    output  wire [31:0] rdata_o
);

    localparam DEPTH_LG2 = 4;
    localparam DATA_WIDTH = 32;
    // 0: do not apply reset to the memory
    localparam RST_MEM = 0;
    localparam FIFO_DEPTH = (1<<DEPTH_LG2);

    reg [DATA_WIDTH-1:0] mem[FIFO_DEPTH];

    reg full, full_n,
        empty, empty_n;
    reg [DEPTH_LG2:0]  wrptr, wrptr_n, rdptr, rdptr_n;

    always_ff @(posedge clk)
        if (!rst_n & RST_MEM) begin
            for (int i=0; i<FIFO_DEPTH; i++) begin
                mem[i] <= {DATA_WIDTH{1'b0}};
            end
        end
        else begin
            if (wren_i) begin
                mem[wrptr[DEPTH_LG2-1:0]] <= wdata_i;
            end
        end

    always_ff @(posedge clk)
        if (!rst_n) begin
            full <= 1'b0;
            empty <= 1'b1;    // empty after as reset

            wrptr <= {(DEPTH_LG2+1){1'b0}};
            rdptr <= {(DEPTH_LG2+1){1'b0}};
            
        end else begin
            full <= full_n;
            empty <= empty_n;

            wrptr <= wrptr_n;
            rdptr <= rdptr_n;
        end

    always_comb begin
        wrptr_n = wrptr;
        rdptr_n = rdptr;

        if (wren_i) begin
            wrptr_n = wrptr + 'd1;
        end
        
        if (rden_i) begin
            rdptr_n = rdptr + 'd1;
        end

        empty_n = (wrptr_n == rdptr_n);
        full_n = (wrptr_n[DEPTH_LG2]!=rdptr_n[DEPTH_LG2]) & (wrptr_n[DEPTH_LG2-1:0]==rdptr_n[DEPTH_LG2-1:0]);

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

    assign  full_o = full;
    assign  empty_o = empty;
    assign  rdata_o = mem[rdptr[DEPTH_LG2-1:0]];

endmodule
