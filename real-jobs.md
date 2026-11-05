# Real jobs

Outcome: three working watches,
assembled from the parts the earlier
chapters proved — rebuild on edit,
re-check on edit, restart on edit —
with their transcripts as the spec. The
evidence is transcript
`watchexec-lab/transcripts/t10-real-jobs.txt`,
with the server's proof in t06.

## Job one: rebuild the page when a note changes

```
watchexec -w . -i 'build' -- ./build.sh
```

Every part is a chapter: watch the
project (chapter 4), ignore the output
folder so the build cannot retrigger
itself (chapters 6 and 7), run the
builder. The lab edited two notes —
one of them gaining a new sentence
about the lane flooding every February —
and counted:

```
builds run: 2
new sentence present in build/index.html? 1 occurrence(s)
```

Two builds in total: the startup build,
and one build for the two edits — they
were made back to back and settled into
a single run, exactly as chapter 8
predicts — with the new sentence in the
built page. This is the watch most
people want first, and it is five words
of command once the loop is disarmed.

## Job two: re-run the checks when a note changes

```
watchexec --postpone -e md -w . -- ./check.sh
```

The checker demands a title line at the
top of every note. The lab broke the
rule on purpose — created a note that
just starts talking — and the watch
answered:

```
FAIL notes/untitled.md -- first line is not a title: This note has no title line.
some notes are missing titles
[Command exited with 1]
```

Three things to notice. The failure is
reported in full, in the command's own
words. Watchexec's closing line changes
its report: `[Command exited with 1]`,
against success's `[Command was
successful]`. And — the point of the
chapter — **the watch did not die**.
The lab then fixed the note by giving
it a title, and the very next run, with
no restart of anything, came back:

```
PASS notes/untitled.md
all notes have titles
[Command was successful]
```

A watcher that quit on the first
failure would be nearly useless for
checks, whose whole purpose is to fail
while you work. If you ever *want* the
opposite — a watch that gives up when
the command errors, for instance under
a process manager that should restart
the pair — the switch is
`--exit-on-error`, named here from the
help text.

## Job three: restart the server when its inputs change

```
watchexec -r -w . -- python3 serve.py
```

Chapter 9's watch, unmodified. The
flags earn a second look in this
company: no `--postpone`, because a
server should be *up* — the startup run
is the point, not a nuisance — and no
filters, because the fixture reads two
files (`serve.py` itself and
`banner.txt`) and either one's change
deserves a restart. In your own work
the filters are where this job is
tuned: watch the code and config, ignore
the logs the server writes, or the rule
from chapter 1 will restart your server
for the crime of recording that it
served a page.

## The three side by side

| Job | Command shape | Startup run? | The part that saves you |
| --- | --- | --- | --- |
| Rebuild | `watchexec -w . -i 'build' -- ./build.sh` | yes, harmless | the ignore that disarms the loop |
| Re-check | `watchexec --postpone -e md -w . -- ./check.sh` | no — nothing to check yet | surviving `[Command exited with 1]` |
| Restart | `watchexec -r -w . -- python3 serve.py` | yes, essential | SIGTERM and a replaced process |

Keep the trio in mind as patterns, not
recipes: most real watches are one of
these three with the names changed,
plus a debounce from chapter 8 when the
saves run slow.

Check: assemble the re-check watch
against a folder of your own with a
check you can break, break it, watch
the failing run, fix it, and watch the
pass — without touching the watcher.
That arc, failure to fix under a
watcher that never blinked, is the
daily experience this tool exists for.
