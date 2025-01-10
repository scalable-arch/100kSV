// Copyright (c) 2024 Sungkyunkwan University
//
// Authors:
// - Jungrae Kim <dale40@skku.edu>

`define     TIMEOUT_CYCLE       4000000
`define     REQ_CNT             64
module ARBITER_TB_TOP ();
    localparam  REQ_CNT_LG2     = $clog2(`REQ_CNT);
    reg                         clk;
    reg                         rst_n;
    reg     [`REQ_CNT-1:0]      arbiter_req_arr;
    reg     [REQ_CNT_LG2-1:0]   arbiter_data_arr [0:`REQ_CNT-1];
    wire    [`REQ_CNT-1:0]      arbiter_gnt_arr;
    wire                        arbiter_req_o;
    wire    [REQ_CNT_LG2-1:0]   arbiter_data_o;
    int                         transactions_queue[$];
    
    // clock generation
    initial begin
        clk                     = 1'b0;

        forever #10 clk         = !clk;
    end

    // reset generation
    initial begin
        rst_n                   = 1'b0;     // active at time 0

        repeat (3) @(posedge clk);          // after 3 cycles,
        rst_n                   = 1'b1;     // release the reset
    end

    //set random seed
    initial begin
        int seed = 12345;
        int random_value;
        random_value = $urandom(seed);
    end

    // enable waveform dump
    initial begin
        $dumpvars(0, u_DUT);
        $dumpfile("dump.vcd");
    end
	
    // timeout
	initial begin
		#`TIMEOUT_CYCLE $display("Timeout!");
		$finish;
	end

    SAL_ARBITER_RR_64TO1 #(
        .REQ_CNT                    (`REQ_CNT),
        .DATA_WIDTH                 (12)
    ) u_DUT (
        .clk                        (clk),
        .rst_n                      (rst_n),
        .req_arr_i                  (arbiter_req_arr),
        .data_arr_i                 (arbiter_data_arr),
        .gnt_arr_o                  (),
        .req_o                      (arbiter_req_o),
        .data_o                     (arbiter_data_o),
        .gnt_i                      (1'b1)
    );
    
    task test_init();
        arbiter_req_arr             = 'h0;
        @(posedge rst_n); 
        repeat (10) @(posedge clk);
    endtask

    task transactions();
        int i;
        arbiter_req_arr             = 'hFFFF_FFFF_FFFF_FFFF;
        
        for(i = 0; i < `REQ_CNT; i++) begin
            arbiter_data_arr[i]     = i;
        end

        while(|arbiter_req_arr) begin
            @(posedge clk);
            if(arbiter_req_o == 1'b1) begin
                transactions_queue.push_back(arbiter_data_o);
                arbiter_req_arr[arbiter_data_o] = 1'b0;
            end
        end

        repeat (3) @(posedge clk);
    endtask

    task run_test();
        transactions();
    endtask

    task print();
        int transaction;
        int cnt = 0;
        while(transactions_queue.size()!=0) begin
            transaction = transactions_queue.pop_front();
            $display("==%d'th req transaction==",transaction);
            cnt++;
        end
        if(cnt == `REQ_CNT) begin
            $display("Verification Done");
        end else begin
            $display("Error : small number of transactions %d",cnt);
        end
    endtask

    initial begin
        $display("====================Start Simulation!====================");
        test_init();
        run_test();
        print();
        $display("====================Simulation Done!====================");
        $finish;
    end

endmodule
