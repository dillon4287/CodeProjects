#!bin/bash
#$ -S /bin/bash
#$ -N vanilla
#$ -q pub8i
#$ -l mem_free=2G
#$ -cwd
#$ -notify 
#$ -M dillonflann@gmail.com
module load MATLAB
./SimStudyliu2006Vanilla 10000
