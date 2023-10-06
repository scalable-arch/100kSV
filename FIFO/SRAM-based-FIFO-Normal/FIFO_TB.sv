// A testbench for a FIFO
`timescale 1ns/10ps

module FIFO_TB;

    localparam  CLK_PERIOD              = 10;
    localparam  FIFO_DEPTH_LG2          = 4;
    localparam  DATA_WIDTH              = 32;

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
    wire                                full,   empty;
    logic                               wren,   rden;
    logic   [DATA_WIDTH-1:0]            wdata,  rdata;
    logic   [DATA_WIDTH-1:0]            expected_data;
    logic     [DATA_WIDTH-1:0]            temp_rdata;

    SRAM_Based_FIFO
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
//        temp_rdata                      = rdata;
        @(posedge rst_n);   // wait for the reset release

        for (int i=0; i<TEST_DATA_CNT; i=i+1) begin
            @(posedge clk);
            #1
            rden                            = 1'b0;

            if (~empty) begin
                // step 1: check

                // peek the expected data from the scoreboard
                int                             peak_result;
            
                // step 2: pop the entry
                if (($random()%3)==0) begin         // pop with 33% probability
                    // pop from the DUT
                    rden                            = 1'b1;

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
    
    always @(posedge clk)begin
        
        if(temp_rdata !== rdata) begin
            //rdata가 변경되었을 경우
            data_sb.get(expected_data);

            //score board를 pop
            //expected data와 rdata 확인
                if (expected_data == rdata)begin

                    //expected data와 rdata가 같을 경우 matching
                    $display($time, "ns, matching!!!: %x (exp) %x (DUT)", expected_data, rdata);
                end
                else begin
                    // 다를 경우 fatal
                     $fatal($time, "ns, data mismatch: %x (exp) %x (DUT)", expected_data, rdata);
                end
            // 변경된 rdata를 temp_rdata에 할당
            temp_rdata <= rdata;
        
        end
        
    end
    
        

endmodule
