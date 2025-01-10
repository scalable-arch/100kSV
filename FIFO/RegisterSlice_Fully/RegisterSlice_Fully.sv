`timescale  1ns/10ps

//`define     ID_WIDTH                3
//`define     ADDR_WIDTH              32
`define     FIFO_DEPTH              2

//typedef struct packed{
//    logic     [`ID_WIDTH-1:0]          ID;
//    logic     [`ADDR_WIDTH-1:0]        ADDR;
//    logic     [DATA_WIDTH-1:0]        DATA;
//} AXI_SIG;

module RegisterSlice_Fully #(
    parameter DATA_WIDTH = 32
)(
    input   wire                    aclk,
    input   wire                    areset_n,

    //input signal
    input   [DATA_WIDTH-1:0]        prev_stage_data_i,
    output  wire                    prev_stage_ready_o,
    input   wire                    prev_stage_valid_i,

    //output signal
    output  [DATA_WIDTH-1:0]        next_stage_data_o,
    input   wire                    next_stage_ready_i,
    output  wire                    next_stage_valid_o

);


    localparam AXI_SIG_LEN = $bits(prev_stage_data_i);
    localparam FIFO_DEPTH_LG2 = $clog2(`FIFO_DEPTH);

    logic [AXI_SIG_LEN-1:0]   fifo  [0:`FIFO_DEPTH-1];
    logic [FIFO_DEPTH_LG2:0]  wr_ptr;
    logic [FIFO_DEPTH_LG2:0]  rd_ptr;
    wire                      wren;
    logic                     rden;
    logic                     full,   full_n,
                              empty,  empty_n;

    logic      [FIFO_DEPTH_LG2:0]      wr_ptr_n,  rd_ptr_n;

    // wren, rden
    assign wren = (prev_stage_valid_i && !full)  ? 1'b1 : 1'b0;
    assign rden = (!empty && next_stage_ready_i) ? 1'b1 : 1'b0;
    assign next_stage_valid_o = !empty;
    assign prev_stage_ready_o = !full;

    always_ff @(posedge aclk) begin
        if(!areset_n) begin
            full        <=      1'b0;
            empty       <=      1'b0;

            wr_ptr      <=      {(`FIFO_DEPTH+1){1'b0}};
            rd_ptr      <=      {(`FIFO_DEPTH+1){1'b0}};

            for(int i=0; i<`FIFO_DEPTH; i++) begin
                fifo[i] <=    {AXI_SIG_LEN{1'b0}};
            end
        end
        else begin
            full        <=      full_n;
            empty       <=      empty_n;

            wr_ptr      <=      wr_ptr_n;
            rd_ptr      <=      rd_ptr_n;

            if(wren) begin
                fifo[wr_ptr[FIFO_DEPTH_LG2-1:0]] <= prev_stage_data_i;
            end
        end
    end

    always_comb begin
        wr_ptr_n    =   wr_ptr;
        rd_ptr_n    =   rd_ptr;

        if(wren)
            wr_ptr_n     =   wr_ptr + 'd1;

        if(rden)
            rd_ptr_n     =   rd_ptr + 'd1;

        empty_n          =  (wr_ptr_n == rd_ptr_n);
        full_n           =  (wr_ptr_n[FIFO_DEPTH_LG2]!=rd_ptr_n[FIFO_DEPTH_LG2])
                            & (wr_ptr_n[FIFO_DEPTH_LG2-1:0]==rd_ptr_n[FIFO_DEPTH_LG2-1:0]);
    end

    //assign full_o = full;
    //assign empty_o = empty;

    assign next_stage_data_o = (next_stage_valid_o) ? fifo[rd_ptr[FIFO_DEPTH_LG2-1:0]] : 'x;



endmodule