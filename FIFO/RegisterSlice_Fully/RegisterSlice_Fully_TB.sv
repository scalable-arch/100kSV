`timescale  1ns/10ps

`define     ID_WIDTH                3
`define     ADDR_WIDTH              32
`define     DATA_WIDTH              32

`define     AXI_LEN                 {`ID_WIDTH+`ADDR_WIDTH+`DATA_WIDTH}



module  RegisterSlice_Fully_TB;

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

    logic            [`AXI_LEN-1:0]          in_AXI;
    wire             [`AXI_LEN-1:0]          out_AXI;

    logic                                   svalid;
    wire                                    sready;
    wire                                    dvalid;
    logic                                   dready;



    RegisterSlice_Fully    udt(.aclk(clk),.areset_n(rstn),
                   .prev_stage_data_i(in_AXI),.prev_stage_ready_o(sready),.prev_stage_valid_i(svalid),
                   .next_stage_data_o(out_AXI),.next_stage_ready_i(dready),.next_stage_valid_o(dvalid));

    initial begin
        svalid = 1'b0;
        dready = 1'b0;

        @(posedge rstn);

        dready = 1'b1;

        repeat(2) @(posedge clk);
        #0 svalid = 1'b1;

        repeat(3) @(posedge clk);
        #0 svalid = 1'b0;

        repeat(2) @(posedge clk);
        #0 svalid = 1'b1;

        repeat(2) @(posedge clk);
        #0 dready = 1'b0;

        repeat(2) @(posedge clk);
        #0 dready = 1'b1;
    end

    initial begin
        in_AXI = 'x;
        @(posedge rstn);

        repeat(2) @(posedge clk);
        #0 in_AXI = 1;
        repeat(1) @(posedge clk);
        #0 in_AXI = 2;
        repeat(1) @(posedge clk);
        #0 in_AXI = 3;

        repeat(1) @(posedge clk);
        #0 in_AXI = 'x;

        repeat(2) @(posedge clk);
        #0 in_AXI = 4;
        repeat(1) @(posedge clk);
        #0 in_AXI = 5;
        repeat(1) @(posedge clk);
        #0 in_AXI = 6;
        repeat(1) @(posedge clk);
        #0 in_AXI = 7;

        repeat(3) @(posedge clk);
        #0 in_AXI = 8;
        repeat(1) @(posedge clk);
        #0 in_AXI = 9;
    end

    // Time_out
    initial begin
        #TEST_TIMEOUT
        $display("Simulation timed out!");
        $fatal("Simulation timed out");
    end


endmodule