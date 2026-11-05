#!/bin/bash
# t06: restart mode. A fixture server on 127.0.0.1:18093 reads
# banner.txt once at startup. Editing the banner must replace
# the process: new PID serving, old PID gone, and the old
# process must have received SIGTERM (its own log says so).
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t06"
rm -rf "$PROJ" "$LAB/wx-t06.out" "$LAB/projects/signals.log"
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
cd "$PROJ"

"$WX" -r -w . -- python3 serve.py > "$LAB/wx-t06.out" 2>&1 &
WXPID=$!
sleep 2.5
echo "--- first fetch:"
RESP1=$(curl -s http://127.0.0.1:18093/)
echo "$RESP1"
PID1=$(echo "$RESP1" | sed -n 's/served by pid: //p')
echo "--- editing banner.txt"
echo "Fieldnotes, second edition, revised" > banner.txt
sleep 2.5
echo "--- second fetch:"
RESP2=$(curl -s http://127.0.0.1:18093/)
echo "$RESP2"
PID2=$(echo "$RESP2" | sed -n 's/served by pid: //p')
echo "--- old pid $PID1 alive?"
if kill -0 "$PID1" 2>/dev/null; then echo "YES (still running)"; else echo "no, it is gone"; fi
echo "--- new pid $PID2 alive?"
if kill -0 "$PID2" 2>/dev/null; then echo "yes"; else echo "NO"; fi
kill -INT $WXPID 2>/dev/null; wait $WXPID 2>/dev/null
sleep 0.5
echo "--- signals log (written by the servers themselves):"
cat "$LAB/projects/signals.log" 2>/dev/null
echo "--- watchexec output:"
cat "$LAB/wx-t06.out"
