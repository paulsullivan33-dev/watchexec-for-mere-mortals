# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's traffic is the lab talking to itself.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** The limits chapter names what the
   tool cannot do: it sees the operating system's events, not
   your editor's intentions, so one save arrives as several
   events and a rename can arrive in halves; it cannot know a
   write is finished, only that writes have stopped for a
   while; it watches paths, not meanings, so it cannot tell
   your edit from your build's output unless you teach it the
   difference; and it runs the command with your full
   permissions, unattended, for as long as you leave it
   running.
8. **The one rule is in the text, early.** Chapter 1 and the
   README state the rule plainly — *the watcher runs your
   command whenever the files change, including when the
   change was your own command's doing* — before any procedure
   depends on it, and later chapters point back to it where the
   rule bites: the build that retriggers itself, the changes
   that arrive while a run is still going, and the question of
   what a command should be allowed to do with nobody watching.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is an Ubuntu 24.04 sandbox. Watchexec
**2.8.0** was the project's official release binary for Linux
(`watchexec-2.8.0-x86_64-unknown-linux-gnu.tar.xz` from the
watchexec GitHub releases), run from the lab's own folder
rather than installed system-wide; no `watchexec` package was
present in this machine's apt sources. Python 3.12 provided
the fixture server and the slow-save writer. The lab is in
`watchexec-lab/`: a fictional walking-notes project
(`fixtures/fieldnotes/`) with two Markdown notes, a site
builder, a title checker, and a tiny HTTP server; per-test
driver scripts (`drivers/`); and small command scripts the
watcher ran. Every test watched a fresh copy of the fixture
project, and run counts were proven by logs kept outside the
watched tree. All transcripts live in
`watchexec-lab/transcripts/`.

Run for real, with transcripts as evidence:

- Version and the full `--help` text, captured before anything
  else was trusted (t00). There is no `--once` flag in it;
  chapter 13 says so plainly rather than inventing one.
- The first watch (t01): exactly one run at startup, exactly
  one more after one edit, with `--timings` reporting
  `[Command was successful, lasted 5ms]`.
- The event stream (t02), via `--print-events`: one shell
  redirect arrived as three events — Create(File),
  Modify(Data(Any)), Modify(Metadata(Any)) — and still caused
  exactly one run; a rename arrived as Name(From), Name(To),
  and Name(Both); a `chmod` alone, a removal, and a new folder
  each triggered a run; the closing Ctrl-C appeared as an
  event with source Keyboard. Each event block was printed
  twice by the printer, once on arrival and once at action
  time; the chapter quotes one block per action.
- Filtering (t03): `-e md` admitted a Markdown edit and
  refused a text-file edit; `-i 'draft-*'` refused a draft and
  admitted a normal note; a `.gitignore` listing `scratch/`
  was honoured by default in a folder that was not a git
  repository, and `--no-vcs-ignore` released it.
- The loop (t04): a build whose output lands in the watched
  tree, with every build unique, ran **99 times in 6 seconds**
  with no ignore — under the default busy policy — and exactly
  once in 6 seconds with `-i 'build'`.
- Debounce (t05): one simulated save written in three chunks
  300 ms apart produced 3 runs at the default 50 ms debounce,
  1 run at `--debounce 900ms`, and 3 runs again when the
  chunks were 1500 ms apart under the same 900 ms setting.
- Restart (t06): a fixture server on 127.0.0.1 port 18093,
  started under `-r`, served a banner read at startup by
  process 39697; after the banner file was edited, process
  39752 served the new banner, the old process was gone, and
  both processes' own logs recorded that they received
  SIGTERM — the default stop signal — and exited cleanly.
  Watchexec's shutdown printed its 10-second stop timeout.
- What the command is told (t07, t11): by default, nothing —
  a run's environment contained no WATCHEXEC variables at
  all. With `--emit-events-to environment`, a modify set
  WATCHEXEC_WRITTEN_PATH and WATCHEXEC_META_CHANGED_PATH
  under WATCHEXEC_COMMON_PATH; a create set
  WATCHEXEC_CREATED_PATH; a rename set
  WATCHEXEC_RENAMED_PATH to `movedfile.md:newfile.md`; a
  remove set WATCHEXEC_REMOVED_PATH. With
  `--emit-events-to stdio`, one append arrived as four
  `modify:` lines — the paths repeat and a consumer must
  deduplicate. With `json-stdio`, one append arrived as two
  JSON lines, Modify(Data(Any)) and Modify(Metadata(Any)).
- Working modes (t08): `--postpone` ran nothing for 2 seconds
  and then ran on the first change; a change during a
  3-second run was ignored under the default
  `--on-busy-update do-nothing` (1 run total) and earned
  exactly one extra run under `queue` (2 total); under
  `--poll 500ms` an edit was picked up and ran the command
  once.
- Clear and shell (t09): under a real terminal provided by
  `script(1)`, `-c` emitted exactly one clear-screen sequence
  (ESC [ 2J) and one cursor-home (ESC [ H) before the run.
  The default shell honoured a redirection and created the
  file; with `--shell=none` the same words ran with the `>`
  as a literal argument — no file, and the text printed to
  the screen instead.
- Real jobs (t10): a rebuild-on-edit watch produced exactly
  one build per edit with the new sentence present in the
  built page; a check-on-edit watch reported FAIL for a
  title-less note, watchexec printed `[Command exited with 1]`
  and kept watching, and the fix produced a passing run.

Documented only — described from the project's `--help` text
and manual, not run, and the text does not claim otherwise:

- Package installation routes other than the release tarball
  the lab used (distribution packages, Cargo, Homebrew,
  Windows installers), and everything Windows-specific,
  including its signal limitations.
- `--delay-run`, `--timeout`, `--env`, `--workdir`,
  `--socket`, argfiles, and the `@argfile` form.
- The `signal` mode of `--on-busy-update` and the `--signal`
  option; restart and the other busy modes were run.
- The `file`, `json-file`, and filter-program (`-j`) event
  routes; `environment`, `stdio`, and `json-stdio` were run.
- `--clear=reset`, desktop notifications (`-N`), the bell,
  and interactive mode (`-I`), which needs a person at a
  terminal pressing keys.
- `--exit-on-error` (the failure it guards against was run;
  the option itself was not), `--map-signal`,
  `--stop-timeout` values other than the observed default,
  and polling intervals other than 500 ms.
- The neighbouring tools in chapter 14 are characterised, not
  benchmarked.

Fixtures are this guide's own and deliberately generic: two
walking notes, a banner, and the small programs that build,
check, and serve them. No example is modelled on any real
person, network, service or organisation. One accident is
kept in the record: the clear-screen test's watcher outlived
the `script(1)` session that hosted it, twice, and had to be
stopped by hand — a watcher keeps running until something
stops it, which is rather the point of chapter 1's rule.
