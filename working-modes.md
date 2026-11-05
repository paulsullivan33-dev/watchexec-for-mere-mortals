# Working modes

Outcome: the switches that change
*whether* and *when* a watch runs, as
opposed to what it watches — postpone,
the busy policies, and polling — plus
one absence you should know about
before you go looking for it. The
evidence is transcript
`watchexec-lab/transcripts/t08-modes.txt`.

## Postpone: no startup run

Chapter 4's startup run is usually a
kindness. When it is not — the command
is expensive, or meaningless until
something has actually changed — `-p`
(`--postpone`) holds fire:

```
watchexec --postpone -w . -- ./check.sh
```

The lab's count: **0 runs after 2
seconds** of watching a quiet folder,
then **1 run** the moment the first
edit landed. Postponed watches are also
the honest way to measure everything
else, which is why most of this guide's
transcripts use the flag: every run on
record belongs to a change the lab
made, none to the watcher's arrival.

## Busy policies: a change arrives mid-run

Runs take time, and files do not stop
changing while yours is under way —
sometimes *because* yours is under way.
`--on-busy-update` decides what such
events are worth. The lab tested the
family with a command that takes three
seconds, changing a file one second
into the run:

| Policy | Meaning | Lab result |
| --- | --- | --- |
| `do-nothing` (default) | events during a run are dropped | 1 run total — the mid-run change vanished |
| `queue` | remember that something changed; run once more when the current run finishes | 2 runs total |
| `restart` | stop the running command, start fresh | chapter 9's mode (`-r`) |
| `signal` | send the running command a signal (`--signal`) and otherwise leave it alone | documented-only |

Choose by what a mid-run change *means*
for your command. For builds and
checks, `do-nothing` is a considered
default — the change was very likely
your own command's output arriving —
but know its price: a genuine edit made
while a long check runs is silently
dropped, and the results on screen may
predate your last save. `queue` is the
careful middle: never two runs at once,
never a change forgotten, at most one
extra run no matter how much changed
during the busy period. The lab's
numbers — 1 against 2 for identical
actions — are the whole argument.

## Polling: when there is no event stream

Everything so far rode on the operating
system reporting changes the moment
they happen. Some file systems cannot:
network shares are the classic case,
some virtual and synced folders behave
the same, and the symptom is a watch
that simply never fires. `--poll`
replaces the event stream with
sweeping: watchexec walks the tree on
an interval and diffs what it finds
against what it remembers.

```
watchexec --poll 500ms --postpone -w . -- ./check.sh
```

The lab's edit under polling was picked
up and ran the command once — the same
visible behaviour, bought at a
different price: a sweep costs work
proportional to the tree, and the
interval is a trade between freshness
and load. The default interval, 30
seconds, suits large trees on shares;
the lab's half-second suits a small
fixture and a stopwatch. Polling is a
remedy, not an upgrade: on a file
system with a working event stream, the
stream is cheaper and instant.

## The mode that does not exist: run once

People regularly reach for a
`--once`: run when the next change
happens, then exit. **Watchexec 2.8.0
has no such flag** — the lab checked
its captured `--help` for it before
writing this section, and the idea
appears only in the phrase "run once at
startup", which is the ordinary startup
run. A watcher is a resident tool:
it starts, it stays, Ctrl-C ends it.

If you truly need fire-once behaviour,
the honest shapes are a postponed watch
you stop after the first run, or a
different tool — chapter 14's `entr`
runs its command per batch of changes
fed to it and exits when its input
closes, which suits pipelines
watchexec's permanence does not. What
this guide will not do is dress up an
absent flag as present.

Named for completeness, from the help
text: `--exit-on-error` ends the watch
when a run fails (chapter 12 met the
need), `-I` interactive mode answers
keypresses — `r` restart, `s` stop,
`p` pause, `q` quit — at a real
terminal, and `--stdin-quit` ends the
watch when its standard input closes,
a courtesy to process managers. None of
the three was needed by the lab's
proofs; all three are there when your
setup is the kind that needs them.

Check: with the three-second command,
predict — then measure — the total run
count for a mid-run edit under
`do-nothing` and under `queue`. If your
predictions land at 1 and 2, the busy
policies hold no surprises for you.
