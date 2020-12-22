[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin Load & Update'


# Tatin's Load and Update Strategy

Before you read this document you have to have a good understanding of what Semantic Versioning is. If that's the case then carry on reading, otherwise please read [SemanticVersioning](./SemanticVersioning.html) first.

## The Strategy Problem

Let's imagine that you need two packages, `Foo` and `Goo`. Both rely on package `Zoo`, but while `Foo` requests 1.1.1 of `Zoo`, `Goo` insists on version 1.2.0. However, the best version of `Goo` available is actually 2.0.0, and even for major version 1 there is a better version available: 1.3.0.

Now from what we've said so far it should be clear that version 2.0.0 is not an option at all because it is considered as a completely different package and therefore ignored.

Because of SemVer we know that `Goo` would crash on version 1.1.1 of `Zoo` in case it takes advantage of the new features built into version 1.2.0. (We know there _are_ new features because of the bump of the minor part of `Zoo`'s version number)

We can take several different approaches here:

* We could load both versions and make `Foo` use version 1.1.1 and `Goo` use version 1.2.0
* We could load the better version (1.2) and make `Zoo` and `Goo` both use that version 
* We could check the server, find that there is a better version available (1.3.0) and use that one

  (More generally, always check for the best version and use that one)

All these options are actually used by different package managers in the wild, so there is no consensus on what's best.

To many programmers the last option seems particularly appealing because you are always up-to-date, you always get the latest fixes when you build your application. Great!

But when you look at it from a different angle then things look much less appealing: 

1. You build your application
1. You run your test cases -- they all pass
1. You build your application again (without changing _anything_)
1. You run your test cases again, but this time they fail

This can happen in case the author of a package has released a new version of a package you depend on in one way or another.

Attractive as an automated update mechanism might be, you want a build to be _reproducible_.

That does not necessarily mean that you always need to update all packages in your application "by hand", there are smarter ways to do this, and we will discuss this later.

So, when asked to load installed packages, Tatin will just do exactly that: load the packages defined as required by the configuration files of the main packages `Foo` and `Goo`.

Except when a package is requested more than once, and with different minor and/or patch numbers: in that case Tatin uses _the best version_, which might or might not be the best one available. In our example that would be 1.2.0, while 1.3.0 is ignored.

This is called ["Minimal Version Selection"](https://research.swtch.com/vgo-mvs "Link to the paper defining it"). It guarantees that when you re-build, you will get exactly the same result.


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

Installed packages are loaded with the Tatin user command `LoadDependencies` which takes a folder as argument that must have a file `apl-dependencies.txt` but also a file `apl-buildlist.json` which is either created or possibly extended by the installation process. 

It also requires a namespace as second argument: that's where the references pointing to the principal packages are going to be created. This is similar to `LoadPackage`.

```
      ]TATIN.LoadDependencies /myPkgs/ #.Temp
```

This is what `LoadDependencies` will do:

1. It reads the file `apl-dependencies.txt`.
2. It checks whether this file was changed _after_ the file `apl-buildlist.json` was written to disk.

  If that is the case, the build list will be checked for consistency with `apl-dependencies.txt`; if that 
  is fine then the build list is created from scratch,
3. Finally it will prune the build list and bring in the remaining packages.

Note that the pruning is in charge for removing the package `Zoo` 1.1.1. That means that rather than loading `Zoo` twice _only the best version_ will be loaded: both `Foo` and `Goo` will use `Zoo` version 1.2.0. 


## Special case

### Removing a principal package

Let's assume that you don't need `Goo` anymore.

Generally we advise to _not_ delete stuff manually from the folder that holds all packages of an application. 

If you want to get rid of one then it is recommended to use the method 

`]TATIN.UninstallPackage` 

instead. That will make sure that it removes not only the package in question, but also all packages that are dependencies of it, but _only_ if those packages are not requested by other packages as well.

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

In this case this is true, so Tatin would perform some health checks, and an error would be thrown in case they fail. This is mainly an insurance against people manually changing `apl-dependencies.txt` and making mistakes.
  
Since the health check passes the build-list would be re-created. As a result `Goo` would disappear from the build list, and therefore a future `]TATIN.LoadDependencies` command would not load it any more.

However, note this: although `Foo` only required `Zoo` 1.1.1, Tatin would _not_ go back to that version, because version 1.2.0 of `Zoo` is already installed. It would therefore keep loading version 1.2.0 although at this point in time this version is not referenced at all.

### Need to overwrite a package dependency 

Imagine you've installed a principal packages `Foo`, and as a result you also got two dependency packages, `Goo` and  `Zoo`:

Foo -> Goo -> Zoo

You find that sometimes `Zoo` crashes because of a bug.

Two different scenarios both cause a problem here:

* You check the project's web site and find that the guy in charge has already fixed the problem in `Zoo`, but `Goo` has not been updated and still refers to the buggy version of `Zoo`.

* You find that the version you already have is still the best, and the author does not respond to emails or even Pull Requests at the moment, and you are under time pressure, but it's easy to fix the problem yourself, so you put a fixed copy into a local Registry.

  (Assuming that you have defined your Registry chain so that local versions of packages take precedence)

The first step is obviously to install that fixed version, but that is not enough, because neither `apl-dependencies.txt` nor `apl-buildlist.json` would refer to that version, therefore it would not be loaded.

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


W> Above
W>
W> The above needs attention _and_ examples on `https://test.tatin.dev`


## Checking and updating

**_Note that this hat not been implemented yet and is open to discussion_**


### Checking 

Let's assume you want to check whether there are better versions of the principal packages of your application.

There is a user command available that can help you with that:

```
      ]TATIN.CheckVersions ./
```

It requires a path to a folder that holds a file `apl-dependencies.txt`  and a file `apl-buildlist.json`. 

This user command would check whether there are any better versions available and report its findings to the session.

In case there is a better version in terms of minor and/or patch number but also a better major version then it would report both.

It is then up to you to take action, or to use the user command `]TATIN.Update`.

You may also restrict the output of the command to a specific package, say `mygroup-Foo`; in that case just specify the package as an additional parameter:

```
      ]TATIN.CheckVersions /myPkgs/ mygroup-Foo
```

You may specify more than one package:

```
      ]TATIN.CheckVersions /myPkgs/ mygroup-Foo mygroup-Goo
```


### Updating 

#### Updating _all_ principal packages

After having executed `]TATIN.CheckVersions` you might want to update all principal packages of your application. This can be achieved by executing:

```
      ]TATIN.Update ./ *
```

This will update _all_ principal packages. 

Of course dependencies will be updated implicitly if one of the principal packages requires a better version.

#### Updating a specific principal package

Lets assume your application uses the package `mygroup-Foo-1.0.0`, and that the versions 1.0.0, 1.1.0, 1.2.0 and 2.0.0 are all available from a Tatin server.

After having executed `]TATIN.CheckVersions` you might want to update `mygroup-Foo`.

This can be achieved by executing:

```
      ]TATIN.Update /myPkgs/ mygroup-Foo
```

This will update `mygroup-Foo-1.0.0` to `mygroup-Foo-1.2.0` _but not_ to version `mygroup-Foo-2.0.0`. This is because `mygroup-Foo-2.0.0` is considered to be a completely different package.


#### Updating to a specific version

There might be a reason why you want to update `mygroup-Foo-1.0.0` but not to version `mygroup-Foo-1.2.0`  but to version `mygroup-Foo-1.1.0`. However, this is _not_ supported by `]TATIN.Update`; you need to edit the file `apl-dependendies.txt` in order to achieve that.

The same is true in case you want to update to a new major version, `mygroup-Foo-2.0.0` in our example.