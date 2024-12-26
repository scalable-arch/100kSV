// A testbench for an asynchronous FIFO
`timescale 1ns/10ps

module Async_FIFO_TB;

    localparam  WR_CLK_PERIOD           = 10;
    localparam  RD_CLK_PERIOD           = 15;
    localparam  FIFO_DEPTH_LG2          = 4;
    localparam  DATA_WIDTH              = 32;

    localparam  TEST_DATA_CNT           = 128;
    localparam  TEST_TIMEOUT            = 100000;

    //----------------------------------------------------------
    // Clock and reset generation
    //----------------------------------------------------------
    logic                               wrclk;
    logic                               rdclk;
    logic                               wrrst_n;
    logic                               rdrst_n;

    // NOTE : wrclk and rdclk have different clock periods
    initial begin
        wrclk                             = 1'b0;
        forever
            #(WR_CLK_PERIOD/2) wrclk          = ~wrclk;
    end

    initial begin
        wrrst_n                           = 1'b0;
        repeat (3) @(posedge wrclk);      // wait for 3 clocks
        wrrst_n                           = 1'b1;
    end

    initial begin
        rdclk                             = 1'b0;
        forever
            #(RD_CLK_PERIOD/2) rdclk          = ~rdclk;
    end

    initial begin
        rdrst_n                           = 1'b0;
        repeat (3) @(posedge rdclk);      // wait for 3 clocks
        rdrst_n                           = 1'b1;
    end

    //----------------------------------------------------------
    // Design-Under-Test (DUT)
    //----------------------------------------------------------
    wire                                full,   empty;
    logic                               wren,   rden;
    logic   [DATA_WIDTH-1:0]            wdata,  rdata;

    wire    [FIFO_DEPTH_LG2:0]          wrbptr,  wrgptr,
                                        rdbptr,  rdgptr;

    Async_FIFO
    #(
        .DEPTH_LG2                      (FIFO_DEPTH_LG2),
        .DATA_WIDTH                     (DATA_WIDTH)
    )
    dut
    (
        .wrclk                          (wrclk),
        .rdclk                          (rdclk),
        .wrrst_n                        (wrrst_n),
        .rdrst_n                        (rdrst_n),

        .full_o                         (full),
        .wren_i                         (wren),
        .wdata_i                        (wdata),

        .empty_o                        (empty),
        .rden_i                         (rden),
        .rdata_o                        (rdata)
    );

    //----------------------------------------------------------
    // Driver, Monitor, and Scoreboard
    //----------------------------------------------------------

    // A scoreboard to hold expected data
    mailbox                             data_sb = new();    // unlimited size

    // Push driver
    initial begin
        wren                            = 1'b0;
        wdata                           = 'hX;
        @(posedge wrrst_n);   // wait for the reset release

        for (int i=0; i<TEST_DATA_CNT; i=i+1) begin
            @(posedge wrclk);
            #1
            wren                            = 1'b0;
            if (~full) begin
                if (($random()%3)==0) begin     // push with 33% probability
                    wren                            = 1'b1;
                    wdata                           = $urandom();
                    data_sb.put(wdata);
                    $display($time, "ns, pushing %x", wdata);
                end
            end
        end
        wren                            = 1'b0;
    end

    // Pop driver/monitor
    initial begin
        rden                            = 1'b0;
        @(posedge rdrst_n);   // wait for the reset release

        for (int i=0; i<TEST_DATA_CNT; i=i+1) begin
            @(posedge rdclk);
            #1
            rden                            = 1'b0;

            if (~empty) begin
                // step 1: check

                // peek the expected data from the scoreboard
                int                             peek_result;
                logic   [DATA_WIDTH-1:0]        expected_data;

                peek_result = data_sb.try_peek(expected_data);
                if (peek_result==0) begin
                    $fatal($time, "ns, the scoreboard is empty: %d", peek_result);
                end

                // compare against the rdata
                if (expected_data===rdata) begin    // "===" instead of "==" to compare against Xs
                    $display($time, "ns, peeking matching data: %x", rdata);
                end
                else begin
                    $fatal($time, "ns, data mismatch: %x (exp) %x (DUT)", expected_data, rdata);
                end

                // step 2: pop the entry
                if (($random()%3)==0) begin         // pop with 33% probability
                    // pop from the DUT
                    rden                            = 1'b1;
                    // pop from the scoreboard -> discard
                    data_sb.get(expected_data);
                    $display($time, "ns, popping matching data: %x", rdata);
                end
            end
        end
        rden                            = 1'b0;

        repeat(10) @(posedge rdclk);
        $finish;
    end

    // Time-out
    initial begin
        #TEST_TIMEOUT
        $display("Simulation timed out!");
        $fatal("Simulation timed out");
    end

endmodule
