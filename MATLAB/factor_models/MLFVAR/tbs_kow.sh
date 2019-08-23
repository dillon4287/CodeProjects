#!bin/bash
#$ -S /bin/bash
#$ -q its
#$ -N kow
#$ -l mem_free=2G
#$ -cwd
#$ -notify 
#$ -M dillonflann@gmail.com
#$ -m e
#$ -o bin/outputfiles/
#$ -e bin/errorlogs/
module load MATLAB
./KOW_TBS_Exec 1000 200 800 kowDataVar1NoTransformation.mat 
