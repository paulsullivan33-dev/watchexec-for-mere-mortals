# Installing watchexec

Outcome: watchexec on your machine,
proved by the one check every route
must pass — and an honest account of
which routes this guide ran and which
it only read about.

## The check

However you install it, the proof is
the same two commands:

```
watchexec --version
watchexec --help
```

The lab's copy answers the first with
its name, version, and build details
(transcript
`watchexec-lab/transcripts/t00-version.txt`):

```
watchexec 2.8.0 (07e2b99e 2026-10-05) +pid1
```

If `watchexec --version` does not run,
nothing else in this guide will either;
fix the install before going on. The
second command prints the full manual —
851 lines in 2.8.0. This guide captured
all of it before trusting any of it
(`watchexec-lab/transcripts/t00-help-full.txt`),
and the shorter `watchexec -h` prints a
summary when the full text is more than
you need. There is also a proper manual
page: `watchexec --manual` writes it
out, and the release file ships it as
`watchexec.1`.

## The route the lab used: the release file

The project publishes ready-made files
for each release on its GitHub releases
page. The lab downloaded
`watchexec-2.8.0-x86_64-unknown-linux-gnu.tar.xz`
— the name is the version, then the
machine it was built for — unpacked it,
and ran the `watchexec` binary inside
from the lab's own folder, without
installing anything system-wide:

```
tar -xJf watchexec-2.8.0-x86_64-unknown-linux-gnu.tar.xz
./watchexec-2.8.0-x86_64-unknown-linux-gnu/watchexec --version
```

The unpacked folder also carries the
manual page, shell completions for
several shells, and the project's
licence. To make the command available
everywhere, put the binary somewhere on
your `PATH` — a personal `~/bin` folder
is the usual choice — under the plain
name `watchexec`.

Two honest notes about this machine.
First, the sandbox's apt sources held
**no watchexec package at all** —
`apt-cache policy watchexec` answered
with nothing — which is why the lab
used the release file. Your
distribution may differ. Second,
everything in this guide was verified
against 2.8.0; option spellings and
defaults are a moving target across
versions, and `watchexec --help` on
*your* copy outranks this guide wherever
the two disagree.

## The other routes, documented only

The project and its community offer
more doors, which the lab did not walk
through and will not pretend to have:

- **Distribution packages.** Some
  distributions package watchexec;
  check yours (`apt`, `dnf`, `pacman`)
  before downloading anything.
- **Cargo.** Watchexec is a Rust
  program, and `cargo install watchexec`
  (or `cargo binstall watchexec` for a
  prebuilt binary) builds or fetches it
  through Rust's own tooling.
- **Homebrew** on macOS (and Linux):
  `brew install watchexec`.
- **Windows.** The releases page carries
  Windows builds, and package managers
  such as Scoop and Chocolatey list it.
  Windows behaviour differs where this
  guide says it does — most importantly,
  it has no Unix-style signals (chapter
  9).

Whichever door you use, finish with the
check at the top of this chapter. The
version line is the handshake between
your machine and the rest of this
guide.

Check: `watchexec --version` prints a
version, and `watchexec -h` prints a
summary you can scroll. If both do, you
are installed — chapter 4 puts the tool
to work.
