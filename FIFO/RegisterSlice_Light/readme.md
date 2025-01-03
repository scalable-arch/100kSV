 # Register Slice 
 

## 0. Introduction

The AXI Register Slice core connects one AXI memory-mapped master to one AXI memory-mapped slave through a set of pipeline registers, typically to break a critical timing path.


## 1. Port Descriptions

The core interfaces are shown in the following figure. For more specific port information, see the following sections.

![Alt text](image-2.png)

NOTE) "Please refer to the following AMD document for detailed signals of the S_AXI and M_AXI ports mentioned above." 

<https://docs.xilinx.com/r/en-US/pg373-axi-register-slice/Port-Descriptions>



## 2. AXI Interface Parameters

The following table lists the parameters that control the physical characteristics of the AXI interfaces of the core.

![Alt text](image-3.png)

NOTE)  1. Automiacally set by tools based on system connectivity.

## 3. Modes of Operation

The following modes of the AXI Register Slice are available on each AXI channel.

### 1) Fully-Registerd Register Slice

Implemented as a two-deep FIFO buffer, this mode supports throttling by the channel source and/or channel destination as well as back-to-back transfers without incurring bubble cycles (up to 100% duty cycle). This mode is appropriate on W and R channels carrying bandwidth-critical AXI4 or AXI3 burst transfers.

This mode is selected as "Full" in the configuration dialog. Fully-registered mode drives registered payload outputs and registered VALID and READY handshake outputs as shown in the figure.

![Alt text](image-4.png)

The figure shows that the Fully-Registered mode introduces one latency cycle, but no bubble cycles.

![Alt text](image-5.png)


### 2) Ligth-Weight Register Slice

Implemented as a simple one-stage pipeline register, this mode minimizes resources while isolating timing paths, but always incurs one bubble cycle following each transfer, resulting in a maximum duty cycle of 50%. This mode is appropriate on AW, AR and B channels, which normally do not require back-to-back transfers, and for all channels operating in AXI4-Lite protocol.

This mode is selected as "Light" in the configuration dialog. Light-weight mode drives registered payload outputs and registered VALID and READY handshake outputs as shown in the figure.

![Alt text](image-6.png)

The figure shows that the Light-Weight mode introduces one latency cycle, with one bubble cycle following each transfer.

![Alt text](image-7.png)

## 4. Conclude

###  Ligth-Weight Register Slice
#### 1) Module
I designed the Light Weight Register Module using the following modules.

![Alt text](image-9.png)

#### 2) FSM

The controller was designed based on the following FSM (Finite State Machine)

![Alt text](image-8.png)


- For convenience in the FSM diagram, the conditions under which transitions occur are not explicitly indicated.

- [S_IDLE   = 3'b000] corresponds to (svalid, dready) = (0,0)   

- [S_READY  = 3'b001] corresponds to (svalid, dready) = (0,1)

- [S_VALID  = 3'b010] corresponds to (svalid, dready) = (1,0)

- [S_TRANS  = 3'b011] corresponds to (svalid, dready) = (1,1)

- [S_BUBBLE = 3'b111] corresponds to (svalid, dready) = (1,1)

- [S_TRANS => S_BUBBLE]: This transition always occurs to hold for one more clock cycle.



#### 3) Timing diagram

The verification results using the written testbench are as follows.

![Alt text](image-1.png)

- From the testbench results, we can observe that signals are only transmitted when both svalid and dready are 1. As intended for the light-weight register slice, we can see that the signal is transmitted for a duration of 2 clock cycles.



![Alt text](image-10.png)

- when (svalid, dready) = (1,1), the dvalid signal is one global clock cycle faster than the sready signal. (The clock signal for dvalid and the clock signal for dready differ by one clock cycle.)
- We can also confirm that dvalid and sready signals are produced as intended.
