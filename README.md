# Watchexec for Mere Mortals

Every programmer knows the loop by
heart. Edit a file. Switch to the
terminal. Run the command — build the
site, run the checks, restart the
server. Switch back. Half the time you
forget a step, or run the command
against the version you saved two edits
ago, and spend a minute doubting a
result that was only ever stale.
**Watchexec** takes the loop over: it
watches a folder, and **every time the
files change, it runs the command for
you**.

One rule governs everything it does,
and this guide states it in chapter 1
and keeps pointing back to it: **the
watcher runs your command whenever the
files change — including when the
change was your own command's doing.**
A watcher makes no distinction between
your edit and your build's output. If
the output lands in the watched folder,
the command runs again, forever, at
full speed: this guide's lab measured
99 self-triggered builds in 6 seconds.
The same rule has a serious side. A
watcher runs your command unattended,
with your full permissions, for as long
as you leave it going. What it watches
and what it runs are your choice, and
your responsibility.

The lab behind this guide ran the real
thing: **watchexec 2.8.0**, the official
release binary from the project's
GitHub releases, against a small
fictional project — two walking notes,
a script that builds them into a web
page, a script that checks each note
has a title, and a tiny server. Against
that project the lab counted runs at
startup and after single edits; printed
the raw event stream and watched one
save arrive as three events; gated the
watch with extension filters, ignore
patterns, and a `.gitignore`; built the
self-triggering loop and then stopped
it with one ignore; wrote a file slowly
in three chunks and measured how the
debounce setting settled — or refused
to settle — the burst into runs;
restarted a live server by editing the
file it had read at startup, and proved
the old process died by the signal the
guide names; read exactly what a
command is told about a change in each
of watchexec's reporting modes, and
what it is told by default (nothing);
and broke a note on purpose to watch
the checker fail, the watcher stay up,
and the fix turn the run green.

What the lab could not do, it did not
fake. Interactive mode needs a person
at a keyboard; Windows behaviour and
the package installs for each operating
system are taken from the project's own
help text and labelled documented-only.
`criteria.md` keeps the full ledger of
what was run and what was only read.

## What this guide covers

- [**What watchexec is**](what-watchexec-is.md) —
  the edit-run loop, what a watcher
  takes over, and the one rule
- [**The moving parts**](the-moving-parts.md) —
  the watcher, the event stream, the
  filters, the debouncer, and the
  runner
- [**Installing watchexec**](installing-watchexec.md) —
  the release file the lab used, the
  package routes, and the version check
  every install must pass
- [**Your first watch**](your-first-watch.md) —
  the startup run, one edit one run,
  reading watchexec's own messages, and
  stopping the watcher
- [**What counts as a change**](what-counts-as-a-change.md) —
  creates, writes, renames, removals and
  metadata, and why one save is several
  events
- [**Filtering the noise**](filtering-the-noise.md) —
  extensions, patterns, ignore files,
  and the ignore switches
- [**The loop everyone builds once**](the-loop.md) —
  the command that retriggers itself,
  measured, and the three ways out
- [**Debounce and timing**](debounce-and-timing.md) —
  settling a burst of events into one
  run, with the numbers from a slow save
- [**Long-lived commands**](long-lived-commands.md) —
  restart mode, the stop signal, and
  the process that gets replaced
- [**What the command is told**](what-the-command-is-told.md) —
  the changed-file reports, in the
  environment, on standard input, and
  as JSON — and the silence by default
- [**Clear screens and shells**](clear-and-the-shell.md) —
  a clean screen per run, and what
  changes when there is no shell
- [**Real jobs**](real-jobs.md) — rebuild
  on edit, re-check on edit, restart on
  edit: three working watches assembled
- [**Working modes**](working-modes.md) —
  postpone, the busy policies, polling,
  and the run-once mode that does not
  exist
- [**The neighbours**](the-neighbours.md) —
  entr, nodemon, cargo watch, and
  inotifywait, the plumbing underneath
- [**Limits**](limits.md) — events are
  not intentions, settled is not
  finished, and a watcher has your
  permissions
- [**Troubleshooting**](troubleshooting.md) —
  the run that never comes, the run
  that never stops, and the run that
  comes twice
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Editing files, running the builds
themselves, or process managers that
keep a watcher alive across logins and
reboots — a watcher is a foreground
tool you start and stop, and chapter 13
says where its modes end. Filter
programs in the jaq language (the
`-j` option) are named where they
belong and left to the manual; the
filters this guide teaches cover the
ordinary work. Nothing here watches
other people's machines or files: every
example watches a folder of the
reader's own.

## How to use this guide

Read chapter 1 for the rule and
chapter 2 for the map of parts; chapter
4 gets a real watch running, and
chapters 5 to 8 teach you to read what
it does. Chapter 7 is the one to read
before your first real watch, not
after: everyone builds the loop once,
and it is cheaper to build it on
purpose, in the lab, at 99 builds per
6 seconds, than to meet it in the wild.
The lab's fixture project lives in
`watchexec-lab/fixtures/`, its driver
scripts in `watchexec-lab/drivers/`,
its command scripts beside them, and
every claim's evidence in
`watchexec-lab/transcripts/`; its
distilled commands are
`examples/commands.txt` and its notes
`examples/lab-notes.txt`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Text Processing for Mere Mortals](https://paulsullivan33-dev.github.io/text-processing-for-mere-mortals/)
- [Vim for Mere Mortals](https://paulsullivan33-dev.github.io/vim-for-mere-mortals/)
- [Markdown for Mere Mortals](https://paulsullivan33-dev.github.io/markdown-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/watchexec-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/watchexec-for-mere-mortals/blob/main/LICENSE-CODE).
