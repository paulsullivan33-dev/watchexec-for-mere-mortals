#!/bin/bash
# t05: debounce. A "save" is simulated by writing a file in
# three chunks with pauses between them (python3 writer).
#  A) default debounce (50 ms), chunks 300 ms apart: the pauses
#     outlast the debounce, so the chunks should NOT settle
#     into one run.
#  B) --debounce 900ms, chunks 300 ms apart: one settled run.
#  C) --debounce 900ms, chunks 1500 ms apart: two runs again.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t05"
rm -rf "$PROJ" "$LAB"/runs-t05*.log
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
cd "$PROJ"

writer() { # $1 = gap in seconds between three chunks
  python3 - "$1" <<'PYEOF'
import sys, time
gap = float(sys.argv[1])
with open("notes/slow-save.md", "w") as fh:
    for chunk in ("# A slow save\n", "written in\n", "three chunks.\n"):
        fh.write(chunk); fh.flush()
        time.sleep(gap)
PYEOF
}

phase() { # $1 label, $2 gap, rest = watchexec args
  local label=$1 gap=$2; shift 2
  rm -f notes/slow-save.md
  "$WX" --postpone -w . "$@" -- "$LAB/cmd-count.sh" "runs-$label.log" >/dev/null 2>&1 &
  local wpid=$!
  sleep 1.5
  writer "$gap"
  sleep 2.5
  kill -INT $wpid 2>/dev/null; wait $wpid 2>/dev/null
  echo "$label: chunks $(python3 -c "print(f'{$gap*1000:.0f} ms apart')") -> runs: $(wc -l < "$LAB/runs-$label.log")"
}

echo "one simulated save = three writes to notes/slow-save.md"
phase t05a 0.3
phase t05b 0.3 --debounce 900ms
phase t05c 1.5 --debounce 900ms
