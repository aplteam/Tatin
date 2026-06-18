---
title: "Creating a new version"
description: "What a Tatin project administrator does to create a new release on GitHub"
keywords: 
---
# Creating a new version

!!! abstract "How to create a new version of Tatin."

A contributor’s job is done once they have submitted a Pull Request (PR) on GitHub.

This article is about what an administrator of the Tatin project on GitHub does after accepting a PR or finishing work on a branch.


## Check version, history and documentation

!!! info "A version comprises both server and client, so the version number is always the same for both."

1. Check `#.Tatin.Registry.Version` is correct
1. Check `#.Tatin.Registry.History` is correct
1. Check the document `docs/source/release-notes.md` is correct
1. Proofread the documentation

A function creates a single HTML file from all the Markdown documentation, making proofreading much easier:

          htmlFilename←#.Tatin.Admin.CreateProofReadDocument 1

Open that file with a tool of your choice and use its spell-checking capabilities.


## Run Tatin's `Make` function

!!! tip "Ask Cider"

    You can ask Cider how to create a new version of Tatin:

              ]CIDER.HowToMakeNewVersion
```
    #.Tatin.Admin.Make 0
```

The `Make` function launches two instances of Dyalog, one for creating the client version, one for creating the server version:

1.  runs `#.Tatin.Admin.MakeClient`
1.  runs `#.Tatin.Admin.MakeServer`

!!! info "The build ID is always bumped when you create a new version."


### Arguments

The arguments to `Make` are both flags:

------|---
right | Suppress user prompts: 1 is suitable for, say, a batch script
left  | (optional) Block the `load` and `lx` command-line options in instances of Dyalog started to create the Client and the Server, thus preventing the interpreter from immediately running the code, and allowing you to run the code in the Tracer. (Defaults to zero.)


### Distribution files

The `Dist/` folder gets replaced.
It contains the ZIPs to be released on GitHub;
`.gitignore` prevents the folder appearing on GitHub.

The ZIPs:

    Tatin-Client-{major}.{minor}.{patch}.zip
    Tatin-Server-{major}.{minor}.{patch}.zip

### The `Run` function

This function is used to make Tatin and/or Cider available in `⎕se`. A new release of Tatin requires both `Run.aplf` and a zipped version of it: `Run.zip`. Note that the function is part of the Tatin project.

### The `]Activate` user command

This user command is a general one, but it was invented with Dyalog v18.2 particularly for Tatin: it can be used to make experimental software like Tatin & Cider available (`]Activate`) or remove it (`]Deactivate`). You can also call `]ListActivated` in order to check what got activated.

For the time being the user command is part of the Tatin project. That implies that the script (`Activate.dyalog`) as well as a ZIP file that contains just that script (`Activate.zip`) must be part of a release until further notice.

### Releasing

Create a new release on GitHub:
  
1. On GitHub, go to the Tatin repository and select Releases → Draft a new release
1. Create a new tag matching the version number, e.g. 0.112.0
1. Set the release title to the same version number
1. Attach files as release assets
   * The two ZIPs from `Dist/`
   * `Activate.dyalog` and `Activate.zip`
   * `Run.aplf` and `Run.zip`
1. Publish the release
