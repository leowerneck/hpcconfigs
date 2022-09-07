#!/bin/bash

#This is an example script for executing generic jobs with 
# the use of the command 'qsub <name of this script>'


#These commands set up the Grid Environment for your job.  Words surrounding by a backet ('<','>') should be changed
#Any of the PBS directives can be commented out by placing another pound sign in front
#example
##PBS -N name
#The above line will be skipped by qsub because of the two consecutive # signs 

# Specify job name
#PBS -N trial

# Specify the resources need for the job
# Walltime is specified as hh:mm:ss (hours:minutes:seconds)
### set vmem equal to the number of nodes times 64GB (medium memory node)
#PBS -l select=4:ncpus=40:mpiprocs=8,walltime=06:00:00

# edu_res: University research projects
#PBS -P edu_res

export MV2_ENABLE_AFFINITY=0
#export MV2_ENABLE_AFFINITY=1
export MV2_THREADS_PER_PROCESS=5
export OMP_NUM_THREADS=5

module load gcc/9.4.0-gcc-8.4.1-57pg mvapich2/2.3.6-gcc-9.4.0-n6hz zlib/1.2.11-gcc-9.4.0-okda

cd $PBS_O_WORKDIR

mpirun -n 32 -envall ./cactus_etilgrmhdgcc94 -reo GW150914_SA.par |tee CCTK_Proc0.out
