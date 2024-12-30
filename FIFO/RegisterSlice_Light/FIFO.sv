`timescale  1ns/10ps

`define     ID_WIDTH                3
`define     ADDR_WIDTH              32
`define     DATA_WIDTH              32


package payload_package;

    typedef struct packed{
        logic     [`ID_WIDTH-1:0]          ID;
        logic     [`ADDR_WIDTH-1:0]        ADDR;
        logic     [`DATA_WIDTH-1:0]        DATA;
    } payload_t;
    
endpackage


module FIFO(
    // Global Signal
    input   wire                    clk,
    input   wire                    rstn,

    //source siganl

    input   payload_package::payload_t  in_payload,
    output  wire                        sready,             
    input   wire                        svalid,

    //destination signal
    output  payload_package::payload_t  out_payload,
    input   wire                        dready,
    output  wire                        dvalid,
    output  wire    [1:0]               CE,
    output  wire                        ready,valid,

    output  wire                        cnt,
    output  wire    [2:0]               state
);
    localparam  payload_legnth  =   $bits(in_payload);

    wire                            ready;
    wire                            valid;

    //wire        [1:0]               CE;

    Control u_Control(.clk(clk),.rstn(rstn),.svalid(svalid),.sready(ready),.dvalid(valid),.dready(dready),.CE(CE),.state(state));

    DFF     u_DFF1(.clk(clk),.rstn(rstn),.D(ready),.Q(sready));
    DFF     u_DFF2(.clk(clk),.rstn(rstn),.D(valid),.Q(dvalid));

    DFF_CE #(.payload_len(payload_legnth)) u_DFF_CE(.clk(clk),.rstn(rstn),.CE(CE),.D(in_payload),.Q(out_payload));
 

endmodule