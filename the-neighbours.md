# The neighbours

Outcome: you can place watchexec among
the other change-runners honestly —
which jobs its neighbours do better,
and which of its parts they leave to
you. These tools are characterised from
their own documentation and reputations
here, not benchmarked; the lab ran
watchexec only, and this chapter says
nothing about any neighbour that a
transcript would be needed to support.

## entr: the pipeline native

`entr` (Event Notify Test Runner) is
the minimalist of the family. You hand
it a list of files on standard input —

```
find . -name '*.md' | entr ./check.sh
```

— and it runs the command when any of
them changes, exiting when its input
closes. The differences from watchexec
are all consequences of that design.
The file list is **yours to supply and
fixed when entr starts**: a file
created later is not watched until you
restart entr (scripts wrap it in a loop
for exactly this). There is no filter
stack, no debounce dial, no event
report — and almost nothing to learn.
It has a restart mode (`-r`) for
servers. Choose entr when the watch is
one line in a shell pipeline and the
file set is stable; choose watchexec
when the tree itself changes shape —
files arriving and leaving — or when
you want the settling, filtering, and
reporting done for you.

## nodemon: the Node.js household name

`nodemon` watches and restarts **Node
applications**: run your server under
it, and saving a source file restarts
the app. It speaks its ecosystem's
language natively — configuration in
`nodemon.json` or `package.json`,
extension lists, an `execMap` that can
point other file types at other
runtimes — and for a Node project it is
often already installed by a teammate's
habit. Outside that ecosystem it works,
through the exec map, but it is a guest.
Choose nodemon inside a Node project
that already uses it; choose watchexec
for language-neutral watching with the
fuller control panel this guide
describes.

## cargo watch: the Rust project's own

`cargo watch` is a Cargo subcommand
that runs Cargo commands — `check`,
`test`, `run`, chains of them — when a
Rust project changes. It understands
the project's layout (what `target/`
is, what to ignore) without being told,
because it was born in that layout. For
a Rust project it is the zero-config
answer, the way nodemon is for Node.
Its world ends at the project's edge:
it is not a general folder watcher.
Choose it inside Rust projects; choose
watchexec anywhere else, including
Rust projects whose real job involves
files Cargo does not know about.

## inotifywait: the plumbing, exposed

Underneath watchexec on Linux sits the
kernel's inotify, and `inotifywait`
(from the inotify-tools package) prints
that layer raw:

```
inotifywait -m -e close_write notes/
```

It reports events — and stops there.
No settling, no filtering beyond event
types, no runner discipline; the
canonical use is a shell loop that
reads its lines and acts. That rawness
is a feature in two situations: when
you are diagnosing *what the kernel
actually reports* for some action
(chapter 5's exercise, one floor
lower), and when the reaction you want
is so specific that a general watcher
is the wrong shape. For everything
else, inotifywait is the reason
watchexec exists: the settling,
ignoring, and restarting in this guide
are exactly the parts you would
otherwise write yourself, in shell, at
midnight.

| Tool | You supply | Watches new files automatically | Settling and filters | Happiest where |
| --- | --- | --- | --- | --- |
| watchexec | a folder and a command | yes | built in, this whole guide | any folder, any stack |
| entr | a list of files on stdin | no — restart to extend | minimal | shell pipelines |
| nodemon | an app to restart | yes, in its tree | tuned for Node | Node projects |
| cargo watch | a Cargo project | yes, in its layout | Cargo-shaped defaults | Rust projects |
| inotifywait | event types and a folder | events only, no runs | none — you build them | diagnosis, bespoke loops |

Check: for each tool, name the one job
where you would reach for it before
watchexec. If each answer is a
different job, you have the family's
map.
