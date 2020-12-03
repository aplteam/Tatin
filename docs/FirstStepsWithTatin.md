[parm]:title             = 'Tatin Intro'
[parm]:leanpubExtensions = 1


# First steps with the Tatin Client

## Basics

### What exactly is a package?

A package may consist of as little as a single source file and as much as a nested folder structure with many text files. Those text files may contain a function, an operator, a class, an interface or a namespace.

Note that there is no clear-cut line between an application and a package: one man's package may well be somebody else's application.

Note also that it does not make too much sense to publish a package that consists of just a single function. That's a route several programming languages have chosen, and it did not work out well. There is the famous story about the `ToLowercase` function written in JavaScript which can be consumed as a package. It's currently on version 4.1, and we are looking forward to version 5.0  ;)

### Assets

A package may come with all sorts of assets (CSS files, BAT files, icons, images, config files, documentation, DLLs...) which can be accessed via a folder that is defined in the package configuration file.

The finer details of package configuration are discussed in the document "PackageConfiguration.html".

### Why do we need packages?

Packages are these days available in probably 99% of all programming languages. They allow the consumption of code that others have written to solve a particular task, without any problem; even name clashes can easily be avoided.

But packages also allow you to update to a newer (and therefore hopefully better) version in an easy and straightforward manner.

## Where we start from

We assume that you have the Tatin client installed and ready for use. That means that this command gives you a list with all Tatin user commands available to you:

```
      ]tatin -?
```

## What Registries are available

After a fresh installation you might wonder what Registries are at your disposal.


```
      ]tatin.ListRegistries
 URL                 Alias 
 ----                ----- 
 https://tatin.dev/  tatin 
```

At this point Tatin only knows about the principal Tatin server. If you wish to access other servers on the Internet or your company's Intranet, or you want to host and publish packages locally (in all likelyhood your own ones), then you must change the user settings. 

All these topics --- and others --- are discussed in a separate document: "TatinUserSettings.html". Here we try to keep things simple.


## Consuming packages

Let's assume you need a tool in order to convert [Markdown](https://en.wikipedia.org/wiki/Markdown "Link to the Wikipedia") into HTML.

### Listing packages

You may list _all_ packages managed by Tatin's principal server with this command:

```
      ]tatin.ListPackages [tatin]
Group    Package Name     Major 
 -----    ------------     ----- 
 aplteam  WindowsEventLog  2     
 aplteam  Logger           4     
 aplteam  OS               2     
...
```

The square brackets around "tatin" declare that string to be an alias. Without the square brackets Tatin would assume the argument to be either a local path or a URL like `https://localhost/my_tatin_server`.

A> ### Local and remote Registries
A>
A> The Tatin client can access packes that are managed by a Tatin Server but also Registries that are locally available. 
A> In order to address a local Registry you would just provide the path to it.
A>
A> Of course features like listing only packages that carry a specific tag are only available when a Registry is managed by a Tatin server.

Note that the list comprehends not only group names and package names but also the major version number of each package. This is because in principle these packages:

```
aplteam-misc-1.0.0
aplteam-misc-1.1.0
aplteam-misc-1.1.1
```

...are all different versions of the _same_ package while these:

```
aplteam-misc-1.0.0
aplteam-misc-2.0.0

```

...are considered to be as diffent as these:

```
aplteam-This-1.0.0
aplteam-That-1.0.0
```

A> ### Semantic Versioning and Minimal Version Strategy.
A> 
A> This is because Tatin is based on the concepts of _Semantic Versioning_ and _Minimal Version Strategy_.
A>
A> These concepts are discussed in a separate document with the name "TatinsLoadAndUpdateStrategy".

`]tatin.ListPackages` will return a list with _all_ packages available in the given Registry. Now that can be a pretty long list. It might therefore be a good idea to tell something about what you are looking for in order to make the server shrink the list.

* If you happen to know the group name you may specify `-group=whatever`; then only packages of that group are listed.
* Every package is tagged with keywords. You may specify one or more tags, for example `-tag=linux,date`.

A> ### Searching for tags
A>
A> Note that the search for a tag follows this strategy:
A> 1. First Tatin tries to find 100% matches
A> 1. If that does not yield results, it tries to find the search string _somewhere_ in the tags (`⍷`)
A> 1. If that does not yield a result then a fuzzy search is performed
A> 
A> The fuzzy search would find "windows" when you enter "winndows" and "linux" when you enter "linuks". It has limits but in practice it works quite well unless the tags are very short: typing "AY" when you meant "AI" would not work.
A>
A> Notes:
A> * The strategy outlined above is applied on each tag independently.
A> * Searching for multiple tags would mean that only packages that carry _all of them_ would qualify.
A> * Searching for tags is an action that is carried out by a Tatin Server. That means that specifying `-tags=` makes sense only in HTTP requests: only then is there a server on the other side that can process the request.

In our case we look for something that runs on all platforms. The user command `ListTags` takes one or more tags and returns a list of tags that were also found in the packages that carried the specified tags:

```
            ]Tatin.Listtags [tatin] -tags=mack-os,markd
 apltree   
 converter 
 linux     
 mac-os    
 markdown  
 windows   
```

That's good: there must be at least one package that carries the tags "mac-os" and "markdown" but _also_ the tags "windows" and "linux" because those are both listed, so there will be a package available that runs on all major platforms.

Note that although we misspelled "mac-os" as "mack-os" it was still identified correctly. Similarly, "markd" was enough for finding "markdown". 

We are now ready to identify that package by executing `ListPackages` with the `-tags` option:

```
           ]tatin.ListPackages [tatin] -tags=mac-os,markdown
 Group    Package Name  Major 
 -----    ------------  ----- 
 aplteam  MarkAPL       9     

```

Note that because packages which share the same group and name but have different major version numbers are considered to be different packages, the major version number is part of the list.


The last question is: how many versions of that package are available:

```
       ]tatin.ListVersions [tatin]aplteam-MarkAPL
 aplteam-MarkAPL-9.1.1  
```

We could have specified the major number as well though it does not make a differenc here because there's just one anyway:

```
       ]tatin.ListVersions [tatin]aplteam-MarkAPL-9
 aplteam-MarkAPL-9.1.1  
```

We could also have specified the minor number:

```
       ]tatin.ListVersions [tatin]aplteam-MarkAPL-9.1
 aplteam-MarkAPL-9.1.1  
```


### Give it a try

Let's assume that you are not certain whether you really want to use `MarkAPL`, you just want to check it out. 

That can be achieved with the `LoadPackage` user command. That loads the package into the workspace and leaves no trail in the file system if that can be avoided.

A> In case the package has file dependencies, like DLLs, images, CSS files and what not, than those will be saved in a specific package-dependent directory within the temp directory of your operating system, so in such cases there is a footprint left in the file system.

Notes:

* Loading a package has only one purpose: to investigate a package.

* Loading a package might be different from installing a package: when loading a package the precise versions of dependency packages will be loaded, but with installing a package that is not necessarily the case. This is discussed in the paper `TatinsLoadAndUpdateStrategy.html`


Let's load the `MarkAPL` package into the workspace:

```
      ]tatin.LoadPackage [tatin]aplteam-MarkAPL-9.1.1 #.MyTests
```

The namespace `#.MyTests` may or may not exist. If it does not Tatin will create it.

When you try to execute the following statements on your own machine then you will probably see different version numbers.

Tatin created named "MarkAPL" in the target namespace `#.MyTests`:

```
      #.MyTests.⎕nl ⍳16
MarkAPL
```

That link points to the namespace that holds the package as such, which is loaded into `_tatin`. The name of the namespace carries the version number:

```
      #.MyTests.MarkAPL
#._tatin.aplteam_MarkAPL_9_1_9 
```

`_tatin` also contains all the dependencies "MarkAPL" relies on:

```
      #._tatin.⎕nl ⍳16
aplteam_APLTreeUtils_6_0_0
aplteam_FilesAndDirs_3_2_1
aplteam_IniFiles_4_0_0    
aplteam_MarkAPL_9_1_9     
aplteam_OS_2_0_0          
aplteam_Tester2_2_2_2     
aplteam_WinSys_4_0_0  
```

[^dotnetcore]: More information on .NET Core is available at <<br>>
<https://en.wikipedia.org/wiki/.NET_Core>

