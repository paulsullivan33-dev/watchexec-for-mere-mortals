#!/bin/sh
# The fieldnotes test: every note must open with a title line
# (a line starting with "# "). Prints PASS or FAIL per note
# and a summary; exits non-zero if any note fails.
cd "$(dirname "$0")"
fail=0
for note in notes/*.md; do
  first=$(head -n 1 "$note")
  case "$first" in
    "# "*) echo "PASS $note" ;;
    *) echo "FAIL $note -- first line is not a title: $first"; fail=1 ;;
  esac
done
if [ "$fail" -eq 0 ]; then
  echo "all notes have titles"
else
  echo "some notes are missing titles"
  exit 1
fi
