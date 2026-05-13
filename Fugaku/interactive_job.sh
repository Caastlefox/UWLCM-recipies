#!/bin/bash
pjsub --interact --sparam wait-time=90 -L "rscunit=rscunit_ft01,rscgrp=int,node=1,elapse=1:30:00" -g hp250099 --no-check-directory -x PJM_LLIO_GFSCACHE=/vol0004
# /vol0004 required by spack (https://riken-rccs.github.io/fugaku-doc/docs/user-guide/sys-use/fugakuspackguide/build/en/intro.html#installation-and-management-of-packages)

