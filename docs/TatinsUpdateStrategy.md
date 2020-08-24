# Tatin's Update Strategy

Tatin's update strategy is based on the concept of [semantic versioning (SemVer)](<https://semver.org "Link to the document that introduced SemVer">), so before we go into the details we first need to understand SemVer.

## What is Semantic Versioning (SemVer)?

### Format

A version number following the rules for Semantic Versioning always has the format `{major}.{minor}.{patch}`. After `{patch}` there might be more information available, but this is just for convenience; Tatin would simply ignore any additional pieces of information.

Valid examples for a version number are therefore:

```
0.1.0
1.0.0
12.23.199
1.2.3-beta-1
```

The Semantic Versioning rules lay out when exactly which part of the version number may or must be bumped.

### Versioning Rules

Given `1.2.3.4` the `1` is called the _major version number_, the `2` is called the _minor version number_, the `3` is called the _patch number_ and the `4` is called the _build number_.

#### The Patch Number

The patch number is bumped only _when a change does not affect compatibility_. 

A typical example is a bug fix: imagine that a particular piece of data crashes a function in the package. When you fix that problem then you may bump the patch number because nothing else has changed. A consumer of the package can be sure that everything that worked before will still work.

In real life things get messy pretty quickly: imagine that the function produces a wrong result instead of crashing. Fixing could cause a consumer of the package a headache in case she coded in a way that makes her application now _relying_ on the bug.

If there is a chance that consumers might rely on the bug then you should actually bump the Major number rather than the Patch number - see there.

#### The Minor Number

The minor version number is bumped in case functionality was added to a package. 

That means that compatibility_.  should still be guaranteed: anything else works exactly as before. A consumer should be confident when updating the package that nothing will break. She just may take advantage of, say, a function  added to the API.

#### The Major Number

When you change the API not by just adding stuff but by deleting or renaming parts of the public interface, or changing the parameters that an API function requires, then the package is incompatible with earlier versions. If that's the case then you must bump the major version number.

#### Example

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

... are also considered to be different packages.

Tatin reflects that by listing all major versions of a package when the user command `]tatin.ListPackages` is invoked.


### Why Semantic versioning

Before the introduction of the rules of Semantic Versioning everybody assigned version numbers to their liking. Updating to a new version always carried a significant risk that things would break.

With the rules of Semantic Versioning in place if everybody involved acts accordingly and sensibly, updating should be safe. Of course people make mistakes, so there is still a chance that a new version will break things anyway, but the chances are now much better than before the introduction of Semantic Versioning.

## Update strategy

First we need to make clear that we don't mention the major part of the version number at all. The reason is that packages with different major version numbers are considered different packages, as explained above.

Let's first define what exactly the problem is. Let's imagine that you need two packages, `Foo` and `Goo`. Both rely on the package `Zoo` but while `Foo` requests 1.0 of `Zoo`, `Goo` insists on version 1.2 which happens to be the best version at that time of loading.

There are two different approaches here:

* We could load both versions and make `Foo` use version 1.1.0 and `Goo` use version 1.2.0
* We load the "best" version (1.2) and make `Zoo` and `Goo` both use that version 

⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹

Now imagine that you re-build your application which makes use of `Foo` and `Goo`, and implicitly also of `Zoo`. Should your package manager contact the server those packages were drawn from and check whether there is now a better version available and, in case there is, say, a version 1.3 of `Zoo` available now, draw this automatically?

At first this might seem attractive, because you end up having a kind of automated updated mechanism in place.

But when you look at it from a different angle then things look much grimmer: 

1. You build your application
1. You run your test cases -- they all pass
1. Your build your application again
1. You run your test cases, but this time they don't pass, though you have not changed anything.

Attractive as an automated update mechanism might be, you want a build to be _reproducible_.

That does not necessarily mean that you always need to update all packages in your application "by hand", there are smarter ways to do this, but this is not in the scope of this document.

So, when asked to load installed packages, Tatin will just do exactly that: load the packages it has recorded as required when installing `Foo` and `Goo`. This guarantees that when you re-build, you will get exactly the same result again.

⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹


