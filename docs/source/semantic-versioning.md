---
title: "Semantic Versioning"
description: "An introduction to Semantic Versioning and how Tatin applies it"
keywords: 
---
# Tatin and Semantic Versioning

Tatin is based on the concept of Semantic Versioning (SemVer), so before we go into any details, we first need to understand SemVer.

Semantic Versioning came into being via this website: [https://semver.org/](https://semver.org/)

## What SemVer is about

Semantic Versioning is a convention for communicating intent through version numbers: the three parts — major, minor, and patch — signal respectively whether a new release breaks backward compatibility, adds new functionality without breaking anything, or only fixes bugs. By following these rules consistently, both package authors and consumers can reason about whether upgrading is safe without having to read every change in detail.

## Format

The version number of a Tatin package must follow the rules for Semantic Versioning: it always has the format `{major}.{minor}.{patch}`.

While `{major}` and `{minor}` are plain integers, `{patch}` must begin with a number but may include a hyphen-separated suffix — for example `3`, `3-alpha-1`, or `3-beta-2-fix-issue-345`. The full patch field, number and suffix together, participates when Tatin establishes package precedence: `1.2.3` therefore takes precedence over `1.2.3-beta-1`.

Valid examples for a version number are therefore:

```
0.1.0
1.0.0
12.23.199
1.2.3-beta-1
```

Information after the hyphen is restricted to ASCII letters and digits until a space or a plus (`+`) is detected.

The plus (`+`) is used to separate an (optional) build number from the other parts of a version number.

### Build numbers

After `{major}.{minor}.{patch}` you may add the optional build number. Build numbers _do not_ participate in establishing precedence and are therefore ignored by Tatin when constructing the name of a package and/or a package ZIP file.

!!! note "That means that you cannot publish two packages that share the same group-name, package-name, major-no, minor-no and patch but have different build numbers — they are the same as far as Tatin is concerned."

A build number, when specified, needs to be separated by a `+`. A build number must consist of digits.

```
2.3.4+1456
1.2.3-beta-1      ⍝ becomes 1.2.3-beta-1 as a Tatin package
1.2.3-beta-1+123  ⍝ becomes 1.2.3-beta-1 as a Tatin package
```

Therefore the version number `1.2.3-beta-1+abc` is _invalid_.

Note that if a package has a build number, it is bumped whenever the package is built again, no matter what. It is never reset.

### Precedence

When Tatin needs to establish precedence, it first takes `{major}.{minor}.{patch}` into account. As long as `{patch}` is just a number, it is straightforward how this can be established.

But when there is a package `1.2.3-fix-double-quotes` and a package `1.2.3-fix-domain-error`, it is not possible to establish precedence from `{major}.{minor}.{patch}`. The build number cannot be used for this because it is optional. In such a case the publishing date is used to tell packages apart.


## Versioning rules

### The patch number

The patch number is bumped only when a change _does not affect compatibility_.

A typical example is a bug fix: imagine that a function in a package crashes because an edge condition was not handled. When you fix that problem, you may bump the patch number because nothing else has changed. A consumer of the package can be reasonably confident that everything that worked before will continue to work.

However, in real life things can get messy pretty quickly: the consumer of a package might mistake a bug for a feature if it does not crash but does something it shouldn't, and take advantage of the bug. Imagine that a new version of the package comes with a fix for just that bug...

If there is a good chance that a consumer might rely on the bug, consider bumping the major version number instead. Very old bugs are excellent candidates for that.


### The minor number

The minor version number is bumped when functionality is added to a package.

That means that compatibility should still be guaranteed: anything else works exactly as before. A consumer should be confident when updating the package that nothing will break, and may take advantage of, say, a function added to the API.

!!! details "Chances of breaking things"

    Note that by definition it seems that a change of the minor number is indicating a very low risk: just adding functionality should never change anything that has worked before, while a change in the patch number might come from a bug fix your code relies on.

    In reality however, a version with a new minor version number often comes with bug fixes as well.


### The major number

When you change the API not just by adding functionality but by deleting or renaming parts of the public interface, or changing the parameters that an API function requires, then the package is _guaranteed to be incompatible_ with earlier versions. If that's the case, then you must bump the major version number.

These two packages:

```
aplteam-foo-1.0.0
aplteam-GOO-1.0.0
```

... are of course considered to be different packages, but according to the concept of SemVer these two packages:

```
aplteam-foo-1.0.0
aplteam-foo-2.0.0
```

... are _also_ considered to be different packages.

Tatin reflects that by listing all major versions of a package when this user command is invoked:

```
]Tatin.ListPackages
```


## Why Semantic Versioning?

Before the introduction of the rules of Semantic Versioning, everybody assigned version numbers to their liking. Updating to a new version always carried a significant risk that things would break.

With the rules of Semantic Versioning in place, if everybody involved acts accordingly and sensibly, updating should be much safer.

However, things can get pretty complicated even with Semantic Versioning; see the [Load and Update Strategy](load-and-update-strategy.md).

!!! details "The version number is saved in the package configuration"

    A package configuration file **must** contain a version number, but many developers want the version number also available in their code, for example as a function `Version` that returns the version number. There shouldn't be two sources for the same piece of information (it is unclear which would take precedence in case they are different), so it's best to make the function `Version` read and extract the version number from the package config file, but that will not work when the package config file is not available, which will be the case when a package does not need assets.