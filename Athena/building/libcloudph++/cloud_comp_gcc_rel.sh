#!/bin/bash -l
## Nazwa zlecenia
#SBATCH -J cloud_comp_gcc_rel
## Liczba węzłów
#SBATCH -N 1
## Ilość zadań na węzeł
#SBATCH --ntasks-per-node=1
## Ilość rdzeni na zadanie
#SBATCH --cpus-per-task=4
## Maksymalny czas trwania zlecenia (format HH:MM:SS)
#SBATCH --time=00:20:00 
## Nazwa grantu do rozliczenia zużycia zasobów
#SBATCH -A plganiso-gpu-a100
## Specyfikacja partycji
#SBATCH -p plgrid-gpu-a100
## Plik ze standardowym wyjściem
#SBATCH --output="/net/people/plgrid/plgpdziekan/output/cloud_comp_gcc_rel.out"
## Plik ze standardowym wyjściem błędów
#SBATCH --error="/net/people/plgrid/plgpdziekan/output/cloud_comp_gcc_rel.err"
## liczba gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=36GB


rm -rf /net/people/plgrid/plgpdziekan/code/libcloudphxx/build/
mkdir /net/people/plgrid/plgpdziekan/code/libcloudphxx/build/

#singularity exec --nv -B $SCRATCH ~/singu_images/uwlcm_ubuntu_20_04_cuda_11_4_mvapich2_v2.sif sh -c "cd ~/code/libcloudphxx/build; cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=mpic++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_mpi -DLIBCLOUDPHXX_FORCE_MULTI_CUDA=True; make -j4 install"
singularity exec --nv -B $SCRATCH ~/singu_images/uwlcm_ubuntu_20_04_cuda_11_4.sif sh -c "cd ~/code/libcloudphxx/build; cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_gcc -DLIBCLOUDPHXX_FORCE_MULTI_CUDA=True; make -j4 install"

