#!/bin/bash
# t03: filtering. Three short watches over the same project.
#  A) -e md        : a .txt edit must NOT run the command; a .md edit must.
#  B) -i 'draft-*' : an edit to a draft must NOT run it; a normal edit must.
#  C) .gitignore   : honoured by default; --no-vcs-ignore turns that off.
LAB=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WX="$LAB/bin/watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec"
PROJ="$LAB/projects/t03"
rm -rf "$PROJ" "$LAB"/runs-t03*.log "$LAB"/wx-t03*.out
cp -r "$LAB/fixtures/fieldnotes" "$PROJ"
cd "$PROJ"
echo "scratch text" > notes/shopping.txt
echo "# Draft -- not ready" > notes/draft-ideas.md
mkdir -p scratch
echo "scratchings" > scratch/list.txt

run_watch() { # $1 label, rest = extra watchexec args
  local label=$1; shift
  "$WX" --postpone -w . "$@" -- "$LAB/cmd-count.sh" "runs-$label.log" > "$LAB/wx-$label.out" 2>&1 &
  WPID=$!
  sleep 1.5
}
stop_watch() { kill -INT $WPID 2>/dev/null; wait $WPID 2>/dev/null; }
count() { wc -l < "$LAB/runs-$1.log" 2>/dev/null || echo 0; }

echo "### A) watchexec --postpone -e md"
run_watch t03a -e md
echo "edited notes/shopping.txt" >> notes/shopping.txt; sleep 1.5
echo "runs after .txt edit: $(count t03a)"
echo "one more line" >> notes/orchard.md; sleep 1.5
echo "runs after .md edit:  $(count t03a)"
stop_watch

echo "### B) watchexec --postpone -i 'draft-*'"
run_watch t03b -i 'draft-*'
echo "more draft" >> notes/draft-ideas.md; sleep 1.5
echo "runs after draft edit:   $(count t03b)"
echo "one more line" >> notes/orchard.md; sleep 1.5
echo "runs after normal edit:  $(count t03b)"
stop_watch

echo "### C) .gitignore with scratch/ in it"
printf 'scratch/\n' > .gitignore
run_watch t03c
echo "more scratch" >> scratch/list.txt; sleep 1.5
echo "runs after scratch edit (gitignore honoured): $(count t03c)"
stop_watch
run_watch t03d --no-vcs-ignore
echo "even more scratch" >> scratch/list.txt; sleep 1.5
echo "runs after scratch edit (--no-vcs-ignore):    $(count t03d)"
stop_watch
