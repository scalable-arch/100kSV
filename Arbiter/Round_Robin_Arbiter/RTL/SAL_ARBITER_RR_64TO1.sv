// Copyright (c) 2024 Sungkyunkwan University
// All rights reserved
// Author: Jungrae Kim <dale40@gmail.com>
// Description: Round-robin arbiter

module SAL_ARBITER_RR_64TO1
#(
    parameter   REQ_CNT                 = 64
  , parameter   REQ_CNT_LG2             = $clog2(REQ_CNT)
  , parameter	DATA_WIDTH	        = 12
)
(
    input   wire                        clk
  , input   wire                        rst_n

  , input   wire    [REQ_CNT-1:0]       req_arr_i
  , input   wire    [DATA_WIDTH-1:0]   	data_arr_i [0:REQ_CNT-1]
  , output  wire    [REQ_CNT-1:0]       gnt_arr_o

  , output  logic                       req_o
  , output  logic   [DATA_WIDTH-1:0]   	data_o 
  , input   wire                        gnt_i
);
    localparam	DEPTH1_REQ_CNT		= REQ_CNT >> 2; //16
    localparam	DEPTH0_REQ_CNT		= REQ_CNT >> 4; //4

    wire	[DEPTH1_REQ_CNT-1:0]	depth1_req_arr;
    wire	[DEPTH0_REQ_CNT-1:0]	depth0_req_arr;

    wire	[DATA_WIDTH-1:0]	depth1_data_arr [0:DEPTH1_REQ_CNT-1];
    wire	[DATA_WIDTH-1:0]	depth0_data_arr [0:DEPTH0_REQ_CNT-1];

    wire	[DEPTH1_REQ_CNT-1:0]	depth1_gnt_arr;
    wire	[DEPTH0_REQ_CNT-1:0]	depth0_gnt_arr;

    //------------------------------------------------------------------------------
    // DEPTH 0 | # of Arbiter = 1
    //------------------------------------------------------------------------------
    SAL_ARBITER_RR_4TO1
    #(
	.REQ_CNT                        (4)
      , .DATA_WIDTH			(DATA_WIDTH)
    ) 
    u_arbiter_depth0
    (
	.clk				(clk)
      , .rst_n				(rst_n)
      , .req_arr_i			(depth0_req_arr)
      , .data_arr_i			(depth0_data_arr)
      , .gnt_arr_o			(depth0_gnt_arr)
      , .req_o				(req_o)
      , .data_o				(data_o)
      , .gnt_i                          (gnt_i)
     );
	
    //------------------------------------------------------------------------------
    // DEPTH 1 | # of Arbiter = 4
    //------------------------------------------------------------------------------
    genvar j;
    generate
        for(j = 0; j < 4; j = j + 1) begin
            SAL_ARBITER_RR_4TO1 
            #(
                .REQ_CNT                (4)
              , .DATA_WIDTH		(DATA_WIDTH)
            ) 
            u_arbiter_depth1
            (
                .clk			(clk)
              , .rst_n			(rst_n)
              , .req_arr_i		(depth1_req_arr[(j*4)+:4])
              , .data_arr_i		(depth1_data_arr[(j*4)+:4])
              , .gnt_arr_o		(depth1_gnt_arr[(j*4)+:4])
              , .req_o			(depth0_req_arr[j])
              , .data_o			(depth0_data_arr[j])
              , .gnt_i                  (depth0_gnt_arr[j])
            );
        end
    endgenerate

    //------------------------------------------------------------------------------
    // DEPTH 2 | # of Arbiter = 16
    //------------------------------------------------------------------------------
    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin
            SAL_ARBITER_RR_4TO1 
            #(
                .REQ_CNT                (4)
              , .DATA_WIDTH		(DATA_WIDTH)
            ) 
            u_arbiter_depth2
            (
                .clk			(clk)
              , .rst_n			(rst_n)
              , .req_arr_i		(req_arr_i[(i*4)+:4])
              , .data_arr_i		(data_arr_i[(i*4)+:4])
              , .gnt_arr_o		(gnt_arr_o[(i*4)+:4])
              , .req_o			(depth1_req_arr[i])
              , .data_o			(depth1_data_arr[i])
              , .gnt_i                  (depth1_gnt_arr[i])
            );
        end
    endgenerate
endmodule
