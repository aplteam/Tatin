[parm]:title             = 'Tatin: first steps'
[parm]:leanpubExtensions = 1


# First steps with the Tatin Client

Before you start reading this document you should have read the document [Introduction.html](./Introduction.html).

I> Note that you should have at least an idea of what [Semantic Versioning](./SemanticVersioning.html) is all about.

In this document additional information that you might or might not be interested in at this stage is presented in gray boxes. You might well skip over them till later.

## Where we start from

We assume that you have the Tatin client installed and ready for use. That means that this command gives you a list with all Tatin user commands available to you:

```
      ]tatin -?
```

## What Registries are available

After a fresh installation you might wonder what Registries are available to you.


```
      ]tatin.ListRegistries
 URL                     Alias         Port    Priority
 ----                    ----------    ----    --------
 https://tatin.dev/      tatin            0         100
 https://test.tatin.dev/ test-tatin       0           0 
```

At this point Tatin only knows about the principal Tatin server and the Tatin test server. If you wish to access other servers on the Internet or your company's Intranet, or you want to host and publish packages locally (in all likelihood your own ones), then you must change the user settings. 

All these topics --- and related ones --- are discussed in a separate document: "TatinUserSettings.html". Here we try to keep things simple.


## Looking around

### Listing packages

You may list _all_ packages managed by Tatin's principal server with this command:

```
      ]tatin.ListPackages [tatin]
 Group & Name             ≢ Major versions
 -----------------------  ----------------
 aplteam-APLTreeUtils2                   1 
 aplteam-CodeCoverage                    2 
 aplteam-Compare                         1 
 aplteam-CompareSimple                   3 
 ...
```

The square brackets around "tatin" declare that string to be an alias. Without the square brackets Tatin would assume the argument to be either a local path or a URL like `https://localhost/my_tatin_server`.

A> ### Local and remote Registries
A>
A> The Tatin client can access packages that are managed by a Tatin Server, but also Registries that are locally available (read: not managed by a server). 
A> In order to address a local Registry you would just provide the path to it.
A>
A> Of course features like listing just the packages that carry a specific tag are only available when a Registry is managed by a Tatin server.

### Searching by tag(s)

`]tatin.ListPackages` will return a list with _all_ packages available in the given Registry, aggregated by major version number. Now that can be a pretty long list. It might therefore be a good idea to tell something about what you are looking for in order to make the server shrink the list.

* If you happen to know the group name you may specify `-group=whatever`; then only packages of the group "whatever" are listed.
* Every package is tagged with keywords. You may specify one or more tags, for example `-tag=linux,date`.

A> ### Searching for tags: the strategy
A>
A> 1. First Tatin tries to find a 100%-match
A> 1. In case there is no match, Tatin tries to find it _somewhere_ (`⍷`)
A> 1. In case there is still no match a fuzzy search is performed
A> 
A> The fuzzy search would find "windows" when you enter "winndows" and "linux" when you enter "linuks". It has limits, but in practice it works quite well unless the tags are very short: typing "AY" when you meant "AI" would not work.
A>
A> Notes:
A> * The strategy outlined above is applied on each tag independently.
A> * Searching for multiple tags would mean that only packages that have a hit for _all of them_ would qualify.
A> * Searching for tags is an action that is carried out by a Tatin Server. That means that specifying `-tags=` makes sense only in HTTP requests: only then is there a server on the other side that can process the request.

Let's assume you need a tool for converting [Markdown](https://en.wikipedia.org/wiki/Markdown "Link to the Wikipedia") into HTML, and that the package should run on all platforms.

The user command `ListTags` takes one or more tags and returns a list of tags that were also found in the packages that carried the specified tags:


```
            ]Tatin.ListTags [tatin] -tags=mack-os,markd
 apltree   
 converter 
 linux     
 mac-os    
 markdown  
 windows   
```

Good news: there must be at least one package that carries the tags "mac-os" and "markdown" but _also_ the tags "windows" and "linux" because those are both listed, so there will be a package available that runs on all major platforms.

Note that although we misspelled "mac-os" as "mack-os" it was still identified correctly. Similarly, "markd" was enough to find "markdown". 

We are now ready to identify that package by executing `ListPackages` with the `-tags` option:

```
           ]tatin.ListPackages [tatin] -tags=mac-os,markdown
 Group & Name     ≢ major versions
 ---------------  ---------------- 
 aplteam-MarkAPL                 1

```

Note that because packages which share the same group and name but have different major version numbers are considered different packages, the major version number is part of the list.

I> If you wonder why that is, then please read the document discussing [Semantic Versioning](./SemanticVersioning.html).


## Consuming packages

### Overview

Packages can be consumed in two different ways:

* You may load a package in order to investigate it
* You may install a package to make it part of an application

Loading a package leaves no footprint at all in the file system in case the package has no assets, or puts those assets into the temp folder of the current operating system. That's why you must specify a parent namespace but not a folder.

Installing a package (and all its dependencies) means that it is saved in the file system. That's why you must specify a folder but not a parent namespace.

Installed packages are considered dependencies of an application. Consequently in order to bring them into the workspace you must use the `]LoadDependencies` command (or its API equivalent), and it requires two mandatory parameters: the installation path and the parent namespace.


### Checking out a package: `LoadPackage`

Let's assume that you want to check whether the package `MarkAPL` suits your needs, in other words: you just want to check it out. 

That can be achieved with the `LoadPackage` user command. It loads the package into the workspace and leaves no trail in the file system if that can be avoided.

A> ### Leaving a trace on the file system
A>
A> In case the package has file dependencies (assets), like DLLs, images, CSS files and what not, then those will be saved in a specific package-dependent directory within the temp directory of your operating system, so in such cases there _is_ a footprint left on the file system.

Notes:

* Loading a package in this way has only one purpose: to investigate it.

* Loading a package might be different from installing a package: when loading a package the precise versions of dependency packages will be loaded, but when a package is installed that is not necessarily the case. 

  This is discussed in the paper `TatinsLoadAndUpdateStrategy.html`


Let's load the `MarkAPL` package into the workspace; for that we need to specify a URL and a target namespace:

```
      ]tatin.LoadPackage [tatin]MarkAPL #
  Attempting to install https://tatin.dev/aplteam-MarkAPL-10.0.0...
  Establish dependencies...
  4 dependencies identified
  Fetching https://tatin.dev/aplteam-MarkAPL-10.0.0...
  Unzipping C:\Users\username\AppData\Local\Temp\...
  Add aplteam-MarkAPL-10.0.0 to dependency file...
  Fetching https://tatin.dev/aplteam-APLTreeUtils2-1.1.0...
  ...
C:\Users\username\AppData\Local\Temp\username_155648451
```

Here we have specified `#` as the target namespace. In case the target namespace is something like `#.MyTests` then it may or may not exist. If it does not, Tatin will create it.

I> If the package or any of its dependencies depend on assets the path to a directory in the temp directory of your OS is printed to the session by `]tatin.LoadPackage`.
I>
I> This is because this folder cannot be deleted by Tatin. If none of the loaded packages has any assets then nothing is printed to the session, indicating that no footprint is left behind.

I> When you try to execute the following statements on your own machine then you will probably see different version numbers.

Tatin has created a reference named `MarkAPL` in the target namespace `#`:

```
      #.⎕nl ⍳16
MarkAPL
_tatin 
```

That reference points to the namespace that holds the package as such, which is loaded into `_tatin`: this is the namespace Tatin uses to manage all the packages.

I> The name `_tatin` is hard-coded and _cannot_ be changed.

The name of the namespace carries the version number:

```
      #.MarkAPL
#._tatin.aplteam_MarkAPL_10_0_0 
```
`_tatin` also contains all the packages `MarkAPL` depends on:

```
      #._tatin.⎕nl ⍳16
aplteam_APLTreeUtils2_1_1_0
aplteam_FilesAndDirs_5_0_0
aplteam_MarkAPL_10_0_0
aplteam_OS_3_0_0          
```

No matter whether the APL code of a package is a single function (or operator) or a bunch of functions and operators or a single namespace (ordinary or scripted) or a bunch of namespaces or a single class or a bunch of classes or a mixture of all these APL objects, they are going to live in a namespace `code`.

But Tatin will also inject references pointing to the dependencies into `code`, therefore:

```
      #._tatin.aplteam_MarkAPL_11_0_0.code.⎕nl⍳16
APLTreeUtils2
FilesAndDirs 
MarkAPL      
```

`MarkAPL` is the package we asked for. It depends on two packages, `APLTreeUtils2` and `FilesAndDirs`. For those references are injected. `FilesAndDirs` depends on `OS` but because that is not required by `MarkAPL` no reference to it is injected into MarkAPL's `code`, instead you would find such a reference in `#._tatin.aplteam_FilesAndDirs_5_0_1.code`.


#### Tatin Variables

For every package Tatin will establish certain variables, though strictly speaking they are not variables but niladic functions, the best way to simulate a constant in APL.

Those variables are injected into a namespace `TatinVars` which in turn is injected into `code`.

Some of them always exist, some of them only under certain circumstances. This is a list:


##### `CONFIG`

This is a simple character vector that stems from the file `apl-package.json` of the given package.


##### `DEPENDENCIES`

A vector of character vectors with the package IDs of the packages the package in question relies on.


##### `HOME`

Is either an empty vector or a character vector holding the path of a folder that carries assets; these are discussed next.


##### `ID`

The full package name. This will include a build ID if there is any.


##### `LX`

This might or might not exist. If it does exist then it means that the package config file defined a function name as `lx`, and that this function was executed successfully. `LX` holds the result that is returned by that function if it did return a result. Otherwise it becomes an empty vector.

Note that if there is no `lx` defined in a package config file, or if it is empty, or the function crashed (that will be trapped and ignored by Tatin) then there is no `LX`.


##### `URI`

Character vector that holds the address of a Tatin server or the full name of a ZIP file.


#### Assets

`MarkAPL` comes with HTML and CSS files. Therefore `MarkAPL` must be able to find those assets. This can be achieved by referring to the Tatin variable `HOME` in `#._tatin.aplteam_MarkAPL_11_0_0.code.TatinVars`:

```
      ⎕←path←#._tatin.aplteam_MarkAPL_11_0_0.code.TatinVars.HOME
C:\Users\...\Temp\username_155648451/aplteam-MarkAPL-11.0.0
      F←#._tatin.aplteam_MarkAPL_11_0_0.code.FilesAndDirs
      ⍪⊃F.Dir path,'\'
 C:\Users...\Temp\username_155648451\aplteam-MarkAPL-11.0.0\apl-dependencies.txt 
 C:\Users\...\Temp\username_155648451\aplteam-MarkAPL-11.0.0\apl-package.json     
 C:\Users\...\Temp\username_155648451\aplteam-MarkAPL-11.0.0\Files                
 C:\Users\...\Temp\username_155648451\aplteam-MarkAPL-11.0.0\MarkAPL.aplc         
      cfg←#._tatin.aplteam_MarkAPL_11_0_0.code.TatinVars.CONFIG
      ⎕←folder←{⍵.assets}⎕JSON⍠('Dialect' 'JSON5')⊣cfg
Files/
      ⍪⊃F.Dir path,'\',folder
 C:\...\aplteam-MarkAPL-11.0.0\Files\BlackOnWhite_print.css       
 C:\...\aplteam-MarkAPL-11.0.0\Files\BlackOnWhite_screen.css      
...
```

### Installing packages permanently: `InstallPackage`

Let's assume you've checked out `MarkAPL`, and that it turns out to suit your needs. You decide to use it in your application `Foo` which happens to live in `/Path2Foo/` on disk and in `#.Foo` in the workspace. 

Let's also assume that the code of your application lives in `Foo.Core`, and that you want to address `MarkAPL` with `##.MarkAPL` from any function within `Foo.Core`.

For that you need to execute two steps:

1. Install the required packages (and implicitly all dependencies)
2. Load all these packages

#### Step 1 : installing

```
      ]TATIN.InstallPackage [tatin]aplteam-MarkAPL /Path2Foo/Packages
```

Note that we did not specify any of the major, minor and patch numbers but the Registry by alias (`[tatin]`); that tells Tatin that we want to get the very latest version of `MarkAPL` from the principal Tatin server.

If you do not even specify the Registry then Tatin would scan all Registries _that have a priority greater than 0_; the first hit wins. Only then would it establish the best version on that server.

A> ### Scanning Registries
A>
A> The fact that Tatin scans Registries in order to find a package can be put to good use when developing packages:
A> you can run your own Tatin server on, say, your own machine, and give it the highest priority. You can then publish new versions of a package on that server first. That way Tatin would find the package on your local machine.
A> 
A> Later, when the package is ready, you could publish it to, say the principal Tatin server on `https://tatin.dev`, and delete it from your local Registry.
A>
A> The fact that Registries with a priority of `0` or less are ignored by Tatin when it comes to scanning Registries allows you to include a Registry like `https://test.tatin.dev` in your user settings. You don't really want that Registry to participate in a scan, but that way you can still execute commands like `]tatin.ListPackages` etc on it.

You may even omit the group name, although this would fail in case the name ("MarkAPL") is used in more than one group.

Let's check what's now in `/Path2Foo/Packages`

```
      ⍪⊃⎕NINFO ⍠ 1 ⊣ '/Path2Foo/Packages\*'
 /Path2Foo/Packages/apl-buildlist.json          
 /Path2Foo/Packages/apl-dependencies.txt        
 /Path2Foo/Packages/aplteam-APLTreeUtils2-1.1.0 
 /Path2Foo/Packages/aplteam-FilesAndDirs-5.0.0  
 /Path2Foo/Packages/aplteam-MarkAPL-10.0.0      
 /Path2Foo/Packages/aplteam-OS-3.0.0            
```

The build-list defines the relationship of the packages:

```
      ⍪⊃⎕NGET '/Path2Foo/Packages/apl-buildlist.json'1
 {                                                    
   principal: [                                           
     1,                                               
     0,                                               
     0,                                               
     0,                                               
   ],                                                
   packageID: [                                       
     "aplteam-MarkAPL-10.0.0",                        
     "aplteam-APLTreeUtils2-1.1.0",                   
     "aplteam-FilesAndDirs-5.0.0",                    
     "aplteam-OS-3.0.0",                              
   ],                                                 
   url: [                                             
     "https://tatin.dev/",      
     "https://tatin.dev/", 
     "https://tatin.dev/",  
     "https://tatin.dev/",            
   ],                                                 
 }                                                    
```

Notes:

* `principal` is a flag that tells top-level packages (these are the ones you asked for) from dependencies.

* `url` carries not the package name except when it is a ZIP file, because naturally the filename carries the package ID. However, including a ZIP file as a dependency is an exception anyway. The only reason why one might do this is testing a pre-release package.

The dependencies file specifies what packages _your application_ depends on as of yet:

```
      ⍪⊃⎕NGET '/Path2Foo/Packages/apl-dependencies.txt' 1
 aplteam-MarkAPL-10.0.0 
```

#### Step 2 : loading

Having the packages installed you may now load them into your application. This is achieved by the `LoadDependencies` user command:

```
      ]TATIN.LoadDependencies /Path2Foo/Packages/ #.Foo
```

As you might have guessed the folder specified as first argument must contain these two files:

```
apl-dependencies.txt
apl-buildlist.json
```

If one or both are missing an error will be thrown.

A> ### `#._tatin` versus `⎕SE._tatin`
A> 
A> Note that whether you specify a namespace in `#` or in `⎕SE` as the target of a `LoadDependencies` operation decides whether the packages are loaded into `#._tatin` or `⎕SE._tatin`.

Let's check whether it worked:

```
      ⍪⊃#.Foo.MarkAPL.Markdown2HTML 'A paragraph' '' '* This' '* That'
 <p>A paragraph</p> 
 <ul>              
 <li>This</li>     
 <li>That</li>     
 </ul>                  
```

[^dotnetcore]: More information on .NET Core is available at <<br>>
<https://en.wikipedia.org/wiki/.NET_Core>