#!/bin/bash
#PJM -L "rscunit=rscunit_ft01"
#PJM -L "node=1"               # Number of node
#PJM -L "rscgrp=small"         # Specify resource group
#PJM -L "elapse=60:00"         # Job run time limit value
#PJM -g hp250099               # group name
#PJM -x PJM_LLIO_GFSCACHE=/vol0002 # volume names that job uses
##PJM -x PJM_LLIO_GFSCACHE=/vol0004:/vol0005
##PJM -S                        # Direction of statistic information file output
#PJM -j
#PJM -o uwlcm_%j.out
##PJM -e uwlcm_%j.err

# export TMPDIR=/worktmp
# newgrp fugaku


#OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK} apptainer exec -B ${SCRATCH} -B ${PLG_GROUPS_STORAGE}/plgguwicmw --nv /home/u14261/singu_images/uwlcm_ubuntu_20_04_cuda_11_4.sif sh -c '
OMP_NUM_THREADS=48 singularity exec /vol0001/ra250030/u14261/singu_images/uwlcm_ubuntu_24_04_cuda_12_9_0_arm64.sif sh -c '
now=`date +"%d_%m_%Y"`; 
outname_nomicro=${now}_out_UWLCM_moist_thermal_;
outdir_nomicro=~/wyniki/moist_thermal/${outname_nomicro};
outdir=${outdir_nomicro}out_lgrngn/;
mkdir -p ${outdir}; 
LD_LIBRARY_PATH="${LD_LIBRARY_PATH};/home/u14261/builds_with_gcc/lib/" /home/u14261/builds_with_gcc/bin/uwlcm \
        --outdir=${outdir}  --case=moist_thermal --nx=96 --ny=96 --nz=96 --dt=0.5 \
        --spinup=0 --nt=120 --micro=blk_1m --sd_conc=16 --backend=OpenMP --outfreq=12 \
        --sstp_cond=5 --sstp_coal=5 --coal=1 --sgs=1 --window=0 \
        --coal_kernel=hall --term_vel=beard76 --save_vel=0
'
