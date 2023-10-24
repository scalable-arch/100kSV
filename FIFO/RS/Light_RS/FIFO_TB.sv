`timescale  1ns/10ps


`define     ID_WIDTH                3
`define     ADDR_WIDTH              32
`define     DATA_WIDTH              32
`define     TOTAL_WDITH             {`ID_WIDTH+`ADDR_WIDTH+`DATA_WIDTH}




module  FIFO_TB;

    localparam  CLK_PERIOD              = 10;

    localparam  TEST_DATA_CNT           = 16;
    localparam  TEST_TIMEOUT            = 10000;


    //----------------------------------------------------------
    // Clock and reset generation
    //----------------------------------------------------------

    logic                                 clk;
    logic                                 rstn;    
    
    initial begin
        clk                             =   1'b1;
        forever 
            #(CLK_PERIOD/2) clk         =   ~clk;
    end

    initial begin  
        rstn                            =   1'b0;
        repeat (3) @(posedge clk);  
        rstn                            =   1'b1;
    end

    //----------------------------------------------------------
    // Design-Under-Test (DUT)
    //----------------------------------------------------------

    logic   [`TOTAL_WDITH-1:0]             payload_in;
    wire    [`TOTAL_WDITH-1:0]             payload_out;
    
    logic                                   svalid;
    wire                                    sready;
    wire                                    dvalid; 
    logic                                   dready;
    wire     [1:0]                          CE;
    wire                                    ready,valid;
    wire    [2:0]                           state;

    //-----------------------------------------------------------------
    // ------------------- module instantiation -----------------------
    //-----------------------------------------------------------------

    FIFO    u_FIFO(.clk(clk),.rstn(rstn),.in_payload(payload_in),.sready(sready),.svalid(svalid),.out_payload(payload_out),.dready(dready),.dvalid(dvalid),.CE(CE),.ready(ready),.valid(valid),.state(state));
    

    initial begin
        svalid = 1'b0;
        dready = 1'b0;

        @(posedge rstn);

        dready = 1'b1;

        repeat(3) @(posedge clk);
        svalid = 1'b1;

        repeat(6) @(posedge clk);
        svalid = 1'b0;

        repeat(3) @(posedge clk);
        svalid = 1'b1;

        repeat(4) @(posedge clk);
        dready = 1'b0;

        repeat(3) @(posedge clk);
        dready = 1'b1;
    end


    initial begin
        payload_in = 'x;
        @(posedge rstn);
        
        repeat(3) @(posedge clk);
        #0 payload_in = 1;
        repeat(2) @(posedge clk);
        #0 payload_in = 2;
        repeat(2) @(posedge clk);
        #0 payload_in = 3;
        repeat(2) @(posedge clk);
        #0 payload_in = 'x;
        repeat(3) @(posedge clk);
        #0 payload_in = 4;
        repeat(2) @(posedge clk);
        #0 payload_in = 5;
        repeat(2) @(posedge clk);
        #0 payload_in = 6;
        repeat(5) @(posedge clk);
        #0 payload_in = 7;
        repeat(2) @(posedge clk);
        #0 payload_in = 8;
        repeat(2) @(posedge clk);
        #0 payload_in = 9;

    end



    // Time_out
    initial begin
        #TEST_TIMEOUT
        $display("Simulation timed out!");
        $fatal("Simulation timed out");
    end

endmodule