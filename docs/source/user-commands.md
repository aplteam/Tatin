---
title: "User commands"
description: "Use Tatin through its user commands"
keywords: 
---
# User commands

!!! abstract "User commands put Tatin packages at your fingertips"

Commands for building, publishing, deprecating, and deleting packages are on a [separate page](user-commands-publish.md).

User commands and their options are case-insensitive.

They all have help built in, for example

```
]tatin -?
]tatin -??
]TATIN.LoadPackages -?
```

!!! warning "Square brackets in the command syntax"

    Square brackets in the command syntaxes shown on this page indicate **optional command arguments**.
    For example, the `ListPackages` command has syntax

        ]TATIN.ListPackages [source]

    Above, `source` is optional.


## Command options

Options are further optional arguments to the command.

Specify all the command’s arguments _before_ any options.
Prefix options with dashes, e.g.

    ]TATIN.BuildPackage path/to/package path/to/target -bump=minor

Options affect only the current command.
They override settings in the [user settings](user-settings.md) and leave them unchanged.

Each command’s options are tabulated below its definition.


## Search patterns

Case-insensitive search patterns are used to find packages.
(Optional elements are bracketed.)

```
[reg][/][alias@][grp-]name[-maj[.min[.patch]]]
```

------|-----------------------------
reg   | registry alias or URL
alias | local alias for the package (use only for [installing packages](#install-packages) or [loading packages](#load-packages))
name  | package name
maj   | major version number
min   | minor version number
patch | patch number


!!! info "Registry scans"

    When scanning registries, Tatin scans all registries listed in the [user settings](user-settings.md) with a priority above 0.

---

## Cache

    ]TATIN.Cache [reg]

Where (optional) `reg` is a registry alias or URL, list Tatin package cache contents (domain names and package names) for `reg` if specified, otherwise for all known registries.

------|---
clear | List cached packages, ask for confirmation, then remove them.
force | With `clear`, skips confirmation. (Useful for tests.)
path  | Return full package paths.

```
      ]TATIN.cache '[tatin]'
  --- Entries in cache for tatin.dev/:
   aplteam-ADOC-7.1.2
   aplteam-GitHubAPIv3-1.4.0
   aplteam-CommTools-1.8.1
   ...
```

API:
[`ClearCache`](api.md#clear-cache),
[`ListCache`](api.md#list-cache)


## Copy registry

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


You can also use the API function [`CopyRegistry`](api.md#copy-registry) for this.


## Check for later version

    ]TATIN.CheckForLaterVersion folder

Where `folder` is the path to a package folder (contains an `apl-buildlist.json` file),
scan known registries
and list later **minor** versions of principal packages.
(List different major versions as different packages.)

Prints a table with columns:

---|---
1  | currently installed package ID
2  | package ID of the latest version found, or message, e.g. "no response" or "not found"
3  | URL of the original source registry
4  | `!` for a later version
5  | URL of registry with a different (usually later) version; might be empty

Reports registries not scanned because their priority is 0.

-------------|------------------------------
dependencies | Include dependencies
major        | Include later major versions

To update to latest minor version use [`]TATIN.ReInstallDependencies`](#reinstall-dependencies).
(New major versions need installing.)


## Debug

    ]TATIN.Debug [toggle]

Where `toggle` is 0, 1, `on` or `off`, set Debug Mode on or off.

If `toggle` is omitted, report current state.

With Debug Mode on, Tatin leaves application errors untrapped so you can investigate them.
(Error guards in dfns, errors when communicating via TCP/IP and similar errors are still trapped.)


## Documentation

    ]TATIN.Documentation

Open Tatin documentation in a browser window.


## Find dependencies

    ]TATIN.FindDependencies pkgs [sources]

Where

-   `pkgs` is a comma-delimited list of package IDs (minor and patch numbers are ignored)
-   `sources` is a registry URL or alias (`[*]` for all known), or a path to a folder;
    (optional: defaults to current folder)

scan the source/s recursively for folders with `apl-dependencies.txt` files and list results.

```
      ]TATIN.FindDependencies MarkAPL [*]
  https://tatin.dev/
                       aplteam-ADOC-7.0.0
                       aplteam-ADOC-7.0.1
                       aplteam-ADOC-7.1.0
                       ...
```

--------|----------
verbose | Report the actual package folder(s) rather than the hosting folder.

API:
[`FindDependencies`](api.md#find-dependencies)


## Init

    ]TATIN.Init [config]

Where (optional) `config` is a path to a folder containing a `tatin-client.json` file,
(re)set my user settings in `⎕SE`.

If `config` is omitted, use the default user-settings file.

Useful to apply in the session user settings that have changed on file.



## Install packages

    ]TATIN.InstallPackages pkgs [target]

Where

-   `pkgs` is a comma-separated list: each item identifies a package as one of

    -   a [search pattern](#search-patterns) (optionally including a package alias)
    -   `file://{path/to/ZIP}`

-   `target` (optional) is

    -   path to target folder
    -   `[MyUCMDs]name` or `[MyUCMDs]` (case insensitive)
    -   a Cider project alias

create the target folder if necessary, and
install there the package/s and any dependencies,
registering any package aliases specified.

??? tip "A local alias for a package allows you to use different versions of it in parallel."

    Don't use this for other purposes.

If `target` is `[MyUCMDs]` or `[MyUCMDs]name` install in `⎕SE`.
If `name` is omitted, the package name is used. However, if more than one user-command package is specified after `[MyUCMDs]` an error will be thrown.

If `target` is omitted, look for open Cider projects:
if just one is found, use it; if there are multiple, ask the user which one to use.

When installing into a Cider project,
if its `dependencies` and `dependencies_dev` properties identify one folder,
install there; if both are defined, ask the user.

If a search pattern does not specify a registry, scan known registries
and use the first hit.
(For dependencies, always scan.)

--------|---------------------
nobetas | Ignore beta versions.


??? example "Example arguments to InstallPackages"

    ```
    [tatin]/group-name-1.0.0 /path       ⍝ reg alias & package ID with "/"
    [tatin]group-name-1.0.0 /path        ⍝ reg alias & package ID without "/"
    [tatin]group-name-1.0 /path          ⍝ no patch no
    [tatin]group-name-1 /path            ⍝ neither patch nor minor no.
    [tatin]group-name /path              ⍝ no version information at all
    [tatin]name /path                    ⍝ no group and no version information
    [tatin]A@name /path                  ⍝ registry alias and package alias
    group-name-2.0.0 /path               ⍝ just a full package ID
    name /path                           ⍝ just a package name
    A@name /path                         ⍝ just a package name with a pkg alias
    file:///path/grp-name-1.0.0/ /path/  ⍝ package in a local Registry
    foo,bar /install/                    ⍝ multiple packages
    foo [MyUCMDs]                        ⍝ install user command foo
    foo [MyUCMDs]test                    ⍝ install user command foo into test/
    ```

API:
[`InstallPackages`](api.md#install-packages)


## List deprecated

    ]TATIN.ListDeprecated [reg]

Where `reg` is a registry alias or URL
list major versions of all deprecated packages.
If `reg` omitted, use `[tatin]`.

---|---
all | List all versions of all deprecated packages.

API:
[`ListDeprecated`](api.md#list-deprecated)



## List licenses

    ]TATIN.ListLicenses [reg]

Where `reg` is a registry alias or URL,
list the licences it accepts.

If `reg` omitted, use `[tatin]`.

```
      ]TATIN.ListLicenses
 Unlicense  CC0  0BSD  EPL  MIT  BSL  ISC  Apache  BSD-2  BSD-3
```

API:
[`ListLicences`](api.md#list-licences)


## List packages

    ]TATIN.ListPackages [source]

Where `source` is

-   a registry URL or alias
-   `[*]` for known registries (or `?` – ask the user)
-   path to a registry
-   path to an install folder

list the packages there, aggregated by major version.

If `source` is omitted, use `[tatin]`.

If `source` is an install folder, ignore command options
and show just package names, with a flag for principal packages.

---|----
group=       | list only packages in this group
dependencies | show all dependencies, assume `-noaggr`
tags=        | (comma-separated list) list only packages so tagged
uc           | list only packages that are user commands
os=          | (comma-separated list of `lin`, `mac`, `win`) list only packages for these operating system/s
since=       | (YYYYMMDD or YYYY-MM-DD) ignore packages published earlier (implies `-date` and assumes `-noaggr`)
date         | show publishing date and assume `-noaggr`
project_url  | show the URL
noaggr       | don’t aggregate

!!! tip "Both / or \\ work as path separators, and trailing separators are optional."

API:
[`ListPackages`](api.md#list-packages)



## List registries

    ]TATIN.ListRegistries

List alias, URL, ID, port, priority and no-caching flag of known registries
in descending order of priority.

If a registry does not respond, ask the user: retry, skip, or cancel the command.

-----|------------------
full | Show API keys too.
raw  | Show the raw data.

See also [`]TATIN.UserSettings`](#user-settings).

API:
[`ListRegistries`](api.md#list-registries)



## List tags

    ]TATIN.ListTags [source]

Where `source` (default `[tatin]`) is

-   a registry alias or URL
-   `?` (ask the user)

list alphabetically all tags used in all packages there.

---|---
tags= | (comma-separated list) show only tags on packages that have all the listed tags
os=   | (comma-separated list: `lin`, `mac` and `win`) show only tags on packages restricted to these operating systems

API:
[`ListTags`](api.md#list-tags)



## List versions

    ]TATIN.ListVersions pattern

Where `pattern` is a [search pattern](#search-patterns), list all versions of the package.

If the registry is specified as `?` or `[?]`, ask the user to choose one.

If no registry is specified, show registry URLs.

If version precedence is not clear from the version numbers (e.g. for beta versions)
take publication dates into account.

-----|-----------------------
date | Show publication dates.

API:
[`ListVersions`](api.md#list-versions)



## Load dependencies

    ]TATIN.LoadDependencies [source] [ns]

Where

-  `source` is the source: a folder, into which one or more packages have been installed,
    or `[MyUCMDs]` (case insensitive)
-  `ns` is the target namespace

recursively search the source folder for packages listed in `apl-dependencies.txt`
and load them into the target namespace unless already there.

If `ns` is omitted, the target namespace is the current namespace –
unless `source` is `[MyUCMDs]`, when it defaults to `⎕SE`.

If no arguments are specified, look for open Cider projects.
If one is open, use it; if multiple, ask which.
If the Cider project config defines multiple installation folders, ask which to use.

-----------------|----------------------------------------------------
makeHomeRelative | Instead of absolute paths, make `TatinVars.GetFullPath2AssetsFolder` and `TatinVars.HOME` return only the package folder and its parent.
overwrite        | Overwrite existing packages in the target namespace.

API:
[`LoadDependencies`](api.md#load-dependencies)



## Load packages

    ]TATIN.LoadPackages pkgs [ns]

Where

-   `pkgs` is a comma-separated list: each item identifies a package as one of

    -   a [search pattern](#search-patterns) (optionally including a package alias)
    -   `file://{path/to/folder}` or `file://{path/to/ZIP}`

-   `ns` is the target namespace (defaults to the current namespace)

load the package/s and all dependencies into the target,
register any aliases specified in `pkgs`,
and show the number of packages loaded, including dependencies.

??? tip "A local alias for a package allows you to use different versions of it in parallel."

    Don't use this for other purposes.

If a search pattern does not specify a registry, scan known registries
and use the first hit.
(For dependencies, always scan.)


--------|----------------------
nobetas | Ignore beta versions.
verbose | Report details.


!!! example "Example arguments to LoadPackages"

    ```
    group-name-2.0.0                ⍝ just full package ID without Registry
    [tatin]group-name-1.0           ⍝ alias & package ID without patch no.
    [tatin]group-name-1             ⍝ without patch and minor no.
    [tatin]group-name               ⍝ without any version information
    [tatin]/group-name-1.0.0        ⍝ with "/"
    [tatin]group-name-1.0.0         ⍝ without "/"
    [tatin]name #                   ⍝ with target namespace
    [tatin]A@name #                 ⍝ with package alias
    name #                          ⍝ no Registry and no group
    A@name                          ⍝ no Registry and no group but alias
    A@name #.Foo.Goo                ⍝ with target namespace
    file:///path/group-name-1.0.0/  ⍝ local Registry
    foo,bar                         ⍝ multiple packages
    [company]foo,[personal]bar      ⍝ multiple packages from specific servers
    ```

API:
[`LoadPackages`](api.md#load-packages)


## Load Tatin

    ]TATIN.LoadTatin

Load the Tatin client into `⎕SE` (resulting in `⎕SE.Tatin`), and initialize it.
Write a user config file in my home folder if there is none.

!!! tip "You can use [`Init`](#init) to temporarily switch to a different config."

----------|--------------------------------
force     | Overwrite existing installation.

!!! detail "Makes the Tatin API available."


## Package config

    ]TATIN.PackageConfig [source]

Where `source` is

-    a [search pattern](#search-patterns) including a registry alias or URL, ignore any command options, fetch and show the package config file
-    a path to a package folder, show its config file `apl-package.json`, creating it if necessary

If `source` is omitted,

1.  look for open Cider projects: if one is found, use it; if multiple, ask the user which.
1.  look for a package config file in the current directory and confirm with the user if found.

---|---
edit   | Let the user edit the config (since version 0.104.0 Tatin updates the workspace with the new config).
delete | Delete the config.

??? example

    ```
          ]TATIN.PackageConfig [tatin]MarkAPL
    {
      api: "API",
      assets: "Files/",
      date: 20240926.1737,
      description: "Converts Markdown to HTML5",
      documentation: "",
      files: "",
      group: "aplteam",
      io: 1,
      license: "MIT",
      lx: "",
      maintainer: "kai@aplteam.com",
      minimumAplVersion: "18.2",
      ml: 1,
      name: "MarkAPL",
      os_lin: 1,
      os_mac: 1,
      os_win: 1,
      project_url: "https://github.com/aplteam/MarkAPL",
      source: "APLSource/MarkAPL",
      tags: "markdown,converter",
      userCommandScript: "",
      version: "13.1.0+341",
    }
    ```



## Package dependencies

    ]TATIN.PackageDependencies [path]

Where `path` is the path to a folder containing a package,
display the content of its `apl-dependencies.txt` file,
creating one if necessary.

If `path` is omitted, look for open Cider projects:
if one is open, use it; if multiple, ask the user which.

-------|--------------------------------------------
edit   | Let the user edit the file.
delete | Delete the dependencies file.
force  | Don’t ask the user for confirmations (useful for test cases).


## Ping

    ]TATIN.Ping [source]

Where `source` is

-   a registry or registries, ping it/them and report which respond;
-   a folder, show whether it exists.

Specify a registry as a registry URL or alias, or `?`.

If `source` is

-   omitted, ping all known registries
-   `?` ask the user to choose registries

```
      ]TATIN.Ping
Questioning 2 Tatin Registries...
 https://tatin.dev/       1
 https://test.tatin.dev/  1
      ]TATIN.Ping /Users/sjt/tmp/Foo/packages
Questioning 1 Tatin Registry...
1
```

??? example "Examples"

        ]TATIN.Ping
        ]TATIN.Ping ?
        ]TATIN.Ping [tatin]
        ]TATIN.Ping https://tatin.dev
        ]TATIN.Ping http://tatin.dev   ⍝ This won't work

API:
[`Ping`](api.md#ping)



## Re-install dependencies

    ]TATIN.ReInstallDependencies [folder] [reg]

Where

-   `folder` is the path to a package folder
-   `reg` is a registry URL or alias

remove from the folder all packages listed in `apl-dependencies.txt` (except ZIP files),
compile a new build list, and use it to re/install the dependencies.

!!! tip "ZIP files have priority and are not removed."

If `folder` is unspecified, look for a subfolder of an open Cider project:
if one Cider project is open, use it; if multiple, ask the user which.
Either way, ask the user to confirm the folder.

If `reg` is not specified, scan known registries for the direct dependencies,
but scan known registries anyway for further dependencies.

----------|---------------------------------
dry       | Show what the command would do, but don’t do it.
force     | Skip confirmations (useful for tests).
nobetas   | Ignore beta versions.
recursive | Re-install dependencies in all child folders.
update    | Install the latest version of each dependency.

The `recursive` option was introduced in version 0.118.0.
With it you can re-install dependencies in all principal packages
in (say) your UCMDs folder without prompts:
```apl
]ReinstallDependencies [MyUCMDs] -recursive -update -force
```

API:
[`ReinstallDependencies`](api.md#reinstall-dependencies)


## Uninstall packages

    1. ]TATIN.UnInstallPackages package folder
    2. ]TATIN.UnInstallPackages package
    3. ]TATIN.UnInstallPackages folder -cleanup
    4. ]TATIN.UnInstallPackages ?

Where

---|---
package | <ul markdown><li>fully qualified name of a package</li><li>alias and fully qualified name of a package</li><li markdown>just a package alias (postfix with a `@` to mark it as alias)</li><li>package ID as group and name</li></ul>
folder | <ul markdown><li>path to a folder with installed packages</li><li markdown>`[MyUCMDs]` (case independent)</li><li>a Cider alias in square brackets</li></ul>

Uninstall, according to syntax,

1.  `package` from `folder`
2.  `package` from the currently open Cider project (if several open, ask the user which)
3.  from `folder` all superfluous packages; i.e. neither top-level nor dependency; e.g. outdated versions
4.  the top-level packages selected by the user, and any dependencies thus superfluous

If `folder` is a relative path, it must be a subfolder of an open Cider project.

--------|----------------------
cleanup | See syntax (3) above.
quiet   | Don’t report progress.

API:
[`UninstallPackages`](api.md#uninstall-packages)

!!! detail "If a package was installed twice, once with an alias and once without, running `]UnInstallPackage` on either of them does not uninstall the package but removes just the reference to it. Only when the other one is uninstalled as well, is the package actually removed."

## Update Tatin

    ]TATIN.UpdateTatin

If a later version of Tatin is available, download it from GitHub, install it into the folder it was started from, and display the release notes in a browser window.

!!! warning "Does not update the current workspace"

    To use the updated version, close the current session
    and start a new one.

In Dyalog 19.0 and later the command replaces the version installed in your home folder, not the shipped version, which remains unchanged.


If the update fails, calling it again rarely helps.

??? tip "Troubleshooting"

    === "Dyalog 19.0+"

        1. `]DeActivate tatin` to remove Tatin
        2. `]Activate tatin` to restore the version your installation was shipped with
        3. `]TATIN.UpdateTatin` to update to the latest version

    === "Dyalog 18.2"

        Uninstall Tatin, then install it again.


## Usage data

    ]TATIN.UsageData [reg] [ -download [-all] [-folder=] [-unzip] ]

Where `reg` is a registry URL or alias
(if omitted, ask me which)
list the usage files available.

---------|-----------------------------------------------
all      | Select all available.
download | Ask me which usage files to download to a subfolder of my temp folder.
folder=  | Download to this empty folder.
unzip    | Unzip downloaded file/s and delete ZIPs.

Note that `-all`, `-folder=` and `-unzip` only make sense when `-download` is specified.
!!! detail inline end "Package downloads"

    A package request might be one person taking a quick look,
    or several team members deploying the package in multiple projects,
    with all but the first request served from the Tatin client cache.
    No way to know.

    Tatin's test suite requests packages from both the Principal Registry and the Test server.
    These requests are flagged as part of a test and ignored when the usage data is compiled.


Each month, Tatin saves its request log as a CSV file,
compresses it, makes it available for download as `usage-data-<YYYY>-<MM>.csv`,
and deletes the previous usage file.
For example, in May 2022 it saved `usage-data-2022-04.csv` and deleted `usage-data-2022-03.csv`.

So the filename `usage-data-2022-04.csv` holds requests from 2022-01-01 to 2022-04-30 inclusive.

Each January, Tatin collects the data from last year and saves it in a file `usage-data-<YYYY>.csv`.
It also deletes any files `usage-data-<YYYY>-<MM>.csv`.

For example, in January 2023 it created a file `usage-data-2022.csv`, and deleted all files `usage-data-2022-*.csv`.

A Tatin server [offers a page](https://tatin.dev/v1/usage-data "Link to the principal Tatin server`s Usage Data page") dedicated to the usage data.
The page shows some of the data and provides links for downloading.

There are no API functions available for retrieving usage data.


## User settings

    ]TATIN.UserSettings

Print my user settings from the config file in JSON format,
hiding the API key.

!!! tip "To see current user settings rather than the file content, use the API."

--------|-------------------------------------------------------
edit    | Let the user edit the file, then ask the user whether to refresh current settings.
home    | Show path to the config file and do nothing else.
refresh | Refresh the current user settings from the config file.

API: [`UserSettings`](api.md#user-settings)


## Version

    ]TATIN.Version

Show the client’s Tatin version.

    ]TATIN.Version reg

Where `reg` is a registry URL or alias (if `?` ask the user which) show the Tatin version installed there.

    ]TATIN.Version -all
    ]TATIN.Version *

Show the Tatin versions of the client and known registries.

    ]TATIN.Version -check

Show the installed and minimum required versions of the Principal Registry.

!!! warning "Setting the `check` flag overrides all other arguments."

API:
[`Version`](api.md#version)


