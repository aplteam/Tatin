---
title: 'Create new Tatin version'
description: 'This article is about what an administrator of the Tatin project on GitHub does after accepting a PR or finishing work on a branch.'
keywords: 'apl, dyalog, github, profread, tatin, version'
---
# Create a new version of Tatin

!!! abstract "How to create a new version of Tatin."

A contributor’s job is done once they have submitted a Pull Request (PR) on GitHub.

This article is about what an administrator of the Tatin project on GitHub does after accepting a PR or finishing work on a branch.


## Check version, history and documentation

!!! info "A version comprehends both server and client, so the version number is always the same for both."

1. Check `#.Tatin.Registry.Version` is correct
1. Check `#.Tatin.Registry.History` is correct
1. Check the document `docs/source/release-notes.md` is correct
1. Proofread the documentation

A function creates a single HTML file from all the Markdown documentation, making proofreading much easier:

          htmlFilename←#.Tatin.Admin.CreateProofReadDocument 1

Open that file with the word processor of your choice and use its spell-checking capabilities.


## Run the `Make` function

    #.Tatin.Admin.Make 0


!!! tip inline end "Ask Cider"

    You can ask Cider how to create a new version of Tatin:

        ]CIDER.Make


The `Make` function launches two instances of Dyalog, one for creating the client version, one for creating the server version:

1.  runs `#.Tatin.Admin.MakeClient`
1.  compiles the documentation from Markdown into HTML files and distributes them
1.  runs `#.Tatin.Admin.MakeServer`

!!! info "The build ID is always bumped when you create a new version."


### Arguments

The arguments to `Make` are both flags:

------|---
right | Suppress user prompts: 1 is suitable for, say, a batch script.<br><br>If 0, `Make` will ask whether you want to try updating the packages Tatin itself depends on, and whether to copy the new version of the Tatin Client to the `MyUCMDs/` folder.
left  | (optional) Block the `load` and `lx` command-line options in instances of Dyalog started to create the Client and the Server, thus preventing the interpreter from immediately running the code, and allowing you to run the code in the Tracer. (Defaults to zero.)


### Distribution files

The `Dist/` folder gets replaced.
It contains the ZIPs to be released on GitHub;
`.gitignore` prevents the folder appearing on GitHub.

The ZIPs:

    Tatin-Client-{major}.{minor}.{patch}.zip
    Tatin-Server-{major}.{minor}.{patch}.zip

<!-- FIXME What to do with the ZIPs? -->
