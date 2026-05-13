#!/bin/sh

#for N in 1 2 4 32 128 512 1024
for N in 48 96 192 480
do
   # Determine the resource group based on node count
   if [ $N -gt 384 ]; then
      GROUP="large"
   else
      GROUP="small"
   fi

   echo "Submitting $N nodes to the $GROUP group..."

   NX=$((5*96))
   NY=$((5*96))
   X=$((5*3600))
   Y=$((5*3600))

   # Create the directory first
   RUN_DIR="/vol0001/hp250099/u14261/output/output_mt_lgrngn_strong_scaling_Nnode_$N"
   mkdir -p "$RUN_DIR"

   # Pass the directory using the --working-dir flag
   pjsub --all-mount-gfscache \
	 -x "NX=$NX,NY=$NY,X=$X,Y=$Y" \
	 -L "node=$N" \
	 -L "rscgrp=$GROUP" \
	 -D "$RUN_DIR" \
         -o "$RUN_DIR/%j.out" \
	 moist_thermal_lgrngn_spack.sh
done
