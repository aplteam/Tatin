---
title: 'Tatin: Publish a package'
description: 'Publish your first package; understand where dependencies are installed'
keywords: apl,delete,install,organise,package,publish,tatin,user command
---
# Publish a package

!!! abstract "Organise, configure, install dependencies, publish."


## :fontawesome-solid-circle-play: Get started

<!-- ## :fontawesome-solid-sitemap: Organise -->

A Tatin package separates APL source files from files
such as CSS, EXE, DLL and so on.
Tatin calls the APL files _source_ and the others _assets_.

1.  **Arrange** your files accordingly, e.g.

        myproj/
        ├── assets/
        │   ├── config.ini
        │   ├── foo.json
        │   ├── style.css
        │   └── tests.csv
        └── source/
            ├── RunTests.aplf
            ├── asc.aplf
            ├── dot.aplo
            ├── mean.aplf
            └── valid8_.aplf

    <!-- ## :fontawesome-solid-list: Configure -->

1.  Create a default **configuration** for your package:

        ]TATIN.PackageConfig path/to/myproj -edit

    The command prompts you for the essential [configuration parameters](package-configuration.md) and writes `myproj/apl-package.json`.


    <!-- ## :fontawesome-solid-truck-ramp-box: Install dependencies -->

1.  If your project incorporates other Tatin packages, **install** them, e.g.

        ]TATIN.InstallPackages aplteam-MarkAPL path/to/myproj

    :fontawesome-solid-terminal:
    [`]InstallPackages`](user-commands.md#install-packages)

    This will install the dependencies in `myproj/packages`
    and write there[^pkgs] a file `apl-dependencies.txt`.

    [^pkgs]: By default Tatin assumes a subfolder `packages/` to contain dependencies.


    <!-- ## :fontawesome-solid-upload: Publish to [tatin-test] -->

1.  Finally, **publish**.

        ]TATIN.PublishPackage /path/to/myproj [tatin-test]

    :fontawesome-solid-terminal:
    [`]PublishPackage`](user-commands.md#publish-package)


## :fontawesome-solid-sitemap: Dependencies

### Location

Where should your package’s dependencies be installed?

By default, Tatin installs them in a project subfolder `packages/`.

If you manage your package as a Cider project, Tatin will check the Cider configuration properties `dependencies.tatin` and `dependencies_dev.tatin` and install where they say.

If you do not use Cider you can use [command options](user-commands-publish.md#publish-package) or [API function parameters](api.md#publish-package) to specify an alternative to `packages/`.


### Unpublished dependencies

If you specify a dependency not (yet) published, the server you publish to will not object.

This is because, when several packages are published, there might be mutual – or worse, circular – dependencies between them.
Requiring dependencies to be already published would not work in that case.


### URL protocols

Tatin allows you to identify a package with a URL protocol,
either the `file://` protocol for a local resource
or `http://` or `https://` for a remote one.

Useful as these are for local development, neither is acceptable for specifying a dependency of a published package.

??? detail "URL protocols override Tatin’s scan strategy"

    Normally when a dependency is required Tatin scans known registries in order of priority – unless a URL protocol is used.

    Use URL protocols for local development only, and only with care.

If you publish a package `foo` with a dependency `goo` specified with a URL protocol, the registry will remove the protocol and retain only `goo`.
When Tatin loads `foo` it will scan the registries in its search path, and use the first `goo` it finds.



## :fontawesome-solid-terminal: User-command packages

A user-command package has a script that makes it a user command.

The package might look like this:

    MyUserCommand/
        APLSource/
            MyUserCommand/        ⍝ Contains the code
            TestData/
            TestCases/
            MyUserCommand.dyalog  ⍝ The user command script
        packages/
            ...
        packages_dev/
            ...
        apl-package.json
        cider.config
        LICENSE
        README

The [package configuration](package-configuration.md) specifies

    source: "APLSource/MyUserCommand",

which excludes `TestData/` and `TestCases/` from the published package,
but also excludes script `MyUserCommand.dyalog`
– which we need in the package root!

So tell Tatin the package is a user command, and where to find its script.
In the [package configuration](package-configuration.md):

    userCommandScript: "APLSource/MyUserCommand.dyalog",

This marks the package as a user command.
Tatin first installs everything as usual, then moves the script to the root of the package.

The installed package will then consist of:

-   a folder for the `MyUserCommand` package
-   folders for all dependencies
-   a file `apl-buildlist.json`
-   a file `apl-dependencies.txt`
-   the user command script `MyUserCommand.dyalog`

!!! tip "A package must contain code."

    If you implement a user command as a single script file (quite possible for a simple command) that would not be true.
    So, separate the user-command script (with the required `Run`, `List` and `Help` functions) from the ‘real code’ that does the work.

    Keeping the real code in the package satisfies the requirement.


## :fontawesome-solid-trash-can: Deleting packages

A registry’s [delete policy](user-commands-publish.md#get-delete-policy) controls whether you can delete a package published there:

-   `Any` – you may delete any package
-   `JustBetas` – you may delete only [beta versions](glossary.md)
-   `None` – you cannot delete any packages at all

Each server-hosted registry publishes its delete policy on its [home page](https://tatin.dev).

