#!bin/bash
#$ -S /bin/bash
#$ -q pub8i
#$ -N submitted_long
#$ -l mem_free=8G
#$ -cwd
#$ -notify 
#$ -M dillonflann@gmail.com
module load MATLAB
./kowMcc 10000 2000
