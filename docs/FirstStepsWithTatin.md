[parm]:title             = 'Tatin Intro'
[parm]:leanpubExtensions = 1


# First steps with the Tatin client

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

All these topics are discussed in a separate document: "TatinUserSettings.html". Here we try to keep things simple.


## Consuming packages

Let's assume you need a tool in order to convert [Markdown](https://en.wikipedia.org/wiki/Markdown "The Wikipedia on Markdown") into HTML.

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

Note that the list comprehends not only group names and package names but also the major version numbers of each package. This is because in principle these packages:

```
aplteam-misc-1.0.0
aplteam-misc-1.1.0
aplteam-misc-1.1.1
```

are all different versions of the _same_ package while these:

```
aplteam-misc-1.0.0
aplteam-misc-2.0.0

```

are considered to be as diffent as these:

```
aplteam-This-1.0.0
aplteam-That-1.0.0
```

A> ### Semantic Versioning and Minimal Version Strategy.
A> 
A> This is because Tatin is based on the concepts of _Semantic Versioning_ and _Minimal Version Strategy_.
A>
A> These concepts are discussed in a separate document with the name "TatinsUpdateStrategy".

`]tatin.ListPackages` will return a list with _all_ packages available on that server. Now that can be a pretty long list. It might therefore be a good idea to tell something about what you are looking for in order to make the server shrink the list.

* If you happen to know the group name you may specify `-group=whatever`; then only packages of that group are listed.
* Every package is tagged with keywords. You may specify one or more tags, for example `-tag=linux,date`.

A> ### Searching for tags
A>
A> Note that the search for a tag follows this strategy:
A> 1. First Tatin tries to find 100% matches
A> 1. If that does not yield results, it tries to find the search string _somewhere_ in tags (`⍷`)
A> 1. If that does not yield a result then a fuzzy search is performed
A> 
A> The fizzy search would find "windows" when you enter "winndows" and "linux" when you enter "linuks". It has limits but in practice it works quite well unless the tags are very short: typing "AY" when you meant "AI" would not work.
A>
A> Notes:
A> * The strategy outlined above is applied on each tag independently
A> * Entering more than a single tag would mean that only packages that carry _all of them_ would qualify

In our case we look for something that runs on all platforms. For that we execute this user command:

```
            ]Tatin.Listtags [tatin] -tags=mack-os,markd
 apltree   
 converter 
 linux     
 mac-os    
 markdown  
 windows   
```

That's good: there must be at least one package that carries the tags "mac-os" and "markdown" but _also_ the tags "windows" and "linux", so there will be a package available that runs on all major platforms.

Note that although we misspelled "mac-os" as "mack-os" it was still identified correctly. Similarly, "markd" was enough for finding "markdown". 

We are now ready to identify that package:

```
           ]tatin.ListPackages [tatin] -tags=mac-os,markdown
 Group    Package Name  Major 
 -----    ------------  ----- 
 aplteam  MarkAPL       9     

```

Note that because packages which share the same group and name but have different major version numbers are considered to be different packages the major version number is part of the list.


The last question is: how many versions of that package are available:

```
       ]tatin.ListVersions [tatin]aplteam-MarkAPL
 aplteam-MarkAPL-9.1.1  
```

We could have specified the major number as well:

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

That can be achieved with the `LoadPackage` user command. That loads the package into the workspace and leaves to trail in the file system if that can be avoided.

In case the package has file dependencies, like DLLs, images, CSS files and what not, than those will be saved in a specific package-dependent directory within the temp directory of your operating system. 

Let's load the `MarkAPL` package into the workspace:

```
      ]tatin.LoadPackage [tatin]aplteam-MarkAPL-9.1.1

```


```
      #.MyTests.⎕nl ⍳16
MarkAPL
      #._tatin.⎕nl ⍳16
aplteam_APLTreeUtils_6_0_0
aplteam_FilesAndDirs_3_2_1
aplteam_IniFiles_4_0_0    
aplteam_MarkAPL_9_1_9     
aplteam_OS_2_0_0          
aplteam_Tester2_2_2_2     
aplteam_WinSys_4_0_0  
```

Note that these are ....

```
      #._tatin.aplteam_MarkAPL_9_1_9.⎕nl ⍳16
APLTreeUtils
FilesAndDirs
MarkAPL     
OS          
Tester2     
WinSys      
∆HOME       
∆URI        
      #._tatin.aplteam_MarkAPL_9_1_9.∆HOME
C:/Users/.../AppData/Local/Temp/Foo//aplteam-MarkAPL-9.1.9
      #._tatin.aplteam_MarkAPL_9_1_9.∆URI
https://tatin.dev/aplteam-MarkAPL-9.1.9
```
..............


[^dotnetcore]: More information on .NET Core is available at <<br>>
<https://en.wikipedia.org/wiki/.NET_Core>

