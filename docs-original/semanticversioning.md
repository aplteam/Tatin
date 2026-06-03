---
title: 'Tatin: SemVers'
description: ''
keywords: 
---
# Tatin and Semantic Versioning

Tatin is based on the concept of Semantic Versioning (SemVer), so before we go into any details, we first need to understand SemVer. 

If you are already familiar with the concept of semantic versioning then of course you may skip this document.

## Format

The version number of a Tatin package must follow the rules for Semantic Versioning: it always has the format `{major}.{minor}.{patch}`. 

After `{patch}`, more information might be available, separated from the patch number by a hyphen.

Valid examples for a version number are therefore:

```
0.1.0
1.0.0
12.23.199
1.2.3-beta-1     
```

These pieces of information fully participate when Tatin needs to establish package precedence:

`1.2.3` is "better" than  `1.2.2` but also "better" than `1.2.3-beta1` of course.

Information after the hyphen is restricted to ASCII characters and digits until a space or a plus (`+`) is detected. 

The plus (`+`) is used to separate an (optional) build number from the other parts of a version number.

### Build numbers

After {major}-{minor}-{patch} you may add the optional build number. Build numbers _do not_ participate in establishing precedence and are therefore ignored by Tatin when compiling the name of a package and/or a package ZIP file.

I> That means that you cannot publish two packages that share the same group-name, package-name, major-no, minor-no and patch-no but have different build numbers - they are the same as far as Tatin is concerned.

A build number, when specified, needs to be separated by a `+`. A build number may consist of digits only.

```
2.3.4+1456
1.2.3-beta-1      ⍝ becomes 1.2.3-beta-1 as a Tatin package
1.2.3-beta-1+123  ⍝ becomes 1.2.3-beta-1 as a Tatin package
```

Therefore `1.2.3-beta-1.abc` is _invalid_.

The Semantic Versioning rules define when exactly which part of the version number may or must be bumped. They also define which parts are considered when establishing precedence: build numbers are always ignored.

## Terminology and versioning Rules

Given `1.2.3+4`:

* `1` is the _major version number_
* `2` is the _minor version number_
* `3` is the _patch number_ 
* The (optional) `4` is the _build number_.

### The build number

The build number is optional and is ignored by Tatin. However, if a package has a build-number, it is bumped whenever the package is built again, no matter what. It is never reset. 

### The Patch Number

The patch number is bumped only when a change _does not affect compatibility_. 

A typical example is a bug fix: imagine that a function in a package crashes because an edge condition was not handled. When you fix that problem, you may bump the patch number because nothing else has changed. A consumer of the package can be reasonably confident that everything that worked before will continue to work.

However, in real life things get messy pretty quickly: the consumer of a package might mistake a bug for a feature if it does not crash but does something it shouldn't, and take advantage of the bug. Imagine that a new version of the package comes with a fix for just that bug...

If chances are high that a consumer might rely on the bug then you should bump the Major number rather than the Patch number - see there. Very old bugs are excellent candidates for that.

### The Minor number

The minor version number is bumped in case functionality was added to a package. 

That means that compatibility should still be guaranteed: anything else works exactly as before. A consumer should be confident when updating the package that nothing will break. She just may take advantage of, say, a function added to the API.

A> ### Chances of breaking things
A>
A> Note that by definition it seems that a change of the minor number is indicating a very low risk: just adding functionality should never change anything that has worked before, while a change in the patch number might come from a bug fix your code relies on. 
A>
A> In reality however a version with a new (bumped) minor version number often comes with bug fixes as well.

### The Major number

When you change the API not by just adding stuff but by deleting or renaming parts of the public interface, or changing the parameters that an API function requires, then the package is _guaranteed to be incompatible_ with earlier versions. If that's the case then you must bump the major version number.

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

Tatin reflects that in several ways, for example by listing all major versions of a package when this user command is invoked:

```
      ]tatin.ListPackages
```


## Why Semantic versioning?

Before the introduction of the rules of Semantic Versioning, everybody assigned version numbers to their liking. Updating to a new version always carried a significant risk that things would break.

With the rules of Semantic Versioning in place, if everybody involved acts accordingly and sensibly, updating should be much safer. 

However, things can get pretty complicated even with Semantic Versioning; see the [TatinsLoadAndUpdateStrategy](tatinsloadandupdatestrategy.md).

Semantic versioning came into being via this website:

[https://semver.org/](https://semver.org/ {target="_blank"})



