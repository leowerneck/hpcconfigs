#!/bin/bash
#
# Teton job script
#
# 384 cores / node
# 192 cores / socket, 2 sockets / node

#SBATCH --job-name=<name>
#SBATCH --nodes=2
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=16
#SBATCH --ntasks-per-socket=8
#SBATCH --cpus-per-task=24
#SBATCH --time=48:00:00
#SBATCH --output=bns-%j.out
#SBATCH --error=bns-%j.err
#SBATCH --wckey=edu_res
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<your email>
#SBATCH --exclusive

export ET_ENV_DIR=<path to you environment>

. "${ET_ENV_DIR}/env.sh"
module list

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export CACTUS_NUM_THREADS=$OMP_NUM_THREADS

srun ./cactus_sim -reo "${SLURM_JOB_NAME}.par"

echo "All done!"
