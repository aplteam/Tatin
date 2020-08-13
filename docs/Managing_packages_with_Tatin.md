[parm]:leanpubExtensions = 1
[parm]:numberHeaders     = 6
[parm]:saveHTML          = 1
[parm]:title             = Tatin
[parm]:toc               = 6
[parm]:cssURL            = ⎕NULL
[parm]:linkToCSS         = 0
[parm]:collapsibleTOC    = 1
[parm]:width             = 1200


# Managing packages with Tatin


## Overview


### What is a project?

In this document the term "project" is loosely used to refer to anything that contains files that can be converted into a package. 

A project may --- and usually does --- contain files and folders that aid in the development of the package and comprise test cases etc. which are not included in the resulting package.

## What is a package?

A package is a module that solves a particular problem. It may depend on other packages, and it may also depend on files like DLLs etc. but it is independet in any other respect.

A package is constructed from a project by getting rid of everything that is not strictly needed like test cases etc.

Packages are ideally hosted somewhere central, be it on the web for general packages or a server in a company with packages specific to that company. This is called a Registry.

A package can be either a namespace with a mixture of functions, operators and classes or a just a function of just a class.


### What is a package manager?

The term "package manager" can refer to two different aspects:

* A server that manages access to a specific Registry via (usually) an HTTP interface.

* A client that allows...

  * listing of all packages on a perticular Registry
  * fetching a particular package
  * possibly publishing packages to a particular Registry

  A client is expected to manage dependencies, meaning that when the package manager is asked to fetch the package "Foo" which depends on package "Zoo" which in turn depends "Boo", then it will fetch all three packages.



### A simple example

A simple example is the class [DotNetZip](https://github/aplteam/DotNetZip): it creates a ZIP archive or adds to an existing ZIP archive, and it can unzip a ZIP archive and also list the contents of a ZIP archive. 

It's advantage over other solutions is that it works on all major platforms: Windows, Linux and Mac-OS.

This package depends on .NET or .NET Core and on the class `FilesAndDirs` which in turn depends on the namespace script `ALPTreeUtils` but it does not depend on any files, therefore it is an example for a simple version of a package.

These are the only files you would get if you fetch this package with the Tatin client:

```
apl-package.json
DotNetZip.aplc
```

While DotNetZip.aplc is the class script, the file apl-package.json defines the meta data of the package:

```
{
  "alias": "",
  "api": "DotNetZip",
  "date": "2020-05-16",
  "description": "Zipping and unzipping with.NET Core on all major platforms",
  "files": "",
  "group": "aplteam",
  "name": "DotNetZip",
  "project_url": "https://github.com/aplteam/DotNetZip",
  "source": "DotNetZip.aplc",
  "tags": "zip-tools;windows;mac-os;linux",
  "version": "0.5.1"
}
```

But fetching `DotNetZip` would implicitly also fetch `APLTreeUtils` and `FilesAndDirs`, although that is not exactly obvious unless you know where to look.

## Package names and versioning


### Rules


Note that any package needs to follow the naming convention rules:

```
{group}-{name}-{major.minor.patch}
```

Both "group" and "name" must be valid APL names and must consist of ASCII characters, and they must not contain a hyphen or a dot as those are used as separators.

After the patch number additional information may be added (like `-beta` or `_preview`.

Some examples for valid package names:

```
dyalog-conga-3.3.0
aplteam.APLTreeUtils.5.2.3-beta
```

### Semantic Versioning (SemVer)

[Semantic Versioning ](https://semver.org/ ""  Link to the home of Semantic Versioning") are an essential concept for understanding how Tatin manages packages.

The simplified rules are:

* Packages with different major version numbers are considered as different as packages belonging to different groups, or having different names. 

* The minor version number is bumped when new functionality is added in one way or another.

  However, in any other respect no changes are expected, so the versions should be fully compatible.

* The patch number is bumped when one or more bugs got fixed. 

  Ideally that would mean full compatability is guaranteed, but in reality that it not always the case: if you recognize a certain odd behaviour of a package not as faulty but as useful and therefore take advantage of it, then a fix that makes the package behave correctly may well break your code.

  Of the course the same can be said regarding a change in the minor number when that not only adds functionality but also fixes bug(s).

Therefore it's fair to say that changing to a new version always comes with some danger to break something, even with semantic versioning. However, it should be a very rare event.

## How to fetch dependencies

One of the main features of any package manager is that dependencies are fetched automatically.

There are three different strategies available:

Always upgrade

: This means that whenever a better version of a package that is a dependency becomes available, it is fetched. (This regards only the minor and the patch number of course)

Exact

: Fetch the precise version specfied as a dependency and stick with it.

: Note that this means that if a package `Foo` is required by two different packages in two different versions then _both versions_ need to be installed/loaded.

Minimal

: This loads only one version of a package --- not matter how often it is required ---, and it is the best one. Not necessarily the best one _available_, but the best one _required_.

: The minimal version strategy has a couple of quite complex and sometimes surprising consequences which are discussed in detail in the paper "Tatin and Minimal Version Strategy".


## Using Tatin

We assume that when you start using packages you will consume packages managed by a Tatin server. Therefore we will discuss how to install the Tatin client and then start using the Tatin client.



### Installing the Tatin client


Details for how to install the Tatin client are available on <https://github.com/aplteam/Tatin>

Note that the installation process depends on the operating system you are using.


### Using the Tatin client

Once the Tatin client is installed a set of user commands is available to you. These user commands can be used to fetch, load and manage your packages.

There is also an API available: if you need to execute a certain command from APL code then rather entering a user command the recommended way is to use the corresponding API function.

All user command belong to the group `Pakk`, so by entering `]pakk.` into the session autocomplete gives you a list of command available.

All API functions are available from `⎕SE.Tatin`, so by adding a dot at the end autocomplete gives you a list of all function available via the API. 

However, not for all user commands is there a corresponding API call available: user commands that are intended to report something to the user are less likely to have a corresponding API function.

Note that a package can be consumed in two different ways:

1. You may want to load a package --- and any dependencies, if there are any --- into the workspace, ideally without leaving a trail on the file system. 

   The typical scenario for this is that you want to give a particular package a try in order to find out whether it's suitable for your needs.

2. You want to incorporate a package --- and any dependencies, if there are any --- into an application of yours.

   For that you need to install the package, typically in a sub folder of the folder that hosts your application.

   You then may load an installed package into your workspace in order to use it from your application.

Note that it does not make a difference how a package is brought into the workspace: that would look excatly the same.

We discuss the two different scenarious one after the other.

#### Loading a package

The general idea of just loading a package is to fetch it from a Tatin Registry (that is a zipped file), unzip it into a temporary directory, load the code into the workspace and delete the temporary directory.

That means that ideally the whole process leaves no trace once you `)OFF` the workspace, but there is an exception: if the package needs, say, a particular DLL then of course it needs to be able to access that DLL. In this case the temporary folder is **not** deleted.

...

#### Installing a package

The idea of installing one or more packages is to make it part of an application, and become independent from any Tatin Server as a result.

You can then load the packages from the package installation folder. Because the package is already unzipped this is also faster.

Of course there are commands available that allow you to list and update packages.

....



### Setting up your own Registry

In case you want to develop and use your own packages, you might consider setting up your own registry on your local machine.

Note that in case you need to cooperate with other uers setting up a Tatin server is more appropriate.

...


### Setting up your own Tatin server


In case you want to develop and use packages within a larger company (read: you need to cooperate in one way or another with other users) then it's best to set up your own Tatin server.

...