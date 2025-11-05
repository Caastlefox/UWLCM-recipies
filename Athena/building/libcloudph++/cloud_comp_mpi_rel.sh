#!/bin/bash -l
## Nazwa zlecenia
#SBATCH -J cloud_comp_mpi
## Liczba węzłów
#SBATCH -N 1
## Ilość zadań na węzeł
#SBATCH --ntasks-per-node=1
## Ilość rdzeni na zadanie
#SBATCH --cpus-per-task=1
## Maksymalny czas trwania zlecenia (format HH:MM:SS)
#SBATCH --time=00:20:00 
## Nazwa grantu do rozliczenia zużycia zasobów
#SBATCH -A plganiso-gpu-a100
## Specyfikacja partycji
#SBATCH -p plgrid-gpu-a100
## Plik ze standardowym wyjściem
#SBATCH --output="/net/people/plgrid/plgpdziekan/output/cloud_comp_mpi.out"
## Plik ze standardowym wyjściem błędów
#SBATCH --error="/net/people/plgrid/plgpdziekan/output/cloud_comp_mpi.err"
## liczba gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=36GB

module load GCC/11.3.0 OpenMPI/4.1.4-mpi-thread-multiple Boost.MPI/1.79.0-mpi-thread-multiple HDF5/1.12.2-threadsafe CMake/3.23.1 Python/3.10.4

printenv

rm -rf /net/people/plgrid/plgpdziekan/code/libcloudphxx/build/
mkdir /net/people/plgrid/plgpdziekan/code/libcloudphxx/build/

cd ~/code/libcloudphxx/build 
# note: Boost.MPI/1.79.0-mpi-thread-multiple doesn't have boost.python (?), hence libcloudph++ Python interface won't compile and we disable it's compilation
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=mpic++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_mpi -DLIBCLOUDPHXX_FORCE_MULTI_CUDA=True -DTHRUST_INCLUDE_DIR=$CUDA_HOME/include/ -DLIBCLOUDPHXX_DISABLE_BINDINGS=True
VERBOSE=1 make -j4 install
