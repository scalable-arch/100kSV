# 100kSV

**100k lines of SystemVerilog** to be a Computer Architect or VLSI front-end expert.


Resources:
- Synopsys DesignWare Building Blocks
https://www.synopsys.com/dw/buildingblock.php
- HDLBits
https://hdlbits.01xz.net/wiki/Main_Page

# Module 1: Structural SystemVerilog (Transistor-level)
- [```Inverter```](https://github.com/scalable-arch/100kSV/tree/main/TR/INV)
- [```NAND2```](https://github.com/scalable-arch/100kSV/tree/main/TR/NAND2)
- [```NOR2```](https://github.com/scalable-arch/100kSV/tree/main/TR/NOR2)
- [```AND2```](https://github.com/scalable-arch/100kSV/tree/main/TR/AND2)
- [```OR2```](https://github.com/scalable-arch/100kSV/tree/main/TR/OR2)
- XOR2
- XNOR2
- [```AND-OR-Inverter 21```](https://github.com/scalable-arch/100kSV/tree/main/TR/AOI21)
- OR-AND-Inverter
- [```2:1 Mux```](https://github.com/scalable-arch/100kSV/tree/main/TR/MUX2)
- [```1:2 demux```](https://github.com/scalable-arch/100kSV/tree/main/TR/DEMUX2)

# Module 2: Structural SystemVerilog (Gate-level)
- XOR2
- XNOR2
- [```2:1 Mux```](https://github.com/scalable-arch/100kSV/tree/main/Gate/MUX2)
- 1:2 demux
- [```Half-adder```](https://github.com/scalable-arch/100kSV/tree/main/Gate/HALF_ADDER)
- [```Full-adder```](https://github.com/scalable-arch/100kSV/tree/main/Gate/FULL_ADDER)
- Karnaugh Map
- Sum-of-Products
- Product-of-Sums
- Address decoder
- Barrel shifter

# Module 3: Structural SystemVerilog (Block-level)
- Ripple Carry Adder

# Module 4: Behavioral SystemVerilog (Combinational)

# Module 5: Behavioral SystemVerilog (Finite State Machine)

- Mealy machine
- Moore machine
- Traffic light controller
- SRAM controller
- Digital lock


# Module 6: Basic TestBench

- Clock generation
- Reset generation
- I/O
- interface

# Module 7: Design Components (FIFO)

(For show-ahead and normal FIFO modes, refer to https://www.intel.com/content/www/us/en/docs/programmable/683241/21-1/scfifo-and-dcfifo-show-ahead-mode.html)

- Simple FIFO (Show-ahead)
- [```Parameterized FIFO (Show-ahead)```](https://github.com/scalable-arch/100kSV/tree/main/FIFO/FIFO2)
- Parameterized FIFO (Normal)
- SRAM-based FIFO (Show-ahead)
- SRAM-based FIFO (Normal)
- Almost-full FIFO
- FIFO array
- Store-and-forward FIFO
- Replay FIFO
- Multi-reader FIFO
- Narrower FIFO
- Wider FIFO
- async FIFO
- Register slice (https://www.xilinx.com/products/intellectual-property/axi-register-slice.html)

# Module 8: Design Components (Arbiter)
- Fixed-priority arbiter
- Round-robin arbiter
- Weighted round-robin arbiter
- parameterized arbiter
- Two-level arbiter

# Module 9: Arithmetic/Logical Operations
- 4-bit adder (ripple carry)
- 4-bit adder (carry look-ahead)
- 4-bit subtractor
- 4-bit adder/subtracdtor
- Comparator
- Absolute value
- Arithmetic shifter
- Barrel shifter
- Incremeting counter
- Decrementing counter
- Saturating counter
- Booth's multiplier
- two-stage pipelined multiplier
- Binary to gray code converter
- floating-point adder
- floating-point subtractor
- leading one's detector
- priority coder

## Etc.
## Test Bench


# Computer Architecture

# Functional Units

- Multiply-accumulator
- Instruction Fetch
- Instructino Decode
- Arithmetic Logical Unit
- Floating-Point Unit
- LD/ST Unit
- Branch Prediction

## Cache

- Direct-mapped cache
- 2-way set-associative cache
- Fully-associative cache
- MSI-cache
- MESI-cache
- MOESI-cache
- MSHR
- TLB

## SRAM controller

## DRAM controller

# System-on-a-Chip

## AMBA APB

## SystemRDL

## AMBA AHB

## AMBA AXI

## AXI-Streaming

## AHB DMA

## AXI DMA (non-pipelined)

## AXI DMA (pipelined)

## Scatter-Gather DMA

## Credit control

# Error checking
- Parity check
- CRC
- Single-Error Correcting ECC
- Linear Feedback Shift Register

## Synchronizer

- 1-bit synchronizer
- hand-shake synchronizer
- pulse synchronizer
- multi-bit synchronizer
- asynchronous FIFO
- reset synchronizer

