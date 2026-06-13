# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

Tatin is a package manager for Dyalog APL. It requires Dyalog APL 18.2+ Unicode edition and is managed as a [Cider](https://github.com/aplteam/Cider) project. All source is loaded and saved by Dyalog Link via Cider.

## Code architecture

Source lives in `APLSource/` and is organised into four APL namespaces:

| Namespace  | Purpose |
|------------|---------|
| `Client`   | Package consumer logic (install, load, publish, etc.) |
| `Server`   | HTTP server for hosting a Tatin registry |
| `Registry` | Code shared by both client and server (versioning, package config, utilities) |
| `Admin`    | Development helpers: building a new release, running tests, maintenance |

Supporting namespaces loaded from `packages/` (runtime) and `packages_dev/` (dev, includes `Tester2`) are copied into `APLSource/` by `Admin.CopyPackagesToAPLSource`. Never edit those copies directly — edit the package source.

Two external dependencies live outside the packages system and are kept in `Assets/Runtime/`:
- **Plodder** — the HTTP server (`Assets/Runtime/Plodder/`)
- **Rumba** — HTTP/1.1 implementation in APL (`Assets/Runtime/Rumba/`)

File extensions: `.aplf` = function, `.aplc` = class, `.apln` = namespace, `.apla` = array/variable, `.dyalog` = user-command script.

## Opening the project

```apl
]CIDER.OpenProject /path/to/Tatin
```

Cider calls `Admin.SetDevelopment` on open. Answer **Y** to `Set DEVELOPMENT←1 in ⎕SE._Tatin?` — this routes user-command and API execution through `#` (where Link tracks changes) instead of `⎕SE` (where it doesn't).

## Running tests

Tests use the **Tester2** framework. The test server communicates on port 5001 by default.

```apl
⍝ 1. One-time preparation (initialises client, sets up references, creates T alias)
#.Tatin.TestCases.Prepare

⍝ 2. Run the full suite (interactive; will prompt to start the test server)
#.Tatin.TestCases.RunTests

⍝ 3. Run a specific group
#.Tatin.TestCases.T.RunThese 'UC'

⍝ 4. Run specific numbered tests
#.Tatin.TestCases.T.RunThese 'UC' (600 601 602)

⍝ 5. Run two groups / exclude a group
#.Tatin.TestCases.T.RunThese 'API,Misc'
#.Tatin.TestCases.T.RunThese '~UserCommand'

⍝ 6. Debug mode (stops on failure instead of continuing)
1 #.Tatin.TestCases.T.RunThese 'UC' 600

⍝ 7. Batch / non-interactive (starts its own test server)
#.Tatin.TestCases.RunBatchTests 1
1 #.Tatin.TestCases.RunBatchTests 1    ⍝ debug mode

⍝ 8. List groups and their test counts
#.Tatin.TestCases.T.ListGroups

⍝ 9. Abort cleanly (do NOT use )reset)
#.Tatin.TestCases.T.QuitTests
```

On Linux/macOS, starting the test server is manual: open a second Dyalog instance and run the command shown (e.g. `)Load /path/to/test-server/RunTatinServer.dws`).

Server-side tests run independently:

```apl
#.Tatin.TestCasesServer.RunTests
```

### Batch testing from the command line

```bash
./RunTests.sh          # Linux/macOS (edit path to dyalog inside first)
RunTests.bat           # Windows
```

## Building a new version

```apl
#.Tatin.Admin.Make 0   ⍝ interactive
#.Tatin.Admin.Make 1   ⍝ batch (no prompts)
```

Or via Cider: `]CIDER.Make`

`Make` launches two sub-processes: one for `MakeClient` (bumps build number), one for `MakeServer`. Output ZIPs land in `Dist/`. Building is Windows-only.

Before running `Make`: verify `#.Tatin.Registry.Version` and `#.Tatin.Registry.History` are correct, and that `docs/source/release-notes.md` is up to date.

## Updating package dependencies

```apl
⍝ Reinstall packages (add -update to upgrade minor versions, -major for major)
]ReInstallDependencies /path/to/Tatin/packages -update

⍝ After reinstalling, copy updated code into APLSource/
#.Tatin.Admin.CopyPackagesToAPLSource 1    ⍝ actually copies
1 #.Tatin.Admin.CopyPackagesToAPLSource 1  ⍝ dry run
```

## Docs

Documentation is built with MkDocs (Material theme). Sources are in `docs/source/`. Config: `docs/mkdocs.yml`.

When renaming a page or changing a nav label, update both `docs/mkdocs.yml` and `docs/zensical.toml` — both define the nav independently.

```bash
cd docs && mkdocs serve   # local preview
```

### Editing documentation

When reviewing `docs/source/*.md` files for typos and grammar:

- Fix only clear errors (spelling, punctuation, grammar). Do not rephrase or restructure.
- If something seems factually wrong or genuinely unclear, raise it for discussion rather than changing it.
- Make the fix directly with no HTML comments.

#### Review progress

| File | Status |
|------|--------|
| `api.md` | Done |
| `contribute.md` | Done |
| All others | Not yet reviewed |
