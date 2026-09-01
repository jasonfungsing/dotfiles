#!/bin/sh
# GPU utilisation for the tmux status bar (see status-right in tmux.conf).
# The tmux-cpu plugin's #{gpu_percentage} only knows nvidia-smi/cuda-smi,
# so on Apple Silicon it prints "No GPU" — this reads the integrated
# GPU's load from the IORegistry instead, which needs no sudo. Averages
# across accelerators in case ioreg reports more than one.
ioreg -r -d 1 -w 0 -c IOAccelerator 2>/dev/null |
  grep -o '"Device Utilization %"=[0-9]*' |
  awk -F'=' '{sum+=$2; n++} END {if (n) printf "%d%%", sum/n; else printf "n/a"}'
