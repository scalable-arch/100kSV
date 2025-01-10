// Copyright (c) 2024 Sungkyunkwan University
// All rights reserved
// Author: Jungrae Kim <dale40@gmail.com>
// Description: Round-robin arbiter

module SAL_ARBITER_RR_4TO1
#(
    parameter   REQ_CNT                 = 4
  , parameter   REQ_CNT_LG2             = $clog2(REQ_CNT)
  , parameter   DATA_WIDTH              = 64
)
(
    input   wire                        clk
  , input   wire                        rst_n

  , input   wire    [REQ_CNT-1:0]       req_arr_i
  , input   wire    [DATA_WIDTH-1:0]    data_arr_i [0:REQ_CNT-1]
  , output  logic   [REQ_CNT-1:0]       gnt_arr_o

  , output  logic                       req_o
  , output  logic   [DATA_WIDTH-1:0]    data_o   
  , input   wire                        gnt_i
);

    logic   [REQ_CNT_LG2-1:0]           prev_winner, prev_winner_n;
    logic   [REQ_CNT-1:0]               shift_valid;
    logic   [REQ_CNT-1:0]               shift_ready;
    logic   [REQ_CNT-1:0]               gnt_arr;

    assign  req_arr_dup                 = {req_arr_i, req_arr_i};

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            prev_winner                 <= 'd3;
        end else begin
            prev_winner                 <= prev_winner_n;
        end
    end

    always_comb begin
        prev_winner_n                   = prev_winner;
        req_o                           = 'd0;
        data_o                          = 'd0;
        gnt_arr_o                       = 'h0;

        if (req_arr_i[0] & gnt_arr[0]) begin
            req_o                       = req_arr_i[0];
            data_o                      = data_arr_i[0];
            if(gnt_i) begin
                prev_winner_n           = 2'd0;
                gnt_arr_o[0]            = 1'b1;
            end
        end else if (req_arr_i[1] & gnt_arr[1]) begin
            req_o                       = req_arr_i[1];
            data_o                      = data_arr_i[1];
            if(gnt_i) begin
                prev_winner_n           = 2'd1;
                gnt_arr_o[1]            = 1'b1;
            end
        end else if (req_arr_i[2] & gnt_arr[2]) begin
            req_o                       = req_arr_i[2];
            data_o                      = data_arr_i[2];
            if(gnt_i) begin
                prev_winner_n           = 2'd2;
                gnt_arr_o[2]            = 1'b1;
            end
        end else if (req_arr_i[3] & gnt_arr[3]) begin
            req_o                       = req_arr_i[3];
            data_o                      = data_arr_i[3];
            if(gnt_i) begin
                prev_winner_n           = 2'd3;
                gnt_arr_o[3]            = 1'b1;
            end
        end
    end

    always_comb begin
        case(prev_winner)
            'd3: begin
                shift_valid             = {req_arr_i[3], req_arr_i[2], req_arr_i[1], req_arr_i[0]};
                gnt_arr                 = {shift_ready[3], shift_ready[2], shift_ready[1], shift_ready[0]};
            end
            'd0: begin
                shift_valid             = {req_arr_i[0], req_arr_i[3], req_arr_i[2], req_arr_i[1]};
                gnt_arr                 = {shift_ready[2], shift_ready[1], shift_ready[0], shift_ready[3]};
            end
            'd1: begin
                shift_valid             = {req_arr_i[1], req_arr_i[0], req_arr_i[3], req_arr_i[2]};
                gnt_arr                 = {shift_ready[1], shift_ready[0], shift_ready[3], shift_ready[2]};
            end
            'd2: begin
                shift_valid             = {req_arr_i[2], req_arr_i[1], req_arr_i[0], req_arr_i[3]};
                gnt_arr                 = {shift_ready[0], shift_ready[3], shift_ready[2], shift_ready[1]};
            end
        endcase
    end

    always_comb begin
        shift_ready                     = {REQ_CNT{1'b0}};
        for(int i = 0; i < REQ_CNT; i++) begin
            if(shift_valid[i]) begin
                shift_ready[i]          = 1'b1;
                break;
            end
        end
    end
endmodule
