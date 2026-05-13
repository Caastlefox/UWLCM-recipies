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

rm -rf /home/u14261/code/libmpdataxx/libmpdata++/build/
mkdir /home/u14261/code/libmpdataxx/libmpdata++/build/

#singularity exec --nv -B $SCRATCH ~/singu_images/uwlcm_ubuntu_20_04_cuda_11_4_mvapich2_v2.sif sh -c "cd ~/code/libmpdataxx/libmpdata++/build; cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=mpic++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_mpi -DLIBCLOUDPHXX_FORCE_MULTI_CUDA=True; make -j4 install"
#singularity exec --nv -B $SCRATCH ~/singu_images/uwlcm_ubuntu_20_04_cuda_11_4.sif sh -c "cd ~/code/libmpdataxx/libmpdata++/build; cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_gcc -DLIBCLOUDPHXX_FORCE_MULTI_CUDA=True; make -j4 install"
singularity exec ~/singu_images/uwlcm_ubuntu_24_04_cuda_12_9_0_arm64.sif sh -c "cd ~/code/libmpdataxx/libmpdata++/build; cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_gcc; make -j4 install"
