#!/bin/bash
# t01: the first watch. Startup run, then one edit, one more run.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t01"
rm -rf "$PROJ" "$LAB/runs-t01.log" "$LAB/wx-t01.out"
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
chmod +x "$PROJ/build.sh" "$PROJ/check.sh"

echo "watchexec: $("$WX" --version | head -1)"
echo "command: watchexec --timings -w . -- $LAB/cmd-count.sh runs-t01.log"
cd "$PROJ"
"$WX" --timings -w . -- "$LAB/cmd-count.sh" runs-t01.log > "$LAB/wx-t01.out" 2>&1 &
WXPID=$!
sleep 2
echo "runs after startup: $(wc -l < "$LAB/runs-t01.log")"
echo "--- editing notes/orchard.md (appending one line)"
echo "The pears were spoken for by noon." >> notes/orchard.md
sleep 2
echo "runs after one edit: $(wc -l < "$LAB/runs-t01.log")"
kill -INT $WXPID 2>/dev/null; wait $WXPID 2>/dev/null
echo "=== runs log ==="
cat "$LAB/runs-t01.log"
echo "=== watchexec's own output ==="
cat "$LAB/wx-t01.out"
