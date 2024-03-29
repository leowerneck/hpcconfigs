#!/bin/bash

# Specify job name
#PBS -N pte4
#PBS -l select=16:ncpus=48:mpiprocs=8,walltime=48:00:00
#PBS -P edu_res
#PBS -m abe
#PBS -M <your_email_address>

module purge
# Must load gcc/9.2.0-gcc-4.8.5-bxc7, as intel compiler uses the updated GLIBC etc.
module load gcc/9.2.0-gcc-4.8.5-bxc7 intel/19.0.5-gcc-9.2.0-kl4p intel-mpi/2018.5.288-intel-19.0.5-alnu zlib/1.2.11-intel-19.0.5-p7mu hdf5/1.10.6-intel-19.0.5-m6j7 hwloc/2.1.0-intel-19.0.5-4ncw gsl/2.7_intel19.0.5 git/2.25.0-gcc-9.2.0-v4mv
module list

export OMP_NUM_THREADS=6
cd $PBS_O_WORKDIR

mpiexec -n 128 ./cactus_intel19 -reo bns-SLy_h020-IGM-basedonolderrun.par | tee CCTK_Proc0.out
