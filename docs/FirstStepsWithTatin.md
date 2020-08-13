[parm]:title             = 'Tatin Intro'
[parm]:leanpubExtensions = 1


# First steps with the Tatin client

We assume that you have the Tatin client installed and ready for use. That means that this command gives you a list with all Tatin user commands available to you:

```
      ]tatin -?
```

## What Registries are available

After a fresh installation you might wonder what Registries at your disposal.


```
      ]tatin.ListRegistries
 URL                 Alias 
 ----                ----- 
 https://tatin.dev/  tatin 
```

At this point Tatin only knows about the principal Tatin server. If you wish to host and publish packages locally (in all likelyhood your own ones), then you must [add that local Registry to the config file](#Adding Registries).


## Consuming packages

Let's assume you need a ZIP tool (zipper) that is platform independent.

This has been a problem for a long time, because many zippers are available on one or two platforms, but none has been available on all three major platforms (Windows, Linux, Mac OS) for a long time.

In our first example we are going to try to find an appropriate package and give it a try.

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

Note that the list comprehends not only group names and package names but also the major version numbers of each package. This is because in principle these two packages:

```
aplteam-misc-1.0.0
aplteam-misc-1.1.0
```

are different versions of the same package while these:

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
A> These concepts are discussed in a separate document with the name "Tatin_Update_Strategy".

This user command will return a list with all packages available on that server. Now that can be a pretty long list. It might therefore be a good idea to tell something about what you are looking for in order to shrink the list.

* If you know the group name you may specify `-group=whatever`; then only packages of that group are listed.
* Every package is tagged with keywords. You may specify one or more tags, for example `-tag=linux,date`.

A> ### Searching for tags
A>
A> Note that the search for a tag follows this recipe:
A> 1. First Tatin try to find 100% matches
A> 1. If that does not yield results, it tries to find the search string somewhere in tags
A> 1. If that does not yield a result then a fuzzy search is performed
A> 
A> The fizzy search would find "windows" when you enter "winndows" and "linux" when you enter "linuks". It heas limits but in practice it works quite well unless the tags are very short: typing "AY" when you meant "AI" would not work.
A>
A> Note that entering more than a single tag would meand that only packages that carry _all of them_ would qualify.

In our case we look for a zip tool that runs on all platforms. For that we execute this user command:

```
      ]Tatin.Listtags [tatin] -tags=mack-os,zip
 linux  mac-os  windows  zip-tools 
```

That's good: there must be at least one package that carries the tags "mac-os" and "zip" but _also_ the tags "windows" and "linux", so there will be a zipping tools that is running on all major platforms.

Note that although we misspelled "mac-os" as "mack-os" it was stil identified correctly. Similarly, "zip" was enough for finding "zip-tools". That's because the algorithm uses three different approaches

1. First it tries to find 100%-matches
2. If that does not yield a result it tried to find the specified tag with `⍷` _somewhere_.
3. If that does not yield a result either then a fuzzy search is performed.


### Give it a try

Let's assume that you are not certain whether you really want to use `DotNetZip`, you just want to check it out. 

That can be achieved with the `LoadPackage` user command. That loads the package into the workspace and leaves to trail in the file system.

A> ### File dependencies (assets)
A>
A> Although in most cases this will be true there are exceptions:
A>
A> In case the package has file dependencies, like DLLs, than those DLLs will be saved in a specific package-dependent directory within the temp directory of your operating system. 

..............


----

### Adding Registries

You can check the your current settings with the `UserSettings` command:

```
      ]tatin.UserSettings
 User settings in <C:\Users\{username}\AppData\Local\Tatin\tatin-client.json> : 
 {                                                                       
   registries: [                                                         
     {                                                                   
       alias: "tatin",                                                   
       api_key: "***",                                                   
       port: 0,                                                          
       priority: 100,                                                    
       uri: "https://tatin.dev/",                                        
     },                                                                  
   ],                                                                    
   source: "",                                                           
 }                                                                       

```



[^dotnetcore]: More information on .NET Core is available at <<br>>
<https://en.wikipedia.org/wiki/.NET_Core>

