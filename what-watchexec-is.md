# What watchexec is

By the end of this chapter you can say,
in one sentence, what watchexec takes
off your hands — and state the one rule
that decides whether it helps you or
runs away with your afternoon.

## The loop you already run by hand

Think of the last thing you built at a
terminal. The rhythm was probably:

1. Change a file in your editor.
2. Switch to the terminal.
3. Run the command — the build, the
   checks, the server restart.
4. Read the result.
5. Switch back, change another file.

Steps 2 and 5 are pure overhead, and
step 3 is a small act of faith: did you
remember to run it *after* the last
save? Everyone has debugged a failure
that turned out to be a stale run — the
code was fine, the terminal was showing
the previous version of it.

**Watchexec** is a program that sits in
that loop where you used to be. You
tell it a folder to **watch** and a
**command** to run:

```
watchexec -w . -- ./build.sh
```

It runs the command once when it
starts. Then it waits. When a file in
the folder changes, it runs the command
again. And again, for as long as you
leave it running — until you stop it
with Ctrl-C. Your editor stays in
front; the terminal updates itself
behind it.

Its own one-line description, from
`watchexec --help`, is "Execute
commands when watched files change"
(transcript
`watchexec-lab/transcripts/t00-help-full.txt`).
That is the whole job. Everything else
in this guide — filters, timing,
restarts, reports — is about making
that simple sentence behave well in a
real folder full of real files, some of
which your command itself will write.

## The rule: the watcher cannot tell your edit from its own

Watchexec watches *files*, not
intentions. It does not know that the
change to `build/index.html` was made
by the build it just ran, while the
change to `notes/orchard.md` was made
by you. Both are changes. Both earn a
run. So:

> **The watcher runs your command
> whenever the files change — including
> when the change was your own
> command's doing.**

This is not a bug and not a trap set by
the tool; it is the tool, working
exactly as described. Chapter 7 builds
the consequence on purpose: a build
whose page lands in the watched folder
retriggered itself **99 times in
6 seconds** — about sixteen builds a
second, each one writing the file that
started the next. The way out is one
ignore pattern, and chapter 6 teaches
the filters before you need them under
pressure.

The same rule has a quieter, more
serious side, and the guide will not
pretend otherwise: **a watcher runs
your command unattended, with your own
permissions, every time the files
change, for as long as it is running.**
Watchexec is a loaded tool in the plain
sense that a scheduled task is: it does
what it is told, tirelessly, whether or
not anyone is watching it back. Keep
the commands you hand it boring and
safe to run a hundred times in a row —
because, chapter 7 again, a hundred
times in a row is a real number. Watch
folders of your own, run commands of
your own, and stop the watcher when
you are done with it.

## Where it comes from

Watchexec is a free, open-source
program written in Rust; the project
lives at github.com/watchexec/watchexec
and describes itself as a library with
a command-line tool on top — other
programs build watching into themselves
with the same engine. This guide's lab
ran **watchexec 2.8.0**, the current
release at the time of writing, taken
straight from the project's release
page. It runs on Linux, macOS, and
Windows; where the platforms differ —
signals, shells, file systems — the
chapters say so.

Check: say the loop watchexec takes
over, in your own words, and then say
the rule out loud once. If you can do
both, you have this chapter.
