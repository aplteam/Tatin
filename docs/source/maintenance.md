---
title: 'Tatin: Server Maintenance'
description: "Care and grooming of your Tatin server"
keywords: 'apl, dyalog, maintenance, registry, server, tags, tatin'
---
# Maintain your server

!!! abstract "Care and grooming of your Tatin server."


## :fontawesome-solid-tag: Curate the tags

The most important maintenance job is to curate the tags.

Tags can be very useful for finding a package, but package authors may use different tags for the same thing, use legal but different spelling (UK versus US) or invalid spelling, or tags that make no sense, such as the group name or `dyalog` etc.

To be useful, tags needs curating.

A package’s tags are defined in its [configuration file](package-configuration).
Merely changing the config file is enough: the server watches for such changes and adds the new config to the package ZIP, thus updating it.

Create and run maintenance jobs to correct problems in the package config files.


## :fontawesome-solid-folder: Maintenance jobs

The [Maintenance Folder](glossary.md) holds maintenance jobs in the form of APL function files (APLFs).
The downloaded server includes some examples.

!!! detail inline end ""

    If a job crashes, the server

    1.  reports it to the log file
    1.  emails a report to the maintainer (see [config](install-server.md#email))
    1.  renames the file from `*.aplf` to `*.crashed` to stop it being run again

If the server finds APLFs in the Maintenance Folder during housekeeping, it loads and executes them.
<!-- FIXME Is this ‘batch’ arrangement replaced by the user command? -->

Once executed, a file is renamed by adding an extension `.executed`,
so it is not run again.
That also documents what jobs were executed, and when.

For example, a file `RemoveDyalogFromTags.aplf` gets loaded into an unnamed namespace and called with a right argument `G` (for _globals_). <!-- FIXME not the config param space? -->
Once executed, the file is renamed to `RemoveDyalogFromTags.aplf.executed`.

:fontawesome-solid-terminal:
User command:
[`]Maintenance`](user-commands-host.md#maintenance)




## :fontawesome-solid-calendar-plus: Update the server

Download the release ZIP from the [Releases](https://github.com/aplteam/Tatin/releases) page into a temporary folder and unzip it.


!!! warning "Read the release note before doing anything else."

    An update could require taking the server down for maintenance.


By default, a running Tatin server watches the workspace on disk
and reloads it if it changes.
This makes for an easy update if no other action is required.

The automatic update can be switched off in the INI file with `[CONFIG]ReloadWS`.

While reloading the workspace, the server returns error messages.
Expect this to last 10 seconds or more, depending on the number of packages managed.


### The INI file

The update might add or remove settings in the INI file: consult the release note.

If there are changes, follow instructions in the note.

!!! danger "Do not replace the INI file."

The server monitors the INI file for changes, and re-initialises if it finds them.
Whether that works depends on the change: some settings are used at an early stage and cannot be changed later.
Again, the release note will tell.


### Assets

The release note describes what action to take, if any.
Often the subfolder `docs/` is to be replaced. (Contains the documentation.)


### Maintenance folder

!!! danger "Never replace the Maintenance Folder"

    The folder `maintenance/` documents changes made to the packages:
    you don’t want to lose this.

If the new folder is not empty, copy its content over.
Maintenance files can be used to carry out changes on all or some of the packages managed by the server, like adding a new property to the package config files of all packages.





