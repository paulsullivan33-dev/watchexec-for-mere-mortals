#!/bin/sh
# Build the fieldnotes site: stitch every note into one page.
# The page lands in build/, inside the watched project, and it
# carries a build counter, so no two builds are ever identical.
set -e
cd "$(dirname "$0")"
mkdir -p build
count=0
if [ -f build/.counter ]; then
  count=$(cat build/.counter)
fi
count=$((count + 1))
echo "$count" > build/.counter
{
  echo "<h1>Fieldnotes</h1>"
  echo "<p>Build number $count</p>"
  for note in notes/*.md; do
    echo "<article>"
    cat "$note"
    echo "</article>"
  done
} > build/index.html
echo "built build/index.html (build number $count)"
