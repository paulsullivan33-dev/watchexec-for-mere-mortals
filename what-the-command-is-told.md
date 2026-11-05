# What the command is told

Outcome: you know what your command can
learn about the change that triggered
it — in each of watchexec's reporting
modes, and in the default, which will
surprise you. The evidence is
transcripts
`watchexec-lab/transcripts/t07-emit.txt`
and `t11-emit-default-and-json.txt`.

## By default: nothing

A command that rebuilds "whatever
changed" would like the list of changed
files. It is natural to assume
watchexec hands it over automatically.
In 2.8.0 it does not: event reporting
defaults to `--emit-events-to none`,
and the lab proved the default by
running a command whose only job was to
record every `WATCHEXEC` variable in
its environment after a real edit:

```
--- a run happened; WATCHEXEC variables were:
(nothing at all)
```

The run happened; the environment was
silent. (Versions before 2.0 reported
to the environment by default, which is
why older write-ups describe variables
you will not see.) If your command
needs the news, you must ask for it.
There are four channels.

## The environment: --emit-events-to environment

The legacy channel, deprecated but
completely functional, sets variables
naming the changed paths. The lab
turned it on and made four changes, one
at a time:

| Action | Variables the run received |
| --- | --- |
| Modify `notes/orchard.md` | `WATCHEXEC_COMMON_PATH=…/notes`, `WATCHEXEC_WRITTEN_PATH=orchard.md`, `WATCHEXEC_META_CHANGED_PATH=orchard.md` |
| Create `notes/newfile.md` | `WATCHEXEC_CREATED_PATH=newfile.md` (and WRITTEN and META_CHANGED beside it) |
| Rename it to `movedfile.md` | `WATCHEXEC_RENAMED_PATH=movedfile.md:newfile.md` |
| Delete `movedfile.md` | `WATCHEXEC_REMOVED_PATH=movedfile.md` |

The full cast: `WATCHEXEC_CREATED_PATH`,
`WATCHEXEC_REMOVED_PATH`,
`WATCHEXEC_RENAMED_PATH`,
`WATCHEXEC_WRITTEN_PATH`,
`WATCHEXEC_META_CHANGED_PATH`, and
`WATCHEXEC_OTHERWISE_CHANGED_PATH` for
anything else. Three honest wrinkles,
all visible in the table:

- **Paths are relative** to
  `WATCHEXEC_COMMON_PATH`, the longest
  folder all the changed paths share.
  Prepend it to each name to get the
  real path. Several paths in one
  variable are separated by `:` on
  Unix, deduplicated and sorted.
- **One action sets several
  variables.** An append is a write
  *and* a metadata change; a creation
  by writing is a create *and* a write.
  The variables describe the events,
  not your intention.
- **Rename order is not promised.** The
  lab's rename arrived as
  `movedfile.md:newfile.md` — new name
  first — and the help text warns
  explicitly that neither order, nor
  even both halves arriving, is
  guaranteed on every platform. Build
  nothing on rename order.

The mode is deprecated because the
environment is a cramped, fragile
place to put a list — a huge change set
can overflow it — and the project says
it will be removed one day. It is also,
today, the channel every shell script
already knows how to read.

## Standard input: --emit-events-to stdio

The modern text channel writes the
changed paths to the **command's
standard input**, one per line, each
prefixed with the kind — `create:`,
`remove:`, `rename:`, `modify:`,
`other:` — as absolute paths, then
closes the input. The lab's command was
a bare `cat` into a log:

```
modify:…/notes/orchard.md
modify:…/notes/orchard.md
modify:…/notes/orchard.md
modify:…/notes/orchard.md
```

One append, **four identical lines**:
this channel reports the events in the
batch, unreconciled — chapter 5's
burst, delivered raw. A command that
consumes it must deduplicate (and must
actually read its input, or decline
the channel; a command that never
reads stdin simply never sees the
news). The `file` mode writes the same
lines to a temporary file instead, and
hands over its path in
`$WATCHEXEC_EVENTS_FILE` — read about
in the help text, not run in the lab.

## JSON: --emit-events-to json-stdio

For programs, the same events as JSON,
one object per line, with structured
tags for the source, the event kind
(here shown shortened by line wrapping
from a single line as delivered), and
the path:

```
{"tags":[{"kind":"source","source":"filesystem"},
{"kind":"fs","simple":"modify","full":"Modify(Data(Any))"},
{"kind":"path","absolute":"…/notes/orchard.md","filetype":"file"}]}
{"tags":[ …, {"kind":"fs","simple":"modify","full":"Modify(Metadata(Any))"}, … ]}
```

One append, two events — Data and
Metadata — each fully described. This
is the channel to build on if the
consumer is a program of yours: no
parsing of prefixes, no environment
limits, no ambiguity about what kind
of thing happened. `json-file` is its
file-writing twin, also documented
here rather than run.

A postscript for the curious: `--only-emit-events`
runs watchexec with **no command at
all**, as a pure event source for other
tooling. The lab names it from the help
text; everything it emits, the channels
above already showed.

Check: run the environment-dumping
command once with no reporting flag —
silence — and once with
`--emit-events-to environment`, edit
one file, and read the variables your
run received. Explaining why
`WATCHEXEC_COMMON_PATH` must be
prepended, in one sentence, means the
chapter did its work.
