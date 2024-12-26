
module RRArbiter#(
parameter DATA_WIDTH = 16
)
 (
    input   wire                                aclk
  , input   wire                                areset_n

  , input wire                                  A_valid_i
  , input wire                                  B_valid_i
  
  , input wire  [DATA_WIDTH-1:0]                A_data_i
  , input wire  [DATA_WIDTH-1:0]                B_data_i
  
  , output wire [DATA_WIDTH-1:0]                data_o
);

    logic                                       winner_rw;
    logic                                       winner_valid;

    logic                                       prev_winner, prev_winner_n;

    logic [DATA_WIDTH-1:0]                      winner_data;
    logic [DATA_WIDTH-1:0]                      data, data_n;

    localparam logic                            A = 2'b00,
                                                 B = 2'b01;


    //----------------------------------------------------------

    // A = 01, B = 10

    always_ff @(posedge aclk)
        if (~areset_n) begin
            prev_winner                     <= A;
            data <=16'bx;
        end

        else begin
            prev_winner                     <= prev_winner_n;
            data                            <= data_n;
            
        end

    // round-robin arbiter
    always_comb begin
        prev_winner_n                   = prev_winner;

        winner_rw                       = 1'bx;
        winner_valid                    = 1'b0;
        winner_data                     = 16'bx;
        
        // if the last winner is B -> A > B
        // if the last winner is A -> B > A
        if (  ((prev_winner == B) & A_valid_i)
            | ((prev_winner == A) & ~B_valid_i) )
        begin
            // A
            winner_rw                       = A;
            winner_valid                    = A_valid_i;
            winner_data                     = A_data_i;
        end 
        else begin
            // B
            winner_rw                       = B;
            winner_valid                    = B_valid_i;
            winner_data                     = B_data_i;
        end

        if (winner_valid) begin
            prev_winner_n                   = winner_rw;     
        end
        // no one is valid
        else begin
            winner_data                     = 16'bx;
        end      
        
        data_n                              = winner_data;
        
    end

assign data_o                               = data;


endmodule