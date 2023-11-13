#!/bin/bash

# Partition options:
# Name  Priority MaxTime MaxSubmitPU
# ----------------------------------
# tiny     72    6 hrs       --
# short    36    24 hrs     1000
# reg      18    7 days      500
# long      9      --         50

# Falcon has 36 cores/node, so ntasks-per-node*cpus-per-task should equal 36

# Note 1: per-node memory is 128GB RAM, so usage above that will
# require splitting the job across more nodes with less processes/node

# Note 2: since falcon has 2 sockets/node, ntasks-per-node should be
# divisible by 2 so they can be evenly divided across the sockets

#SBATCH --job-name=my-job     # Job Name
#SBATCH -o test-results-%j    # output and error file name (%j expands to jobID)
#SBATCH --partition=long      # Queue (partition) name
#SBATCH --nodes=16            # Number of nodes
#SBATCH -n 96                 # Total number of MPI processes
#SBATCH --ntasks-per-node=6   # MPI processes per node
#SBATCH --ntasks-per-socket=3 # MPI processes per socket
#SBATCH --cpus-per-task=6     # OpenMP processes per node
#SBATCH -t 336:00:00          # run time (hh:mm:ss)

module purge
module load gcc/12.1.0 openmpi/4.1.3 hdf5/1.12.2
module list

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

echo "Preparing run:"
date

# This automatically sets the ntasks, mapping by socket/threads based on the slurm variables
mpirun -n $SLURM_NTASKS -x OMP_NUM_THREADS --map-by ppr:$SLURM_NTASKS_PER_SOCKET:socket:pe=$OMP_NUM_THREADS /path/to/my_mpi_executable -reo my.par

echo "Run complete."
date
