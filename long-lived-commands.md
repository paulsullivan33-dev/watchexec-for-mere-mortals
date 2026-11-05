# Long-lived commands

Outcome: you can put a server — a
command that runs forever — under a
watch, and prove that an edit replaces
the process: the old one stopped, by a
signal you can name, and the new one
serving. The evidence is transcript
`watchexec-lab/transcripts/t06-restart.txt`.

## The problem with servers

Everything so far assumed commands that
finish: a build, a check. A server does
not finish. Under a plain watch, editing
a file starts *another* server beside
the first — or, more honestly, tries
to, and the second one dies on the
spot because the port is taken, while
the first serves the old code forever.
What you want is replacement: on each
change, stop the running command and
start a fresh one. That is **restart
mode**:

```
watchexec -r -w . -- python3 serve.py
```

`-r` is shorthand for
`--on-busy-update=restart` (chapter 13
covers the busy policies as a family):
when a change arrives and the command
is still running, stop it, wait for it
to exit, start it again.

## The proof

The lab's fixture server is a small
Python program with two deliberate
qualities. It reads `banner.txt` **once,
at startup**, and serves that text —
so the page it serves can only change
if the process is replaced. And it
serves its own process ID, and keeps a
log of the signals it receives. It
listens on 127.0.0.1, port 18093, and
nowhere else.

The watch started; the lab fetched the
page; then edited `banner.txt`; then
fetched again:

```
--- first fetch:
banner: Fieldnotes, first edition
served by pid: 39697
--- second fetch:
banner: Fieldnotes, second edition, revised
served by pid: 39752
--- old pid 39697 alive? no, it is gone
--- new pid 39752 alive? yes
```

A new process, serving the new banner,
and the old process *gone* — not
lingering, not holding the port. The
fetch after the edit is the whole
point: without restart, that fetch
would have shown the first edition
forever.

## How the old process is stopped

Restart is only as clean as the stop.
Watchexec's defaults, both observed:

- **The signal is SIGTERM.** Before
  exiting, each server wrote its own
  line in its own log:
  `server pid 39697 received SIGTERM
  and exited cleanly` — and so did its
  replacement when the watch itself was
  stopped. SIGTERM is the polite
  request ("please end"), the one
  programs can catch to tidy up after
  themselves, as this one did. The
  option is `--stop-signal`; give it a
  name (`SIGINT`), a short name
  (`INT`), or a number.
- **It waits, then insists.** After the
  stop signal, watchexec waits for the
  process to exit — 10 seconds by
  default — before forcefully
  terminating it. The lab saw the wait
  announced on shutdown:
  `[Waiting 10s for processes to exit
  before stopping...]`. `--stop-timeout`
  sets the patience; 0 means kill at
  once. A server that ignores SIGTERM
  will cost you those ten seconds on
  every edit, which is its own
  diagnostic.
- **The whole family gets the word.**
  The command runs in its own process
  group by default, so the stop reaches
  helpers the command itself started —
  the thing you want when a "server" is
  really a script that launches two
  more programs. `--wrap-process` and
  the deprecated `--no-process-group`
  govern this; the defaults served the
  lab, so the alternatives are named
  from the help text only.

Two relatives, also documented-only in
this guide: `--timeout` kills any
single run that outlives a duration you
set — a leash for builds that hang,
useless for servers, which are supposed
to hang — and the `signal` busy policy
(`-s SIGUSR1`, say) prods a running
command with a signal *instead of*
restarting it, for programs that can
reload themselves. Windows, finally,
has no signals in this sense at all:
the help text is plain that stopping
there means termination, and graceful
shutdown is the program's own problem.

Check: put the fixture server — or any
server you run — under `-r`, fetch its
page, edit the file it reads at
startup, and fetch again. A new
process serving new content, and the
old process absent from the process
list, is restart mode understood in
full.
