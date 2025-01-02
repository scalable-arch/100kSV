
module RRArbiter#(
parameter DATA_WIDTH = 16
)
 (
    input   wire                                aclk
  , input   wire                                areset_n

  , input wire                                  A_prev_valid_i
  , input wire                                  B_prev_valid_i
  , output reg                                  A_prev_ready_o
  , output reg                                  B_prev_ready_o
  
  , input wire  [DATA_WIDTH-1:0]                A_prev_data_i
  , input wire  [DATA_WIDTH-1:0]                B_prev_data_i
  
  , output reg [DATA_WIDTH-1:0]                 next_data_o
  , output reg                                  next_valid_o
  , input wire                                  next_ready_i
);

    logic                                       winner_rw;
    logic                                       winner_valid;

    logic                                       prev_winner, prev_winner_n;

    logic [DATA_WIDTH-1:0]                      winner_data;
    logic [DATA_WIDTH-1:0]                      data;

    localparam logic                             A = 2'b00,
                                                 B = 2'b01;


    //----------------------------------------------------------

    // winner A = 01, B = 10
    
    assign next_data_o                          = data;
    assign next_valid_o                         = winner_valid;
    

    always_ff @(posedge aclk)
        if (~areset_n) begin
            prev_winner                      <= A;
//           data                            <={DATA_WIDTH{1'bx}};
//           winner_data                     <={DATA_WIDTH{1'bx}};
        end

        else begin
            prev_winner                     <= prev_winner_n;
            
        end

    // round-robin arbiter
    always_comb begin
        prev_winner_n                   = prev_winner;

        winner_rw                       = 1'bx;
        winner_valid                    = 1'b0;
        winner_data                     = {DATA_WIDTH{1'bx}};;
        
        A_prev_ready_o                  = 1'b0;
        B_prev_ready_o                  = 1'b0;
        // if the last winner is B -> A > B
        // if the last winner is A -> B > A
        if (  ((prev_winner == B) & A_prev_valid_i)
            | ((prev_winner == A) & ~B_prev_valid_i) )
        begin
            // A
            winner_rw                       = A;
            winner_valid                    = A_prev_valid_i;
            winner_data                     = A_prev_data_i;
            
            A_prev_ready_o                  = next_ready_i;
            
        end 
        else begin
            // B
            winner_rw                       = B;
            winner_valid                    = B_prev_valid_i;
            winner_data                     = B_prev_data_i;
            
            B_prev_ready_o                  = next_ready_i;
        end

        if (winner_valid & next_ready_i) begin
            prev_winner_n                   = winner_rw;
            data                            = winner_data; 
        end
        // no one is valid
        else begin
            data                            = {DATA_WIDTH{1'bx}};;
            prev_winner_n                   = prev_winner;
        end      
        
        
    end





endmodule