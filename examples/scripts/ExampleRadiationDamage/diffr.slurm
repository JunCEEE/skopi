#!/bin/bash
#SBATCH --job-name=skopi
#SBATCH --partition=allgpu
##SBATCH --partition=exfel
##SBATCH --partition=exfel-spb
#SBATCH --constraint=GPU
#SBATCH --nodes=1
#SBATCH --time=1-01:00:00
#SBATCH --output=log.diffr-%j

source /etc/profile.d/modules.sh
module purge

#module load maxwell openmpi/3.1.6
source  /gpfs/exfel/data/user/juncheng/miniconda3/bin/activate skopi

#MCA=' --mca btl_openib_warn_no_device_params_found 0 --mca pml ucx --mca mpi_cuda_support 0 -x UCX_NET_DEVICES=mlx5_0:1 '

export OMP_NUM_THREADS=1

DATADIR=./
SCRATCH=/gpfs/exfel/data/scratch/juncheng
SPATH=$SCRATCH/$SLURM_JOB_NAME.$SLURM_JOB_ID
echo SCRATCH_PATH=$SPATH
BIN=/gpfs/exfel/data/user/juncheng/skopi/bin/radiationDamageMPI

# Show nodes hostnames
mpirun --map-by node -np $SLURM_JOB_NUM_NODES  hostname

# output file name without extension suffix
#IN_DIR=/beegfs/desy/user/juncheng/hydratedProject/w4_noW/pmi_out
IN_DIR=/gpfs/exfel/data/user/juncheng/skopi/examples/scripts/ExampleRadiationDamage
OUT_DIR=diffr

### Clean up previous run
rm -r ${OUT_DIR}.h5 ${OUT_DIR}

# export SIMEX_VERBOSE=ON
mkdir -p $SPATH/${OUT_DIR}
#MCA=' --mca btl_openib_warn_no_device_params_found 0 --mca pml ucx --mca mpi_cuda_support 0 '
# MCA=' --mca btl_openib_warn_no_device_params_found 0  '
#mpirun $MCA --map-by node --bind-to none -x OMP_NUM_THREADS=1 $BIN \
$BIN \
    --inputDir $IN_DIR  \
    --outputDir $SPATH/$OUT_DIR  \
	--uniformRotation 1 \
    --geomFile ./agipd_simple_2d.geom   \
    --calculateCompton 1   \
    --sliceInterval 10   \
    --numSlices 100   \
    --pmiStartID 1   \
    --pmiEndID 1   \
    --numDP 1
# cp -r $SPATH/${OUT_DIR}.h5 $SPATH/${OUT_DIR} $DATADIR
cp -r $SPATH/${OUT_DIR} $DATADIR

err=$?
if  [ $err != 0 ]
then
    echo Copy is not successful, please check $SPATH
else
    python /gpfs/exfel/data/user/juncheng/hydratedProject/src/program/externalLink.py $OUT_DIR
    rm -rf $SPATH
fi
