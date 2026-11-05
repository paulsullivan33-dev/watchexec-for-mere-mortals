# The moving parts

Outcome: a map of the five parts inside
every watch, so that when a later
chapter names a behaviour — a refused
event, a settled burst, a replaced
process — you know which part produced
it and which option steers it.

## The watcher

At the bottom sits the operating
system's own change notification. On
Linux that mechanism is called
**inotify**: the kernel keeps a list of
folders you care about and hands your
program a note each time something in
them changes. macOS and Windows have
their own equivalents, and watchexec's
job at this layer is to speak to
whichever one it finds itself on. The
project's help text names `inotify` as
the backend in its example event
(transcript
`watchexec-lab/transcripts/t00-help-full.txt`).

Two consequences follow, and both get
chapters. First, the notes the kernel
hands over are small and literal — a
file was created, its data changed, its
metadata changed, it was renamed — and
one human action produces several of
them (chapter 5). Second, some file
systems cannot offer this service at
all, notably many network shares; for
those, watchexec can **poll** instead,
walking the tree on a timer and
comparing notes (chapter 13).

## The filter stack

Not every event deserves a run. Between
the watcher and the command sits a
stack of tests, applied in an order the
help text spells out: internal
priorities first, then the kinds of
filesystem event you allow, then your
explicitly watched paths, then
**ignores**, then **filters**, then
optional filter programs. An event that
survives the stack earns a run; one
that fails any test is dropped,
silently. Chapter 6 works the stack:
extension filters (`-e`), glob filters
and ignores (`-f`, `-i`), and the
ignore *files* — `.gitignore` and
friends — that watchexec reads without
being asked.

## The debouncer

Events that pass the filters do not run
the command immediately. They go to the
**debouncer**, which waits a short
while — 50 milliseconds by default —
for the burst to end. Only when the
file system has been quiet for that
long does the run begin. This is what
turns the three events of a single save
(chapter 5) into a single run, most of
the time; chapter 8 measures where
"most of the time" ends, with a save
written slowly, in chunks.

## The runner

The runner starts your command, by
default through a **shell** (chapter
11), in its own **process group**, so
that stopping the command reaches
everything the command itself started.
It reports each run with two bracketed
lines — `[Running: ...]` when the
command starts, `[Command was
successful]` or an exit report when it
ends — unless you ask for quiet
(chapter 4). Around the runner sit the
decisions that make watching practical:
what to do when a change arrives while
a run is still going (the **busy
policy**, chapter 13), whether a
long-running command should be stopped
and replaced (**restart**, chapter 9),
and what the command is told about the
change that caused it (chapter 10).

## The output

Last, the parts you see: an optional
clear of the screen before each run
(`-c`, chapter 11), optional timings,
an optional desktop notification or
bell (named in the help text,
documented-only in this guide), and
diagnostic logging at several depths
(`-v` up to `-vvvv`), including
`--print-events`, the lens chapter 5
uses to watch the event stream itself.

Check: name the five parts in order —
watcher, filters, debouncer, runner,
output — and say which one the
50-millisecond default belongs to. If
you can, the rest of the guide has
somewhere to hang.
