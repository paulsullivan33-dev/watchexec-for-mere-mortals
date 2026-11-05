# Troubleshooting

Outcome: the surprises every watchexec
user meets once, each with the check
that names it. Every one of these
happened in this guide's lab or follows
from a setting the lab measured, and
the fix is a chapter that already
exists — this page is the index of
mishaps.

## "It never runs"

Work the stack from the outside in.
First: is it postponed? A `--postpone`
watch on a quiet folder looks exactly
like a broken one — chapter 13's lab
counted 0 runs for 2 full seconds, by
design. Second: do the events survive
the filters? Run with `--print-events`
(chapter 5) and make your change: no
events printed means the change is not
being *seen* — wrong folder (check your
`-w` paths and your working directory),
or a file system with no event stream,
where `--poll` (chapter 13) is the
remedy. Events printed but no run means
the filters ate them: an extension
list, an ignore pattern, or a
`.gitignore` you forgot the project
had — chapter 6, including the watch
that honoured `.gitignore` in a folder
with no repository at all.

## "It runs constantly and never stops"

That is the loop, chapter 7, and the
first move is not diagnosis, it is
Ctrl-C: at the lab's measured rate you
are spending about sixteen runs a
second on curiosity. Then ask what your
command writes and whether it is inside
the watch. It is. Ignore the output
folder, filter to the input extensions,
or move the output outside the tree.

## "One save, two runs"

Your save's events straddled the
debounce. The usual shapes: an editor
that writes a temporary file, renames
it, then touches the original — with a
pause the debounce did not cover — or a
rename whose halves split across the
boundary (the limits chapter quotes the
help text's warning). Raise `--debounce`
in steps — 200 ms, 500 ms — and count
runs with a counter command each time,
the way chapter 8 did, until one save
is one run.

## "It built a half-written file"

The mirror image of the entry above:
the file went quiet for a full debounce
interval *in the middle of arriving* —
a slow copy, a sync tool, a download
with pauses. The lab produced three
runs from one three-chunk save at the
default setting (chapter 8). Lengthen
the debounce beyond the producer's
pauses, or have the producer signal
completion the old way, by renaming the
finished file into place, and watch for
that name.

## "My edit during a long run was ignored"

By design, probably: the default busy
policy, `do-nothing`, drops events that
arrive while the command is running
(chapter 13 measured a mid-run edit
vanishing without trace). If your edits
must never be dropped, `-o queue` earns
exactly one follow-up run. Before
switching, though, be sure the change
you lost was yours — the same policy is
what ignores your command's *own*
mid-run writes.

## "The restart leaves the old server holding the port"

Restart sends SIGTERM and waits —
10 seconds by default — before forcing
the issue (chapter 9). A server that
ignores SIGTERM, or that takes longer
than the wait to shut down, will still
be holding its port when the new one
tries to bind. The tells: watchexec's
`[Waiting 10s for processes to exit
before stopping...]` line, and the old
process still in the list afterwards.
Shorten `--stop-timeout` if the server
is simply deaf; fix the server's signal
handling if it is merely slow — the
fixture server's one-line signal log is
the difference between the two, made
visible.

## "The WATCHEXEC variables are empty in my command"

They are empty because reporting is off
by default in 2.x — the lab ran a
command whose whole job was to dump
them, and got silence (chapter 10). Add
`--emit-events-to environment` (or
`stdio`, or `json-stdio`). If you are
following an older guide that assumes
the variables simply exist, that guide
was written against a version before
2.0; your `--help` is the authority.

## "It reacts to chmod and touch, not just edits"

Metadata changes are changes
(chapter 5): the lab's bare `chmod 600`
earned a run with no data moving.
`--no-meta` removes metadata events
from the stream if your work does not
need them.

## "I closed the terminal and it is still running"

Yes. A watcher is a process like any
other, and terminal windows are not
leashes — this guide's lab found two of
its own watchers alive after their
session closed, and stopped them by
hand (see the criteria). Check for
strays with your process list
(`pgrep -af watchexec`), and stop the
ones you have forgotten on purpose the
same way you would stop anything:
their own Ctrl-C is gone with the
terminal, so send SIGINT or SIGTERM to
the process instead.

Check: for the last watch that
surprised you, name which entry of this
page it was, and the chapter that
predicted it. The goal of the page is
that next time the naming takes
seconds.
