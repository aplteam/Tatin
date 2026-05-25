---
title: 'Tatin: Package Configuration'
description: 'Your package’s configuration contains essential information about it.'
keywords: apl,configuration,package,tatin
---
# Package configuration

!!! abstract "Your package’s configuration contains essential information about it."

Your package configuration is in file `apl-package.json` in the package root.

!!! example

    ```json
    {
      api: "DotNetZip",
      assets: "",
      description: "Zipping and unzipping with .NET Core on all major platforms",
      documentation: "",
      exclude: "",
      files: "",
      group: "aplteam",
      io: 1,
      license: "MIT",
      lx: "",
      maintainer: "kai@aplteam.com",
      minimumAplVersion: "18.2",
      ml: 1,
      name: "DotNetZip",
      os_lin: 1,
      os_mac: 1,
      os_win: 1,
      project_url: "https://github.com/aplteam/DotNetZip",
      source: "DotNetZip.aplc",
      tags: "zip-tools",
      tatin_version: "0.103.0",
      userCommandScript: "",
      version: "0.5.4",
    }
    ```


!!! detail "Key `wx` was removed in Tatin version 0.61.0."

:fontawesome-solid-terminal:
[`]CreatePackage`](user-commands-publish.md#create-package)<br>
:fontawesome-solid-terminal:
[`]PackageConfig`](user-commands.md#package-config)<br>
:fontawesome-solid-code:
[`InitialisePackage`](api.md#initialise-package)<br>
:fontawesome-solid-code:
[`InitPackageConfig`](api.md#init-package-config)<br>
:fontawesome-solid-code:
[`ReadPackageConfigFile`](api.md#read-package-config-file)


## Standard settings

All the standard settings are optional except those marked required.

A configuration setting or parameter is ‘set’ when a file key or parameter variable is defined with a non-empty string.

`api`
: _String_. The name of a namespace that is to contain the [public interface](api.md#create-api-from-cfg) to the package.
    (`'API'` is a good choice.)

`assets`
: _String_. Path to a folder containing the package’s assets, relative to the package root.

    !!! danger "Treat the assets folder as read-only: do not write to it from a package."

    ??? warning "Tatin signals an error…"

        If

        -   the path contains a `:` or begins with `/`, **unless** the path begins with absolute path to the package root, when Tatin silently converts it to a relative path
        -   the path does not point to an existing folder

    See also `files` and [`GetFullPath2AssetsFolder`](#package-metadata).

    ??? tip "Access package assets from a class instance"

        If you need to access assets from an instance of a class in a package you can either:

        1.  Add to the class a function like this:

            ```apl
            ∇ r←GetAssetFolder
              r←##.TatinVars.GetFullPath2AssetsFolder
            ∇
            ```

        2.  Use the expression `⊃⊃⎕CLASS ⎕THIS` to locate the class script, i.e.

            ```apl
            (⊃⊃⎕CLASS ⎕THIS).##.TatinVars.GetFullPath2AssetsFolder
            ```

    ??? tip "Access platform-dependent assets"

        There is no general solution for the problem of platform-dependent assets.
        One way to solve this is to use [`lx`](#lx).

`deprecated`
: _Flag_. Whether the package is [deprecated](user-commands-publish.md#deprecate-package); default 0.

`deprecate_comment`
: _String_. Why the package was deprecated.


`description`
: _String_. **Required**. What the package does, or what problems it solves.

`documentation`
: _String_. Either:

    -   URL of an online help resource, beginning `http://` or `https://`
    -   local relative path to a file (or program) within the package, beginning `./`
    -   pointer to a function or a variable in the package, beginning `⎕THIS.`, e.g. `⎕THIS.Admin.ShowHelp`

`exclude`
: _Comma-delimited string._ Paths from `source` to file/s or directories to exclude from the package.


    ??? tip "Use cases"

        To publish your package both as a Tatin package and also on GitHub, consider how to specify `⎕IO` and `⎕ML`.

        Tatin packages allow these values to be set in the package config.

        For GitHub you can set them in the `APLSource/` folder as files `⎕IO.apla` and `⎕ML.apla`; Link will load and set them.

        The non-ANSI characters in the filenames make zipping and unzipping across platforms unreliable.
        Since the two files are not required by the Tatin package, they can be excluded from the build, which lets you avoid this.

        ```json
        exclude: "⎕IO.apla, ⎕ML.apla",
        ```

        <!-- For better compatability this property is not injected into new packages but accepted as an optional parameter. This might be changed with version 1.0.0 of Tatin. -->

`files`
: _Comma-delimited string._ Files and/or folders to be moved into the package root, e.g. `ReadMe.txt`. (See also [`assets`](#assets).)

    !!! info "By convention, a file `LICENSE` in the project root is copied to the package root when the package is built."

`group`
: _String._ The group part of the [full package ID](glossary.md).
    You can specify a default in your [user settings](user-settings.md).

`io`
: _Integer._ Value to be assigned to `⎕IO`.

`license`
: _String._ Each Tatin registry [publishes a list](user-commands.md#list-licences) of licences it accepts for packages it hosts.


`lx`

: _String_. Name of a niladic or monadic function in the top-level namespace of the package (_not_ in what might be defined as API!) or a shared method of a class.

    This will be executed by either `LoadPackages` or `LoadDependencies` _after_ all dependencies have been loaded and all refs established, i.e. at a very late stage.
    You could use it

    -   to initialise a package on bringing it into the workspace
    -   to deal with platform-dependent assets

    If the function is monadic its argument is the file path to the package.
    (If the package is brought into the workspace by `LoadPackages` and has no assets,  the argument will be empty.)

    The function must return a result, which is assigned to `TatinVars.LX` inside the [package space](glossary.md).
    (Without an `lx` object there will be no `TatinVars.LX`.)

    ??? tip "Trapping errors"

        The `lx` function is executed under error trapping, and any error silently ignored.
        You have two alternatives to this:

        1.  Localise `⎕TRAP` to the `lx` function and set `⎕TRAP←0 'S'` to make any problem pop up straight away

        1.  Put `:TRAP ⋄ :EndTrap` around the code in the `lx` function and deal with problems yourself, for example in the `:Else` branch.

        The existence of `TatinVars.LX` indicates an `lx` function was executed successfully, even if it is empty.

`maintainer`
: _String_. Email address for the package maintainer. Valid formats:

    ```
    your name <your.name@your-domain.com>
    your.name <your.name@your-domain.com>
    your.name@your-domain.com
    ```

    Any double quotes are removed.

    You can define a default value in the [user settings](user-settings.md).
    Otherwise, if `maintainer` is empty at publication time,
    the registry assigns the email address from the group’s home page if there is one.

`minimumAplVersion`

: _String_. Minimum APL version for the package.

    Tatin itself needs at least version 18.2, so this setting cannot be less.

`ml`
: _Integer._ Value to be assigned to `⎕ML`.

`name`
: _String._ The name part of the [full package ID](glossary.md).

`os_lin`
: _Flag._ Whether the package runs under Linux.

`os_mac`
: _Flag._ Whether the package runs under macOS.

`os_win`
: _Flag._ Whether the package runs under Windows.

`project_url`
: _String._ URL to where the project is hosted, e.g.

        https://github.com/aplteam/MarkAPL

`source`
: !!! detail inline end ""
        Code file extensions:
        ```
        .aplc     ⍝ class
        .aplf     ⍝ function
        .apln     ⍝ namespace
        .aplo     ⍝ operator
        .dyalog   ⍝ SALT script
        ```

: _String._ **Required**. Path, relative to the package root, to a code file, or to a folder of code files.

    (Tatin ignores non-code files.)

    You can specify a default `source` in your [user settings](user-settings.md).

    ??? warning "Tatin does not guarantee compatibility with SALT"

        The `.dyalog` extension is still used by the user-command framework, so Tatin supports it: a user command might well be delivered as a Tatin package.

        Using the `.dyalog` extension outside this context is discouraged.



    ??? detail "Cider and Tatin source properties"

        If you use Cider to manage your project, you see both Cider and Tatin configs have a `source` property. The Cider `source` refers to the Cider project, while the Tatin `source` refers to the package to be published.

        Suppose project Foo consists of a single class `Foo`:
        ```
        Foo/
        ├── APLSource/
        │   ├── Admin/
        │   ├── Foo.aplc
        │   └── TestCases/
        ├── README.md
        ├── apl-package.json
        └── cider.config
        ```
        In `cider.config` the `source` is `APLSource`, because that’s where the code lives.

        In `apl-package.json` however, `source` is `APLSource/Foo.aplc`, because that is what goes in the package.

        A slightly more complex example, with a namespace that hosts several functions:
        ```
        Goo/
        ├── APLSource/
        │   ├── Admin/
        │   ├── Foo.aplc
        │   ├── Goo/
        │   └── TestCases/
        ├── README.md
        ├── apl-package.json
        └── cider.config
        ```
        In this case, the package `source` package could be `APLSource/Goo`, because`Admin` and `TestCases` do not go in the package.


`tags`
: _Comma-delimited string._ **Required**. A list of tags (keywords) to help searchers.

    ??? tip "Tags should relate only to the problems one can solve with the package."

        Operating systems have their own properties (`os_lin`, `os_mac`, `os_win`) introduced with Tatin version 0.81.0.

        There is no point in adding tags like `dyalog` or `apl`…

        Admins of the Principal Registry might silently edit them to keep them consistent and meaningful.

`userCommandScript`
: _String._ Path, relative to the project root, of the user-command script. Identifies and required for [user-command packages](publish-packages.md#user-command-packages). (Introduced in Tatin version 0.86.0.)


`version`
: _String._ Version in the [full package ID](glossary.md).


## Read-only settings

Set by Tatin:

`date`
: _Float._ Date of publication, in the format `yyyymmdd.hhmmss`.

`tatin_version`
: _String._ Tatin version number (no build ID) by which the config data was created or changed.

`url`
: _String._ Source from which package was loaded or installed: URL or file path.



## System variables

APL system variables `⎕IO` and `⎕ML` are local in each package.
They require special treatment, because

-   a package’s definitions might depend on them
-   any subnamespaces inherit the values

Before any code is loaded into a namespace created by `LoadPackages` or `LoadDependencies` Tatin sets these values as

1.  the `io` and `ml` settings in the package configuration; else
1.  the two Dyalog parameters (environment variables) `Default_IO` and `Default_ML`; else
1.  Dyalog’s default value: 1.

??? warning "Don’t set these values in array files"

    Although including array files `⎕IO.apla` or `⎕ML.apla` would cause Link to set the system variables correctly, zipping their file names can break publication.

    See `exclude` for detail.


## User-defined variables

You can set your own variables in a package configuration file.

To avoid name conflicts, your variable names must begin with an underscore.
(Tatin signals an error if it encounters a name it does not know, unless the name begins with an underscore.)


## Package metadata

When Tatin loads a package, it writes its metadata into a namespace `TatinVars` within the package.

For example, suppose Tatin has loaded packages Foo and Goo, and both depend on MarkAPL.

In the workspace we find

    #.Foo
    #.Foo.MarkAPL
    #.Foo.MarkAPL.APLTreeUtils2
    #.Foo.MarkAPL.CommTools
    #.Foo.MarkAPL.FilesAndDirs
    #.Goo
    #.Goo.MarkAPL
    ...

These are refs to the package cache in `#._tatin`.
```apl
      #.Foo.MarkAPL           ⍝ ref to API of cached package
#._tatin.aplteam_MarkAPL_13_1_0.API
      #._tatin.⎕NL 9          ⍝ content of package cache
aplteam-APLTreeUtils2-1.4.0
aplteam-CommTools-1.8.1
aplteam-FilesAndDirs-5.8.0
aplteam_MarkAPL_13_1_0
my_Foo_1_0_0
my_Goo_1_1_0
```
Metadata ‘constants’ in `TatinVars` are niladic functions.
```apl
      )CS #._tatin.aplteam_MarkAPL_13_1_0
#._tatin.aplteam_MarkAPL_13_1_0
      ⎕NL 9                   ⍝ content of cached package
API
APLTreeUtils2
CommTools
FilesAndDirs
LeanPubIcons
MarkAPL
TatinVars
      TatinVars.⎕NL 3         ⍝ metadata 'constants'
ASSETS
CONFIG
DEPENDENCIES
GetFullPath2AssetsFolder
HOME
ID
URI
```

So any package function can refer to its metadata
– e.g. `HOME` as `##.TatinVars.HOME`.


`ASSETS`
: _String._ Path to the assets, relative to `HOME` – empty if there are none.

`CONFIG`
: _String._ Contents of `apl-package.json`.

    ??? tip "Convert to parameter space"

        ```apl
              cfg←(⎕JSON ⍠ 'Dialect' 'JSON5') TatinVars.CONFIG
              cfg.⎕NL 2
        api
        assets
        date
        description
        documentation
        files
        group
        io
        license
        lx
        maintainer
        minimumAplVersion
        ml
        name
        os_lin
        os_mac
        os_win
        project_url
        source
        tags
        uri
        userCommandScript
        version
              cfg.name
        MarkAPL
        ```

`DEPENDENCIES`
: _Strings._ [Full package IDs](glossary.md) of this package’s dependencies.

`GetFullPath2AssetsFolder`
: _String._ Absolute path to the assets, relative to `HOME` – empty if there are none.

    If `HOME` is empty or does not exist on disk the result is `ASSETS`

    ```apl
          #.MarkAPL
    #._tatin.aplteam_MarkAPL_13_1_0.API
          )CS #._tatin.aplteam_MarkAPL_13_1_0
    #._tatin.aplteam_MarkAPL_13_1_0
          ↑TatinVars.(HOME ASSETS GetFullPath2AssetsFolder)
    /Users/sjt/tmp/Foo/packages/aplteam-MarkAPL-13.1.0
    Files/
    /Users/sjt/tmp/Foo/packages/aplteam-MarkAPL-13.1.0/Files/
    ```


`HOME`
: _String._ Path to the directory the package was installed into, even if the package has no assets.

    This differs when the package is imported with [`LoadPackages`](user-commands.md#load-packages).

`ID`
: _String._ Full package ID.

`URI`
: _String._ Source from which the package was loaded: URL or file path.

