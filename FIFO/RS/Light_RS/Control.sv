`timescale  1ns/10ps


module Control(
    input   wire            clk,
    input   wire            rstn,
    input   wire            svalid,
    input   wire            dready,
    
    output  reg             dvalid,
    output  reg             sready,
    output  reg     [1:0]   CE,
    output  reg     [2:0]   state
    );

    localparam              S_IDLE       =  3'b000,
                            S_READY      =  3'b001,
                            S_VALID      =  3'b010,
                            S_TRANS      =  3'b011,
                            S_BUBBLE     =  3'b111;
    


    //reg      [2:0]          state,      state_n;
    reg      [2:0]          state_n;


    

    //state
    always_ff @(posedge clk) begin
        if(!rstn) begin
            state        <=  S_IDLE;
        end

        else begin
            state        <=  state_n;
        end
    end

    

    //next
    always_comb begin
        state_n         =   state;

        sready = 1'b0;
        dvalid = 1'b0;
        CE = 2'b00;
        case(state)
            S_IDLE: begin
                sready = 1'b0;
                dvalid = 1'b0;
                CE     = 2'b00;
                case({svalid, dready})
                    2'b00: state_n = state;
                    2'b01: state_n = S_READY;
                    2'b10: state_n = S_VALID;
                    2'b11: state_n = S_TRANS;
                endcase
            end

            S_READY:    begin
                sready = 1'b1;
                dvalid = 1'b0;
                CE     = 2'b00;
                case({svalid, dready})
                    2'b00: state_n = S_IDLE;
                    2'b01: state_n = state;
                    2'b10: state_n = S_VALID;
                    2'b11: state_n = S_TRANS;
                endcase
            end

            S_VALID:    begin
                sready = 1'b0;
                dvalid = 1'b1;
                CE = 2'b10;
                case({svalid, dready})
                    2'b00: state_n = S_IDLE;
                    2'b01: state_n = S_READY;
                    2'b10: state_n = state;
                    2'b11: state_n = S_TRANS;
                endcase
            end

            S_TRANS: begin
                sready = 1'b0;
                dvalid = 1'b1;
                state_n = S_BUBBLE;
                CE = 2'b11;
            end

            S_BUBBLE:   begin
                sready = 1'b1;
                dvalid = 1'b0;
                CE = 2'b01;
                case({svalid, dready})
                    2'b00: state_n = S_IDLE;
                    2'b01: state_n = S_READY;
                    2'b10: state_n = S_VALID;
                    2'b11: state_n = S_TRANS;
                endcase
            end
            
        endcase
    end
    

endmodule