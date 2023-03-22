#!/bin/bash


# Partition options:
# Name  Priority MaxTime MaxSubmitPU
# ----------------------------------
# tiny     72    6 hrs       --
# short    36    24 hrs     1000
# reg      18    7 days      500
# long      9      --         50

# ntasks-per-node * cpus-per-task should (hopefully) equal 36.
# Note that the per-node memory is 128GB RAM, so usage above that
# will require splitting the job across more nodes regardless of cores

#SBATCH --job-name=name-me-plz
#SBATCH --partition=long
#SBATCH --nodes=2 # 36 processes per node
#SBATCH --ntasks-per-node=9
#SBATCH --cpus-per-task=4
#SBATCH -t 1:00:00 # run time (hh:mm:ss)
#SBATCH -o test-results-%j # output and error file name (%j expands to jobID)

module load gcc/12.1.0 openmpi/4.1.3 hdf5/1.12.2 fftw/3.3.10

export OMP_NUM_THREADS=4

echo "Preparing run:"
date

mpirun -n 18 /path/to/my_mpi_executable

echo "Run complete."
date
