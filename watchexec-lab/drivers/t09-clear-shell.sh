#!/bin/bash
# t09: clear screens and shells.
#  A) -c under a real terminal (script(1)): the output must
#     contain the terminal's clear-screen escape sequence.
#  B) the default shell honours redirection; --shell=none
#     cannot -- the same words become literal arguments.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t09"
rm -rf "$PROJ" "$LAB/t09.typescript" "$LAB/wx-t09b.out" "$LAB/wx-t09c.out"
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
cd "$PROJ"

echo "### A) watchexec -c, run under script(1) to give it a terminal"
timeout --signal=INT 6 script -qec "$WX -c --postpone -w . -- echo hello-after-clear" "$LAB/t09.typescript" >/dev/null 2>&1 &
sleep 2.5
echo "a change" >> notes/orchard.md
wait
ESCAPES=$(grep -o $'\033\[2J' "$LAB/t09.typescript" | wc -l)
HOMES=$(grep -o $'\033\[H' "$LAB/t09.typescript" | wc -l)
echo "clear-screen sequences (ESC [ 2J) in the recording: $ESCAPES"
echo "cursor-home sequences (ESC [ H) in the recording:   $HOMES"
echo "the command's line in the recording: $(grep -a 'hello-after-clear' "$LAB/t09.typescript" | head -1)"

echo
echo "### B) redirection: default shell vs --shell=none"
"$WX" --postpone -w . -- 'echo shell-wrote-this > shellout.txt' > "$LAB/wx-t09b.out" 2>&1 &
WPID=$!; sleep 1.5
echo "a change" >> notes/orchard.md; sleep 1.5
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null
if [ -f shellout.txt ]; then echo "default shell: shellout.txt exists, containing: $(cat shellout.txt)"; else echo "default shell: shellout.txt MISSING"; fi

# a fresh tree for the second watch, so no events leak between watches
rm -rf "$LAB/projects/t09-shell"
cp -r "$LAB/fixtures/fieldnotes" "$LAB/projects/t09-shell"
cd "$LAB/projects/t09-shell"
"$WX" -n --postpone -w . -- echo shell-wrote-this '>' shellout2.txt > "$LAB/wx-t09c.out" 2>&1 &
WPID=$!; sleep 1.5
echo "another change" >> notes/orchard.md; sleep 1.5
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null
if [ -f shellout2.txt ]; then echo "shell=none: shellout2.txt EXISTS (unexpected)"; else echo "shell=none: no shellout2.txt -- the '>' was just a word"; fi
echo "shell=none output: $(grep 'shell-wrote-this' "$LAB/wx-t09c.out" | head -1)"
