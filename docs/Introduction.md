[parm]:title             = 'Tatin: Intro'
[parm]:leanpubExtensions = 1
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3
[parm]:numberHeaders     = 2 3 4 5 6


# Introduction

## What is Tatin?

Tatin is a package manager for Dyalog APL that helps you use and manage packages and their interdependencies. 

## What is a package?

A package should serve a particular task, for example convert markdown files into HTML. A package may be independent, but it may also depend on other packages. Tatin manages dependencies behind the scene.

A package may consist of as little as a single source file and as much as a nested folder structure with many source files. Any of those files may contain a single function, a single operator, a single class, a single interface or a single namespace. 

W> Dyalog supports several APL objects in a single text files. Tatin does _not_ support this.

A package may also come with assets.

A> ### Assets
A>
A> A package may come with all sorts of assets (CSS files, BAT files, icons, images, config files, documentation, DLLs...) which can be accessed via a folder that is defined in the package configuration file.


## Why do we need packages?

These days packages are available in probably 99% of all programming languages. It allows the consumption of code that others have written to solve a particular task without any problem; even name clashes can easily be avoided, and you don't have to worry about dependencies.

Packages can be updated to a later (and therefore hopefully better) version in an easy and straightforward manner.


## Requirements

* Tatin requires version 18.0 or later. It will come automatically with version 19.0 but must be installed in ealier versions.

* It needs Unicode --- Classic is not supported.

* The Tatin client runs on Windows, Linux and Mac-OS.

* The Tatin server runs on Windows (as a Service) and on Linux (as a Docker image). and Mac-OS. 

* Tatin is not compatible with SALT, although the extension `.dyalog` is supported for the time being.

  In particular Tatin requires source files to carry exacly one APL object, be that a function, an operator, an array, a class script, an interface script or a namespace script.

## Tatin's components

Tatin consists of:

* A Client

  The Tatin client can be used in two different ways:

  * By executing user commands like `]TATIN.LoadPackage`  
  * Via its API by executing a statement like `⎕SE.Tatin.LoadPackage '...'`

* A Tatin Server

  A Tatin server hosts packages, and allows you to fetch packages as well as any dependencies, and to publish packages.

* A set of rules that define how a package is structured, and which meta data is required or may optionally be added.

* A set of HTML documents serving as documentation for different aspects of Tatin.

The principal Tatin server is available at <https://tatin.dev>, but you can also run your own server(s) if you wish. There is also a server <https://test.tatin.dev> available as a playground for experiments.

## Consumers

If you're a consumer, you'll use the Tatin client to load, explore, and possibly install packages from one or more Tatin servers.

Note that although you can access a Tatin server with a browser, its real goal is the communication of the `]TATIN` user commands (or the Tatin API functions) with one or more Tatin servers.


## Authors (publishers)
 
You may develop Tatin packages using whatever tools you're familiar with.  These could be GitHub, GitLab or any of their competitors, or local files on your PC.

When you're ready to create a release of your package, you'll assign a group and specify a name and a version number, define dependencies (if any), and you may provide additional meta information like tags, a description and more. You may even add user-defined meta data.

Finally you publish your package to a Tatin server.

Of course you should publish your first package on the test server https://test.tatin.dev rather than on https://tatin.dev in order to gain experience without shooting yourself into the foot.

That is particular important on https://tatin.dev because any package that was published cannot be changed and/or deleted; you can only publish another version.

## Now what?!

Now is the time to read [First Steps with Tatin](./FirstStepsWithTatin.html "FirstStepsWithTatin.html")


A> ### Semantic versioning and Minimal Version Selection
A>
A> We suggest that you make yourself familiar with the concepts of [Semantic Versioning](https://semver.org/ "External link, opened in a new Tab" {target="_blank"}) and [Minimum Version Selection](https://research.swtch.com/vgo-mvs "External link, opened in a new Tab" {target="_blank"}), and how exactly these concepts are implemented in Tatin by reading the document [Tatin's load- and update strategy](./TatinsLoadAndUpdateStrategy.html "Opens the document TatinsLoadAndUpdateStrategy.html").

