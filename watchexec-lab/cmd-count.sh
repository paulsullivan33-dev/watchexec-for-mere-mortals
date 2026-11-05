#!/bin/sh
# Append one timestamped line to the runs log named by $1,
# in the lab root (outside every watched project).
LAB=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
echo "run at $(date +%H:%M:%S.%N)" >> "$LAB/$1"
echo "the command ran (log: $1)"
