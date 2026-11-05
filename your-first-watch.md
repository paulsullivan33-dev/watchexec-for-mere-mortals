# Your first watch

Outcome: a real watch running against a
real folder — a run when it starts, a
run when you edit, and watchexec's own
messages read and understood. The
evidence is transcript
`watchexec-lab/transcripts/t01-first-watch.txt`.

## The setup

The lab's fixture project is called
**fieldnotes**: two Markdown notes in
`notes/`, and some small scripts the
later chapters use. For this chapter
the command being watched is simpler
than any of them — a counter script
that appends one timestamped line to a
log *outside* the watched folder each
time it runs, so the lab can count runs
exactly. Your first watch can be
anything harmless; counting is clearer
with a command whose whole job is to
leave a mark.

Start the watch from inside the
project:

```
watchexec --timings -w . -- ./count-runs.sh
```

Read it left to right: `--timings`
asks watchexec to report how long each
run took; `-w .` watches the current
folder, recursively; `--` ends
watchexec's own options; everything
after it is the command.

## The startup run

Before you touch anything, the command
runs **once**. The help text says so in
its first paragraph — "At startup, the
specified command is run once" — and
the lab's count agrees: one line in the
log before any edit. Watchexec prints
its own frame around the run:

```
[Running: ./count-runs.sh]
the command ran (log: runs-t01.log)
[Command was successful, lasted 5ms]
```

Three voices, worth telling apart.
`[Running: ...]` and `[Command was
successful, lasted 5ms]` are
**watchexec speaking** — the second
line carries the timing because
`--timings` was given. The middle line
is the command's own output. When a run
fails, watchexec's closing line says so
instead — chapter 12 shows
`[Command exited with 1]` — and the
watch carries on regardless.

If the bracketed lines are noise in
your setup, `-q` (quiet) turns them
off, leaving only your command's voice.
The lab kept them on: while you are
learning, watchexec's frame is the
easiest proof that a run happened at
all.

## One edit, one run

Now edit a watched file — the lab
appended one line to `notes/orchard.md`
— and the command runs again, once:

```
runs after startup: 1
runs after one edit:  2
```

Exactly one run for one edit. Hold on
to how much machinery hides inside that
"exactly": the edit produced several
filesystem events (chapter 5 counts
three for a single shell save), the
filters passed them, and the debouncer
settled them into a single run
(chapter 8). One edit, one run is the
*achievement*, not the raw behaviour of
the file system — and most of this
guide is about the places it can come
apart: outputs that retrigger (chapter
7), slow saves that split (chapter 8),
changes that arrive mid-run (chapter
13).

## Stopping

Ctrl-C stops the watcher. Watchexec
treats even that as an event — the
event chapter's transcript ends with
one whose source is Keyboard and whose
signal is Interrupt — stops any running
command politely (chapter 9 covers the
signals), and exits. A watcher left
running in a forgotten terminal keeps
working, unattended, indefinitely; the
lab's own clear-screen test left two
watchers alive after their terminal
session closed, and they had to be
stopped by hand. Make stopping a habit,
not an afterthought: the rule from
chapter 1 does not sleep just because
you have.

Check: start the watch, confirm the
startup run, make one edit, and confirm
the count moves by exactly one. Then
stop it with Ctrl-C and confirm the
prompt comes back. That is the whole
tool, working — the next chapters take
it apart.
