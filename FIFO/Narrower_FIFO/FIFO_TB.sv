// A testbench for a FIFO
`timescale 1ns/10ps

module FIFO_TB;

    localparam  WRCLK_PERIOD            = 20;
    localparam  RDCLK_PERIOD            = 10;
    localparam  FIFO_DEPTH_LG2          = 4;
    localparam  WRDATA_WIDTH            = 32;
    localparam  RDDATA_WIDTH            = 16;

    localparam  TEST_DATA_CNT           = 128;
    localparam  TEST_TIMEOUT            = 100000;

    //----------------------------------------------------------
    // Clock and reset generation
    //----------------------------------------------------------
    logic                               wrclk, rdclk;
    logic                               rst_n;

    initial begin
        wrclk                           = 1'b0;
        forever
            #(WRCLK_PERIOD/2) wrclk     = ~wrclk;
    end

    initial begin
        rdclk                           = 1'b0;
        forever
            #(RDCLK_PERIOD/2) rdclk     = ~rdclk;
    end

    initial begin
        rst_n                           = 1'b0;
        repeat (3) @(posedge wrclk);      // wait for 3 clocks
        rst_n                           = 1'b1;
    end

    //----------------------------------------------------------
    // Design-Under-Test (DUT)
    //----------------------------------------------------------
    wire                                wrfull, wrempty;
    wire                                rdfull, rdempty;
    logic                               wren,   rden;
    logic   [WRDATA_WIDTH-1:0]          wdata;
    logic   [RDDATA_WIDTH-1:0]          rdata;
    logic   [RDDATA_WIDTH-1:0]          tmp;

    FIFO
    #(
        .DEPTH_LG2                      (FIFO_DEPTH_LG2),
        .WRDATA_WIDTH                   (WRDATA_WIDTH),
        .RDDATA_WIDTH                   (RDDATA_WIDTH)
    )
    dut
    (
        .rst_n                          (rst_n),
        
        .wrclk                          (wrclk),
        .wren_i                         (wren),
        .wdata_i                        (wdata),
        .wrempty_o                      (wrempty),
        .wrfull_o                       (wrfull),
        
        .rdclk                          (rdclk),
        .rden_i                         (rden),
        .rdata_o                        (rdata),
        .rdempty_o                      (rdempty),
        .rdfull_o                       (rdfull)
    );

    //----------------------------------------------------------
    // Driver, Monitor, and Scoreboard
    //----------------------------------------------------------

    // A scoreboard to hold expected data
    mailbox                             data_sb = new();    // unlimited size
    logic   [RDDATA_WIDTH-1:0]          expected_data;

    // Push driver
    initial begin
        wren                            = 1'b0;
        wdata                           = 32'hX;
        @(posedge rst_n);   // wait for the reset release

        for (int i=0; i<TEST_DATA_CNT; i=i+1) begin
            @(posedge wrclk);
            #1
            wren                            = 1'b0;
            if (~wrfull) begin
                if (($random()%3)==0) begin     // push with 33% probability
                    wren                            = 1'b1;
                    wdata                           = $urandom();
                    for (int i=0; i<WRDATA_WIDTH/RDDATA_WIDTH; i=i+1) begin
                        tmp = wdata>>(RDDATA_WIDTH*i);
                        data_sb.put(tmp);
                        $display($time, "ns, pushing %x", tmp);
                    end
                end
            end
        end
        wren                            = 1'b0;
    end

    // Pop driver/monitor
    initial begin
        rden                            = 1'b0;
        @(posedge rst_n);   // wait for the reset release

        for (int i=0; i<TEST_DATA_CNT; i=i+1) begin
            @(posedge rdclk);
            #1

            // compare against the rdata
            if (rden) begin
                if (expected_data===rdata) begin    // "===" instead of "==" to compare against Xs
                    $display($time, "ns, peeking matching data: %x", rdata);
                end
                else begin
                    $fatal($time, "ns, data mismatch: %x (exp) %x (DUT)", expected_data, rdata);
                end
            end

            rden                            = 1'b0;

            if (~rdempty) begin
                // step 1: check

                // peek the expected data from the scoreboard
                int                             peak_result;

                peak_result = data_sb.try_peek(expected_data);
                if (peak_result==0) begin
                    $fatal($time, "ns, the scoreboard is empty: %d", peak_result);
                end

                // step 2: pop the entry
                if (($random()%3)==0) begin         // pop with 33% probability
                    // pop from the DUT
                    rden                            = 1'b1;
                    // pop from the scoreboard -> discard
                    data_sb.get(expected_data);
                    $display($time, "ns, popping expected data: %x", expected_data);
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
