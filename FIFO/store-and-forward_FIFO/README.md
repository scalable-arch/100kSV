# Store-and-foward FIFO

## Introduction and Operation

"Store and Forward" is one of the transmission mechanisms used in data communication. In this method, the entire data packet or frame is stored in a buffer (or FIFO) before being transmitted. Once the entire data has arrived, it is then forwarded to its destination.

1. Data Write : As data packets or frames arrive, they are stored in a FIFO (First-In-First-Out) memory buffer. 

2. Error Checking : Once the entire packet is stored, an error check can be performed. This ensures the integrity of the data. 

3. Data Transmission or Remove : Packet with no error are forward. But packets with errors are removed.

The advantage of the Store and Forward method is that it ensures data integrity since it only transmits after receiving and checking the entire packet.

## Code Architecture

+ s&f FIFO
+ eop(end of packet)_check
+ error_check


## Example
### Initial
if Header[31:28] = 4'b0011 --->  Header(4B) + Data(4B) + Data(4B) + Data(4B) + CRC(4B)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;CRC&nbsp;&nbsp;|  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--   
&nbsp;&nbsp;-> wrptr_tmp  
&nbsp;&nbsp;-> wrptr_store  
&nbsp;&nbsp;-> rdptr

### Write (wren = 1, eop = 0)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;CRC&nbsp;&nbsp;|  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--  
&nbsp;&nbsp;&nbsp;&nbsp; \--\--\--\--\-> \--\--\--> \--\--\--> \--\--\--> \--\--\--> wrptr_tmp  
&nbsp;&nbsp;-> wrptr_store  
&nbsp;&nbsp;-> rdptr


### Store (eop = 1, error = 0)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;CRC&nbsp;&nbsp;|  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> wrptr_tmp  
&nbsp;&nbsp;&nbsp;&nbsp;--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--> wrptr_store  
&nbsp;&nbsp;-> rdptr

### Forward (rden = 1)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;CRC&nbsp;&nbsp;|  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> wrptr_tmp  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> wrptr_store  
&nbsp;&nbsp;&nbsp;&nbsp; \--\--\--\--\-> \--\--\--> \--\--\--> \--\--\--> \--\--\--> rdptr

### Remove (eop = 1, error = 1)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;CRC&nbsp;&nbsp;|  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--  
&nbsp;&nbsp;&nbsp;&nbsp; <\--\--\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\-- wrptr_tmp  
&nbsp;&nbsp;-> wrptr_store  
&nbsp;&nbsp;-> rdptr 

### Empty (write -> store -> forward -> empty)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;data&nbsp;&nbsp;|&nbsp;&nbsp;CRC&nbsp;&nbsp;|  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\--\--\--\-\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--\--  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> wrptr_tmp  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> wrptr_store  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> rdptr

### Full 
+ same condition with simpe FIFO  
+ When packet(same size with FIFO) is stored, FIFO is Full