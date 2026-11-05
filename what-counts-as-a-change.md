# What counts as a change

Outcome: you can predict — before you
make it — whether an action will earn a
run, and you can see the raw event
stream with your own eyes when a
prediction fails. The evidence is
transcript
`watchexec-lab/transcripts/t02-events.txt`.

## The lens: --print-events

Watchexec can show you the events that
triggered each run, in readable form:

```
watchexec --postpone --print-events -w . -- echo "the command ran"
```

The lab ran exactly that (`--postpone`
suppresses the startup run, so every
run on screen belongs to an action the
lab performed) and then made six
changes, one at a time, waiting for
each run to finish before the next. The
event blocks below quote one copy per
action; the printer in fact shows each
block twice, once when the events
arrive and once when the run begins —
itself a small lesson in how much
traffic flows under one quiet edit.

## One save, three events

The first action was a single shell
command creating a note and writing one
line into it — the smallest "save" a
terminal can make:

```
echo "# A new note" > notes/new-note.md
```

The event stream for that one action:

```
kind=Create(File)          path=.../notes/new-note.md
kind=Modify(Data(Any))     path=.../notes/new-note.md
kind=Modify(Metadata(Any)) path=.../notes/new-note.md
```

Three events. The file came into
existence; its **data** changed (the
line went in); its **metadata** changed
(size and timestamps are metadata, and
writing data moves them). This is the
operating system's view of a save, and
it is always like this: an editor save
is several events — often more than
three, since many editors write a
temporary file and rename it over the
original. The run count, though, was
one: settling a burst like this into a
single run is the debouncer's whole job
(chapter 8).

## The kinds, one action at a time

| Your action | Events the lab saw | Run? |
| --- | --- | --- |
| Create a file and write a line | Create(File), Modify(Data), Modify(Metadata) | yes |
| Append a line to an existing file | Modify(Data), Modify(Metadata) | yes |
| Rename a file | Modify(Name(From)) for the old path, Modify(Name(To)) for the new, Modify(Name(Both)) naming the pair | yes |
| `chmod 600` a file, touching nothing else | Modify(Metadata) alone | yes |
| Delete a file | Remove(File) | yes |
| Create a folder | Create(Folder) | yes |
| Press Ctrl-C | an event with source Keyboard, signal Interrupt | stops the watcher |

Points worth carrying away:

- **Metadata counts.** Permissions,
  timestamps, ownership — a change to
  any of them is a change, and the
  `chmod` row earned its run with no
  data moving at all. If that is noise
  for your work, `--no-meta` tells
  watchexec to disregard metadata
  events; the lab names it here from
  the help text and did not need it.
- **A rename is three events too** —
  one for the name left behind, one for
  the name taken up, one for the pair —
  and even watchexec's own help warns
  that rename reporting is the least
  reliable part of the stream: a rename
  can arrive as only one half, or split
  across a debounce boundary into two
  runs. The limits chapter returns to
  this.
- **Reading is not a change.** By
  default watchexec ignores *access*
  events entirely — opening a file does
  not earn a run. The `--fs-events`
  option chooses which kinds pass at
  all: `access`, `create`, `remove`,
  `rename`, `modify`, `metadata`, with
  everything except `access` admitted
  by default (from `watchexec --help`,
  transcript t00).
- **Folders are files for this
  purpose.** Creating a directory is a
  Create event with its own kind, and
  it earns a run like any other.

## Why this chapter earns its place

Every surprise in the troubleshooting
chapter is one of these rows behaving
exactly as documented while a human
expected something else: the run that
fired on a `chmod`, the double run when
a rename split in half, the editor
whose save pattern writes three files
where you see one. When a watch
misbehaves, reach for `--print-events`
before changing any setting: the stream
is the ground truth, and it is usually
more interesting than the guess.

Check: with `--print-events` running,
create a file, rename it, and delete
it, and name each event kind before the
run it triggers finishes printing. If
your naming matches the stream three
times running, you can read any watch
you own.
