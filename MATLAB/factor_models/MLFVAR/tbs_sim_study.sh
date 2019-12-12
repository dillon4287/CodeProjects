#!/bin/bash
#$ -S /bin/bash
#$ -q free64
#$ -N ssdec11
#$ -l mem_free=10G
#$ -cwd
#$ -o bin/outputfiles/
#$ -e bin/errorlogs/
#$ -ckpt restart
module load MATLAB
./runhdfvardec11 10000 2000 SimulationStudy/TimeBreakSimData ${DATA} TBSSims/Dec11th 
