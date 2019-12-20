#!/bin/bash
#$ -S /bin/bash
#$ -ckpt restart 
#$ -q pub8i
#$ -N whole
#$ -l mem_free=8G
#$ -cwd
#$ -o bin/outputfiles/
#$ -e bin/errorlogs/
module load MATLAB
./runhdfvardec12 10000 2000 8000 BigKow kowz_notcentered.mat BigKowResults
