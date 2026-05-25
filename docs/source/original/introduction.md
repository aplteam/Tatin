---
title: 'Tatin: Intro'
description: ''
keywords: 
---
# Introduction

## What is Tatin?

Tatin is a package manager for Dyalog APL that helps you use and manage packages and their interdependencies. 

## What is a package?

A package should serve a particular task, for example converting markdown files into HTML. A package may be independent, but it may also depend on other packages. Tatin manages dependencies behind the scene.

A package may consist of as little as a single source file and as much as a nested folder structure with many source files. Any of those files may contain a single function, a single operator, a single class, a single interface, or a single namespace. 

W> Dyalog supports several APL objects in a single text file. Tatin does _not_ support this.

A package may also come with assets.

A> ### Assets
A>
A> A package may come with all sorts of assets (CSS files, BAT files, icons, images, config files, documentation, DLLs...) which can be accessed via a folder that is defined in the package configuration file.


## Why do we need packages?

These days packages are available in probably 99% of all programming languages. It allows the consumption of code that others have written to solve a particular task. Name clashes can be easily avoided, and you don't have to worry about dependencies.

Packages can easily be updated to a later (and therefore hopefully better) version.


## Requirements

* Tatin requires Dyalog version 18.2 or later. It will come automatically with version 19.0 (although it must be activated with the `]activate` user command) but must be installed in earlier versions.

* It needs Unicode --- Classic is not supported.

* The Tatin client runs on Windows, Linux, Mac OS and the PI.

* The Tatin server runs on Windows (as a Service or a Docker container) and on Linux (as a Docker image). 

  In principle the server also runs on a Mac but the docker container has not been tested on a Mac.

* Tatin is not compatible with SALT, although the extension `.dyalog` is supported.

  In particular Tatin requires source files to carry exactly one APL object, be that a function, an operator, an array, a class script, an interface script, or a namespace script.

## Tatin's components

Tatin consists of:

* A Client

  The Tatin client can be used in two different ways:

  * By executing user commands like `]TATIN.LoadPackages ...`  
  * Via its API by executing a statement like `⎕SE.Tatin.LoadPackages '...'`

* A Tatin Server

  A Tatin server hosts packages and allows you to fetch packages as well as any dependencies, and to publish packages.

* A set of rules that define how a package is structured, and which metadata is required or may optionally be added.

* A set of HTML documents serving as documentation for different aspects of Tatin.

The principal Tatin server is available at <https://tatin.dev>, but you can also run your own server(s) if you wish. There is also a server <https://test.tatin.dev> available as a playground for experiments.

## Consumers

If you're a consumer, you'll use the Tatin client to load, explore, and eventually install packages from one or more Tatin servers.

Note that although you can access a Tatin server with a browser, its real goal is the communication of the `]TATIN` user commands (or the Tatin API functions) with one or more Tatin servers.


## Authors (publishers)
 
You may develop Tatin packages using whatever tools you're familiar with.  These could be GitHub, GitLab or any of their competitors, or local files on your PC.

When you're ready to create a release of your package, you'll assign a group and specify a name and a version number, define dependencies (if any), and you may provide additional meta information like tags, a description, and more. You may even add user-defined metadata.

Finally, you publish your package to a Tatin server.

Of course, you should publish your first package on the test server https://test.tatin.dev rather than on https://tatin.dev to gain experience without shooting yourself in the foot.

That is particularly important on https://tatin.dev because any package that was published cannot be changed and/or deleted; you can only publish another version.

## Now what?!

Now is the time to read [First Steps with Tatin](firststepswithtatin.md)


A> ### Semantic versioning and Minimal Version Selection
A>
A> We suggest that you make yourself familiar with the concepts of [Semantic Versioning](https://semver.org/ "External link, opened in a new Tab" {target="_blank"}) and [Minimum Version Selection](https://research.swtch.com/vgo-mvs "External link, opened in a new Tab" {target="_blank"}), and how exactly these concepts are implemented in Tatin by reading the document [Tatin's load- and update strategy](tatinsloadandupdatestrategy.md).





