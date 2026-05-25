---
title: 'Tatin API reference'
description: 'Complete reference to the Tatin API, which lets you call the Dyalog APL package manager from your own code.'
keywords: api, apl, dyalog, source, tatin
---
# API functions

!!! abstract "With the Tatin API you can write DevOps scripts in APL."

The API functions are similar to the [user-commands](user-commands.md), but not identical.
Not all have equivalent user commands.

[BuildPackage](#build-package)              [InitPackageConfig](#initpackage-config)
[CheckForLaterVersion](#check-for-later-version)      [InstallPackages](#install-packages)
[ClearCache](#clear-cache)                [ListDeprecated](#list-deprecated)
[CopyRegistry](#copy-registry)              [ListCache](#list-cache)
[CreateAPIfromCFG](#create-api-from-cfg)          [ListLicenses](#list-licenses)
[CreateBuildParms](#create-build-parms)          [ListPackages](#list-packages)
[CreateCopyRegistryParms](#create-copyregistry-parms)   [ListRegistries](#list-registries)
[CreateReInstallParms](#create-reinstall-parms)      [ListTags](#list-tags)
[DeletePackages](#delete-packages)            [ListVersions](#list-versions)
[DeprecatePackage](#deprecate-package)          [LoadDependencies](#load-dependencies)
[FindDependencies](#find-dependencies)          [LoadPackages](#load-packages)
[GetDeletePolicy](#get-deletepolicy)           [Ping](#ping)
[GetDependencyTree](#get-dependency-tree)         [PublishPackage](#publish-package)
[GetNoCachingFlag](#get-nocaching-flag)          [ReInstallDependencies](#reinstall-dependencies)
[GetPathToPackageCache](#get-path-to-package-cache)     [ReadPackageConfigFile](#read-package-config-file)
[GetUserHomeFolder](#get-user-home-folder)         [UnInstallPackages](#uninstall-packages)
[InitialisePackage](#initialise-package)         [Version](#version)
{: .typewriter}


Unlike user commands, API function names are case-sensitive.

The Tatin API is in `⎕SE.Tatin`.
Call an API function like this:

    ⎕SE.Tatin.BuildPackage parms

??? warning "API code cache"

    The Tatin code package is loaded into `⎕SE._Tatin`, but the API is exposed via `⎕SE.Tatin`.

    Do not call functions in `⎕SE._Tatin`.

---


## :fontawesome-solid-code: Build package

    zipFilename←BuildPackage parms


Zips all files required for a package into a file at `parms.targetPath` and returns its name.

Parameter space `parms` is typically created with [`CreateBuildParms`](#create-build-parms) and specifies:

`dependencyFolder`
: Path to folder with packages the project depends on. Default is `''`.

: Tatin searches the project for dependencies in (in order of precedence)

    1.  the folder specified in `dependencyFolder`
    1.  `cider.config` (for projects managed by Cider)
    1.  `packages/apl-dependencies.txt`
    1.  `apl-dependencies.txt`

`projectPath`
: Path to folder from which to create the package. (Required.)

`projectspace`
: Namespace that is to contain the package contents.

    ??? warning "Until version 0.118.0 this was known as `tatinVars`"

        Now, Tatin signals an error if it finds a `tatinVars` parameter.

`targetPath`
: Path to folder in which to write the ZIP file. Default is `''`: use `projectPath`.

`version`

: String. One of:

    -   A rule to modify the version number in the package config file:
        -   `'+0.0.1'` bumps the patch number
        -   `'+0.1.0'` bumps the minor number and resets the patch number
        -   `'+1.0.0'` bumps the major number and resets both the patch number and the minor number
    -   An empty character vector
    -   A string that replaces `version` in the package config file

    See [Glossary](glossary.md) for details.


## :fontawesome-solid-code: Check for later version

    r←{flags} CheckForLaterVersion path

Scans all known registries (with priority >0) for later versions of the principal packages installed in `path` and returns a matrix with columns:

    1 - Original package ID
    2 - Latest package ID
    3 - Original URL
    4 - Flag: whether later version is available
    5 - URL of latest version; empty if unchanged

By default, only principal packages and minor and patch numbers are checked.
Change this with optional left argument `flags`: the sum of the following. (Defaults to 0: do neither.)

    1 - List later major versions
    2 - Check package dependencies as well


## :fontawesome-solid-code: Clear cache

    (rc report)←ClearCache url

Clears the cache and returns ==FIXME==.

If `url` is

-   empty all subdirectories but `temp\` are removed
-   not empty, only the given domain is removed from the cache

The cache is the folder [`GetPathToPackageCache`](#get-path-to-package-cache) points to.


## :fontawesome-solid-code: Copy registry

    list←CopyRegistry parms

Copies packages from a managed Tatin registry to a local folder and returns
==as a list of strings the packages copied==

!!! warning "Pause or stop any running local server while `CopyRegistry` is running."

Argument `parms` is typically created with [CreateCopyRegistryParms](#create-copyregistry-parms), and then amended.
Required parameters are marked; others are optional.

`dry`
: List all packages the user command would copy without actually doing it.

    If set you may omit both URL (defaults to `[tatin]`) and `path`.

`force`
: Copy already available packages again.
    By default packages already saved in the target folder are not requested again.

`group=`
: Restrict the packages to be copied to a particular group.

    Dependencies will be copied as well, no matter which group they belong to.

`latest`
: Copy only the latest version of each major version of each non-deprecated package.

    By default all packages are copied, even deprecated ones.

`list=`
: Packages to copy, as one of

    -   A comma-separated list of package names

    -   A file of package names, one per row, specified with the `file://` protocol

    -   A variable name, prefixed by either `#.` or `⎕SE.`

    Specify packages consistently: either `<group>-<pkgName>` or `<group>-<pkgName>-<major>`

`noDeps`
: Flag. If set, ignore dependencies. (Useful only for test cases.)

`path`
: A local folder in which to write the packages. Required unless `dry` set.

`url`
: URL of the Tatin registry from which to copy. Required unless `dry` set.

`verbose=`
: By default, prints the names of all packages copied to `⎕SE`. <!-- FIXME Prints to `⎕SE` or copies to `⎕SE`? -->

    1 – print a detailed report for all packages (`Fetched` indicates success)

    2 – print a message for every package as the list is processed

!!! warning "`CopyRegistry` was introduced with version 0.110.0"

    Tatin registries running on earlier versions will not respond to it.


## :fontawesome-solid-code: Create API from CFG

    {noOf}←{names} CreateAPIfromCFG (source cfg)

<!-- FIXME arguments and results -->

Where

-------|-------------|------------
source | _reference_ | namespace containing the package objects
cfg    | ==_What?_== | package configuration
names  | _strings_   | (optional) names of objects in the namespace to be exposed in the API

then Tatin creates an API space as a child of `source` (with cover functions for the package’s public interface) and returns as a shy result the number of objects exposed.

If `names` is absent, the function looks for a constant `source.Public`.

!!! warning "Not for use with a scripted namespace."

See [Public Interface](public-interface.md) for more.



## :fontawesome-solid-code: Create build parms

    parms←CreateBuildParms projectPath

Creates a parameter space for [`BuildPackage`](#build-package) with parameters:

```
dependencyFolder
projectPath
targetPath
tatinVars
version
```

## :fontawesome-solid-code: Create CopyRegistry parms

    parms←CreateCopyRegistryParms y

Where `y` is either an empty vector or a parameter space,
returns a parameter space for [`CopyRegistry`](#copy-registry).


## :fontawesome-solid-code: Create ReInstall parms

    parms←CreateReInstallParms

Returns a parameter space with default parameters for the (optional) left argument of [`ReInstallDependencies`](#reinstall-dependencies), in particular, `noBetas`, `update` and `dry`.


## :fontawesome-solid-code: Delete packages

    (statusCode errMsg)←DeletePackages (regID packageIDs)

Deletes `packages` from Tatin registry `regID` and returns HTTP `statusCode` and `errMsg`, empty if successful.

All packages specified are removed from the same registry.
Specify `regID` as either

-   a URL
-   a Registry alias
-   a Registry ID

Specify `packages` as a string or list of strings, with each package and version precisely identified:

    <group-name>-<package-name>-<precise_version_number>

A Tatin registry will delete packages only if its configured [Delete policy](#get-delete-policy) permits.

The principal Tatin server operates a `None` policy, meaning that you cannot delete anything from it.

??? info "Why can’t I delete a package from the Tatin server?"

    The main design objective is to ensure a build that includes packages from the principal Tatin registries can always be reproduced in precisely the same way.

    If deleting a package is allowed – even when it is a beta version – then this cannot be guaranteed.

    If you happen to publish a package and realize seconds later that you made a formidable mistake?
    Increase the patch number, fix the problem and publish a new version: that’s the only way.




## :fontawesome-solid-code: Deprecate package

    msg←DeprecatePackage (registry comment package)

Where

-   `registry` is a URL or alias
-   `comment` is a string, such as `See package xyz instead`
-   `package` identifies a package with group name, package name, and (optionally) major version number

marks the package on the registry as deprecated.

If no major version number is provided, then _all_ major versions of the package are deprecated.

As the registry is defined, no scanning is done.


## :fontawesome-solid-code: Find dependencies

    r←{depth} FindDependencies (target pkgList [verbose])

Where

---|---|---
target | string | <p>one of:</p><ul markdown><li>a Registry alias</li><li markdown>`'[*]'` for all defined registries with a priority above 0</li><li>URL of a Tatin server</li><li>path to a folder where the packages of a registry are stored</li></ul>
pkgList | string | a list of package names separated by commas
verbose | flag | optional: whether to include more detail in the result; default 0
depth | integer | optional: limit on recursive search

then Tatin recursively scans the registry for the packages in `pkgList` and returns
a fully qualified list of all matches.
<!-- FIXME as what? -->

<!-- FIXME Get this to work, then include an example -->

By default only the folder containing a file `apl-dependencies.txt` with at least one of the defined packages is returned.
<!-- FIXME This implies the behaviour can be changed. How? -->

If `verbose` is set the actual package folders are returned instead of the hosting folder/s, revealing the precise version/s installed.

Specify packages in `pkgList` partially or in full. Name is required but group and version can be omitted. You can specify a major version number, but minor and patch numbers are ignored if specified.

The function scans `folder` recursively for a file `apl-dependencies.txt`. Folders containing such a file are searched for the packages listed in `pkgList`.
The search is not case-sensitive.

!!! tip "Useful for discovering where packages are used."

Set optional left argument `depth` to limit the number of levels searched.
A server sets this to 1 because it knows it only needs to search the child folders of the Registry folder, which greatly reduces the search time.

You can use it similarly if you know exactly what is stored where.


## :fontawesome-solid-code: Get delete policy

    r←GetDeletePolicy server

Where `server` is the alias or URL of a Tatin server, returns its delete policy:

----------|--------------------------------------
None      | a published package cannot be deleted
Any       | any package can be deleted
JustBetas | only beta versions can be deleted

```apl
      ⎕SE.Tatin.GetDeletePolicy 'https://tatin.dev'
None
      ⎕SE.Tatin.GetDeletePolicy '[tatin]'
None
```


## :fontawesome-solid-code: Get dependency tree

<!-- tree←{append} GetDependencyTree x -->
    tree←GetDependencyTree pkg

Where `pkg` is one of:

-   an HTTP request
-   a folder containing a package, e.g.<br>`file://C:\Temp\{group}-{name}-{major.minor.patch}\`
-   a path to a package in a local registry, e.g. `C:\MyReg\{packageID}`
-   a package ID (Tatin will search the registries defined in your config file)

Tatin returns a dependency tree as a matrix:

col | contains
----|---------
1   | flag: 1 – principal package; 0 – dependency
2   | ID of package that required the dependency
3   | full package ID
4   | full URL: either a local path (without protocol) or http(s)://...

This function requires the version number to be fully specified.

!!! danger "The function accepts an optional left argument for INTERNAL use only."
<!--
FIXME Why document if for internal use only?
Note that the function accepts an optional left argument, but this should not be specified by a user: it is only used internally.

#### Optional left argument `append`

The optional left argument defaults to 0, meaning a saved dependency tree is replaced. By passing a 1 as the left argument one can add to the saved dependency tree.
 -->


## :fontawesome-solid-code: Get NoCaching flag

    flag←GetNoCachingFlag registry

Where `registry` is a URI or alias, Tatin searches `MyUserSettings` for it.
If found the value of the `noCaching` property is returned, otherwise 0.

```apl
      ⎕SE.Tatin.GetNoCachingFlag '[tatin]'  ⍝ actual
0
      ⎕SE.Tatin.GetNoCachingFlag '[fubar]'  ⍝ default
0
```


## :fontawesome-solid-code: Get path to package cache

    path←GetPathToPackageCache

Returns `MyUserSettings.path2cache` if not empty, otherwise the standard path for caching, according to the operating system.

```apl
      ⎕SE.Tatin.GetPathToPackageCache     ⍝ macOS
/Applications/Dyalog/tatin-package-cache
```


## :fontawesome-solid-code: Get user home folder

    path←{aplVersion} GetUserHomeFolder str

Returns the standard path for user-specific data, with string `str` appended.


=== ":fontawesome-brands-windows: Windows"

        C:\Users\%USERPROFILE%\AppData\Roaming\Tatin

=== ":fontawesome-brands-linux: Linux"

        /home/{⎕AN}/Tatin

=== ":fontawesome-brands-apple: macOS"

        /Users/{⎕AN}/Tatin

```apl
      ⎕SE.Tatin.GetUserHomeFolder 'foo'    ⍝ macOS
/Users/sjt/Library/Application Support/Tatin/foo
```

Optional string `aplVersion` is used by test cases to simulate different versions of APL.


## :fontawesome-solid-code: Initialise package

    config←{configParms} InitialisePackage folder

Where `folder` is a path to a folder, and (optional) `configParms` is a parameter space, Tatin creates the folder if necessary and initializes it with a config file.

If the folder exists and already contains a config file, Tatin signals an error.

Optional left argument `configParms` is typically created with [`InitPackageConfig`](#initpackage-config)
but can be made from scratch:
```apl
  parms←⎕NS''
  parms.(group name version)←'aplteam' 'Foo' '1.0.0'
  cfg←parms ⎕SE.Tatin.InitialisePackage 'path/to/folder'
```


## :fontawesome-solid-code: InitPackage config

    cfg←{sourcePath}  InitPackageConfig parms

Where

`parms`
: is a an empty vector or a parameter space

`sourcePath`
: (optional) is a path to the package source folder

Tatin returns a parameter space for [`InitialisePackage`](#initialise-package).

The `source` parameter in the result is set by (in order of precedence)

1.  `sourcePath`
1.  `parms.source`
1.  global default in `MyUserSettings`

```apl
      showParms ⎕SE.Tatin.InitPackageConfig ⍬
api               :
assets            :
description       :
documentation     :
files             :
group             :
io                : 0
license           :
lx                :
maintainer        :
minimumAplVersion : 18.0
ml                : 0
name              :
os_lin            : 1
os_mac            : 1
os_win            : 1
project_url       :
source            :
tags              :
userCommandScript :
version           : 0.1.0
```


## :fontawesome-solid-code: Install packages

    r←{noBetas} InstallPackages (identifiers targetFolder)

Where

---|---|---
identifiers | string | comma-separated list of package identifiers
noBetas | flag | whether to exclude beta versions; default 0
targetFolder | string | `'[MyUCMDs]'`, or `'[MyUCMDs]{pkgname}'`, or a path to a folder

Tatin creates the target folder if necessary, installs the packages in it and returns (as a list of strings) the full names of the principal packages installed. The list length will be the number of packages specified as `identifiers`.

A package identifier is case-insensitive and one of:

-  an HTTP request for a package
-  a ZIP file containing a package
-  a folder containing a package, e.g. `file://C:\Temp\group-name-version\`
-  a path to a package in a registry, e.g. `[RegistryAlias]{group}-{name}-{major.minor.patch}` or `C:\MyReg\{group}-{name}-{major.minor.patch}`
-  a package ID that Tatin will search for in the registries specified in your config file

If `targetFolder` is `'[MyUCMDs]'`, or `'[MyUCMDs]{pkgname}'` (case independent) it is replaced by the actual path to the `MyUCMDs/` folder followed by the name specified or, if none was specified, the name of the package.

To install the latest version, omit minor+patch or even major+minor+patch.



## :fontawesome-solid-code: List cache

    list←{fullpath} ListCache registry [principalFlag]

Where

---|---|---
fullpath      | flag   | optional: report full paths; default 0
principalFlag | flag   | optional: default 0
registry      | string | empty, or a registry domain name or alias

returns the contents of the Tatin package cache as a nested list with an item for each domain represented in the cache.

<!-- FIXME What does `principalFlag` do? -->

Each result item is a pair:

1.  URL of the domain
1.  package names as a list of strings: if `fullpath` is set then the full paths instead

If the cache is empty the result is an empty list.


<!-- Refers to the `MyUserSettings` instance of the class `UserSettings`. -->


## :fontawesome-solid-code: List deprecated

    list←{all} ListDeprecated source

Where

-------|--------|---
all    | flag   | optional: include all versions; default 0
source | string | <p>is one of</p><ul markdown><li>an alias or URL for a Tatin registry</li><li markdown>path to an install folder (contains a file `apl-buildlist.json`)</li><li>alias, URL, or path to a Tatin registry and optionally a (possibly incomplete) package ID</li></ul>

returns (as a 1-column matrix of strings) a list of deprecated packages.

Only the last published version of a major version number is included.
Set the `all` flag to include all versions of any major version  marked as deprecated.

```apl
      ⎕SE.Tatin.ListDeprecated '[tatin]'
┌────────────────┐
│aplteam-APLGit-0│
└────────────────┘
      ⍴⎕SE.Tatin.ListDeprecated 'https://tatin.dev'
1 1
```


## :fontawesome-solid-code: List licenses

    licences←{verbose} ListLicences registry

Where `registry` is the URL or alias of a Tatin server and `verbose` is a flag (default 0), returns a list of licences.

The result is a list of strings – if `verbose` is set, a 2-column matrix of which the first column is licence names and the second their URLsThe result is a list of strings – if `verbose` is set, a 2-column matrix of which the first column is licence names and the second their URLs.

```
      ⎕SE.Tatin.ListLicenses '[tatin]'
 Unlicense  CC0  0BSD  EPL  MIT  BSL  ISC  Apache  BSD-2  BSD-3
      1 ⎕SE.Tatin.ListLicenses 'https://tatin.dev'
 Unlicense  https://en.wikipedia.org/wiki/Unlicense
 CC0        https://en.wikipedia.org/wiki/Creative_Commons_license#Zero_/_public_domain
 ...
```


## :fontawesome-solid-code: List packages

    packages←{parms} ListPackages source

Where

---|---|---
parms  | namespace | optional: parameter space
source | string | <p>one of</p><ul markdown><li>alias or URL of a Tatin registry or folder</li><li markdown>path to an install folder containg a file `apl-buildlist.json`</li><li>path to a registry and optionally a (possibly incomplete) package ID</li></ul>

returns (as a matrix) a list of packages.

The result matrix lists all packages at the source except those where the last package of a major version has been deprecated.
(See [`ListDeprecated`](#list-deprecated)).

The result matrix has 2–4 columns:

-------|---
1      | package ID
2      | if `source` is a folder, a `'*'` flags principal packages<br><br>if `source` is a registry, the number of major versions
[3]    | if `parms.date` is set, publication date
[3\|4] | if `parms.projectUrl` is set, the project URL

Leaving aside any filters specified in `parms`, if `source`

specifies a: | result lists:
-------------|-----------------------------------------------
registry     | all packages, aggregated by major version
package ID without a full version number | matching packages
package name without a group name | matching packages

<!--
If `parms` is specified it must contain parameters `group`, `tags` and `aggregate`.
It may contain `date`, `since`, `project_url` and/or `userCommand`.
 -->

Argument `parms` is optional; if specified, it must contain at least the first three parameters below.

------------|--------|---------------------------
**aggregate** | flag   | aggregate results by minor and patch numbers (default 1)
**group**      | string | list only packages from this group
**tags**       | string | (comma separated, case-insensitive) list only packages with these tags
date        | flag   | append a result column with publication dates
packageID   | string | package identifier: see below
project_url | flag   | append a result column with the project URL
since       | int \| string | date as e.g. `20220601` or  `'2022-06-01'` or `'20220601'`: packages published earlier are ignored
userCommand | flag   | whether to list only packages that are user commands

Parameter `aggregate` combines with any package ID in `source` to determine what packages get listed.

package ID | aggregate | column 1 | column 2
-----------|-----------|----------|----------
(empty)    | 1         | all packages | # of major versions
(empty)    | 0         | all packages | `⍬`
{name}     | 0         | packages that match name<br>(might belong to different groups) | # of major versions
{group}-{name} | 0    | all versions of the package | # of major versions
{group}-{name} | 1    | all major versions of that package | # of major versions
{group}-{name}-{major} | – | all versions (minor and patch) | # of major versions
{group}-{name}-{major}-{minor} | – | all patch versions of the package | ???

```apl
      ⍴r←⎕SE.Tatin.ListPackages '[tatin]'
58 2
      3↑[1] r
 abrudz-sort      1
 aplteam-ADOC     1
 aplteam-APLGit2  1
```

## :fontawesome-solid-code: List registries

    registries←ListRegistries type

Where `type` is a flag or `⍬`, returns as a matrix all registries specified in your config file.

Result `registries` has columns:

     1 – Alias
     2 – URL
     3 – ID
     4 – Port
     5 – Priority
     6 – No-caching flag
     7 – Proxy
    [8 – API key]

If `type` is set the result has an eighth column containing the API key.

```apl
      ⎕SE.Tatin.ListRegistries ⍬
 tatin       https://tatin.dev/       29fbeb21-c6a0-4691-b6b6-8a ...
 tatin-test  https://test.tatin.dev/  2a282315-bfd6-4b15-8fe7-8c ...
```


!!! warning "The result of the API function and the user command differ."

If the registry does not respond, Tatin signals an error.


## :fontawesome-solid-code: List tags

    list←{parms} ListTags registry

Where `registry` is the alias or URL of a registry, and `parms` is a parameter space, returns as a 2-column matrix all tags in use there:


    1 – tag name
    2 – number of occurrences

If optional argument `parms` contains a list of tags (comma-separated string) as parameter `tags`, then the result lists only tags shared by packages that carry **all** the specified tags.

```apl
      p←⎕NS ''
      p.tags←'markdown'
      p ⎕SE.Tatin.ListTags '[tatin]'
 converter  15
 help        8
 markdown   23
```


## :fontawesome-solid-code: List versions

    mat←{dateFlag} ListVersions pkg

Where (optional) `dateFlag` is a flag and `pkg` identifies a package, returns a list of all versions of the package.

String `pkg` is case-insensitive and can be

-   a package name
-   a group name and a package name
-   a URL pointing to a registry together with a package name
-   a registry alias and a package name
-   a local path to a registry together with a package name

A package name can be just the name or the group and the name. Also, you can specify a major version number, or a major and a minor version number.

(Specifying a patch number makes no sense; if specified, it is ignored.)

Examples:

    'example-versions'
    'example-versions-1'
    'example-versions-1.0'
    '[tatin-test]versions'
    '[tatin-test]example-versions'
    '[tatin-test]example-versions-1'
    '[tatin-test]example-versions-1.0'
    '[tatin-test]example-versions-1.0.1' ⍝ same as previous

In the first three cases known registries with a priority above zero are scanned.

Result `mat` has a column with full package names.

-   If `pkg` does not specify a registry, the first column is registry URLs.
-   If `dateFlag` is set, a last column has publication dates.

```
      1 ⎕SE.Tatin.ListVersions 'MarkAPL'
 https://tatin.dev/  aplteam-MarkAPL-11.0.0  20210427.09
 https://tatin.dev/  aplteam-MarkAPL-11.0.1  20210725.15
 https://tatin.dev/  aplteam-MarkAPL-11.0.2  20211012.07
 https://tatin.dev/  aplteam-MarkAPL-11.0.3  20220509.17
 ...

      ⍴ ⎕SE.Tatin.ListVersions '[tatin]MarkAPL'
15 1
```
If version precedence cannot be established from the version numbers alone (often a problem
with beta versions) then the publishing date is taken into account.


## :fontawesome-solid-code: Load dependencies

    {refs}←{options} LoadDependencies folder [target]

Where

--------|-----------|-----------------------------
options | 2 flags   | optional: default 0
folder  | string    | path to package source folder, or `'[MyUCMDs]'`
target  | reference | optional: target namespace

Loads all packages into `target` according to a build list in `folder` and returns a list of references to the loaded packages. (Principal packages only, not dependencies.)

If unspecified the `target` namespace defaults to `#`, unless `folder` is `'[MyUCMDs]'`, when it defaults to `⎕SE`.

The  flags in `options`:

1.  Overwrite if the package is already loaded
1.  Make home relative. See details below.

!!! detail "User commands"

    Case-insensitive alias `'[MyUCMDs]'` denotes the special folder `MyUCMDs/`, whose location depends on the operating system.

    So where a Tatin package has been installed as a user command (and perhaps bundled into the Dyalog runtime) you cannot use absolute paths for referring to assets.

    In that case the paths must be relative to `MyUCMDs/`.
    This is what the second `options` flag is for.

    The flag affects the result of `HOME` and `GetFullPath2AssetsFolder`. <!-- FIXME wossit? -->
    Rather than returning the full path, only the folder containing the packages, and its parent are returned, making it a relative path.

    Where no name is specified after `[MyUCMDs]` the subfolder is named after the package.

    To install multiple user-command packages, specify no name after `[MyUCMDs]` – otherwise Tatin signals an error.


## :fontawesome-solid-code: Load packages

    no←{noBetas} LoadPackages (identifiers targetSpace)

Where

---|---|---
noBetas     | flag   | optional: ignore beta versions; default 0
identifiers | string | comma-separated list of packages
targetSpace | ref    | fully-qualified namespace: target

Tatin loads packages dynamically into the target space and returns the number of principal packages loaded.

??? detail

    Tatin actually loads the package into `[#|⎕SE]._tatin.{packageName}` and puts a reference to it in `targetSpace`.

    Also loads any dependencies into `[#|⎕SE]._tatin` but does _not_ create references for them in `targetSpace`.

In `identifiers` specify a package as one of

-   an HTTP request
-   a ZIP file containing a package
-   a folder containing a package, e.g. `'file://C:/Temp/group-name-version'`
-   a path to a package in a registry, e.g. `'[RegistryAlias]{packageID}'` or `'C:\MyReg\{packageID}'`
-   a [package ID](glossary.md)

Where a package is specified as a package ID, Tatin searches the registries it knows with a priority above 0.
The first hit wins.

If the target space already exists but is not an ordinary namespace, Tatin signals an error.



## :fontawesome-solid-code: Ping

    flag←Ping source

Where `source` is

-   a registry alias or URL, `flag` is whether the host is up and running
-   a folder, `flag` is whether it exists

```apl
      ⎕SE.Tatin.Ping '[tatin]'
1
      ⎕SE.Tatin.Ping 'https://tatin.dev'
1

      ⎕SE.Tatin.Ping '/Users/sjt/tmp/Foo'
1
```


## :fontawesome-solid-code: Publish package

    {fn}←{deps} PublishPackage (source registry)

Where

---------|------------|-----------------------------------------
deps     | parm space | optional: argument for `BuildPackage`
source   | string     | folder from which to create the package
registry | string     | registry to which to publish the package

Tatin

1. Confirms no package has already been published to the registry under this name (case insensitive).
1. If `source` is a folder, uses [`BuildPackage`](#build-package) to zip the package into a temp folder; `deps`, if specified, is passed as the argument.
1. Moves the ZIP into the registry
1. If the registry is local, updates its index

<!-- FIXME `deps` was described here as a left argument to `BuildPackage`; the function is monadic, so I have presumed it is the *right* argument. -->

and returns

-----|---------------------------------------------------------
rc   | HTTP return code (whether the registry is remote or not)
emsg | error message: empty if `rc` is 200
zfn  | zip file name: empty if `source` is a ZIP file, otherwise name of the ZIP file created

!!! detail "Delete policy"

    The package is published no matter what the server’s delete policy is.

    That differs from the [user command](user-commands.md#publish-package), which asks you to confirm publication of a package that cannot then be deleted.


## :fontawesome-solid-code: Reinstall dependencies

    {refs}←{parms} ReInstallDependencies deps folder [reg]

Where

-------|------------|--------------
parms  | parm space | optional: typically created by calling [`CreateReInstallParms`](#CreateReInstallParms)
deps   | ???        | ???
folder | string     | target folder: contains `apl-dependencies.txt`
reg    | string     | optional: registry alias or URL

Tatin, in the target folder,

1.  deletes file `apl-buildlist.json` and all directories
2.  re-installs all files listed in `apl-dependencies.txt` (ignoring lines that start with a lamp `⍝`)

and returns
a list of references to the principal packages installed.
<!-- FIXME Confirm -->

Packages originally installed from ZIP files are just re-installed from their ZIP files without further ado.

If `reg` is omitted Tatin scans all known registries with a priority above `0`.
(Packages with different major version numbers are considered as different packages.)

Optional argument `parms` can specify three flags.
All default to 0,

--------|---------------------------------
noBetas | Ignore beta versions
update  | Update to a later version if available
dry     | Report what the function would do but don’t do it

??? detail "Registry scans"

    For each dependency Tatin scans known registries, even if `reg` was specified.

    Tatin queries every known registry with a priority above 0, highest priority number first. First hit wins.

    If you installed a package from a Tatin registry and later removed that registry from your user settings, or set its priority to 0, then `ReInstallDependencies` will **not** scan it, despite knowing perfectly well where the package came from.


## :fontawesome-solid-code: Read package config file

    cfg←ReadPackageConfigFile path

Where `path` is a path to a package Tatin returns its config file as a parameter namespace.

The `path` argument may optionally include the config file name `apl-package.json`.

```apl
      path←'path/to/packages/aplteam-APLTreeUtils2-1.4.0'
      q←⎕SE.Tatin.ReadPackageConfigFile path
      showParms q
api               : APLTreeUtils2
assets            :
date              : 20240325.14
description       : General utilities required by most members of the APLTree library
documentation     :
files             :
group             : aplteam
io                : 1
license           : MIT
lx                :
maintainer        : kai@aplteam.com
minimumAplVersion : 18.0
ml                : 1
name              : APLTreeUtils2
os_lin            : 1
os_mac            : 1
os_win            : 1
project_url       : https://github.com/aplteam/APLTreeUtils2
source            : APLSource/APLTreeUtils2.aplc
tags              : tools,utilities
uri               : https://tatin.dev/
userCommandScript :
version           : 1.4.0+78

```

## :fontawesome-solid-code: Uninstall packages

    (list emsg)←UnInstallPackage (packageID folder)

Where

---|---|---
packageID | string | a [full package ID](glossary.md) or an alias
folder    | string | <p>either</p><ul markdown><li>path to a package folder with a Tatin dependency file<br>`apl-dependencies.txt`</li><li markdown>`'[MyUCMDs]'` (case-insensitive)</li></ul>

Tatin attempts to un-install the package `packageID`
and any of its dependencies
(that are neither principal packages nor required by other packages)
and returns:

-----|-----------------|--------------------------------
list | strings | Fully qualified names of all removed packages. (Might include aliases.)
emsg | string  | Error message, ideally empty.

<!-- `[MyUCMDS]` would translate into `MyUCMDs/packages/`. -->

!!! detail "If the package was installed with an alias then `packageID` must be its alias."

If `packageID` matches more than one package, Tatin signals an error

If `packageID` is empty, Tatin attempts to clean up: remove any packages that are neither principal packages nor required by other packages

<!--
FIXME relates only to user command?
`folder` may be a subfolder of an open Cider project. Tatin works out the correct one; if there are multiple Cider projects open the user is questioned.
 -->

<!--
FIXME Move to user-commands.md
If a package was installed twice, once with an alias and once without, running `]UnInstallPackage` on either of them does not uninstall the package but removes just the reference to it. Only when the other one is uninstalled as well is the package actually removed.
 -->

<!--
FIXME If this relates only to package dependencies why confirm
      pkg is mentioned in the dependency file?
      How else would it have been identified?

To keep things simple Tatin performs the following steps:
1. Checks whether the package ID is mentioned in the dependency file. If not an error is thrown
3. Removes `packagedID` from the dependency file
4. Re-compile the build list based on the new dependency file
5. Removes all packages that are not mentioned in the build list anymore
 -->

!!! danger "Deleting parent folders"

    Removing the folders hosting the packages might fail for all sorts of reasons,
    even after successfully removing the package and any dependencies
    from both the dependency file and the build list.
    <!-- FIXME Seems a bit vague. Must keep zombie folders indefinitely? -->

## :fontawesome-solid-code: Version

    r←Version

Returns as strings Tatin’s name, version and date.

```
      ⎕SE.Tatin.Version
┌─────┬────────────┬──────────┐
│Tatin│0.112.1+1942│2024-08-16│
└─────┴────────────┴──────────┘
```

