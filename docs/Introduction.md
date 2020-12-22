[parm]:title             = 'Tatin: Intro'
[parm]:leanpubExtensions = 1


## Introduction

### What is Tatin?

Tatin is a package manager for Dyalog APL that helps you use and manage packages and their interdependencies. 

### What is a package?

A package should serve a particular task, for example convert markdown files into HTML. A package may be independent, but it may also depend on other packages. Tatin manages dependencies behind the scene.

A package may consist of as little as a single source file and as much as a nested folder structure with many text files. Any of those text files may contain a function, an operator, a class, an interface or a namespace. A package may also come with assets.

A> ### Assets
A>
A> A package may come with all sorts of assets (CSS files, BAT files, icons, images, config files, documentation, DLLs...) which can be accessed via a folder that is defined in the package configuration file.


### Why do we need packages?

These days packages are available in probably 99% of all programming languages. They allow the consumption of code that others have written to solve a particular task without any problem; even name clashes can easily be avoided, and you don't have to worry about dependencies.

Packages can be updated to a newer (and therefore hopefully better) version in an easy and straightforward manner.


## Tatin's components

Tatin consists of:

* A client package. The Tatin client can be used in two different ways:

  * By executing user commands like `]TATIN.LoadPackge`  
  * Via its API by executing a statement like `⎕SE.Tatin.LoadPackge '...'`

* A Tatin Server

  A Tatin server hosts packages, and allows you to fetch packages as well as any dependencies, and to publish packages.

* A set of rules that define how a package is structured, and which meta data is required or may optionally be added.

* A set of HTML documents serving as documentation for different aspects of Tatin.

The principal Tatin server is available at <https://tatin.dev>, but you can also run your own server(s) if you wish. There is also a server <https://test.tatin.dev> available as a playground for experiments.


### Consumers

If you're a consumer, you'll use the Tatin client to load, explore, and possibly install packages from one or more Tatin servers.

Note that although you can access the Tatin server with a browser, it's real goal is the communication of the `]TATIN` user commands with one or more Tatin servers.


### Authors / publishers
 
You'll develop Tatin packages using whatever tools you're familiar with.  These could be GitHub, GitLab or any of their competitors, or local files on your PC.

When you're ready to create a release of your package, you'll give the release a version number and provide meta information like group, name and version number as well as dependencies, tags, a description and more.

Finally you publish your package to a Tatin server.

## Now what?!

We suggest that you make yourself familiar with the concept of [Semantic Versioning](https://semver.org/ "External link, opened in a new Tab" {target="_blank"}), 

and how exactly it is implemented in Tatin by reading the document [Tatin's load- and update strategy](./TatinsLoadAndUpdateStrategy.html "Opens the document TatinsLoadAndUpdateStrategy.html").