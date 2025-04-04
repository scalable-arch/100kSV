// A testbench for a FIFO
`timescale 1ns/10ps

module FIFO_TB;

    localparam  CLK_PERIOD              = 10;
    localparam  FIFO_DEPTH_LG2          = 4;
    localparam  DATA_WIDTH              = 32;

    localparam  TEST_DATA_CNT           = 128;
    localparam  TEST_TIMEOUT            = 500000;

    //----------------------------------------------------------
    // Clock and reset generation
    //----------------------------------------------------------
    logic                               clk;
    logic                               rst_n;

    initial begin
        clk                             = 1'b0;
        forever
            #(CLK_PERIOD/2) clk             = ~clk;
    end

    initial begin
        rst_n                           = 1'b0;
        repeat (3) @(posedge clk);      // wait for 3 clocks
        rst_n                           = 1'b1;
    end

    //----------------------------------------------------------
    // Design-Under-Test (DUT)
    //----------------------------------------------------------
    wire                                full,   empty;
    logic                               wren,   rden;
    logic   [DATA_WIDTH-1:0]            wdata,  rdata;
    logic   [3:0]                       error_discard = 'd0;


    FIFO
    #(
        .DEPTH_LG2                      (FIFO_DEPTH_LG2),
        .DATA_WIDTH                     (DATA_WIDTH)
    )
    dut
    (
        .clk                            (clk),
        .rst_n                          (rst_n),

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
    logic   [DATA_WIDTH-1:0]            delete_mailbox;
    // Push driver
    initial begin
        wren                            = 1'b0;
        wdata                           = 'hX;
        @(posedge rst_n);   // wait for the reset release

        for (int i=0; i<TEST_DATA_CNT; i=i+1) begin
            @(posedge clk);
            #1
            wren                            = 1'b0;
            if (~full) begin
                if (($random()%3)==0) begin                           // push with 33% probability (write data(not last))
                    wren                            = 1'b1;
                    wdata                           = $urandom();
                    wdata[31:1]                     = $random() + 'd1;
                    if (($random()% 18)==0) begin                     //  push with 1/18 probaility (write last data)
                    wdata[31:1]                     = 'd0;
                    end
                    data_sb.put(wdata);
                    error_discard = error_discard + 'd1;

                    if (wdata[31:1] != 'd0) begin                    // for push log
                        $display($time, "ns, pushing %x", wdata);
                    end else if ((wdata[31:1] == 'd0) & wdata[0] == 'd1) begin
                        $display($time, "ns, pushing %x // last data(end packet) with error", wdata);
                        for (int i=0; i< error_discard; i++) begin
                            data_sb.get(delete_mailbox);
                            $display($time, "ns, remove  %x // Remove error packet", delete_mailbox);
                        end 
                        error_discard = 'd0;
                    end else if ((wdata[31:1] == 'd0) & wdata[0] == 'd0) begin
                        $display($time, "ns, pushing %x // last data(end packet) with no error", wdata);
                        error_discard = 'd0;
                    end
                end
            end
        end
        wren                            = 1'b0;
    end

    // Pop driver/monitor, not modified(same with simple FIFO)
    initial begin
        rden                            = 1'b0;
        @(posedge rst_n);   // wait for the reset release

        for (int i=0; i<TEST_DATA_CNT; i=i+1) begin
            @(posedge clk);
            #1
            rden                            = 1'b0;

            if (~empty) begin
                // step 1: check

                // peek the expected data from the scoreboard
                int                             peak_result;
                logic   [DATA_WIDTH-1:0]        expected_data;

                peak_result = data_sb.try_peek(expected_data);
                if (peak_result==0) begin
                    $fatal($time, "ns, the scoreboard is empty: %d", peak_result);
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

        repeat(10) @(posedge clk);
        $finish;
    end

    // Time-out
    initial begin
        #TEST_TIMEOUT
        $display("Simulation timed out!");
        $fatal("Simulation timed out");
    end

endmodule