[parm]:title             = 'Tatin ReadMe'

⍝ Note that the document "Documentation Center" that is offered on Tatin's home page is dynamically generated from this page.

## Documentation Center

The Tatin documentation consists of a collection of HTML files.

This document gives you an overview over these HTML files: their purpose and who should (or may) read them, and which ones you can safely ignore depending on your skills and goal(s).


### General information

* [Introduction](./Introduction.html "Introduction.html") (draft)

  A must-read for _everybody_.

* [Semantic Versioning](./SemanticVersioning.html "SemanticVersioning.html") (draft)

  Read this if you don't know what Semantic Versioning is; an understanding is essential for using Tatin.

* [Tatin's Load and Update Strategy](./TatinsLoadAndUpdateStrategy.html "TatinsLoadAndUpdateStrategy.html") (draft)

  Discuss what measures Tatin takes when dependencies rely on different versions of the same package and related issues.

* [Tatin User Settings](./TatinUserSettings.html "TatinUserSettings.html") (draft)

  You need to read this _only_ in case one or more of the following is true for you:
  
  * You are unhappy with Tatin's default location for the user settings file
  * You need multiple user settings files
  * You need different user settings files for multiple users

* [Syntax Reference](./SyntaxReference.html "SyntaxReference.html") (draft)

  Documents the syntax of all API functions.

### The Client

* [Installing and updating the Tatin Client](./InstallingAndUpdatingTheTatinClient.html "InstallingAndUpdatingTheTatinClient.html") (draft)

  Check whether autocomplete in the Dyalog session offers you something after entering `]Tatin` - if that's the case Tatin is already available, so no need to install it.

  However, you might still want to update Tatin.

* [First Steps with Tatin](./FirstStepsWithTatin.html "FirstStepsWithTatin.html") (draft)

  Read this before you consume your first package

* [Package Configuration](./PackageConfiguration.html "Regarding Package Configuration") (draft)

  Read this for discussing the details of package configuration files.

* [Publishing Packages](./PublishingPackages.html "PublishingPackages.html") (draft)

  Read this in case you want to publish Tatin packages.

* [Caching](./Caching.html "Caching.html") (draft)

  By default the Tatin client caches any package that is either installed or loaded. This document
  discusses the implications, and under which circumstances you might want to switch caching off, either
  globally or just for a specific Registry.


### The Server

* [Installing the Tatin Server](./InstallingTheTatinServer.html "InstallingTheTatinServer.html") (draft)

  Read this if you want to run your own Tatin server.  


### Misc

* [Usage data](./UsageData.html "Usage data.html") (draft)

  Read this in case you are interested in statistical data regarding downloads of packages

* [Tatin for Contributors](./TatinForContributors.html "TatinForContributors.html") (draft)

  Read this in case you want to contribute to the Tatin project on GitHub

* [Run Dyalog behind Apache](./RunDyalogBehindApache.html "RunDyalogBehindApache.html") (draft)

  Read this if you want to run a Tatin server behind an Apache server.