#!/bin/bash
# t02: what counts as a change. --print-events shows the events
# that triggered each run: create, modify, rename, remove, metadata.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t02"
rm -rf "$PROJ" "$LAB/wx-t02.out"
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"

cd "$PROJ"
"$WX" --postpone --print-events -w . -- echo "the command ran" > "$LAB/wx-t02.out" 2>&1 &
WXPID=$!
sleep 1.5

echo "=== action: create notes/new-note.md"
echo "# A new note" > notes/new-note.md
sleep 1.5
echo "=== action: modify notes/new-note.md"
echo "Some text in the new note." >> notes/new-note.md
sleep 1.5
echo "=== action: rename notes/new-note.md to notes/renamed-note.md"
mv notes/new-note.md notes/renamed-note.md
sleep 1.5
echo "=== action: metadata only -- chmod notes/renamed-note.md"
chmod 600 notes/renamed-note.md
sleep 1.5
echo "=== action: remove notes/renamed-note.md"
rm notes/renamed-note.md
sleep 1.5
echo "=== action: create a folder notes/sketches"
mkdir notes/sketches
sleep 1.5

kill -INT $WXPID 2>/dev/null; wait $WXPID 2>/dev/null
echo "=== watchexec output with --print-events ==="
cat "$LAB/wx-t02.out"
