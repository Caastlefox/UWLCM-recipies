#!/bin/bash
#PJM -L "rscunit=rscunit_ft01"
#PJM -L "node=1"               # Number of node
#PJM -L "rscgrp=small"         # Specify resource group
#PJM -L "elapse=60:00"         # Job run time limit value
#PJM -g hp250099               # group name
##PJM -x PJM_LLIO_GFSCACHE=/vol0002 # volume names that job uses
#PJM -x PJM_LLIO_GFSCACHE=/vol0004:/vol0005
##PJM -S                        # Direction of statistic information file output

# export TMPDIR=/worktmp
# newgrp fugaku

rm -rf /home/u14261/code/UWLCM/build/
mkdir /home/u14261/code/UWLCM/build/

singularity exec ~/singu_images/uwlcm_ubuntu_24_04_cuda_12_9_0_arm64.sif sh -c "cd ~/code/UWLCM/build; cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_gcc -Dlibmpdata++_DIR=$HOME/builds_with_gcc/share/libmpdata++ -Dlibcloudph++_DIR=$HOME/builds_with_gcc/builds_with_gcc/share/libcloudph++ -DUWLCM_DISABLE=\"PIGGYBACKER;2D_BLK_1M;2D_BLK_2M;3D_BLK_2M;2D_LGRNGN;2D_NONE;3D_NONE\" -DUWLCM_TIMING=1; make -j4 install"
