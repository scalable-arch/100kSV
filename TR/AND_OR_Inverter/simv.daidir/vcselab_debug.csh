#!/bin/csh -f

cd /home/jyk2498/SystemVerilog/100kSV/TR/AND_OR_Inverter

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/usr/synopsys/vcs/R-2020.12-SP1-1/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

