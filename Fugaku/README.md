PJM scripts are submitted from login nodes using:

pjsub --all-mount-gfscache SCRIPT.sh

Note that singularity runs don't work with MPI. Use spack for that. For setting Spack environment, see https://github.com/igfuw/UWLCM/blob/master/spack/fugaku/README_fugaku_spack.md
