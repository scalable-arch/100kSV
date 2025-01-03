`timescale 1ns / 1ps

module RRArbiter_TB;
    localparam DATA_WIDTH           = 16;
    localparam CLK_PERIOD           = 10;
    localparam TEST_TIMEOUT         = 10000;
    
    // Total Transition Length
    localparam A_DURATION           = 5;
    localparam B_DURATION           = 15;

    // Initiation Time 
    localparam A_INIT_TIME          = 100;
    localparam B_INIT_TIME          = 50;
     
    //----------------------------------------------------------
    // Clock and reset generation
    //----------------------------------------------------------
    logic                   clk, reset_n;
    
    initial begin
        clk                             = 1'b0;
        forever
            #(CLK_PERIOD/2) clk         = ~clk;
    end
    
    initial begin
        reset_n                         = 1'b0;
        repeat (3) @(posedge clk);      // wait for 3 clocks
        reset_n                         = 1'b1;
    end
    
    //----------------------------------------------------------
    // Design-Under-Test (DUT)
    //----------------------------------------------------------  
    logic                             A_prev_valid_i,
                                      B_prev_valid_i;
    logic [DATA_WIDTH-1:0]            A_prev_data_i, B_prev_data_i;
    logic [DATA_WIDTH-1:0]            next_data_o;
    logic                             next_valid_o;
    logic                             next_ready_i;

    RRArbiter #(
        .DATA_WIDTH                 (DATA_WIDTH)
    ) dut (
        .aclk                       (clk),
        .areset_n                   (reset_n),
        
        .A_prev_valid_i             (A_prev_valid_i),
        .B_prev_valid_i             (B_prev_valid_i),
        
        .A_prev_data_i              (A_prev_data_i),
        .B_prev_data_i              (B_prev_data_i),
        
        .next_data_o                (next_data_o),
        .next_valid_o               (next_valid_o),
        .next_ready_i               (next_ready_i)
    );

    //----------------------------------------------------------
    // Execution
    //----------------------------------------------------------
    integer A_count;
    integer B_count;
    integer A_init = 0;
    integer B_init = 0;

    initial begin
        A_count                     = A_DURATION;
        A_prev_valid_i              = 0;
        A_prev_data_i               = 16'hA000;

        #A_INIT_TIME;
        A_init                      = 1;
    end

    initial begin
       B_count                     = B_DURATION;
       B_prev_valid_i              = 0;
       B_prev_data_i               = 16'hB000;

       #B_INIT_TIME;
       B_init                      = 1;            
    end

    // A
    always @(posedge clk) begin
        if (A_init == 1) begin
            if (A_count > 0) begin
                A_prev_valid_i      = 1;
                A_prev_data_i       = 16'hAAAA;
            end
            else begin
                A_prev_valid_i      = 0;
            end
        end
    end

    // B
    always @(posedge clk) begin
        if (B_init == 1) begin
            if (B_count > 0) begin
                B_prev_valid_i      = 1;
                B_prev_data_i       = 16'hBBBB;
            end
            else begin
                B_prev_valid_i      = 0;
            end
        end
    end
    // For ready
    initial begin
        next_ready_i = 1;
    end

    //----------------------------------------------------------
    // Count
    //----------------------------------------------------------
    always @(posedge clk) begin
        if (next_data_o == 16'hAAAA) begin
            A_count                 = A_count - 1;
        end
        else if (next_data_o == 16'hBBBB) begin
            B_count                 = B_count - 1;
        end
    end

    //----------------------------------------------------------
    // Timeout for simulation
    //----------------------------------------------------------
    initial begin
        #TEST_TIMEOUT
        $display("Simulation timed out!");
        $fatal("Simulation timed out");
    end

endmodule
