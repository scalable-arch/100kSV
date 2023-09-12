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
- 1:2 demux

# Module 2: Structural SystemVerilog (Gate-level)
- XOR2
- XNOR2
- [```2:1 Mux```](https://github.com/scalable-arch/100kSV/tree/main/Gate/MUX2)
- 1:2 demux
- Half-adder
- Full-adder
- Karnaugh Map
- Sum-of-Products
- Product-of-Sums
- Address decoder
- Barrel shifter

# Module 3: Structural SystemVerilog (Block-level)

# Module 4: Behavioral SystemVerilog (Combinational)

# Module 5: Behavioral SystemVerilog (Finite State Machine)

- Traffic Light Controller
- Digital lock
- Mealy machine
- Moore machine


# Module 6: Basic TestBench

- Clock generation
- Reset generation
- I/O
- interface

# Module 7: Design Components (FIFO)
- Simple FIFO
- [```Parameterized FIFO```](https://github.com/scalable-arch/100kSV/tree/main/FIFO/FIFO2)
- SRAM-based show-ahead FIFO
- SRAM-based normal (non show-ahead) FIFO
- FIFO array based on SRAM
- Store-and-forward FIFO
- Replay FIFO
- Narrower FIFO
- Wider FIFO
- async FIFO
- Register slice

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

