---
title: "Maintain your server"
description: "Maintaining your Tatin server"
keywords: 
---
# Maintain your server

!!! abstract "Care and grooming of your Tatin server."

As packages accumulate on a registry, their configuration files can drift: tags diverge, variant spellings creep in, and conventions change. Maintenance is the process of correcting or updating those files programmatically, without touching the package ZIPs manually. Common tasks include standardising tags, removing meaningless ones, and adding new properties to existing packages. 

Tatin automates this through maintenance jobs — APL function files placed in the Maintenance folder that the server detects and runs automatically.


## Curate the tags

The most important maintenance job is to curate the tags.

Tags can be useful for finding a package, but package authors may use different tags for the same thing, use legal but different spelling (UK versus US) or invalid spelling, or tags that make no sense, such as the group name or `dyalog` etc.

To be useful, tags need curating.

A package’s tags are defined in its [configuration file](package-configuration).
Merely changing the config file is enough: the server watches for such changes and adds the new config to the package ZIP, thus updating it.

Create and run maintenance jobs to correct problems in the package config files.


## Maintenance jobs

The [Maintenance Folder](glossary.md) holds maintenance jobs in the form of APL function files (APLFs).
The downloaded server includes some examples.

The purpose is to change packages managed by a Tatin server.

!!! detail inline end ""

    If a job crashes, the server

    1.  reports it to the log file
    1.  emails a report to the maintainer (see [config](install-server.md#email))
    1.  renames the file from `*.aplf` to `*.crashed` to stop it being run again

If the server finds APLFs in the Maintenance Folder during housekeeping, it loads and executes them.

Once executed, a file is renamed by adding an extension `.executed`,
so it is not run again.
That also documents what jobs were executed, and when.

For example, a file `RemoveDyalogFromTags.aplf` gets loaded into an unnamed namespace and called with

* the package ID as the left argument
* a two-element vector as the right argument:
  * The first element is the package configuration as a namespace
  * The second element is the path to the Registry

Once executed, the file is renamed to `RemoveDyalogFromTags.aplf.executed`.

Note that the user command `]Maintenance` serves a different purpose: It can be used to adapt *installed* packages!




## READMEs

Every package page shows the README of the newest release of that major version line. The server fetches those from GitHub itself; [Publish a package](publish-packages.md#the-readme-on-the-package-page) states what a package has to do to qualify.

Three files hold the result, and all three belong to the server rather than to any package:

| File | Where | What it holds |
|---|---|---|
| `apl-readme.md` | in a package folder | The Markdown, when there is any |
| `apl-readme.json` | in a package folder | Where it came from, and whether it was found at all |
| `apl-readme-sweep.json` | in the root of the registry | When the registry was last walked |

`apl-package.json` is never touched, and none of these files is part of a package: the ZIP a client downloads is built when the package is published and takes no notice of its neighbours.

The server looks for READMEs when something has been published, and once a day in any case. A package that could not be fetched is tried three times altogether: at once, 24 hours later and a week after the first attempt.

### Fetching a README again

Deleting a package's `apl-readme.json` marks that package as one to look at again.

!!! danger "Deleting records does not start anything by itself"

    Whether the registry is walked at all is decided by `apl-readme-sweep.json`, and that takes no notice of the per-package files. Deleting them and waiting achieves nothing until the next walk comes round anyway.

    To have it happen now, run

    ```apl
    #.Tatin.Server.BackfillReadmes #.Tatin.Server.G.RegistryPath
    ```

    It asks every package directly and ignores the sweep record. Deleting `apl-readme-sweep.json` as well works too, and makes the next housekeeping call walk the registry.

The same call is what to run on a registry that already holds hundreds of packages, rather than waiting for the daily walk to work through them. A `1` as left argument makes it a dry run, reporting what it would fetch and touching nothing:

```apl
1 #.Tatin.Server.BackfillReadmes #.Tatin.Server.G.RegistryPath
```


## Update the server

Download the release ZIP from the [Releases](https://github.com/aplteam/Tatin/releases) page into a temporary folder and unzip it.


!!! warning "Read the release note before doing anything else."

    An update could require taking the server down for maintenance.


By default, a running Tatin server watches the workspace on disk
and reloads it if it changes.
This makes for an easy update if no other action is required.

The automatic update can be switched off in the INI file with `[CONFIG]ReloadWS`.

While reloading the workspace, the server returns error messages.
Expect this to last 10-30 seconds, depending on the number of packages managed.


### The INI file

The update might add or remove settings in the INI file: consult the release note.

If there are changes, follow instructions in the note.

!!! danger "Do not replace the INI file."

The server monitors the INI file for changes, and re-initialises if it finds them.
Whether that works depends on the change: some settings are used at an early stage and cannot be changed later.
Again, the release note will tell.


### Assets

The release note describes what action to take, if any.

Whether `Assets/` needs updating or just one (or some) of its sub folders, it's always best to upload them as, say, `Assets_`, then delete the original and finally rename `Assets_` to `Assets`. This is because otherwise stale files will survive and one day cause confusion or worse.


### Maintenance folder

!!! danger "Never replace the Maintenance Folder"

    The folder `maintenance/` documents changes made to the packages:
    you don’t want to lose this.

If the new folder is not empty, copy its contents over.
Maintenance files can be used to carry out changes to all or some of the packages managed by the server, like adding a new property to the package config files of all packages.






