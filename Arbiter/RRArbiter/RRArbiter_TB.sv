`timescale 1ns / 1ps


module RRArbiter_TB;
    localparam DATA_WIDTH           =16;
    localparam CLK_PERIOD           =10;
    localparam TEST_TIMEOUT         =10000;
    
    // Total Transition Length
    localparam A_DURATION           =30;
    localparam B_DURATION           =50;

    // Initiaion Time 
    localparam A_INIT_TIME          =100;
    localparam B_INIT_TIME          =50;
     
    
    //----------------------------------------------------------
    // Clock and reset generation
    //----------------------------------------------------------
    
    logic                   clk, reset_n;
    
    initial begin
        clk                             = 1'b0;
        forever
            #(CLK_PERIOD/2) clk             = ~clk;
    end
    
    initial begin
        reset_n                           = 1'b0;
        repeat (3) @(posedge clk);      // wait for 3 clocks
        reset_n                           = 1'b1;
    end
    
    //----------------------------------------------------------
    // Design-Under-Test (DUT)
    //----------------------------------------------------------  
    
    logic                             A_valid_i,
                                      B_valid_i;
    logic [DATA_WIDTH-1:0]            A_data_i, B_data_i;
    logic [DATA_WIDTH-1:0]            data_o;
    
        RRArbiter
    #(
        .DATA_WIDTH                 (DATA_WIDTH)
    )
    dut(
        .aclk                       (clk),
        .areset_n                   (reset_n),
        
        .A_valid_i                  (A_valid_i),
        .B_valid_i                  (B_valid_i),
        
        .A_data_i                   (A_data_i),
        .B_data_i                   (B_data_i),
        
        .data_o                     (data_o)
    );

    //----------------------------------------------------------
    // Excution
    //----------------------------------------------------------

    // runtime count in clk
    integer A_count;
    integer B_count;
    
    integer A_init = 0;
    integer B_init = 0;
    
    initial begin
    
        A_count                     = A_DURATION;
        B_count                     = B_DURATION;
        A_valid_i                   = 0;
        B_valid_i                   = 0;
        
        #A_INIT_TIME;
        A_init                      = 1;
        
        #B_INIT_TIME;
        B_init                      = 1;
    
    
    end
    
    
    always @(posedge clk) begin
        if(A_init ==1) begin
            if( A_count > 0 ) begin
        
                A_valid_i               = 1;
                A_data_i                = 16'hAAAA;
        
            end
            else begin
                A_valid_i                   = 0;
                A_data_i                    = 16'hA000;
            end
        end
    end

    always @(posedge clk) begin
        if(B_init ==1) begin
            if( B_count > 0 ) begin
        
                B_valid_i               = 1;
                B_data_i                = 16'hBBBB;
        
            end
            else begin
                B_valid_i                   = 0;
                B_data_i                    = 16'hB000;
            end
        end
    end
   

    //----------------------------------------------------------
    // Count 
    //----------------------------------------------------------
    
    always @(posedge clk) begin
        if(data_o == 16'hAAAA) begin
            A_count                 = A_count - 1;
        end
        else if(data_o ==  16'hBBBB) begin
            B_count                 = B_count - 1;
        end
    
    end
    
    initial begin
        #TEST_TIMEOUT
        $display("Simulation timed out!");
        $fatal("Simulation timed out");
    end

endmodule
