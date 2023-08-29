# 100kSV

100K lines of SystemVerilog to be a Computer Architect or VLSI front-end expert.


Synopsys DesignWare Building Blocks
https://www.synopsys.com/dw/buildingblock.php

# Module 1: Structural Verilog (Transistor-level)
- [Inverter](https://github.com/scalable-arch/100kSV/tree/main/m0000_TR_INV)
- [NAND2](https://github.com/scalable-arch/100kSV/tree/main/m0001_TR_NAND2)
- [NOR2](https://github.com/scalable-arch/100kSV/tree/main/m0002_TR_NOR2)
- [AND2](https://github.com/scalable-arch/100kSV/tree/main/m0003_TR_AND2)
- [OR2](https://github.com/scalable-arch/100kSV/tree/main/m0004_TR_OR2)
- XOR2
- XNOR2
- AND-OR-Inverter
- OR-AND-Inverter
- 2:1 Mux
- 1:2 demux

# Module 2: Structural Verilog (Gate-level)
- XOR2
- XNOR2
- 2:1 mux
- 1:2 demux
- Half-adder
- Full-adder
- Karnaugh Map
- Sum-of-Products
- Product-of-Sums
- Address decoder
- Barrel shifter

# Module 3: Structural Verilog (Block-level)

# Module 4: Behavioral Verilog (Combinational)

# Module 5: Behavioral Verilog (Finite State Machine)

# Module 6: Behavioral Verilog (Memory elements)

# Arithmetic components
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

# Building blocks

## FIFO
- Register-based Show-ahead FIFO
- Parameterized FIFO
- SRAM-based show-ahead FIFO
- SRAM-based normal (non show-ahead) FIFO
- FIFO array based on SRAM
- Store-and-forward FIFO
- Replay FIFO
- Narrower FIFO
- Wider FIFO
- async FIFO

## Arbiter
- Fixed-priority arbiter
- Round-robin arbiter
- Weighted round-robin arbiter
- parameterized arbiter
- Two-level arbiter

## FSM

- Mealy machine
- Moore machine
- Traffic Light Controller
- Digital lock

## Etc.
## Test Bench

-- clock generation
-- reset generation
-- interface

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

