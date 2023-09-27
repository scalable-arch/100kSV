module SRAM_Based_FIFO #(
    parameter       DEPTH_LG2           = 4,
    parameter       DATA_WIDTH          = 32,
    parameter       RST_MEM             = 0     // 0: do not apply reset to the memory
)
(
    input   wire                        clk,
    input   wire                        rst_n,

    input   wire                        chip_select_i,

    output  wire                        full_o,
    input   wire                        wren_i,
    input   wire    [DATA_WIDTH-1:0]    wdata_i,

    output  wire                        empty_o,
    input   wire                        rden_i,
    output  wire    [DATA_WIDTH-1:0]    rdata_o
);

    localparam  FIFO_DEPTH              = (1<<DEPTH_LG2);


    reg                                 full,       full_n,
                                        empty,      empty_n;
    reg     [DEPTH_LG2:0]               wrptr,      wrptr_n,
                                        rdptr,      rdptr_n;


    

    SRAM #(.ADDRESS_DEPTH(DEPTH_LG2), .DATA_WIDTH(DATA_WIDTH), .DATA_DEPTH(FIFO_DEPTH), .RST_MEM(RST_MEM)) sram_memory 
    (
        .clk(clk), //clk
        .data_i(wdata_i), //write할 data
        .read_address_i(rdptr[DEPTH_LG2-1:0]), //read할 address
        .write_address_i(wrptr[DEPTH_LG2-1:0]), //write할 address
        .data_o(rdata_o), //read시 나오는 data
        .wren_i(wren_i), //wren
        .rden_i(rden_i), //rden
        .rst_n(rst_n), //reset
        .chip_select_i(chip_select_i) //해당 chip을 사용
    );


    always_ff @(posedge clk)
        if (chip_select_i) begin
            if (!rst_n) begin
                full                        <= 1'b0;
                empty                       <= 1'b1;    // empty after as reset

                wrptr                       <= {(DEPTH_LG2+1){1'b0}};
                rdptr                       <= {(DEPTH_LG2+1){1'b0}};
            end
            else begin
                full                        <= full_n;
                empty                       <= empty_n;

                wrptr                       <= wrptr_n;
                rdptr                       <= rdptr_n;
            end
            
        end

    always_comb begin
        wrptr_n                     = wrptr;
        rdptr_n                     = rdptr;
        if (chip_select_i) begin
            if (wren_i) begin
                wrptr_n                     = wrptr + 'd1;
            end

            if (rden_i) begin
                rdptr_n                     = rdptr + 'd1;
            end
        end
        empty_n                     = (wrptr_n == rdptr_n);
        full_n                      = (wrptr_n[DEPTH_LG2]!=rdptr_n[DEPTH_LG2])
                                     &(wrptr_n[DEPTH_LG2-1:0]==rdptr_n[DEPTH_LG2-1:0]);

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

endmodule

module SRAM #(
    parameter       ADDRESS_DEPTH       =   8,
    parameter       DATA_WIDTH          =   32,
    parameter       DATA_DEPTH          =   16,
    parameter       RST_MEM             =   0
)
(   
    input   wire                        clk,
    input   wire [DATA_WIDTH-1:0]       data_i,
    input   wire [ADDRESS_DEPTH-1:0]    read_address_i,
    input   wire [ADDRESS_DEPTH-1:0]    write_address_i,
    output  reg [DATA_WIDTH-1:0]        data_o,
    input   wire                        wren_i,
    input   wire                        rden_i,
    input   wire                        rst_n,
    input   wire                        chip_select_i
);

    reg [DATA_WIDTH-1:0] sram [DATA_DEPTH];
    localparam  FIFO_DEPTH              = (1<<ADDRESS_DEPTH);

    always_ff @ (posedge clk)
        if (chip_select_i) begin 
            if (!rst_n & RST_MEM)begin
                for (int i=0; i<FIFO_DEPTH; i++) begin
                    sram[i]                      <= {DATA_WIDTH{1'b0}};
                end
            end
            else begin
                if (wren_i == 1'b1)begin
                    sram [write_address_i] <= data_i;
                end
                if (rden_i == 1'b1)begin
                    data_o = sram [read_address_i];
                end
            end
        end

    


endmodule