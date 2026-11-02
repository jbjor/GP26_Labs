#!/bin/bash
# Build and run Lab 4 on a Roihu GPU node. The output is also saved in output.txt.
#   sbatch --account=<your-project> run.sh          default image size
#   sbatch --account=<your-project> run.sh <m>      a square m x m image
#   sbatch --account=<your-project> run.sh <m> <n>  an (m x n) image
#SBATCH --job-name=lab-4
#SBATCH --partition=gputest
#SBATCH --time=00:05:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:gh200:1
#SBATCH --output=lab4_%j.out

set -eo pipefail
if ! type module >/dev/null 2>&1; then
  export CSC_ENV_INIT_NON_INTERACTIVE=yes
  source /etc/profile.d/zz-csc-env.sh
fi
cd "${SLURM_SUBMIT_DIR}"
module load cuda
# The GPU nodes are ARM (Grace), so build here, on the node.
make -B
srun ./convolution "$@" 2>&1 | tee output.txt
