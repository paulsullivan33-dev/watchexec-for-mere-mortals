#!/bin/sh
# Record the WATCHEXEC_* environment variables of one run,
# appended as a block to env-t07.log in the lab root.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
{
  echo "--- a run happened; WATCHEXEC variables were:"
  env | grep '^WATCHEXEC' | sort
} >> "$LAB/env-t07.log"
echo "env dumped"
