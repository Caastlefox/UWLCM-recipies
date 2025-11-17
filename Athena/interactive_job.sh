#!/bin/bash

srun -p plgrid-gpu-a100 -N 1 --ntasks-per-node=1 -t 5:00:00 --cpus-per-task=128 --gres=gpu:0 -n 1 -A plgicmw24-gpu-a100 --pty /bin/bash -l
#srun -p plgrid-gpu-a100 -N 1 --ntasks-per-node=1 -t 5:00:00 --cpus-per-task=43 --gres=gpu:8 -A plgfractal-gpu-a100 --pty /bin/bash -l
