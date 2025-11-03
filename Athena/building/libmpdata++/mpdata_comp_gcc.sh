#!/bin/bash -l
## Nazwa zlecenia
#SBATCH -J mpdata_comp_gcc
## Liczba węzłów
#SBATCH -N 1
## Ilość zadań na węzeł
#SBATCH --ntasks-per-node=1
## Ilość rdzeni na zadanie
#SBATCH --cpus-per-task=1
## Maksymalny czas trwania zlecenia (format HH:MM:SS)
#SBATCH --time=00:20:00 
## Nazwa grantu do rozliczenia zużycia zasobów
#SBATCH -A plgicmw24-gpu-a100
## Specyfikacja partycji
#SBATCH -p plgrid-gpu-a100
## Plik ze standardowym wyjściem
#SBATCH --output="/net/people/plgrid/plgpdziekan/output/mpdata_comp_gcc.out"
## Plik ze standardowym wyjściem błędów
#SBATCH --error="/net/people/plgrid/plgpdziekan/output/mpdata_comp_gcc.err"
## liczba gpu
#SBATCH --gres=gpu:1

rm -rf /net/people/plgrid/plgpdziekan/code/libmpdataxx/libmpdata++/build/
mkdir  /net/people/plgrid/plgpdziekan/code/libmpdataxx/libmpdata++/build/

singularity exec --nv ~/singu_images/uwlcm_ubuntu_20_04_cuda_11_4.sif sh -c "cd ~/code/libmpdataxx/libmpdata++/build; cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=gcc -DCMAKE_INSTALL_PREFIX=$HOME/builds_with_gcc; make install"

