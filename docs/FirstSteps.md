[parm]:title             = 'Tatin Intro'
[parm]:leanpubExtensions = 1


# First steps with the Tatin client

We assume that you have the Tatin client installed and ready for use. That means that this command gives you a list with all Tatin user commands available to you:

```
      ]tatin -?
```

## What Registries are available

After a fresh installation you might wonder what is at your disposal.


```
      ]tatin.ListRegistries
 Path                Alias 
 ----                ----- 
 https://tatin.dev/  tatin 
```

At this point Tatin only know about the principle Tatin server. If you wish to host and publish packages locally (in all likelyhood your own ones), then you must [add that local Registry to the config file](#Adding Registries).


## Consuming packages

Let's assume you need a ZIP tool (zipper) that is platform independent.

This has been a problem for a long time, because many zippers are available on one or two platforms, but none has been available on all three major platforms (Windows, Linux, Mac OS) for a long time.

Now we have .NET Core[^dotnetcore], a library that runs on all three platforms. 

The package [`DotNetZip`](https://github.com/aplteam/DotNetZip "Link to the project page on GitHub") is a Dyalog package that is based on .NET or .NET Core, whatever is available. 

In our first example we are going to comsume that package.

### Listing packages

Let's assume that you know about .NET Core, but what you don't know is whether there is a package available on the Tatin Registry.

That can be checked with this command:

```
      ]tatin.ListPackages [tatin]
Group    Package Name     Major 
 -----    ------------     ----- 
 aplteam  WindowsEventLog  2     
 aplteam  Logger           4     
 aplteam  OS               2     
...
```

The square brackets around `tatin` declare that string to be an alias. By default the user command would assume a local path or a URL like `https://tatin.dev`.

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

A> This is because Tatin is based on the concepts of _Semantic Versioning_ and _Minimal Version Strategy_.
A>
A> These concepts are discussed in a separate document with the name "Tatin's Update Strategy".

This user command will return a list with all packages available on that server. That can be a pretty long list. It might therefore be a good idea to tell something about what you are looking for in order to shrink the list.

* If you know the group name you may specify `-group=whatever`; then only packages of that group are listed.
* Every packackge is tagged with keywords. You may specify one or more tags with `-tag=linux,date`.

### Give it a try

Let's assume that you are not certain whether you really want to use `DotNetZip`, you just want to check it out. 

That can be achieved with the `LoadPackage` user command. That loads the package into the workspace and leaves to trail in the file system.

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

