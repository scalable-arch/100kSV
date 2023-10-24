`timescale  1ns/10ps

`define     ID_WIDTH                3
`define     ADDR_WIDTH              32
`define     DATA_WIDTH              32

typedef struct packed{
    logic     [`ID_WIDTH-1:0]          ID;
    logic     [`ADDR_WIDTH-1:0]        ADDR;
    logic     [`DATA_WIDTH-1:0]        DATA;
} AXI_SIG;

module FIFO #(
    localparam FIFO_DEPTH = 2
)(
    input   wire          clk, 
    input   wire          rstn, 

    //source signal
    input   AXI_SIG       in_AXI,
    output  wire          sready,
    input   wire          svalid,

    //destination signal
    output  AXI_SIG       out_AXI,
    input   wire          dready,
    output  wire          dvalid

    


    //debuging sig
    //output  wire         full_o, 
    //output  wire         empty_o,
    //output  logic [1:0]  wr_ptr,
    //output  logic [1:0]  rd_ptr,
    //output  wire        wren,
    //output  wire        rden,
    //output  logic [66:0] fifo [0:FIFO_DEPTH-1]
);

    localparam AXI_SIG_LEN = $bits(in_AXI);
    localparam FIFO_DEPTH_LG2 = $clog2(FIFO_DEPTH);

    logic [AXI_SIG_LEN-1:0]   fifo  [0:FIFO_DEPTH-1];
    logic [FIFO_DEPTH_LG2:0]  wr_ptr;
    logic [FIFO_DEPTH_LG2:0]  rd_ptr;
    wire                      wren;
    logic                     rden;
    logic                     full,   full_n,   
                              empty,  empty_n;

    logic      [FIFO_DEPTH:0]      wr_ptr_n,  rd_ptr_n;

    // wren, rden
    assign wren = (svalid && !full)  ? 1'b1 : 1'b0;
    assign rden = (!empty && dready) ? 1'b1 : 1'b0; 
    assign dvalid = !empty;
    assign sready = !full; 

    always_ff @(posedge clk) begin
        if(!rstn) begin 
            full        <=      1'b0;
            empty       <=      1'b0;

            wr_ptr      <=      {(FIFO_DEPTH+1){1'b0}};
            rd_ptr      <=      {(FIFO_DEPTH+1){1'b0}};

            for(int i=0; i<FIFO_DEPTH; i++) begin
                fifo[i] <=    {AXI_SIG_LEN{1'b0}};
            end
        end
        else begin 
            full        <=      full_n;
            empty       <=      empty_n;

            wr_ptr      <=      wr_ptr_n;
            rd_ptr      <=      rd_ptr_n;

            if(wren) begin
                fifo[wr_ptr[FIFO_DEPTH_LG2-1:0]] <= in_AXI;
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

    assign out_AXI = (dvalid) ? fifo[rd_ptr[FIFO_DEPTH_LG2-1:0]] : 'x;

     

endmodule