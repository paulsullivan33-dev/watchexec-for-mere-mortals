# Limits

Outcome: the honest boundary of the
tool, in one place — what watchexec
cannot see, cannot know, and must not
be trusted with — so nothing in the
earlier chapters is mistaken for a
promise. Every limit here was either
measured in the lab or is stated in the
project's own help text; the criteria
keep the two apart.

## It sees events, not intentions

The event stream is the kernel's
ledger, not your editor's diary. One
save is a burst of create, data, and
metadata events (chapter 5); a slow
save is several runs' worth (chapter
8). Watchexec cannot know that three
events were "really" one action, or
that a pause inside a copy is not the
copy finishing. Debounce is a guess
with a dial on it — a good guess,
tunable, and a guess.

Renames are the softest part of the
ledger. The help text warns, in its own
words, that a rename's two halves may
arrive separately, in either order,
split across a debounce boundary, or
with one half missing entirely. Any
logic built on rename events — in your
filters, or in a command reading the
chapter 10 reports — must survive
meeting half a rename.

## Settled is not finished

A run starts when the tree has been
quiet for the debounce interval. Quiet
is not the same as *complete*. A file
still arriving — a download, a sync, a
long copy — whose pauses outlast your
debounce will be built, checked, or
served in its unfinished state, and the
lab's 1500-millisecond save is the
small end of that truth. For inputs
that arrive slowly, the defences are a
longer debounce (chapter 8) and
commands that tolerate partial input —
or that check for the producer's own
"done" signal, like a renamed final
name, before believing a file.

## It watches paths, not meanings

Nothing in the tool knows that
`build/` is output and `notes/` is
input. Chapter 7's loop is the standing
proof: the distinction exists only in
your filters. The same blindness means
a watched folder shared with other
writers — a sync folder, a shared
mount, a directory a download tool
targets — turns *their* changes into
*your* command runs. Which brings the
safety limit into the open:

## It runs your commands, unattended, with your permissions

A watch is a standing order: *run this,
whenever that changes, until I say
stop.* It keeps that order in an empty
room, at 3 a.m., at sixteen runs a
second if the files conspire. The lab
left two watchers running after their
terminal closed, and they were found
and stopped by hand — benign commands
in a fixture folder, and still a small
cold moment. Treat a watch like the
loaded tool it is:

- Hand it commands that are safe to run
  a hundred times unattended, because
  that is a measured possibility, not a
  figure of speech.
- Watch folders you control, and be
  deliberate about any folder another
  person or program can write to.
- Remember that stopping is part of the
  job. A watcher has no natural end;
  your Ctrl-C is the end.

## Smaller print, honestly stated

- **Metadata is a change** (chapter 5).
  A `chmod`, a `touch`, a backup tool
  refreshing timestamps — all earn runs
  until `--no-meta` or a filter says
  otherwise. Noise to one project is
  signal to another; the default
  believes the kernel.
- **Reading is invisible by default.**
  Access events are excluded unless
  `--fs-events` admits them, so "run
  this when someone opens the file" is
  a job watchexec declines by default.
- **Very large trees cost.** The kernel
  watches directories one by one and
  has a per-user limit on how many; a
  huge tree can reach it, and polling a
  huge tree (chapter 13) costs a full
  walk per interval. The lab's fixture
  was five files; your monorepo is a
  different country.
- **Long debounces remember
  everything.** Events accumulate in
  memory while they wait (the help text
  says so), so the 30-minute scheduler
  trick of chapter 8 has a price on a
  busy tree.
- **Windows signals are not signals.**
  Stopping a command there means
  termination without the graceful
  SIGTERM conversation of chapter 9 —
  stated in the project's help, and the
  reason cross-platform watches should
  be tested on the platform they will
  live on.
- **It does not manage itself.** No
  daemon mode, no supervision, no
  restart-after-reboot lives inside
  watchexec; keeping a watch alive
  across logins belongs to your service
  manager, outside this guide's scope.

Check: name three limits from this
chapter that apply to a watch you are
actually running, and the chapter that
hands you each one's mitigation. If you
can, the tool's size is clear to you —
which is what makes it safe to use at
full strength.
