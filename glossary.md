# Glossary

The terms, collected in one place. Each
is defined the way this guide uses it.

**Busy policy** — What watchexec does
with events that arrive while the
command is still running, set by
`--on-busy-update`: ignore them
(`do-nothing`, the default), remember
them for one more run (`queue`), stop
and restart (`restart`), or prod the
command with a signal (`signal`).

**Debounce** — The quiet interval
watchexec waits out after events arrive
before running the command; 50
milliseconds by default, set with
`--debounce`. Named for the switch
contacts it was invented to tame:
several bounces, one press.

**Emit** — Watchexec's word for handing
event information to the command,
governed by `--emit-events-to`: to the
environment, to standard input, to a
file, as JSON, or — the default — not
at all.

**Event** — One reported change: a file
created, its data or metadata changed,
a rename, a removal — and also signals
and keypresses, which arrive through
the same machinery. The unit the whole
tool is built from.

**Event kind** — The type of an event
as the kernel reports it: `Create`,
`Modify(Data)`, `Modify(Metadata)`,
`Modify(Name)`, `Remove`, and friends,
visible verbatim with `--print-events`.

**Filter** — A test an event must pass
to earn a run. Extension filters (`-e`),
glob filters (`-f`), and ignores (`-i`,
the ones that must *not* pass) together
form the filter stack.

**Glob** — A filename pattern using
wildcards, `*` for any run of
characters and `?` for a single one:
`draft-*` matches every name beginning
`draft-`.

**Ignore file** — A file of patterns —
`.gitignore`, `.ignore`, their kin —
that watchexec reads without being
asked, at the project root and below.

**inotify** — The Linux kernel's file
change notification service: the
mechanism underneath the watch on
Linux. macOS and Windows offer their
own equivalents under other names.

**Metadata** — The facts about a file
that are not its contents: permissions,
ownership, timestamps, size. Changing
them is an event like any other.

**Polling** — Watching by inspection:
walking the tree on an interval and
comparing it with the last walk, used
when the file system offers no event
stream. Set with `--poll`.

**Postpone** — The mode (`--postpone`,
`-p`) in which the usual startup run is
skipped and the command first runs on
the first change.

**Process group** — A set of processes
the operating system treats as one for
signalling. Watchexec runs the command
in its own group so a stop reaches the
command's own children too.

**Restart** — The busy policy (`-r`)
that stops a still-running command —
SIGTERM by default — and starts it
again, for servers and other
long-lived commands.

**Settle** — What a burst of events
does during the debounce interval:
stops arriving, so the run can begin.
A save is *settled* when the file
system has been quiet for the full
interval; settled is not the same as
finished.

**Signal** — A one-word message the
operating system delivers to a process:
SIGTERM (please end), SIGINT (the
Ctrl-C signal), SIGKILL (end, no
appeal). How watchexec stops commands,
and how you stop watchexec.

**Watch** — One running watchexec: a
set of folders, a filter stack, a
debounce, a command. The noun for the
thing this whole guide configures.

**WATCHEXEC_COMMON_PATH** — In
environment reporting, the longest
folder shared by all the changed paths
in a run; the per-kind variables hold
paths relative to it.
