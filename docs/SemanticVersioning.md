[parm]:leanpubExtensions = 1
[parm]:title             = 'SemVers'


# Tatin and Semantic Versioning

Tatin is based on the concept of Semantic Versioning (SemVer), so before we go into any details we first need to understand SemVer. 

## Format

The version number of a Tatin package must follow the rules for Semantic Versioning: it always has the format `{major}.{minor}.{patch}`. 

A> Semantic versionin came into being via this website:
A>
A> [https://semver.org/](https://semver.org/ {target="_blank"})

After `{patch}` there might be more information available, separated from the patch number by either a dot or a hyphen, but this is just for convenience; Tatin would simply ignore any additional pieces of information.

Valid examples for a version number are therefore:

```
0.1.0
1.0.0
12.23.199
2.3.4.1456
1.2.3-beta-1
```

The Semantic Versioning rules lay out when exactly which part of the version number may or must be bumped.

## Terminology and versioning Rules

Given `1.2.3.4`:

* `1` is the _major version number_
* `2` is the _minor version number_
* `3` is the _patch number_ 
* The (optional) `4` is the _build number_.

### The Build number

The build number is bumped whenever the package is built again, not matter what. It is never reset. The build number is optional and is ignored by Tatin.

### The Patch Number

The patch number is bumped only when a change _does not affect compatibility_. 

A typical example is a bug fix: imagine that a function in a package crashes because an edge coniditon was not handled. When you fix that problem then you may bump the patch number because nothing else has changed. A consumer of the package can be reasonably confident that everything that worked before will continue to work.

However, in real life things get messy pretty quickly: the consumer of a package might mistake a bug as a feature if it does not crash but does something it shouldn't, and take advantage of the bug. Imagine that a new version of the package comes with a fix for just that bug...

If chances are high that a consumer might rely on the bug then you should actually bump the Major number rather than the Patch number - see there. Bugs that are very old are excellent candidates for that.

### The Minor number

The minor version number is bumped in case functionality was added to a package. 

That means that compatibility  should still be guaranteed: anything else works exactly as before. A consumer should be confident when updating the package that nothing will break. She just may take advantage of, say, a function  added to the API.

A> ### Chances of breaking things
A>
A> Note that by definition it seems that a change of the minor number is indicating a very low risk: just adding functionality should never change  anything that has worked before, while a change in the patch number might come from a bug fix your code actually relies on. 
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

Tatin reflects that by listing all major versions of a package when this user command is invoked:

```
      ]tatin.ListPackages
```


## Why Semantic versioning?

Before the introduction of the rules of Semantic Versioning everybody assigned version numbers to their liking. Updating to a new version always carried a significant risk that things would break.

With the rules of Semantic Versioning in place, if everybody involved acts accordingly and sensibly, updating should be much safer. 

However, things can get pretty complicated even with Semantic Versioning; see the [TatinsLoadAndUpdateStrategy](TatinsLoadAndUpdateStrategy.html "Link to the HTML document").
