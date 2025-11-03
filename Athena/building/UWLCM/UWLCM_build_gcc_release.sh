#!/bin/bash -l
## Nazwa zlecenia
#SBATCH -J UWLCM_comp_gcc
## Liczba węzłów
#SBATCH -N 1
## Ilość zadań na węzeł
#SBATCH --ntasks-per-node=1
## Ilość rdzeni na zadanie
#SBATCH --cpus-per-task=4
## Maksymalny czas trwania zlecenia (format HH:MM:SS)
#SBATCH --time=00:20:00 
## Nazwa grantu do rozliczenia zużycia zasobów
#SBATCH -A plgicmw24-gpu-a100
## Specyfikacja partycji
#SBATCH -p plgrid-gpu-a100
## Plik ze standardowym wyjściem
#SBATCH --output="/net/people/plgrid/plgpdziekan/output/UWLCM_comp_gcc.out"
## Plik ze standardowym wyjściem błędów
#SBATCH --error="/net/people/plgrid/plgpdziekan/output/UWLCM_comp_gcc.err"
## liczba gpu
#SBATCH --gres=gpu:1

rm -rf /net/people/plgrid/plgpdziekan/code/UWLCM/build/
mkdir /net/people/plgrid/plgpdziekan/code/UWLCM/build/

singularity exec --nv ~/singu_images/uwlcm_ubuntu_20_04_cuda_11_4.sif sh -c "cd ~/code/UWLCM/build; cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_gcc -Dlibmpdata++_DIR=$HOME/builds_with_gcc/share/libmpdata++ -Dlibcloudph++_DIR=$HOME/builds_with_gcc/builds_with_gcc/share/libcloudph++ -DUWLCM_DISABLE=\"PIGGYBACKER;2D_BLK_1M;2D_BLK_2M;3D_BLK_2M;2D_LGRNGN;2D_NONE;3D_NONE\" -DUWLCM_TIMING=1; make -j4 install"
