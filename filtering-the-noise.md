# Filtering the noise

Outcome: a watch that runs for the
changes you mean and stays quiet for
the rest — extensions, patterns, and
ignore files, each proved against the
same project. The evidence is
transcript
`watchexec-lab/transcripts/t03-filtering.txt`.

A real project folder is a busy place:
editors write swap files, builds write
outputs, tools write caches. The
filters are how you tell watchexec
which of that traffic is *yours*. Three
layers cover nearly everything, and the
lab proved each one the same way: a
change that must not run the command,
followed by one that must, so both
directions are on record.

## Layer one: extensions

```
watchexec --postpone -e md -w . -- ./check.sh
```

`-e md` admits only events for files
whose names end in `.md` (the dot is
optional in the option; several
extensions can be listed, comma
separated or by repeating the flag).
The lab's watch, so filtered, was shown
a text-file edit and a Markdown edit:

```
edited notes/shopping.txt : runs 0
edited notes/orchard.md   : runs 1
```

Extensions are the bluntest filter and
often the right one: a notes project
cares about `.md`, a stylesheet build
about `.css`, and everything else in
the tree is free to change without
consequence.

## Layer two: patterns

Filters and ignores also speak in
**glob patterns** — the shell's
wildcard language, where `*` stands for
any run of characters. `-f` keeps only
what matches; `-i` throws away what
matches. The lab's watch ignored drafts
by name:

```
watchexec --postpone -i 'draft-*' -w . -- ./check.sh
```

```
edited notes/draft-ideas.md : runs 0
edited notes/orchard.md     : runs 1
```

Two habits matter here. Quote patterns
in your shell (the single quotes above)
so the shell itself does not expand
them against whatever files happen to
be nearby before watchexec ever sees
them. And remember the order of the
stack from chapter 2: ignores are
applied before filters, so an ignore
always wins an argument with a filter.

## Layer three: ignore files

Watchexec also reads the ignore files
your project already keeps. The list,
from the help text, is long — Git's
`.gitignore` (at the project root and
in child folders) and `.git/info/exclude`,
Mercurial's `.hgignore`, Bazaar's and
Darcs' and Fossil's equivalents, and a
generic `.ignore` file that several
tools share. The lab proved the common
case: a `.gitignore` containing one
line, `scratch/`, in a project folder
that was **not a git repository at
all**:

```
watchexec --postpone -w . -- ./check.sh
edited scratch/list.txt : runs 0
```

The ignore was honoured anyway —
watchexec reads the file because it is
there and shaped like an ignore file,
not because a repository vouches for
it. That is convenient (your editor's
and your version control's idea of
"noise" is already written down) and
occasionally surprising, which is why
the release valves are named in the
same breath:

```
watchexec --postpone --no-vcs-ignore -w . -- ./check.sh
edited scratch/list.txt : runs 1
```

- `--no-vcs-ignore` — skip version
  control's ignore files (`.gitignore`
  and its kin).
- `--no-project-ignore` — skip all
  project ignore files, VCS or not.
- `--no-global-ignore` — skip your
  personal, machine-wide ignore files.
- `--no-default-ignore` — skip
  watchexec's own built-in ignores.
- `--ignore-nothing` — the first two
  switches of that family combined: no
  discovered and no built-in ignores at
  all. Your explicit `-i` patterns and
  `--ignore-file` lists still apply —
  "nothing" means nothing *discovered*,
  not nothing at all.

You can also supply your own lists:
`--ignore-file` (and `--filter-file`
for keeps) name a text file with one
pattern per line, `#` lines treated as
comments — the right shape for a watch
whose rules are worth keeping beside
the project. The lab names these from
the help text; its proofs above used
the inline forms.

## Filters see events, not files

One discipline underlies all three
layers: a filter judges **events**, not
the file's worth. A rename produces an
event for the old path and an event for
the new one, and a pattern that matches
only one of them can admit a change you
meant to exclude, or the reverse. When
a filter's behaviour surprises you,
`--print-events` (chapter 5) shows you
exactly which events the stack was
handed. Guess at the stack's inputs and
you will guess wrong in interesting
ways; read them and the fix is usually
one pattern.

Check: set a watch loose on a folder
with one extension filter and one
ignore pattern, and correctly predict —
out loud, before each change — the run
counts for a matching edit, a wrong
extension, and an ignored name. Three
right answers and the stack is yours.
