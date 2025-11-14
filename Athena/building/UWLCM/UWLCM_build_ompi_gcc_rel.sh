#!/bin/bash -l
## Nazwa zlecenia
#SBATCH -J UWLCM_comp_ompi
## Liczba węzłów
#SBATCH -N 1
## Ilość zadań na węzeł
#SBATCH --ntasks-per-node=2
## Ilość rdzeni na zadanie
#SBATCH --cpus-per-task=4
## Maksymalny czas trwania zlecenia (format HH:MM:SS)
#SBATCH --time=00:20:00 
## Nazwa grantu do rozliczenia zużycia zasobów
#SBATCH -A plganiso-gpu-a100
## Specyfikacja partycji
#SBATCH -p plgrid-gpu-a100
## Plik ze standardowym wyjściem
#SBATCH --output="/net/people/plgrid/plgpdziekan/output/UWLCM_comp_ompi.out"
## Plik ze standardowym wyjściem błędów
#SBATCH --error="/net/people/plgrid/plgpdziekan/output/UWLCM_comp_ompi.err"
## liczba gpu
#SBATCH --gres=gpu:1

rm -rf /net/people/plgrid/plgpdziekan/code/UWLCM/build/
mkdir /net/people/plgrid/plgpdziekan/code/UWLCM/build/

module load GCC/11.3.0 OpenMPI/4.1.4-mpi-thread-multiple Boost.MPI/1.79.0-mpi-thread-multiple HDF5/1.12.2-threadsafe CMake/3.23.1 Blitz++/1.0.2 CUDA/12.2.0
#module r uwlcm_ompi

cd ~/code/UWLCM/build 
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=mpic++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_mpi -Dlibmpdata++_DIR=$HOME/builds_with_mpi/share/libmpdata++ -Dlibcloudph++_DIR=$HOME/builds_with_mpi/share/libcloudph++ -DUWLCM_TIMING=1
VERBOSE=1 make -j4 install


#-DUWLCM_DISABLE="PIGGY;2D_BLK_2M;2D_LGRNGN"
