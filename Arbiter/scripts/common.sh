#!/bin/bash

RUN_DIR=OUTPUT

COMPILE_CMD='vcs'
COMPILE_OPTIONS='-full64 -debug_access+all -kdb -LDFLAGS -Wl,--no-as-needed'

SIM_OPTIONS=''

WAVE_CMD='/home/ScalableArchiLab/tools/synapticad-19.00c-x64/bin/syncad'
WAVE_OPTIONS='-p wfp'

#VERDI_CMD='Verdi-SX'
VERDI_CMD='Verdi'
VERDI_OPTIONS=''

DC_CMD='dc_shell-xg-t'
DC_OPTIONS=''

CSR_CMD='/home/ScalableArchiLab/bin/csrCompileLite'