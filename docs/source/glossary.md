---
title: 'Tatin glossary'
description: 'An explanation of terms used in the Tatin documentation'
keywords: apl, documentation, glossary, tatin
---
# Glossary

<style>
    dt {
        font-weight: bold;
    }
</style>

!!! abstract "Some terms used in the Tatin documentation"

beta
: A package with a text description in its patch.

    (See **version** and examples of **full package ID**.)


build number
: Tatin assigns each **version** a build number, in chronological sequence.

    This is not part of the version.
    Tatin treats two packages that differ only in build number
    as the same version of the same package.

    (See examples of **full package ID**.)

constant
: A niladic function or a variable. (Same syntax, but the former is immutable.)

dependency
: Contrary to normal usage, a dependency of a package `foo` is another package on which `foo` depends.


flag
: The meaning depends on context:

    -   In the API or configuration, a boolean; a flag is ‘set’ with 1.
    -   In the user commands, a parameter without a corresponding value: for example in `]TATIN.PackageConfig -edit`, the `edit` flag is set.


full package ID
: A package is uniquely identified by its full package ID: group, name, and **version**.

    Group, name and version are separated by hyphens.
    When shown, a **build number** is separated from the patch by a plus sign.

    Some examples:

        apltree-Foo-1.0.0
        apltree-Foo-1.0.1+123
        apltree-Foo-1.0.1-alpha-1         ⍝ beta
        apltree-Foo-1.0.2-alpha-1+127     ⍝ beta


fully qualified namespace
: A reference beginning with `#.` or `⎕SE.`

Known Registries
: Registries specified in your [user settings](user-settings.md)

    A registry scan searches known registries with a priority above zero,
    in descending order of priority.

Maintenance Library
: A child folder `Maintenance/` of the the Tatin server installation folder, containing [maintenance scripts](user-commands-host.md#maintenance).

package alias
: A short name you can use locally as an alternative to a full package ID.
    (Allows you to work with multiple versions of the same package.)

package cache
: A namespace that holds the contents of a package.

    By convention there are two: `#._tatin` and `⎕SE._tatin`.
    Both are referred to by objects in the workspace;
    neither should be named in your code.

package ID
: A case-insensitive pattern for matching against full package names: the name of a package, possibly also including its group; major version number; major and minor version numbers; or major and minor version and patch numbers. Examples:

    ```apl
    'MarkAPL'                  ⍝ name
    'aplteam-MarkAPL'          ⍝ group-name
    'MarkAPL-11'               ⍝ name-major
    'APLTEAM-MARKAPL-12.1'     ⍝ group-name-major-minor
    'MarkAPL-13.1.2'           ⍝ name-major-minor-patch
    'aplteam-MarkAPL-13.1.2'   ⍝ group-name-major-minor-patch
    ```

package space
: The namespace in which the package is actually stored.

    For example, if Tatin loads package MarkAPL 13.1.0, it creates a namespace `#.MarkAPL` containing references to the objects in MarkAPL’s API. Those references point to objects in the package space, where Tatin puts the actual MarkAPL objects, e.g.
    ```
    #._tatin.aplteam_MarkAPL_13_1_0
    ```

parameter space
: A namespace of variables representing parameters

Plodder
: A generalized HTTP server, used by Tatin, based on [Rumba](https://github.com/aplteam/RumbaLean) and Conga.

    For details see https://github.com/aplteam/Plodder


registry alias
: A short name you can use locally as an alternative to its URL.
<!-- FIXME Can I also use as an alternative to a path? -->

: Tatin is installed with `tatin` and `tatin-test` as aliases for the Principal Registry and the Test Server.


string
: A character vector, e.g. `'abc def'`


strings
: A vector of strings, e.g. `'abc' 'def'`


version
: A version follows the conventions of
    [Semantic Versioning](https://semver.org):
    and comprises major and minor versions (integers)
    and a patch, separated by periods,
    e.g. `1.0.3`

    A patch is also an integer,
    but may be followed by a hyphen and a text description,
    indicating a **beta** version, e.g. `1.0.3-trial`.

    A new

    -   major version marks a breaking change
    -   minor version marks a non-breaking change
    -   patch marks a change in implementation

    (See examples of **full package ID**.)

