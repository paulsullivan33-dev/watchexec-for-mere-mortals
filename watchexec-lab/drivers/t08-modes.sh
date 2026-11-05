#!/bin/bash
# t08: working modes.
#  A) --postpone: no run at startup; the first change runs it.
#  B) busy, default (-o do-nothing): a change during a 3-second
#     run is ignored -- no second run.
#  C) busy, -o queue: the same change earns exactly one re-run.
#  D) --poll 500ms: no kernel watcher, same visible behaviour.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t08"
rm -rf "$PROJ" "$LAB"/runs-t08*.log "$LAB"/slow-t08*.log
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
cd "$PROJ"
count() { wc -l < "$LAB/$1" 2>/dev/null || echo 0; }

echo "### A) --postpone"
"$WX" --postpone -w . -- "$LAB/cmd-count.sh" runs-t08a.log >/dev/null 2>&1 &
WPID=$!; sleep 2
echo "runs 2s after startup, nothing changed: $(count runs-t08a.log)"
echo "a change" >> notes/orchard.md; sleep 1.5
echo "runs after the first change:            $(count runs-t08a.log)"
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null

echo "### B) change during a run, default on-busy-update (do-nothing)"
"$WX" -w . -- "$LAB/cmd-slow.sh" slow-t08b.log >/dev/null 2>&1 &
WPID=$!; sleep 1   # the slow run is now under way (3 seconds)
echo "a change during the run" >> notes/orchard.md
sleep 6            # let the run finish and any queue drain
echo "slow runs started: $(grep -c started "$LAB/slow-t08b.log")"
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null

echo "### C) change during a run, -o queue"
"$WX" -o queue -w . -- "$LAB/cmd-slow.sh" slow-t08c.log >/dev/null 2>&1 &
WPID=$!; sleep 1
echo "a change during the run" >> notes/orchard.md
sleep 9
echo "slow runs started: $(grep -c started "$LAB/slow-t08c.log")"
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null

echo "### D) --poll 500ms"
"$WX" --poll 500ms --postpone -w . -- "$LAB/cmd-count.sh" runs-t08d.log >/dev/null 2>&1 &
WPID=$!; sleep 1.5
echo "a change under polling" >> notes/orchard.md; sleep 2.5
echo "runs after one edit under polling: $(count runs-t08d.log)"
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null
