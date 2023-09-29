# Narrower FIFO

## Overview
Narrower FIFO supports a wide write port with a narrow read port if the width ratio is valid. Valid width ratios are powers of 2 (e.g., 1, 2, and 4). For this FIFO, the read and write signals are synchronized to the `rdclk` and `wrclk` clocks, respectively.

## Parameters
- `DEPTH_LG2`: Specifies the depth of the FIFO as the number of log base 2.
- `WRDATA_WIDTH`: Specifies the bit-width of the write data in the FIFO.
- `RDDATA_WIDTH`: Specifies the bit-width of the read data in the FIFO.
- `RST_MEM`: Reset to the memory. 

## Ports
- `rst_n`: Negative-edge-triggered reset.

- `wrclk`: Positive-edge-triggered clock. Use to synchronize the ports such as `wren_i`, `wdata_i`, `wrempty_o`, and `wrfull_o`.
- `wren_i`: Assert this signal to request for a write operation.
- `wdata_i`: Holds the data to be written in the FIFO when the `wren_i` signal is asserted.
- `wrempty_o`: Do not perform read request operation when the FIFO is empty.
- `wrfull_o`: Do not perform write request operation when the FIFO is full.

- `rdclk`: Positive-edge-triggered clock. Use to synchronize the ports such as `rden_i`, `rdata_o`, `rdempty_o`, and `rdfull_o`.
- `rden_i`: Assert this signal to request for a read operation.
- `rdata_o`: Shows the data read from the read request operation.
- `rdempty_o`: Do not perform read request operation when the FIFO is empty.
- `rdfull_o`: Do not perform write request operation when the FIFO is full.

(For Narrower and Wider FIFO, refer to https://www.intel.com/content/www/us/en/docs/programmable/683241/21-1/different-input-and-output-width.html)
