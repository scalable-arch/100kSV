
# Simple FIFO (Show-ahead)

This FIFO is based on existing FIFO2(Parameterized FIFO; Show-ahead mode)

## Specification

#### FIFO.sv ports
| Port      | Type   | Description                                        |
| :-------- | :----- | :------------------------------------------------- |
| `clk`     | input  | System clock. All ports are synchronus.            |
| `rst_n`   | input  | Negative edge reset.                               |
| `full_o`  | output | Active when FIFO is full.                          |
| `wren_i`  | input  | Write enable signal from system interface(e.g. AXI)|
| `wdata_i` | input  | **32bit**. Data for write. From system interface.  |
| `empty_o` | output | Active when FIFO is empty.                         |
| `rden_i`  | input  | Read enable signal from system interface           |
| `rdata_o` | output | **32bit**. Data for read. Goes to system interface.|

#### FIFO.sv parameters 
All parameters are assigned in local parameters. To change the value, you should change the RTL code. If you want to change the value at outer module, use *Parameterized FIFO*.
| Parameter    | Default value    | Description                             |
| :----------- | :--------------- | :-------------------------------------- |
| `DEPTH_LG2`  | `4`              | Logarithm of depth. Used to assign bits.|
| `DATA_WIDTH` | `32`             | Data width.                             |
| `RST_MEM`    | `0`              | Do not apply reset to the memory at `0` |
| `FIFO_DEPTH` | `1 << DEPTH_LG2` | Real depth. Caculated with `DEPTH_LG2`  |



## Running simulation (with GUI)

To simulate, run the following command

```bash
  ./run
```
DVE GUI will be executed\
View the waveform with adding variables in hierachy
