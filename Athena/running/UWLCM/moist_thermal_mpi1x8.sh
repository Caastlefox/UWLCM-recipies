##Runs a moist thermal simulation using entire node. 8 MPI processes, each with 1 GPU and 16 CPU threads

#!/bin/bash -l
## Nazwa zlecenia
#SBATCH -J UWLCM_mpi1x8_moist_thermal
## Liczba węzłów
#SBATCH -N 1
## Ilość zadań na węzeł
#SBATCH --ntasks-per-node=8
## Ilość rdzeni na zadanie
#SBATCH --cpus-per-task=16
## Maksymalny czas trwania zlecenia (format HH:MM:SS)
#SBATCH --time=48:00:00 
## Nazwa grantu do rozliczenia zużycia zasobów
#SBATCH -A plganiso-gpu-a100
## Specyfikacja partycji
#SBATCH -p plgrid-gpu-a100
## Plik ze standardowym wyjściem
#SBATCH --output="/net/people/plgrid/plgpdziekan/output/moist_thermal/UWLCM_mpi1x8_moist_thermal.out"
## Plik ze standardowym wyjściem błędów
#SBATCH --error="/net/people/plgrid/plgpdziekan/output/moist_thermal/UWLCM_mpi1x8_moist_thermal.err"
## liczba gpu
#SBATCH --gres=gpu:8
##SBATCH --gpus-per-task=1
## single GPUS per task (exlusive GPU per task)
##SBATCH --gpu-bind=single:1
## RAM jako temp przestrzen dyskowa
##SBATCH -C memfs
## request exclusive nodes access
#SBATCH --exclusive
## request all memory on a node
#SBATCH --mem=0

#outdir_nomicro=/net/people/plgrid/plgpdziekan/wyniki/moist_thermal/${now}_out_UWLCM_mpi1x8_moist_thermal_;
#outdir_nomicro=${MEMFS}/${outname_nomicro};


#export SLURM_OVERLAP=1 # needed for GPU sharing? dont think so
module load GCC/11.3.0 OpenMPI/4.1.4-mpi-thread-multiple Boost.MPI/1.79.0-mpi-thread-multiple HDF5/1.12.2-threadsafe CMake/3.23.1 Blitz++/1.0.2 CUDA/12.2.0

now=`date +"%d_%m_%Y"`; 
outname_nomicro=${now}_out_UWLCM_moist_thermal_mpi1x8_;
outdir_nomicro=$PLG_GROUPS_STORAGE/plgguwicmw/wyniki/moist_thermal/${outname_nomicro};
outdir=${outdir_nomicro}out_lgrngn/;
mkdir ${outdir}; 

#ppr:4:numa:PE=${SLURM_CPUS_PER_TASK} means 4 processes per numa (which is socket? there are 2 processeros per node) with 128 cores for each process
#OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK} LD_LIBRARY_PATH="${LD_LIBRARY_PATH};/net/people/plgrid/plgpdziekan/builds_with_mpi/lib/" mpiexec --map-by ppr:4:numa:PE=${SLURM_CPUS_PER_TASK} --report-bindings --output-filename /net/people/plgrid/plgpdziekan/output/moist_thermal/UWLCM_mpi1x8_moist_thermal/ -merge-stderr-to-stdout -x LD_LIBRARY_PATH -x OMP_NUM_THREADS -x outdir=${outdir} \

#OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK} LD_LIBRARY_PATH="${LD_LIBRARY_PATH};/net/people/plgrid/plgpdziekan/builds_with_mpi/lib/" mpiexec --map-by slot:PE=${SLURM_CPUS_PER_TASK} --report-bindings --output-filename /net/people/plgrid/plgpdziekan/output/moist_thermal/UWLCM_mpi1x8_moist_thermal/ -merge-stderr-to-stdout -x LD_LIBRARY_PATH -x OMP_NUM_THREADS -x outdir=${outdir} \

#export UCX_TLS=rc,sm,tcp,cuda_copy # disable ib, directRDMA communications as they fail (but would be faster)
export UCX_LOG_LEVEL=info # UCX diagnostics
export UCX_PROTO_INFO=y   # ditto

#OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK} LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/net/people/plgrid/plgpdziekan/builds_with_mpi/lib/" mpiexec --map-by socket:PE=${SLURM_CPUS_PER_TASK} --report-bindings --output-filename /net/people/plgrid/plgpdziekan/output/moist_thermal/UWLCM_mpi1x8_moist_thermal/ -merge-stderr-to-stdout -x LD_LIBRARY_PATH -x OMP_NUM_THREADS -x outdir=${outdir} \
OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK} LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/net/people/plgrid/plgpdziekan/builds_with_mpi/lib/" mpiexec --map-by numa:PE=${SLURM_CPUS_PER_TASK} --report-bindings --output-filename /net/people/plgrid/plgpdziekan/output/moist_thermal/UWLCM_mpi1x8_moist_thermal/ -merge-stderr-to-stdout -x LD_LIBRARY_PATH -x OMP_NUM_THREADS -x outdir=${outdir} \
  ../bind_gpu /net/people/plgrid/plgpdziekan/builds_with_mpi/bin/uwlcm \
       	--outdir=${outdir}  --case=moist_thermal --nx=101 --ny=101 --nz=101 --dt=1 \
        --spinup=0 --nt=600 --micro=lgrngn --sd_conc=128 --backend=CUDA --outfreq=60 \
        --sstp_cond=10 --coal=0 
