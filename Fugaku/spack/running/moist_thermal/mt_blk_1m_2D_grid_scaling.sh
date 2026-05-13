#!/bin/sh

#for N in 1 4 16 256 1024
for N in 4 256 1024 
do
   # Determine the resource group based on node count
   if [ $N -gt 384 ]; then
      GROUP="large"
   else
      GROUP="small"
   fi


   # Create the directory first
   RUN_DIR="/vol0001/hp250099/u14261/output/output_mt_blk_1m_2D_grid_scaling_Nnode_$N"
   mkdir -p "$RUN_DIR"

   SQRTN=$(echo "sqrt($N)" | bc)
   NX=$((SQRTN * 96))
   NY=$((SQRTN * 96))
   X=$((SQRTN*3600))
   Y=$((SQRTN*3600))

   echo "Submitting $N nodes to the $GROUP group. SQRTN=$SQRTN NX=$NX NY=$NY X=$X Y=$Y"

   # Pass the directory using the --working-dir flag
   pjsub --all-mount-gfscache \
	 -x "NX=$NX,NY=$NY,X=$X,Y=$Y" \
	 -L "node=$N" \
	 -L "rscgrp=$GROUP" \
	 -D "$RUN_DIR" \
         -o "$RUN_DIR/%j.out" \
	 moist_thermal_blk_1m_spack.sh
done
