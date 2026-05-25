---
title: 'Tatin user commands for hosting'
description: 'Further user commands for hosting Tatin packages'
keywords: apl,dyalog,host,publish,registry,tatin,ui
---
# User commands for hosting

!!! abstract "User commands for hosting a Tatin registry"

[CopyRegistry](#copy-registry)       [Maintenance](#maintenance)
{: .typewriter}

:fontawesome-solid-terminal:
[User commands](user-commands.md)<br>
:fontawesome-solid-terminal:
[User commands for publishing](user-commands-publish.md)


---
## :fontawesome-solid-terminal: Copy registry

    ]TATIN.CopyRegistry [source] [target]

Where

-   `source` is the URL or alias of a Tatin registry (defaults to `[tatin]`)
-   `target` is a path to a local folder (optional if `dry` flag set)

copy non-deprecated packages from `source` to `target` if not already present.

-------|-------------------------------
dependencies= | Flag: whether to copy dependencies, default 1. (Useful only for test cases.)
dry    | List packages that would be copied, but copy nothing.
force  | Overwrite existing packages.
group= | Copy packages only from specified group, but also their dependencies.
latest | Copy only the latest minor version of each major version.
list=  | <p>One of</p><ul markdown><li>a comma-separated list of package IDs</li><li markdown>a file with package names, one per row, specified with the `file://` protocol</li><li markdown>a fully qualified variable name</li></ul><p>Specify all packages as group-name or group-name-major.</p>
verbose= | <ol markdown><li>Print a detailed report for each package copied.</li><li>Print reports as the list is processed.</li></ol>

??? example "Examples"

    List packages that would be copied.

        ]CopyRegistry [tatin] -dry
        ]CopyRegistry -dry

    Copy all packages from `[tatin]` if not already available.

        ]CopyRegistry /path/2/Reg

    Copy the latest minor versions of the highest major versions of packages from `[company-reg]`.

        ]CopyRegistry [company-reg] /path/2/Reg -latest

    Copy from `[tatin]` all packages of the group `aplteam`.

        ]CopyRegistry /path/2/Reg group=aplteam -force

    Copy from `[tatin]`, if not already available, packages listed in variable `#.MyVars`.

        #.MyVars←'aplteam-FilesAndDirs,aplteam-APLTreeUtils2'
        ]CopyRegistry /path/2/Reg -list=#.MyVars

    Copy from `[tatin]` packages specified in variable `#.MyVars`

        ]CopyRegistry /path/2/Reg -list=aplteam-FilesAndDirs-4 -force

    Copy all packages specified in the file /myPkgs.txt if not already available

        ]CopyRegistry /path/2/Reg -list=file=/myPkgs.txt

:fontawesome-solid-code: API:
[`CopyRegistry`](api.md#copy-registry)




## :fontawesome-solid-terminal: Maintenance

    ]TATIN.Maintenance [path]

Where `path` is a path to a folder containing one or more packages,
ask me to select functions from the Maintenance Library,
then apply them to the packages.

Invoked with an option, the command displays information only
and leaves the packages untouched.

-----|--------------------------------------------------------
dry  | Show what the command would do.
info | Show more information about the command and its purpose.
show | Show the leading comments of the selected functions.


The `Maintenance/` folder in the Tatin installation folder holds maintenance jobs:
APLF files for functions that modify Tatin packages.

The command asks you to pick jobs to run from the Maintenance Folder,
then searches recursively in the file path for package config files.
When it finds one, it applies the maintenance functions sequentially,
with the package config data as argument, <!-- FIXME Not 'G'? -->
receiving the same as result, possibly modified,
which it writes back to the package, and also to the ZIP file.


The name of a maintenance function follows a pattern:
==the date it was introduced==, and <!-- FIXME No longer true? -->
a short description of what it does.
Tatin records the run and prevents repetition,
by appending the extension `.executed` to the APLF file’s name.

Some use cases:

-   inject new properties into package config files
-   remove deprecated properties from package config files
-   rename properties in package config files

Release notes tell you when a maintenance function is introduced,
and when, why, and for what to use it.


