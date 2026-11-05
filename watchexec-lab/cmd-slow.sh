#!/bin/sh
# A slow command for the on-busy-update experiment: it takes
# three seconds, marking its start and end in a log.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
echo "slow run started $(date +%H:%M:%S)" >> "$LAB/$1"
sleep 3
echo "slow run finished $(date +%H:%M:%S)" >> "$LAB/$1"
