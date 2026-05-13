#!/bin/bash
#PJM -L "rscunit=rscunit_ft01"
#PJM -L "node=1"               # Number of node
#PJM -L "rscgrp=small"         # Specify resource group
#PJM -L "elapse=60:00"         # Job run time limit value
#PJM -g hp250099               # group name
##PJM -x PJM_LLIO_GFSCACHE=/vol0002 # volume names that job uses
##PJM -x PJM_LLIO_GFSCACHE=/vol0004:/vol0005
##PJM -S                        # Direction of statistic information file output

export TMPDIR=/worktmp
# newgrp fugaku
singularity build --fakeroot --no-setgroups /home/u14261/singu_images/uwlcm_ubuntu_24_04_cuda_12_9_0_arm64.sif /home/u14261/code/UWLCM/singularity/uwlcm_ubuntu_24_04_cuda_12_9.def
