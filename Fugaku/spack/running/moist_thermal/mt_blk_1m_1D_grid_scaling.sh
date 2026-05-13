#!/bin/sh

for N in 1 2 4 32 128 512 1024
do
   # Determine the resource group based on node count
   if [ $N -gt 384 ]; then
      GROUP="large"
   else
      GROUP="small"
   fi


   # Create the directory first
   RUN_DIR="/vol0001/hp250099/u14261/output/output_mt_blk_1m_1D_grid_scaling_Nnode_$N"
   mkdir -p "$RUN_DIR"

   NX=$((SQRTN * 96))
   X=$((SQRTN*3600))

   echo "Submitting $N nodes to the $GROUP group. NX=$NX X=$X"

   # Pass the directory using the --working-dir flag
   pjsub --all-mount-gfscache \
	 -x "NX=$NX,X=$X" \
	 -L "node=$N" \
	 -L "rscgrp=$GROUP" \
	 -D "$RUN_DIR" \
         -o "$RUN_DIR/%j.out" \
	 moist_thermal_blk_1m_spack.sh
done
