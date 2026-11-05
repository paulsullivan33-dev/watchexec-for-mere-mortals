# Clear screens and shells

Outcome: each run can start on a clean
screen, and you understand exactly how
your command line is interpreted on its
way to running — shell or no shell, and
what breaks when the shell goes away.
The evidence is transcript
`watchexec-lab/transcripts/t09-clear-shell.txt`.

## A clean screen per run: -c

When a watch runs a noisy command, the
outputs stack: run twelve's failure
sits somewhere above run eleven's
success, and you find yourself reading
history instead of news. `-c` clears
the terminal before each run, so the
screen always shows the latest attempt
and nothing older:

```
watchexec -c -w . -- ./check.sh
```

Clearing is a terminal trick — a short
**escape sequence**, bytes that instruct
the terminal to wipe itself — and the
lab proved it the way such things must
be proved: by giving watchexec a real
terminal (through `script(1)`, which
records everything a terminal session
contains) and counting the sequences in
the recording. One triggered run
produced exactly one `ESC [ 2J` (erase
the screen) and one `ESC [ H` (cursor
to the top-left corner) before the
command's output. If `-c` ever leaves
your terminal half-wiped — some
terminals answer it oddly — the help
text offers `--clear=reset`, the
stronger reset form; the lab's terminal
needed only the standard one, so reset
is named here, not demonstrated.

## The shell your command runs in

Unless you say otherwise, watchexec
runs your command through a **shell**:
`$SHELL` if your environment defines
one, otherwise `sh` on Unix-like
systems; on Windows it detects among
`pwsh`, `powershell`, and `cmd`. The
shell is given your command with its
`-c` flag, which means everything a
shell offers is on the table — pipes,
redirection, `&&`, globs, variables:

```
watchexec -w . -- 'echo built at $(date) > build/stamp.txt'
```

The lab proved the shell's presence the
direct way: a watched command string
containing a redirection created the
file, containing exactly the words the
echo was given. `--shell` chooses a
different interpreter (the help text
shows `--shell=bash`, and values with
spaces are parsed as a command line,
such as `--shell='zsh -x'`); aliases
and functions from your chosen shell
come with it, which cuts both ways —
a watch that works in your terminal may
behave differently under a login shell
that loads different settings.

## No shell: -n

`--shell=none`, short form `-n`, skips
the interpreter entirely. Watchexec
parses the command words itself —
crudely, by its own admission — and
executes the first word as the program
with the rest as its arguments. The
lab ran the twin of the redirection
test with the shell removed:

```
[Running: echo shell-wrote-this > shellout2.txt]
shell-wrote-this > shellout2.txt
```

No file appeared. Without a shell, `>`
is not an instruction; it is just a
word, and `echo` printed it with the
others. Everything shell-shaped breaks
the same way under `-n`: pipes,
redirection, `&&` and `||`, glob
expansion, `$VARIABLES`, quoting
subtleties. What you get in exchange is
exactness — the arguments your program
receives are the arguments you wrote,
unreinterpreted — and a small saving of
one process per run.

Choose by the command, not by taste:

| Your command is… | Use |
| --- | --- |
| a single program with plain arguments (`./check.sh`, `python3 serve.py`) | either; `-n` is tidy |
| anything with a pipe, redirect, `&&`, glob, or variable | the shell — the default |
| a program whose arguments contain shell-looking text you mean literally | `-n`, and check the `[Running:]` line |

And a debugging habit that serves both
modes: the `[Running: ...]` line prints
the command as watchexec understood it.
Read it before blaming the command; a
surprising number of broken watches are
broken in that one line, where the
quoting went to a different shell than
the author expected.

Check: run the pair yourself — a
redirection under the default shell
creates the file; the same words under
`-n` print to the screen and create
nothing. Two runs, and the shell's role
stops being an abstraction.
