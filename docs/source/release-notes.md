---
title: "Release Notes"
description: "Version release history"
keywords: 
---
# Release notes


The notes contain 

-   actions to take before using a new version
-   important information regarding compatibility

For a complete list of fixes, added features, etc. see [Tatin on GitHub](https://github.com/aplteam/Tatin).

 
---

## v0.124.0 ⋄ 2026-06-03

* The result of the function `Client.CopyRegistry` has changed: it's now always a two-column matrix.

* `CopyRegistry` has changed, refer to the API documentation.

## v0.123.0 ⋄ 2025-12-07

* No action required

## v0.122.0 ⋄ 2025-09-29

* No action required

## v0.121.1 ⋄ 2025-08-08

* No action required

## v0.121.0 ⋄ 2025-07-10

* The API function `Client.ListPackagesInInstallFolder` returned two columns in earlier versions; now it returns four columns.

## v0.120.0 ⋄ 2025-05-03

`LoadPackages` now throws an error when one of the packages specified cannot be found. No package is loaded.

No action required

## v0.119.0 ⋄ 2025-03-12

No action required

## v0.118.2 ⋄ 2025-02-03

No action required

## v0.118.1 ⋄ 2025-01-14

No action required

## v0.118.0 ⋄ 2024-12-30

The API function `BuildPackage` does not process a property `tatinVars` anymore; if it is fed one anyway, it will throw an error.

The function `CreateBuildParms` does not contain a variable `tatinVars` anymore but a variable `projectspace`, which is optional.
You may set it to the namespace where the package project lives.
That enables `BuildPackage` to update `TatinVars.CONFIG` in that namespace, otherwise `BuildPackage` doesn’t know where to look.

Accordingly the option `-tatinVars=` was removed from the `]BuildPackage` user command but the option `-projectspace=` was introduced.

The user command `]ReInstallDependencies` now accepts a flag `-recursive`.
This can be put to use with a folder that contains multiple independent packages, for example the folder `[MyUCMDs]`: all installed packages in that folder can be re-installed and (in this instance) updated without user interaction with the following statement.

    ]ReInstallDependencies [MyUCMDs] -recursive -update -force

## v0.117.0 ⋄ 2024-12-08

The way build numbers are processed has changed: prior to 0.117.0 when a complete version number — including a build number —  was passed on to `]BuildPackage` the build number was not bumped. Now it is bumped.

## v0.116.0 ⋄ 2024-11-30

Tatin now requires at least 18.2: 18.0 is not supported any longer.

## v0.115.3 ⋄ 2024-11-25

Fixes a gaping security hole (Server only, group home page)

## v0.115.2 ⋄ 2024-11-16

No action required

## v0.115.1 ⋄ 2024-11-15

No action required

## v0.115.0 ⋄ 2024-10-14

No action required

## v0.114.0 ⋄ 2024-09-30

In case you are on Windows and you are using OneDrive then you might need to pay attention. 

Older versions of Tatin did not cooperate with OneDrive; this can potentially cause problems. A new document, "Tatin and OneDrive," discusses this issue. If you use OneDrive, read it!

Otherwise no action is required, but be aware of changes made to `]ListVersions`: if no argument is provided it checks on open Cider projects now. In other words, it became more powerful.

## v0.113.1 ⋄ 2024-09-08

No action required

## v0.113.0 ⋄ 2024-09-05

No action required

## v0.112.1 ⋄ 2024-08-16

No action required

## v0.112.0 ⋄ 2024-07-14

The `]CopyRegistry` user command, introduced in 0.110.0, got a changed syntax:

-   The `-full` flag was removed.

-   Default behaviour is now what was so far achievable with `-full` 
    except that deprecated packages are now copied as well.

    This is a necessity for compatability, because some package might well depend on an earlier version of a now deprecated package.

-   With `-dry` one might omit both arguments, meaning that the URL defaults to `[tatin]` while no path is required.

-   The list of copied packages is now returned as a matrix.

## v0.111.0 ⋄ 2024-07-12

No action required

## v0.110.0 ⋄ 2024-07-09

A maintenance file "2024-07-07-Inject-Exclude.aplf" was introduced. 

It allows to add the new "exclude" property (introduced with version 0.109.0) to be introduced into all saved packages as an empty text vector.

You don't have to run this maintenance function on all your packages (Tatin deals with both a defined "exclude" as well
as an absent "exclude") but it is better for future use when this is part of all packages.

## v0.109.0 ⋄ 2024-06-27

No action required

## v0.108.1 ⋄ 2024-05-04

No action required

## v0.108.0 ⋄ 2024-05-02

* You must update your client to 0.108.0 for correct results — prior versions are incompatible with 0.108.0!

## v0.107.0 ⋄ 2024-04-04

The syntax of the API function `DeletePackages` has changed.

## v0.106.2 ⋄ 2024-03-27

Action is required with version 18.2 and/or 18.0

With this version the Tatin user commands won't be available in the session until you either execute `]UReset` yourself, or you add the following code to your `setup.dyalog` in `MyUCMDs/`:

```
:If ~IfAtLeastVersion 19
    {}⎕SE.SALTUtils.ResetUCMDcache -1                 
:EndIf
```

## v0.106.1 ⋄ 2024-03-18

No action required when running Tatin. 

## v0.106.0 ⋄ 2024-03-12

No action required when running Tatin. 

  However, when developing (contributing to) Tatin there is a significant change: read "Special case: working on user commands" in the "Tatin for Contributors" document for details.

## v0.105.0 ⋄ 2024-03-02

Potentially breaking changes: 

-   The function `DeletePackage` was renamed: `DeletePackages`
-   The user command `]DeletePackage` was renamed: `]DeletePackages`

## v0.104.1 ⋄ 2024-01-28

The client requires a server on 0.104.1 as well

## v0.104.0 ⋄ 2024-01-22

The result of both `]ListRegistries` and the corresponding API function return a different (extended) result now.

This implies that older versions of Tatin than 0.104.0 are incompatible with this new version, therefore you are forced to update.

Apart from the update no action is required.

## v0.103.2 ⋄ 2024-01-16

No action required.

## v0.103.1 ⋄ 2023-12-14

No action required.

## v0.103.0 ⋄ 2023-11-04

No action required but note that the result of the API function `LoadPackages` has changed.

## v0.102.3 ⋄ 2023-10-13

No action required

## v0.102.2 ⋄ 2023-10-09

No action required

## v0.102.1 ⋄ 2023-10-07

Most importantly, a bug fix in `]TATIN.CiderUpdate`

## v0.102.0 ⋄ 2023-10-04

Most importantly, a revised install procedure

## v0.101.2 ⋄ 2023-09-30

Very important bug fix in `UnInstallPackages`

## v0.101.1 ⋄ 2023-09-26

Two massive changes:

-   This version is only compatible with Cider 0.36.0 or later

-   The installation folder is not `MyUCMDs/` anymore. However, `]TATIN.UpdateTatin` of your old version cannot know about this, therefore you have to take action once in order to get Tatin into the right folder. 

    See [`]UpdateTatin`](user-commands.md#update-tatin) for details.

-   In future `]TATIN.UpdateTatin` will use the new installation folder.

## v0.100.2 ⋄ 2023-09-23

No breaking changes, no user actions required.

## v0.100.1 ⋄ 2023-08-28

No breaking changes, no user actions required.

## v0.100.0 ⋄ 2023-08-27

No breaking changes, no user actions required.

## v0.99.1 ⋄ 2023-08-05

No breaking changes, no user actions required.

## v0.99.0 ⋄ 2023-08-02

No breaking changes, no user actions required.

## v0.98.2 ⋄ 2023-07-14

This release addresses a bug in the server; the client has not been changed.

Update only required if you run a server.

## v0.98.1 ⋄ 2023-07-13

No breaking changes, no user actions required.

## v0.98.0 ⋄ 2023-07-05

* No breaking changes for the Tatin client, therefore there are no user actions required

* If you run a Tatin server you don't need to take action but you should be aware of a major change

Before version 0.98.0 credentials got stored in a file `Credentials.txt`. The format was:

```
<group>=<api-key>
```

The API-keys were stored as clear text. We don't want that anymore.

With version 0.98.0 credentials will be stored in a file `Credentials.csv`. The format is different:

```
<group>,<api-key-hash>,<Salt>
```

The server will convert `Credentials.txt` automatically into `Credentials.csv`. Afterwards there is a new file `Credentials.csv` while the old file `Credentials.txt` will be deleted.

Note that you might create at a later stage a new file `Credentials.txt` with entries like

```
<group-name>=<api-key>
```

or

```
<group-name>,<api-key>
```

That allows you to add new groups, or overwrite existing ones, for example when somebody lost the API-key.

The server will perform the following actions:

-   Take the data and convert it
-   Delete rows from `Credentials.csv` that are also contained in `Credentials.txt` (same group name)
-   Add the data to `Credentials.csv` 
-   Delete `Credentials.txt`

## v0.97.1 ⋄ 2023-06-30

No breaking changes, no user actions required.

## v0.97.0 ⋄ 2023-06-14

This version comes with several breaking changes:

-   The `]FindDependencies` user command's `-detailed` property has been renamed to `verbose`
-   The API function `FindDependencies` has a changed syntax and returns a changed result.


## v0.96.2 ⋄ 2023-06-08

No breaking changes, no user actions required.

## v0.96.1 ⋄ 2023-05-21

No breaking changes, no user actions required.

## v0.96.0 ⋄ 2023-05-18

No breaking changes, no user actions required.


