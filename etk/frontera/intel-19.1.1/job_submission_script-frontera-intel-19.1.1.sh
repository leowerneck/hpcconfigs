#!/bin/bash

#SBATCH -J jobname         # Job name
#SBATCH -o jobname.o%j     # Name of stdout output file
#SBATCH -e jobname.e%j     # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 32              # Total # of nodes
#SBATCH -n 128             # Total # of mpi tasks
#SBATCH -t 24:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A AST20021 ##### PHY20010  # Project/Allocation name (req'd if you have more than 1)
#SBATCH --mail-user=<your_email_address>

# Any other commands must follow all #SBATCH directives...
module purge
module load intel/19.1.1 impi/19.0.9 hdf5/1.12.2 hwloc/1.11.13 gsl/2.6
module list
pwd
date

# Set thread count (default value is 1)...
export OMP_NUM_THREADS=14

# Launch MPI code...
ibrun ./cactus_intel19 -reo bns-magnetized_ls220.par
