#!/bin/bash
#run_spark_slurm.sh

#SBATCH -J"spark"
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10GB
#  Beware! $HOME will not be expanded and invalid paths will result Slurm jobs
#  hanging indefinitely with status CG (completing) when calling scancel!
##SBATCH --output="/home/$USER/spark/logs/%j.out"
##SBATCH --error="/home/$USER/spark/logs/%j.err"
#SBATCH --time=01:00:

export SPARK_MASTER_PORT=7077
export SPARK_MASTER_WEBUI_PORT=8080
export SPARK_WORKER_CORES=$SLURM_CPUS_ON_NODE
echo "SPARK_WORKER_CORES: $SPARK_WORKER_CORES"
export SPARK_DAEMON_MEMORY=$(( $SLURM_MEM_PER_CPU * $SLURM_CPUS_ON_NODE ))m # keep the m for megabytes
echo "SPARK_DAEMON_MEMORY: $SPARK_DAEMON_MEMORY"
export SPARK_MEM=$SPARK_DAEMON_MEMORY

if [[ -z ${1} ]]; then echo "first argument must be spark singularity image file";else img=$1; fi
if [[ -e ${img} ]]; then echo "using image file $1"; else echo "no image file found $1"; fi
env
echo ""
echo "running master"

singularity exec $img start-master.sh & #e--host $SLURMD_NODENAME --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT 

echo "running slave"
# node infromation come form slurm context
srun singularity exec $img start-slave.sh --memory $SPARK_MEM $SLURMD_NODENAME:$SPARK_MASTER_PORT 
