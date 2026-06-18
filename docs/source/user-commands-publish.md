---
title: "User commands for publishing"
description: "Further user commands for publishing Tatin packages"
keywords: 
---
# User commands for publishing

!!! abstract "User commands for publishing Tatin packages"

---

## Build package

    ]TATIN.BuildPackage [source] [target]

Where `source` and `target` are paths to folders, write the contents of the former as a ZIP in the latter,
bumping the build number unless the `version` option sets it.

Folder `source` must contain a file `apl-package.json` defining the package.

You can omit `source` and/or `target` if the source is an opened Cider project. If there is one it will be used; if there are multiple, ask the user.

The command asks you to confirm any assumptions.

---|---
bump=         | Either `patch` or `minor` or `major`: bump that part of the version number, together with any build number. Affects both the package and its config file.
dependencies= | Find dependencies in this subfolder of the project. (Rarely need to specify this: see [Publishing Packages](publish-packages.md).)
projectspace= | Where the package contents are to be installed.
version=      | Set the version number in both the package project and the package to be created.

Note that `bump=` and `version=` are mutually exclusive.

Until version 0.118.0 `projectspace` was `tatinVars`.

Until version 0.117.0 you could set the build number by including it in the version.
Now the build number gets bumped in all cases.

API:
[`BuildPackage`](api.md#build-package)



## Create package

    ]TATIN.CreatePackage target

Where `target` is a path to a folder, create a new Tatin package in it.

The command is a wrapper for [`]TATIN.PackageConfig -edit`](user-commands.md#package-config).


## Delete packages

    ]TATIN.DeletePackages pattern

Where `pattern` is

-   a registry URL or alias, followed by a package ID
-   a path to a folder containing a package (must contain a file `apl-package.json`) specified with the `file://` protocol

delete one or more packages from the registry or folder, including deprecated packages.

If the pattern matches multiple packages, ask which to delete.

Example arguments:

    https://tatin.dev/grp-foo-1.0.0         ⍝ registry URL, package ID
    [test-tatin]grp-foo-1.0.0               ⍝ registry alias, package ID
    [test-tatin]foo-1.0.0                   ⍝ no group name
    [test-tatin]foo-1                       ⍝ versions of foo with major=1
    [test-tatin]foo                         ⍝ versions of foo
    file:///path/2/Registry/grp-foo-1.0.0   ⍝ local package

API:
[`DeletePackages`](api.md#delete-packages)


## Deprecate package

    ]TATIN.DeprecatePackage pattern[majorversion] comment

Where

-   `pattern` is a registry URL or alias followed by group and package names

-   `majorversion` (optional) is a major version number (omitted, defaults to all major versions)

-   `comment` is text explaining why the package is deprecated (remember to delimit with quotes)

asks to confirm the action, then creates
(for each major version targeted)
a new minor version with the `deprecated` property set.

------|-------------------------
force | Don’t ask for confirmation. (Useful mainly for tests.)

Example: Deprecate on `[tatin]` all major versions of `grp-foo`:
```
]TATIN.DeprecatePackage [tatin]grp-foo "Use MarkAPL instead"
```

API:
[`DeprecatePackage`](api.md#deprecate-package)


## Get delete policy

    ]TATIN.GetDeletePolicy [reg]

Where (optional) `reg` is

-   a registry URL or alias
-   `*` (all known registries)
-   `?` (list them and ask me to choose)

or if omitted, `[tatin]`,
report the delete policy (`None`, `Any`, or `JustBetas`) of the server/s concerned
and cache the result.

------|----------------------------------------
check | Ignore the cache: query the server and cache the response.

API:
[`GetDeletePolicy`](api.md#get-delete-policy)


## Publish package

    ]TATIN.PublishPackage [source] [reg]

Where

-   `source` is a path to a package folder, or a ZIP file (typically created by [BuildPackage](#build-package))
-   `reg` is a registry alias or URL, or `?` (ask me which known registry)

publish the package to the registry if specified, otherwise to `[tatin]`.

If `source` is not specified, look for open Cider projects.
If you find one, use it; if multiple, ask me which.

If the registry’s delete policy is `None`, ask me to confirm publication.

The name of the resulting package is extracted from the ZIP file which therefore must conform
to the Tatin rules.

--------------|-----------------------------------------------------------------
dependencies= | Find dependencies in this project subfolder. (Rarely need to specify: see [Publish Packages](publish-packages.md).)


[Publishing a user-command package](publish-packages.md#user-command-packages)<br>
API:
[`PublishPackage`](api.md#publish-package)
