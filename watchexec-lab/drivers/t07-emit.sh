#!/bin/bash
# t07: what the command is told about the change.
#  A) --emit-events-to environment: the WATCHEXEC_*_PATH vars.
#  B) --emit-events-to stdio: prefixed paths on the command's stdin.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t07"
rm -rf "$PROJ" "$LAB/env-t07.log" "$LAB/stdio-t07.log"
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
cd "$PROJ"

echo "### A) --emit-events-to environment"
"$WX" --postpone --emit-events-to environment -w . -- "$LAB/cmd-dumpenv.sh" >/dev/null 2>&1 &
WPID=$!
sleep 1.5
echo "action: modify notes/orchard.md" >> /dev/null
echo "One more line." >> notes/orchard.md; sleep 1.5
echo "A brand new note." > notes/newfile.md; sleep 1.5
mv notes/newfile.md notes/movedfile.md; sleep 1.5
rm notes/movedfile.md; sleep 1.5
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null
echo "--- env-t07.log (paths shortened to the project folder) ---"
sed "s|$PROJ|PROJECT|g" "$LAB/env-t07.log"

echo
echo "### B) --emit-events-to stdio (the command is: cat >> stdio log)"
"$WX" --postpone --emit-events-to stdio -w . -- sh -c "cat >> $LAB/stdio-t07.log" >/dev/null 2>&1 &
WPID=$!
sleep 1.5
echo "Another line." >> notes/orchard.md; sleep 1.5
echo "Short-lived." > notes/temp.md; sleep 1.5
rm notes/temp.md; sleep 1.5
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null
echo "--- stdio-t07.log (paths shortened) ---"
sed "s|$PROJ|PROJECT|g" "$LAB/stdio-t07.log"
