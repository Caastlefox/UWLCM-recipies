#!/bin/bash
# 4 MPI ranks per node (1 for each CMG)
##PJM --mpi "max-proc-per-node=4"
#PJM --mpi "max-proc-per-node=1"
#PJM --mpi  "rank-map-bynode"

#PJM -L "rscunit=rscunit_ft01"
#PJM -L "node=1"              # Number of nodes (1D)
#PJM -L "rscgrp=small"         # Specify resource group
#PJM -L "elapse=60:00"         # Job run time limit value
#PJM -g hp250099               # group name
#PJM -x PJM_LLIO_GFSCACHE=/vol0002:/vol0001 # volume names that job uses
##PJM -x PJM_LLIO_GFSCACHE=/vol0004:/vol0005
##PJM -S                        # Direction of statistic information file output
#PJM -j
##PJM -e /vol0006/mdt1/home/u14261/run_scripts/spack/moist_thermal/outerr/mt_blk_1m_%j.err
##PJM --working-dir "/vol0001/hp250099/u14261/output"
#PJM -D /vol0001/hp250099/u14261/output/moist_thermal_blk_1m
#PJM -o /vol0001/hp250099/u14261/output/moist_thermal_blk_1m/%j.out

# export TMPDIR=/worktmp
# newgrp fugaku


##1. Trigger LLIO cache of private spack packages staging asynchronously
#while IFS= read -r dir; do
#    if [ -n "$dir" ]; then
#        /home/system/tool/dir_transfer "$dir" &
#    fi
#done < $HOME/uwlcm_spack_env/spack_cache_dirs.txt
#
# Trigger async llio cache of uwlcm libcloud nad libmpdata
/home/system/tool/dir_transfer /vol0006/mdt1/home/u14261/spack/opt/spack/linux-a64fx & # location of my privately installed spack packages
/home/system/tool/dir_transfer /vol0001/hp250099/u14261/builds_with_spack_mpi/ & # location of built UWLCM, libcloud, libmpdata

# 2. Setup OpenMP for Fujitsu
#export OMP_NUM_THREADS=12
export PARALLEL=48
export OMP_NUM_THREADS=${PARALLEL}
#export OMP_PROC_BIND=close # requried for GCC (Fujitsu compiler does this itself)
#export OMP_PLACES=cores # required for GCC (Fujitsu compiler does this itself)

# 3. Setup Spack Environment
source $HOME/spack/share/spack/setup-env.sh
spack env activate $HOME/uwlcm_spack_env

PJM_OUTPATH_STRIPPED=${PJM_STDOUT_PATH%/*}
echo ${PJM_OUTPATH_STRIPPED}

# 4. Wait for LLIO transfers to complete
wait

# 5. Launch


now=`date +"%d_%m_%Y"`; 
outname_nomicro=${now}_out_UWLCM_moist_thermal_Nnode_${PJM_NODE}_;
outdir_nomicro=/vol0001/hp250099/u14261/wyniki/moist_thermal/${outname_nomicro};
#outdir=${outdir_nomicro}out_lgrngn/;
outdir=${outdir_nomicro}out_blk_1m/;
mkdir -p ${outdir}; 

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH};/vol0001/hp250099/u14261/builds_with_spack_mpi/lib/" 

#NX=$(( PJM_NODE * 96 ))
#X=$(( PJM_NODE * 1200 ))
NX=${NX:-96}
NY=${NY:-96}
X=${X:-3600}
Y=${Y:-3600}

echo "NX=$NX, NY=$NY, X=$X, Y=$Y"

mpiexec /vol0001/hp250099/u14261/builds_with_spack_mpi/bin/uwlcm \
        --outdir=${outdir}  --case=moist_thermal --nx=${NX} --ny=${NY} --nz=96 --dt=0.5 \
        --spinup=0 --nt=120 --micro=blk_1m --outfreq=120 \
        --sgs=1 --window=0 \
        --save_vel=0 --X=${X} --Y=${Y} 

mkdir -p ${PJM_OUTPATH_STRIPPED}/${PJM_JOBID}
mv *${PJM_JOBID}* ${PJM_OUTPATH_STRIPPED}/${PJM_JOBID}/
