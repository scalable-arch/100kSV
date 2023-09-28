Create almost_full and almost_empty signals using counters based on read and write signals. 

- The almost_full condition 
    - If counter is greater than almost_full_level.

- almost_write condition 
    - If counter is less than almost_empty_level. 

* Added a part to the testbench that outputs the number of data currently in the FIFO and a signal when the almost_full and almost_empty signals become 1. 
