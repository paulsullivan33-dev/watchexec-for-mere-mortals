#!/bin/bash
# t10: two real jobs.
#  A) rebuild the site on every note edit (build/ ignored).
#  B) re-run the note checks on every edit: break a note,
#     watch it FAIL, fix it, watch it PASS. The watcher keeps
#     watching after the failure.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t10"
rm -rf "$PROJ" "$LAB/wx-t10a.out" "$LAB/wx-t10b.out"
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
chmod +x "$PROJ/build.sh" "$PROJ/check.sh"
cd "$PROJ"

echo "### A) watchexec -w . -i 'build' -- ./build.sh"
"$WX" -w . -i 'build' -- ./build.sh > "$LAB/wx-t10a.out" 2>&1 &
WPID=$!; sleep 2
echo "new sentence for the site" >> notes/orchard.md
echo "The lane floods every February." >> notes/first-walk.md
sleep 2
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null
echo "builds run: $(grep -c '^built' "$LAB/wx-t10a.out")"
echo "new sentence present in build/index.html? $(grep -c 'The lane floods every February' build/index.html) occurrence(s)"
cat "$LAB/wx-t10a.out"

echo
echo "### B) watchexec --postpone -e md -w . -- ./check.sh"
"$WX" --postpone -e md -w . -- ./check.sh > "$LAB/wx-t10b.out" 2>&1 &
WPID=$!; sleep 1.5
printf 'This note has no title line.\nIt just starts talking.\n' > notes/untitled.md
sleep 2
sed -i '1i # The untitled note, titled' notes/untitled.md
sleep 2
kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null
cat "$LAB/wx-t10b.out"
