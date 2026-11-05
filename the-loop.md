# The loop everyone builds once

Outcome: you will have built the
self-triggering watch on purpose, in a
folder where it can do no harm, counted
what it does, and learned the three
ways out — so the first time it happens
in real work, you recognise it in
seconds. The evidence is transcript
`watchexec-lab/transcripts/t04-loop.txt`.

## The setup: an innocent build

The fieldnotes builder stitches the
notes into `build/index.html` — inside
the project, inside the watch. It also
stamps each page with a build counter,
so no two builds are ever byte-identical:
build 7's page genuinely differs from
build 6's. Now watch the project and
build on change, the most natural
command in the world:

```
watchexec -w . -- ./build.sh
```

Follow it by hand. The startup run
builds the page — a change in the
watched tree. The watcher sees the
change and builds again. That build
changes the page again (the counter
moved). The watcher sees the change and
builds again. There is no step in this
story where anything is broken; every
part is doing exactly what chapter 1's
rule says it does. The only question is
how fast "again" is.

## The measurement

The lab let it run for exactly
6 seconds, then stopped it and counted
the builder's own completion lines:

```
### A) watchexec -w . -- ./build.sh   (no ignore)
builds completed in 6 seconds: 99
build counter reached: 99
```

**Ninety-nine builds in six seconds** —
about sixteen a second, each build
taking roughly sixty milliseconds
including the debounce wait. Left
alone, that is close to a million
builds a day: a hot CPU, a churned
disk, a log file growing without bound,
and a page whose build number is
meaningless. Notice what did *not* save
it: the default busy policy ignores
changes that arrive while a command is
running (chapter 13), and the loop
looped anyway — the writes that matter
land as each build finishes, in the
quiet moments between runs, which is
precisely when the watcher is listening
hardest. Do not rely on timing luck to
break a loop. Break it structurally.

## The three ways out

**Keep the output out of the watch.**
Build into a folder outside the watched
tree, or watch only the folder that
holds your sources (`-w notes` rather
than `-w .`). This is the strongest
fix: the output cannot retrigger a
watch it is not inside.

**Ignore the output.** The same watch
with one pattern added:

```
watchexec -w . -i 'build' -- ./build.sh
```

```
### B) watchexec -w . -i 'build' -- ./build.sh
builds completed in 6 seconds: 1
build counter reached: 1
```

One build — the startup run — and then
silence, while the lab watched the
clock for the same six seconds. The
output still lands in the tree; the
watcher has simply been told, in the
language of chapter 6, that nothing
under `build/` is its business.

**Filter to inputs only.** Watching by
extension (`-e md` for the notes)
achieves the same quiet from the other
direction: the builder's `.html` output
and its counter file never match the
admission list. This is the neatest fix
when the inputs share a tidy set of
extensions, and chapter 12's rebuild
watch could have used either; it uses
the ignore, because the notes' formats
may grow.

## Recognising it in the wild

The loop's signature is a watch that
never goes quiet: runs back to back
with no edits of yours between them,
the run count climbing while you watch
it, the output file's timestamp or
version stamp changing every time. The
moment you see it, stop the watcher
first and diagnose second — every
second of diagnosis costs another
sixteen runs. Then ask the one question
that matters: *what is my command
writing, and is it inside the watch?*
It always is.

Check: reproduce the lab's two numbers
in your own scratch folder — a
self-writing command, six seconds, a
count in the dozens or hundreds; then
the same watch plus `-i` for the output
folder, and a count of one. Having felt
both is worth more than reading either.
