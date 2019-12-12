#!/bin/bash
#$ -S /bin/bash
#$ -q pub8i
#$ -N itskow
#$ -l mem_free=4G
#$ -cwd
#$ -o bin/outputfiles/
#$ -e bin/errorlogs/
#$ -ckpt restart
module load MATLAB
./runhdfvardec11 10000 2000 BigKow kowz_notcentered_resurrection.mat BigKowResults
