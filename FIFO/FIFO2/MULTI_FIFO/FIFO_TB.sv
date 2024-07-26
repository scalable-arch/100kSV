// A testbench for a FIFO
`timescale 1ns/10ps

module FIFO_TB;

    localparam  CLK_PERIOD              = 10;
    localparam  FIFO_DEPTH_LG2          = 4;
    localparam  DATA_WIDTH              = 32;

    localparam  READER_NUM              = 2;

    localparam  TEST_DATA_CNT           = 128;
    localparam  TEST_TIMEOUT            = 100000;

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
    wire                                full,   empty[READER_NUM];
    logic                               wren;
    logic                               rden[READER_NUM];
    logic   [DATA_WIDTH-1:0]            wdata;
    logic   [DATA_WIDTH-1:0]            rdata[READER_NUM];

    FIFO
    #(
        .DEPTH_LG2                      (FIFO_DEPTH_LG2),
        .DATA_WIDTH                     (DATA_WIDTH),
        .READER_NUM                     (READER_NUM)
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
    mailbox                             data_sb[READER_NUM];    // unlimited size


    initial begin
        for (int i=0; i<READER_NUM; i++) begin
            data_sb[i]  =   new();
        end
    end

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
                if (($random()%3)==0) begin     // push with 33% probability
                    wren                            = 1'b1;
                    wdata                           = $urandom();
                    data_sb[0].put(wdata);  //reader 1
                    data_sb[1].put(wdata);  //reader 2
                    $display($time, "ns, pushing %x", wdata);
                end
            end
        end
        wren                            = 1'b0;
    end

    // Pop driver/monitor
    initial begin
        rden[0]                        = 'b0;
        rden[1]                        = 'b0;
        
        @(posedge rst_n);   // wait for the reset release

        for (int i=0; i<TEST_DATA_CNT; i=i+1) begin
            @(posedge clk);
            #1
            rden[0]                        = 'b0;
            rden[1]                        = 'b0;
           
            for (int i=0; i<READER_NUM; i++) begin 
                if (~empty[i]&~full) begin
                    // step 1: check
    
                    // peek the expected data from the scoreboard
                    int                             peak_result;
                    logic   [DATA_WIDTH-1:0]        expected_data[READER_NUM];

                    peak_result = data_sb[i].try_peek(expected_data[i]);
                    if (peak_result==0) begin
                        $fatal($time, "ns, the scoreboard is empty: %d", peak_result);
                    end


                    // compare against the rdata
                    if (expected_data[i]===rdata[i]) begin    // "===" instead of "==" to compare against Xs
                        $display($time, "ns, peeking matching data(reader %d): %x", i, rdata[i]);
                    end
                    else begin
                        $fatal($time, "ns, data mismatch(reader %d): %x (exp) %x (DUT)", i, expected_data[i], rdata[i]);
                    end


                    // step 2: pop the entry                
                    if (($random()%3)==0) begin         // pop with 33% probability
                        rden[i]         = 'b1;
                        // pop from the scoreboard -> discard
                        data_sb[i].get(expected_data[i]);
                        $display($time, "ns, popping matching data(reader %d): %x", i, rdata[i]);
                    end
                end
            end
        end
        rden[0]                        = 'b0;
        rden[1]                        = 'b0;

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
