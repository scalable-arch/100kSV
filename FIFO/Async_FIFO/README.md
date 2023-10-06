# Asynchronous FIFO

An **asynchronous FIFO** refers to a FIFO where in the data values are written to the FIFO memory from one clock domain
and the data values are read from a different clock domain, where in the two clock domains are asynchronous to each other.

## Hardware design
![FIFO](https://github.com/dbwls1229/lab2/assets/93321464/e2f4242f-9196-4d90-ba8c-b48d969e520a)
+ PUSH interface on the leftside, POP interface on the rightside.
+ PUSH and POP use different clocks, wrclk and rdclk, respectively.
+ There are two types of r/w pointers.
   + **Binary pointers** (*wrbptr*, *rdbptr*) are for accessing FIFO memory.
   + **Gray-encoded pointers** (*wrgptr*, *rdgptr*) are for making *full* and *empty* signals.
## Clock Domain Crossings (CDC)
To compare read pointers and write pointers which have different clock domains and generate *full* and *empty* signals, we should send a pointer to another clock domain. This is called CDC. <br /><br />
Two methods are used to conduct CDC in this asynchronous FIFO.
### 1. Synchronizers
Capturing the value from one clock domain with another clock domain might incur **metastability** problem if timing violation occurs. <br /><br />
**Synchronizer** passes a value from current clock domain to another clock domain through **two flip-flops** (can be more than this) clocked with the new clock.
The output of the second flip-flop has a much lower probability of metastability. <br /><br />
+ *Wrptr synchronizer* synchronizes write pointer to read clock domain to generate *empty* signal by comparing with read pointer value.
![wrptr sync](https://github.com/dbwls1229/lab2/assets/93321464/1d713cdf-e662-4882-b619-31c0515e42b0)
+ *Rdptr synchronizer* synchronizes read pointer to write clock domain to generate *full* signal by comparing with write pointer value.
![rdptr sync](https://github.com/dbwls1229/lab2/assets/93321464/4213767f-204c-4043-bda7-50069a4df17f)

### 2. Gray-encoding
Since read and write pointer values are N-bit and each bit passes two flip-flops, output of the synchronizers could be unstable depending on routing of each bit. <br />
E.g.,) Transition from 1111 to 0000 might be read as 1101 or 1100 or 0101 or ...  <br /><br />
**Gray-encoding** ensures only single bit changes between the new and old values.
![gray](https://github.com/dbwls1229/lab2/assets/93321464/01f78e8f-bf88-4ce3-9c96-d378676d88a6)
Read and write pointers are gray-encoded and passed to synchronizers. <br /><br />
Gray counter can be calculated as 
```systemverilog
gray_counter = (binary_counter >> 1) ^ binary_counter;
```

