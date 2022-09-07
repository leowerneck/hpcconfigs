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
######PBS -l nodes=4:ppn=64,walltime=4:00:00
######PBS -l nodes=4:ppn=64,walltime=0:10:00
####PBS -l nodes=4:ppn=48:excl,walltime=0:10:00
#PBS -l select=4:ncpus=48:mpiprocs=16,walltime=06:00:00

# edu_res: University research projects
#PBS -P edu_res

module load python/3.8-anaconda-2020.07 gcc/8.4.0-gcc-4.8.5-jacd mvapich2/2.3.5-gcc-8.4.0 hdf5/1.12.0_mvapich2 zlib/1.2.11-gcc-9.2.0-ndme

export MV2_ENABLE_AFFINITY=0
#export MV2_ENABLE_AFFINITY=1
export MV2_THREADS_PER_PROCESS=3
export OMP_NUM_THREADS=3

cd $PBS_O_WORKDIR

mpirun -n 64 -envall ./cactus_etilgrmhdgcc92 -reo GW150914_SA.par |tee CCTK_Proc0.out
