#!/bin/bash
# t04: the loop everyone builds once. The build command writes
# build/index.html inside the watched project, and every build
# differs (a counter), so each run triggers the next.
#  A) no ignore: count the builds in 6 seconds.
#  B) -i 'build': the same setup must settle at exactly 1 build.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t04"
rm -rf "$PROJ" "$LAB/wx-t04a.out" "$LAB/wx-t04b.out"
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
chmod +x "$PROJ/build.sh"
cd "$PROJ"

echo "### A) watchexec -w . -- ./build.sh   (no ignore)"
timeout --signal=INT 6 "$WX" -w . -- ./build.sh > "$LAB/wx-t04a.out" 2>&1
echo "builds completed in 6 seconds: $(grep -c '^built' "$LAB/wx-t04a.out")"
echo "build counter reached: $(cat build/.counter)"

rm -rf build
echo
echo "### B) watchexec -w . -i 'build' -- ./build.sh"
timeout --signal=INT 6 "$WX" -w . -i 'build' -- ./build.sh > "$LAB/wx-t04b.out" 2>&1
echo "builds completed in 6 seconds: $(grep -c '^built' "$LAB/wx-t04b.out")"
echo "build counter reached: $(cat build/.counter)"
echo "--- watchexec output, run B (complete) ---"
cat "$LAB/wx-t04b.out"
