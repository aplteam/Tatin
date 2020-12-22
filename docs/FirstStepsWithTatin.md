[parm]:title             = 'Tatin: first steps'
[parm]:leanpubExtensions = 1


# First steps with the Tatin Client

Before you start reading this document you should have read the document [Introduction.html](./Introduction.html).

Also, it does not hurt to know what [Semantic Versioning](./SemanticVersioning.html) is.

In this document additional information you might or might not be interested in at this stage is presented in gray boxes. You might well skip over them till later.

## Where we start from

We assume that you have the Tatin client installed and ready for use. That means that this command gives you a list with all Tatin user commands available to you:

```
      ]tatin -?
```

## What Registries are available

After a fresh installation you might wonder what Registries are available for you.


```
      ]tatin.ListRegistries
 URL                 Alias 
 ----                ----- 
 https://tatin.dev/  tatin 
```

At this point Tatin only knows about the principal Tatin server. If you wish to access other servers on the Internet or your company's Intranet, or you want to host and publish packages locally (in all likelyhood your own ones), then you must change the user settings. 

All these topics --- and others --- are discussed in a separate document: "TatinUserSettings.html". Here we try to keep things simple.


## Looking around

### Listing packages

You may list _all_ packages managed by Tatin's principal server with this command:

```
      ]tatin.ListPackages [tatin]
 Group & Name             ≢ Major versions
 -----------------------  ----------------
 aplteam-WindowsEventLog  2     
 aplteam-Logger           4     
 aplteam-OS               2  
 ...
```

The square brackets around "tatin" declare that string to be an alias. Without the square brackets Tatin would assume the argument to be either a local path or a URL like `https://localhost/my_tatin_server`.

A> ### Local and remote Registries
A>
A> The Tatin client can access packages that are managed by a Tatin Server but also Registries that are locally available. 
A> In order to address a local Registry you would just provide the path to it.
A>
A> Of course features like listing just the packages that carry a specific tag are only available when a Registry is managed by a Tatin server.

### Searching by tag(s)

`]tatin.ListPackages` will return a list with _all_ packages available in the given Registry, aggregated by major version number. Now that can be a pretty long list. It might therefore be a good idea to tell something about what you are looking for in order to make the server shrink the list.

* If you happen to know the group name you may specify `-group=whatever`; then only packages of the group "whatever" are listed.
* Every package is tagged with keywords. You may specify one or more tags, for example `-tag=linux,date`.

A> ### Searching for tags: the strategy
A>
A> 1. First Tatin tries to find 100% matches for each keyword
A> 1. In case there is no match Tatin tries to find the search string _somewhere_ (`⍷`)
A> 1. In case there is still no match a fuzzy search is performed
A> 
A> The fuzzy search would find "windows" when you enter "winndows" and "linux" when you enter "linuks". It has limits but in practice it works quite well unless the tags are very short: typing "AY" when you meant "AI" would not work.
A>
A> Notes:
A> * The strategy outlined above is applied on each tag independently.
A> * Searching for multiple tags would mean that only packages that have a hit for _all of them_ would qualify.
A> * Searching for tags is an action that is carried out by a Tatin Server. That means that specifying `-tags=` makes sense only in HTTP requests: only then is there a server on the other side that can process the request.

Let's assume you need a tool in order to convert [Markdown](https://en.wikipedia.org/wiki/Markdown "Link to the Wikipedia") into HTML, and that the package should run on all platforms.

The user command `ListTags` takes one or more tags and returns a list of tags that were also found in the packages that carried the specified tags:


```
            ]Tatin.Listtags [tatin] -tags=mack-os,markd
 apltree   
 converter 
 linux     
 mac-os    
 markdown  
 windows   
```

Good news: there must be at least one package that carries the tags "mac-os" and "markdown" but _also_ the tags "windows" and "linux" because those are both listed, so there will be a package available that runs on all major platforms.

Note that although we misspelled "mac-os" as "mack-os" it was still identified correctly. Similarly, "markd" was enough for finding "markdown". 

We are now ready to identify that package by executing `ListPackages` with the `-tags` option:

```
           ]tatin.ListPackages [tatin] -tags=mac-os,markdown
 Group & Name     ≢ major versions
 ---------------  ---------------- 
 aplteam-MarkAPL                 1

```

Note that because packages which share the same group and name but have different major version numbers are considered to be different packages, the major version number is part of the list.


## Consuming packages

### Give it a try: `LoadPackage`

Let's assume that you want to make sure that `MarkAPL` suits your needs, in other words: you just want to check it out. 

That can be achieved with the `LoadPackage` user command. That loads the package into the workspace and leaves no trail on the file system if that can be avoided.

A> ### Leaving a trace on the file system
A>
A> In case the package has file dependencies, like DLLs, images, CSS files and what not, than those will be saved in a specific package-dependent directory within the temp directory of your operating system, so in such cases there is a footprint left in the file system.

Notes:

* Loading a package has only one purpose: to investigate it.

* Loading a package might be different from installing a package: when loading a package the precise versions of dependency packages will be loaded, but with installing a package that is not necessarily the case. This is discussed in the paper `TatinsLoadAndUpdateStrategy.html`


Let's load the `MarkAPL` package into the workspace:

```
      ]tatin.LoadPackage [tatin]aplteam-MarkAPL-9.1.1 #.MyTests
```

The namespace `#.MyTests` may or may not exist. If it does not Tatin will create it.

I> When you try to execute the following statements on your own machine then you will probably see different version numbers.

Tatin created a reference named "MarkAPL" in the target namespace `#.MyTests`:

```
      #.MyTests.⎕nl ⍳16
MarkAPL
```

That reference points to the namespace that holds the package as such, which is loaded into `_tatin`. The name of the namespace carries the version number:

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

`==>` **Add `InstallPackage` and `Load_Dependencies` here** {style="font-size:xx-large;"}

### Installing packages

...


### Loading dependencies

...


[^dotnetcore]: More information on .NET Core is available at <<br>>
<https://en.wikipedia.org/wiki/.NET_Core>

