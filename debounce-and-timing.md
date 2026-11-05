# Debounce and timing

Outcome: you can explain what the
debounce wait is for, predict what a
slow save does to your run count, and
choose a value on purpose instead of by
superstition. The evidence is
transcript
`watchexec-lab/transcripts/t05-debounce.txt`.

## Why a save needs settling time

Chapter 5 showed one save arriving as
three events. Real editors are worse:
many write a temporary file, rename it
over the original, then touch the
timestamps — a burst of events spread
over some milliseconds. Run the command
on the *first* event and you build a
half-written file. So watchexec waits.
When events arrive, it holds them for a
**debounce** interval — 50 milliseconds
by default — and each new event that
belongs to the burst pushes the moment
of action out. Only when the file
system has been quiet for the full
interval does the command run, once,
for the whole burst. Debouncing is the
difference between "the files changed"
and "the files have finished changing,
for now".

## The experiment: one save, written slowly

The lab simulated a slow save: a small
program wrote a note in **three chunks,
with a pause between chunks**, flushing
each chunk to disk before pausing — the
shape of a big file dribbling over a
slow disk, stretched so a stopwatch can
follow it. The same three-chunk save
was then shown to three watches:

| Watch | Pause between chunks | Runs for one "save" |
| --- | --- | --- |
| default debounce, 50 ms | 300 ms | **3** |
| `--debounce 900ms` | 300 ms | **1** |
| `--debounce 900ms` | 1500 ms | **3** |

Read the table as three small lessons:

- **The default is short.** Fifty
  milliseconds settles editor bursts,
  which arrive within a few
  milliseconds of each other. It does
  not settle a save whose parts land a
  third of a second apart: each chunk
  found the file system quiet for a
  full 50 ms and earned its own run.
  Three runs, each building a more
  complete file than the last.
- **A longer debounce settles a slower
  burst.** At 900 ms, the 300 ms pauses
  never added up to a quiet interval,
  so the three chunks became one run —
  against the finished file.
- **No debounce settles everything.**
  With pauses of 1500 ms, even the
  900 ms watch ran three times. Those
  pauses were not one slow save; they
  were three separate moments of
  change, and the watcher was right
  about them. Debounce draws a line
  between "still saving" and "saved,
  then changed again", and the line is
  a choice, not a fact.

## Choosing a value

Start at the default. Reach for a
longer debounce when the evidence asks
for it — runs that fire mid-save,
builds that read half-written files,
uploads and sync tools that deliver
files in visible pieces — and lengthen
it in steps (200 ms, 500 ms, a second),
checking the run count with a counter
command as the lab did. Every extra
millisecond is latency you feel between
saving and seeing the result, so the
right value is the smallest one that
makes your saves atomic *enough*.

The syntax accepts plain milliseconds
(`--debounce 250`) but prefers a span
with units — `--debounce 900ms`,
`--debounce 2s` — and warns that the
unit-less form is deprecated. Set it to
0 only if you enjoy chapter 7: the
help text itself calls 0 "highly
discouraged".

A cousin worth knowing by name:
`--delay-run` sleeps for a set span
*after* the debounce, before each run —
the portable form of `sleep 5 &&
command`. The lab did not need it and
lists it as documented-only. And at the
far end of the dial, the manual points
out that a very long debounce (it gives
30 minutes as an example) turns a watch
into a lazy scheduler — run this at
most twice an hour, however often
things change — with the honest caveat
that the events pile up in memory while
they wait. That, too, the lab read
rather than ran.

Check: write a file in three chunks
with pauses longer than your debounce,
count the runs, then raise the debounce
above the pause and count again — 3,
then 1. When your counts match the
table's shape, the debouncer is a tool
in your hand rather than a mystery in
your terminal.
