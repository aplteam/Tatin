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

The square brackets around "tatin" declare that string to be an alias. Without the square brackets Tatin would assume the argument to be either a local path or a URL like `https://localhost/my_tatin_server` or a simple question mark: `]tatin.ListPackages ?` would present all known Registries to you.

A> ### Local and remote Registries
A>
A> The Tatin client can access packages that are managed by a Tatin Server, but also Registries that are locally available (read: not managed by a server). 
A> In order to address a local Registry you would just provide the path to it.
A>
A> Of course features like listing just the packages that carry a specific tag are only available when a Registry is managed by a Tatin server.

### Searching by tag(s)

`]tatin.ListPackages` will return a list with _all_ packages available in the given Registry, aggregated by major version number. Now that can be a pretty long list. It might therefore be a good idea to tell something about what you are looking for in order to make the server shrink the list.

* If you happen to know the group name you may specify `-group=whatever`: then only packages of the group "whatever" are listed
* Every package is tagged with keywords: you may specify one or more tags, for example `-tag=linux,date`

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

### Installing packages

Imagine you want to use the MarkAPL package in an application you are currently working on which we will call a project. Let's also assume that this project is named "Foo" and lives in `/Foo/`.

The first step is to install the package as part of the project "Foo":

```
      ]tatin.InstallPackage [tatin]MarkAPL /Foo/packages
```

Notes:

* `[tatin]` tells the Tatin client to load MarkAPL from the server the alias `tatin` is pointing to: https://tatin.dev
* "MarkAPL" specifies neither a group nor a version number
  * If the name "MarkAPL" is used within more than just one group the operation will fail
  * Because no version information was provided at all, the very latest version will be installed

#### What got installed?

Once you executed the above statement the `packages/` sub directory carries these files:

```
apl-buildlist.json
apl-dependencies.txt
aplteam-APLTreeUtils2-1.1.1
aplteam-FilesAndDirs-5.0.1
aplteam-MarkAPL-11.0.1
aplteam-OS-3.0.1
```

* The folder `aplteam-MarkAPL-11.0.1` contains the MarkAPL package
* The file `apl-dependencies.txt` contains just one line: `aplteam-MarkAPL-11.0.1`

  That's because you project "Foo" depends so far on just one package, MarkAPL

* The file `apl-buildlist.json` carries the build list


#### The build list

The build list will be used to get all required packages into the workspace. This is how the build list looks so far:

```
{
  packageID: [
    "aplteam-MarkAPL-11.0.1",
    "aplteam-OS-3.0.1",
    "aplteam-FilesAndDirs-5.0.1",
    "aplteam-APLTreeUtils2-1.1.1",
  ],
  principal: [
    1,
    0,
    0,
    0,
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

* There is one package that has `principal` set to 1: MarkAPL. That's because we have explicitly asked for it
* All other packages got installed because MarkAPL depends on them, either directly or indirectly
* The URL points to where the packages were loaded from

#### How does a package look like on disk?

Let's have a look into the directory `/Foo/packages/aplteam-MarkAPL-11.0.1`:

```
apl-dependencies.txt
apl-package.json
aplteam-MarkAPL-11.0.1/Files
MarkAPL.aplc
```

Again `apl-dependencies.txt` lists all dependencies, this time all the packages MarkAPL depends on.

The file `apl-package.json` describes the MarkAPL package:

```
{
  api: "MarkAPL",
  assets: "Files/",
  date: 20210725.153851,
  description: "Converts Markdown to HTML5",
  group: "aplteam",
  info_url: "https://github.com/aplteam/MarkAPL",
  io: 1,
  lx: "",
  ml: 1,
  name: "MarkAPL",
  source: "MarkAPL.aplc",
  tags: "markdown,converter,windows,linux,mac-os,apltree",
  uri: "https://tatin.dev/",
  version: "11.0.1+232",
  wx: 3,
}
```

#### Assets

Note that the file `apl-package.json` specifies `assets: "Files/"`. That means that all assets are to be found in the `Files/` sub directory.

In case of MarkAPL these are a bunch of CSS and HTML files:

```
BlackOnWhite_print.css       
BlackOnWhite_screen.css
LeanPubExtensions.html
MarkAPL.html
MarkAPL_CheatSheet.html
MarkAPL_for_Programmers.html
MarkAPL_print.css
MarkAPL_screen.css
QuickIntro.html
Styles.html
```

Of course it could be anything required by the package.

### Getting a package into the workspace

From the perspective of the application "Foo" all packages are dependencies. Therefore one must issue this command:

```
      ]tatin.LoadDependencies /Foo/packages #.Foo
#._tatin.aplteam_MarkAPL_11_0_1 
```

I> You will also see a couple of messages the user command prints to the session in order to keep you informed about the progress of loading the packages. These are not shown here.

The command prints to the session the name of the namespace into which the package was actually loaded. We can use MarkAPL by referring to it as `#.Foo.MarkAPL` because Tatin has also established a reference in `#.Foo` named `MarkAPL` that points to the real package:


```
      #.Foo.MarkAPL
#._tatin.aplteam_MarkAPL_11_0_1.code.MarkAPL
```

But how does MarkAPL find its assets? Well, Tatin injects a namespace `TatinVars` into `#._tatin.aplteam_MarkAPL_11_0_1.code`, and that namespace carries a variable `HOME` that in turn carries the path to the directory that holds the assets:

```
      #._tatin.aplteam_MarkAPL_11_0_1.code.TatinVars.HOME
/Foo/packages/aplteam-APLTreeUtils2-1.1.1
```

That means that any MarkAPL function can refer to `HOME` with `##.TatinVars.Home`.

`TatinVars` holds more potentially important data; details are discussed at [Tatin Variables](#).

What else lives in `#._tatin`?


```
      #._tatin.⎕nl 9
aplteam_APLTreeUtils2_1_1_1
aplteam_FilesAndDirs_5_0_1 
aplteam_MarkAPL_11_0_1     
aplteam_OS_3_0_1           
```

All packages, whether principal ones or dependencies, are stored in `#._tatin`. For the principal packages a reference is injected into the target namespace.

Note that by naming convention packages are always loaded into either `#._tatin` or `⎕SE._tatin`.


### Checking out a package: `LoadPackage`

Let's assume that before actually installing it you first  want to check whether the package `MarkAPL` suits your needs. In this case you might not want to install it but just to load it into the workspace. 

That can be achieved with the `LoadPackage` user command. It loads the package into the workspace and leaves no trail in the file system if that can be avoided, which means if it has no assets,

A> ### Leaving a trace on the file system
A>
A> In case the package has file dependencies (assets), like DLLs, images, CSS files and what not, then those will be saved in a specific package-dependent directory within the temp directory of your operating system, so in such cases there _is_ a footprint left on the file system.
A>
A> Note that this also means that loading a package only works on your local machine.

Notes:

* Loading a package in this way has only one purpose: to investigate it.

* Loading a package might well be different from installing a package: when loading a package the precise versions of dependency packages will be loaded, but when a package is installed that is not necessarily the case. 

  This is discussed in the paper `TatinsLoadAndUpdateStrategy.html`


Let's load the `MarkAPL` package into the workspace; for that we need to specify a URL and optionally target namespace:

```
      ]tatin.LoadPackage [tatin]MarkAPL
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

Here we did not specify a target namespace, so the package was loaded into `#`. In case the target namespace is something like `#.MyTests` then it may or may not exist. If it does not, Tatin will create it.

I> If the package or any of its dependencies depend on assets the path to a directory in the temp directory of your OS is printed to the session by `]tatin.LoadPackage`.
I>
I> This is because this folder cannot be deleted by Tatin. If none of the loaded packages has any assets then nothing is printed to the session, indicating that no footprint is left behind.


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


### Misc

#### Scanning Registries

The fact that Tatin scans Registries in order to find a package can be put to good use when developing packages:
you can run your own Tatin server on, say, your own machine, and give it the highest priority. You can then publish new versions of a package on that server first. That way Tatin would find the package on your local machine.
 
Later, when the package is ready, you could publish it to, say the principal Tatin server on `https://tatin.dev`, and delete it from your local Registry.

The fact that Registries with a priority of `0` are not scanned by Tatin allows you to include a Registry like `https://test.tatin.dev` in your user settings. You don't really want that Registry to participate in a scan, but that way you can still execute commands like `]tatin.ListPackages` etc. on it.



#### Tatin Variables

For every package Tatin will establish certain variables, though strictly speaking they are not variables but niladic functions, the best way to simulate a constant in APL.

They are injected into a namespace `TatinVars` which in turn is injected into `code`.

Some of them always exist, some of them only under certain circumstances. This is a list:


##### `CONFIG`

This is a simple character vector that stems from the file `apl-package.json` of the given package.


##### `DEPENDENCIES`

A vector of character vectors with the package IDs of the packages the package in question depends on.


##### `HOME`

Is either an empty vector or a character vector holding the path of a folder that hosts the package.


##### `ID`

The full package name. This will include a build ID if there is any.


##### `LX`

This might or might not exist. If it does exist then it means that the package config file defined a function name as `lx`, and that this function was executed successfully. `LX` holds the result that is returned by that function if it did return a result. Otherwise it becomes an empty vector.

Note that if there is no `lx` defined in a package config file, or if it is empty, or the function crashed (that will be trapped and ignored by Tatin) then there is no `LX`.


##### `URI`

Character vector that holds the address of a Tatin server or the full name of a ZIP file.