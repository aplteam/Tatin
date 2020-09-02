[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin Load & Update'


# Tatin's Load and Update Strategy

Tatin is based on the concept of [semantic versioning (SemVer)](<https://semver.org "Link to the document that introduced SemVer">), so before we go into any details we first need to understand SemVer. 

If you are familiar with SemVer then please skip this and carry on with "The Strategy Problem".

## What is Semantic Versioning (SemVer)?

### Format

The version number of a Tatin package must follow the rules for Semantic Versioning: it always has the format `{major}.{minor}.{patch}`. After `{patch}` there might be more information available, separated from the patch number by either a dot or a hyphen, but this is just for convenience; Tatin would simply ignore any additional pieces of information.

Valid examples for a version number are therefore:

```
0.1.0
1.0.0
12.23.199
2.3.4.1456
1.2.3-beta-1
```

The Semantic Versioning rules lay out when exactly which part of the version number may or must be bumped.

### Versioning Rules

Given `1.2.3.4` the `1` is called the _major version number_, the `2` is called the _minor version number_, the `3` is called the _patch number_ and the (optional) `4` is called the _build number_.

#### The Build Number

The build number is bumped whenever the package is built again, not matter what. It is never reset. The build number is optional and is ignored by Tatin.

#### The Patch Number

The patch number is bumped only _when a change does not affect compatibility_. 

A typical example is a bug fix: imagine that a particular piece of data crashes a function in the package. When you fix that problem then you may bump the patch number because nothing else has changed. A consumer of the package can be sure that everything that worked before will still work.

In real life things get messy pretty quickly: imagine that the function produces a wrong result instead of crashing. Fixing could cause a consumer of the package a headache in case she coded in a way that makes her application now _relying_ on the bug.

If chances are high that a consumer might rely on the bug then you should actually bump the Major number rather than the Patch number - see there.

#### The Minor Number

The minor version number is bumped in case functionality was added to a package. 

That means that compatibility  should still be guaranteed: anything else works exactly as before. A consumer should be confident when updating the package that nothing will break. She just may take advantage of, say, a function  added to the API.

A> ### Chances of breaking things
A>
A> Note that by definition it seems that a change of the minor number is indicating a lower risk: just adding functionality should never change  anything that has worked before, while a change in the patch number might come from a bug fix your code actually relies on. 
A>
A> In reality however a version with a new (bumped) minor number might not only add functionality, it might also come with a couple of bug fixes.

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

Tatin reflects that by listing all major versions of a package when this user command is invoked:

```
      ]tatin.ListPackages
```


### Why Semantic versioning?

Before the introduction of the rules of Semantic Versioning everybody assigned version numbers to their liking. Updating to a new version always carried a significant risk that things would break.

With the rules of Semantic Versioning in place if everybody involved acts accordingly and sensibly, updating should be safe. 

Of course people could and will make still mistakes, so there is still a chance that a new version will break things anyway, but there is now a much better chance that things keep working after an update than before the introduction of Semantic Versioning.


## The Strategy Problem

Let's imagine that you need two packages, `Foo` and `Goo`. Both rely on package `Zoo`, but while `Foo` requests 1.1.1 of `Zoo`, `Goo` insists on version 1.2.0. However, the best version of `Goo` available is actually 1.3.0.

Because of SemVer we know that `Goo` would crash on version 1.1.1 of `Zoo` in case it takes advantage of the new features built into version 1.2.0. (We know there _are_ new features because of the bump of the minor part of `Zoo`'s version number)

We can take several different approaches here:

* We could load both versions and make `Foo` use version 1.1.1 and `Goo` use version 1.2.0
* We could load the better version (1.2) and make `Zoo` and `Goo` both use that version 
* We could check the server, find that there is a better version available (1.3.0) and use that one

  (More generally, always check for a better version, and if there is one, use it)

All these options are actually used by different package managers in the wild, so there is no consensus what's best.

To many programmers the last option seems particularly appealing because your application is kind of living on the bleeding edge this way: you are always up-to-date, you always get the latest fixes when you build your application. Great!

But when you look at it from a different angle then things look much less appealing: 

1. You build your application
1. You run your test cases -- they all pass
1. You build your application again (without changing _anything_)
1. You run your test cases again, but this time they fail

Attractive as an automated update mechanism might be, you want a build to be _reproducible_.

That does not necessarily mean that you always need to update all packages in your application "by hand", there are smarter ways to do this, and we will discuss this later.

So, when asked to load installed packages, Tatin will just do exactly that: load the packages it has recorded as required when installing `Foo` and `Goo`.

Except when a package is requested more than once, and with different version numbers: in that case Tatin uses _the best of them_, which might or might not be the best one available.

This is called ["Minimal Version Selection"](https://research.swtch.com/vgo-mvs "Link to the paper defining it"). It guarantees that when you re-build, you will get exactly the same result again.


## Loading Dependencies

Imagine these packages:

```
    +-----------+        +-----------+
    | Foo 1.0.0 |        | Goo 2.1.0 |
    +-----------+        +-----------+
          |                   |
          |                   |
          ∨                   ∨
    +-----------+        +-----------+
    | Zoo 1.1.1 |        | Zoo 1.2.0 |
    +-----------+        +-----------+
```

For simplicity we will assume that the packages are all hosted by a Tatin server known under the alias name `MyTatin`

While `Foo` relies on `Zoo` 1.1.1, `Goo` needs `Zoo` 1.2.0 --- what is Tatin doing about this?

It depends on what you are doing. Let's first load `Zoo` and `Goo` into the workspace, the usual approach to inspect a package:

```
      ]TATIN.Loadpackage [MyTatin]/mygroup-Foo-1.0.0 #.MyPkgs
#.MyPkgs.Foo
      ]TATIN.Loadpackage [MyTatin]/mygroup-Goo-2.1.0 #.MyPkgs
#.MyPkgs.Goo
      #.MyPkgs.⎕nl ⍳16
Foo
Goo
```

A> ### Getting the best version
A>
A> Assuming that version 1.0.0 of `Foo` is the best version available with the major number 1, then this would have been sufficient:
A> ```
A> ]TATIN.Loadpackage [MyTatin]/mygroup-Foo-1 #.MyPkgs
A> ```
A> Note that neither the minor nor the patch number have been specified.
A>
A> Assuming that version 2.1.0 of `Goo` is the very best version available at all, and that's the version you want to use,
A> then this would have been sufficient:
A>
A> ```
A> ]TATIN.Loadpackage [MyTatin]/mygroup-Goo #.MyPkgs
A> ```
A> Note that neither the major nor the minor nor the patch number have been specified.

You wanted `Foo` and `Goo` to be loaded into `#.MyPkgs`, and that's exactly what Tatin did. But where are the dependencies?

Note that `#.MyPkgs` just carries references pointing to where the packages have really been loaded into, and that is the namespace `#._tatin`:

```
      #._tatin.⎕nl 9
mygroup_Foo_1_0_0   
mygroup_Goo_2_1_3 
mygroup_Zoo_1_1_1 
mygroup_Zoo_1_2_0
```

Note that both versions of `Zoo` have been loaded. That's because the two Load operations are independent of each other.

## Installing packages

To make packages a part of an application (say), they first need to be installed. In the following examples we will install two packages, `Foo` and `Goo`. Both require `Zoo`, so `Zoo` will be installed as a side effect.

```
      ⎕NEXISTS /myPkgs
0
      ]TATIN.Installpackage [MyTatin]/mygroup-Foo-1.0.0 /myPkgs/
/myPkgs/mygroup-Foo-1.0.0
      ]TATIN.Installpackage [MyTatin]/mygroup-Goo-2.1.0 /myPkgs/
/myPkgs/mygroup-Goo-2.1.0
      ⍪⊃⎕NINFO ⍠ 1⊢'/myPkgs/*'
/myPkgs/apl-buildlist.json  
/myPkgs/apl-dependencies.txt
/myPkgs/mygroup-Foo-1.0.0
/myPkgs/mygroup-Goo-2.1.0
/myPkgs/mygroup-Zoo-1.1.1
/myPkgs/mygroup-Zoo-1.2.0
```

Let's check the contents of the `/myPkgs/apl-dependencies.txt` file:

```
      ⊃⎕NGET '/myPkgs/apl-dependencies.txt'
mygroup-Foo-1.0.0                          
mygroup-Goo-2.1.0                             
```

Note that these are the principal packages that we've installed.

Let's check the contents of the `/myPkgs/apl-buildlist.json` file:

```
      #.q←⎕JSON⍠('Dialect' 'JSON5')⊢⊃⎕NGET'/myPkgs/apl-buildlist.json'
      ⍉↑#.q.(depth packageID url)
1 mygroup-Foo-1.0.0
2 mygroup-Zoo-1.1.1
1 mygroup-Goo-2.1.0
2 mygroup-Zoo-1.2.0
```

Note that the principal packages carry a 1 in the first column. Numbers higher than 1 indicate the level of dependency.

The build list comprises not only the two principal packages but also all dependencies.

## Loading the installed packages

Though installing is roughly the same as loading except that the packages end up in the file system rather than the workspace, loading the installed packages allows Tatin to optimize what's actually loaded, and in this respect it is different.

Installed packages are loaded with the Tatin user command `LoadDependencies` which takes a folder as argument that must have a file `apl-dependencies.txt` but also a file `apl-buildlist.json` which gets created --- or extended --- by the installation process. 

It also requires a namespace as second argument: that's where the references pointing to the principal packages are going to be created. This is similar to `LoadPackage`.

```
      ]TATIN.LoadDependencies /myPkgs/ #.Temp
```

This is what `LoadDependencies` will do:

* It reads the file `apl-dependencies.txt`.
* It then checks whether this file was changed _after_ the file `apl-buildlist.json` was written to disk.

  If that is the case, the build list will be checked for consistency with `apl-dependencies.txt`; if that 
  is fine then the build list is created from scratch,
* Finally it will prune the build list and bring in the remaining packages.

Note that the pruning is in charge for removing the package `Zoo` 1.1.1. That means that rather than loading `Zoo` twice _only the best version_ will be loaded: both `Foo` and `Goo` will use `Zoo` version 1.2.0. 


## Special case

### Removing a principal package

Let's assume that you don't need `Goo` anymore.

Generally we advise to _not_ delete stuff manually from the folder that holds all packages of an application. 

If you want to get rid of one then it is recommended to use the method `]TATIN.UninstallPackage` instead. That will make sure that it removes not only the package in question, but also all packages that are dependencies of it, but _only_ if those packages are not requested by other packages as well.

Clearly there is a danger that you remove too much when you attempt to do this manually.

However, if you want to remove just a principal package, not dependencies, for example because you _know_ it does not have any, or because you _know_ that all its dependencies are also required by other packages anyway, then you might do it manually, though we still don't recommend it.

For the purpose of discussing what Tatin would do, we assume here that you perform the following two actions:

* You remove the line regarding `Goo` from the `apl-dependencies.txt` file
* You remove `mygroup-Goo-2.1.0` from the package folder (strictly speaking the following is true even when you omit this step)

Note that at this point the file `apl-buildlist.json` would still carry information regarding `Goo.`

Imagine you would now issue this command:

```
      ]TATIN.LoadDependencies /myPkgs/ #.Temp

```

Tatin would check whether the file `apl-dependencies.txt` was changed after `apl-buildlist.json` was created by Tatin.

In this case this is true, so Tatin would perform some health checks, and an error would be thrown in case they fail. This is mainly an insurance against people manually changing `apl-dependencies.txt` and making obvious mistakes.
  
Since the health check passed the build-list would be re-created. As a result `Goo` would disappear from the build list, and therefore a future `]TATIN.LoadDependencies` command would not load it any more.

However, note this: although `Foo` only required `Zoo` 1.1.1, Tatin would _not_ go back to that version, because version 1.2.0 of `Zoo` is already there. It would therefore keep loading version 1.2.0 although at this point in time this version is not referenced at all.

### Need to overwrite a package dependency 

Imagine you've installed a principal packages `Foo`, and as a result you also got two dependency packages, `Goo` and  `Zoo`:

Foo -> Goo -> Zoo

You find that sometimes `Zoo` crashes because of a bug.

Two different scenarios both cause a problem here:

* You check the project's web site and find that the guy in charge has already fixed the problem in `Zoo`, but `Goo` has not been updated and still refers to the buggy version of `Zoo`.

* You find that the version you already have is still the best, and the author does not respond to emails or even Pull Requests at the moment, and you are under time pressure, but it's easy to fix the problem yourself, so you put a fixed copy into a local Registry.

  (Assuming that you have defined your Registry chain so that local versions of packages take precedence)

The first step is obviously to install that fixed version, but that is not enough, because neither `apl-dependencies.txt` nor `apl-buildlist.json` would refer to that version, therefore it cannot be loaded.

Since the build-list is compiled dynamically, the solution here is to add `Zoo` to the file `apl-dependencies.txt`.

A> ### Second problem
A>
A> There is a second problem with this:
A>
A> In the scenario outlined in that Go-paper on semantic versioning you end up using D-1.1.4 although this version is not mentioned anywhere as a dependency, it's just part of the build list.
A>
A> But we agreed that the build list should be re-compiled from scratch in case somebody has changed the dependency file _after_ the build list file was created. In that case we would currently fall back on D-1.1.3 although we don't want that.
A>
A> This also means that manually changing the build list is not an option in any case.

I propose to change that: our build list could just avoid minor and patch numbers for dependencies: it could just remember the major number.

When it comes to `LoadDependencies` the build list just says "load Zoo 1" which translates  to "the best version of Zoo 1.* available in the install folder", and both problems disappear.

⍝## Updating all or selected packages
⍝
⍝Let's assum that you know that some of the packages you are using have been updated since you've installed them. Dependencies might have been updated as well.
⍝
⍝There is a user command available that help you with that:
⍝
⍝```
⍝      ]TATIN.UpdatePackages /myPkgs/
⍝```
⍝
⍝It requires a path to a folder that holds a file `apl-dependencies.txt`  and a file `apl-buildlist.json`. 
⍝
⍝Without any flags it will go through the build list and report to the session any packages that you might want to update. Apart from the reporting it does not do anything.
⍝
⍝You might want the possible updates to be carried out: for that specify the `-proceed` flag.
⍝
⍝The user command will then provide a list in the editor and allow you to make changes by deleting some of the lines.
⍝
⍝If you want the update to be processed without further ado you can specify the `-quiet` flag.