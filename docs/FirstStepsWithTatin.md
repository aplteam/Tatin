[parm]:title             = 'Tatin: first steps'
[parm]:leanpubExtensions = 1
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3 4
[parm]:numberHeaders     = 2 3 4 5 6


# First steps with the Tatin Client

Before you start reading this document you should have read the document [Introduction.html](./Introduction.html).

I> Note that you should know what [Semantic Versioning](./SemanticVersioning.html) is all about.

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

The square brackets around "tatin" declare that string to be an alias. Without the square brackets Tatin would assume the argument to be either a local path or a URL like `https://localhost/my_tatin_server`

If you omit the argument Tatin will present a list with all known Registries to you.

A> ### Local and remote Registries
A>
A> The Tatin client can access packages that are managed by a Tatin Server, but also Registries that are locally available (read: not managed by a server). 
A> In order to address a local Registry you would just provide the path to it.
A>
A> Of course features like listing just the packages that carry a specific tag are only available when a Registry is managed by a Tatin server.

### Searching by tag(s)

`]tatin.ListPackages` will return a list with _all_ packages available in the given Registry, aggregated by major version number. Now that can be a pretty long list. It might therefore be a good idea to tell something about what you are looking for in order to make the server shrink the list.

* If you happen to know the group name you may specify `-group=whatever`: then only packages of the group "whatever" are listed
* Every package is tagged with keywords

  You may specify one or more tags, for example `-tag=linux,date`

A> ### Searching for tags: the strategy
A>
A> 1. First Tatin tries to find 100%-matches
A> 1. In case there is no match, Tatin tries to find it _somewhere_ (`⍷`)
A> 1. In case there is still no match a fuzzy search is performed
A> 
A> The fuzzy search would find "windows" when you enter "winndows" and "linux" when you enter "linuks". It has limits, but in practice it works quite well unless the tags are very short: typing "AY" when you meant "AI" would not work.
A>
A> Notes:
A> * The strategy outlined above is applied on each tag independently.
A> * Searching for multiple tags would mean that only packages that have a hit for _all of them_ would qualify.
A> * Searching for tags is an action that is carried out by a Tatin Server. That means that specifying `-tags=` makes sense only in HTTP requests: only then is there a server on the other side that can process the request.
A> * This feature's sole purpose is to overcome typos; it should not be used deliberately --- as a shortcut for example --- since the result may be incorrect.

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

Note that because packages which share the same group and name but have different major version numbers are considered different packages, the tally of the major version numbers is part of the list.

I> If you wonder why that is, then please read the document discussing [Semantic Versioning](./SemanticVersioning.html).


## Consuming packages

### Installing packages

Imagine you want to use the MarkAPL package in an application you are currently working on which we will call a project. Let's also assume that this project is named "Foo" and lives in `/Foo/`.

The first step is to install the package as part of the project "Foo":

```
      ]tatin.InstallPackages [tatin]MarkAPL /Foo/packages
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

You will probably see different version numbers here.

* The folder `aplteam-MarkAPL-11.0.1` contains the MarkAPL package
* The file `apl-dependencies.txt` contains just one line: `aplteam-MarkAPL-11.0.1`

  That's because your project "Foo" depends so far on just one package, MarkAPL

* The file `apl-buildlist.json` carries the build list


#### The build list

The build list will be used to get all required packages into the workspace. This is how the build list looks like so far:

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
* The URL points to where the packages was loaded from

#### How does a package look like on disk?

To answer this question we need to look into the directory `/Foo/packages/aplteam-MarkAPL-11.0.1`:

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
  documentation: "",
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
}
```

Note that `MarkAPL` is a class. If you would leave `api` empty then when `MarkAPL` is loaded into `#` you would need to call the `Version` function with:

```
#.MarkAPL.MarkAPL.Version
```

By defining `MarkAPL` as the api this suffices:

```
#.MarkAPL.Version
```

The `api` parameter is discussed in detail in the "PackageConfiguration" document.

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

A> ### Regarding Assets
A>
A> Note that assets are to be consumed, meaning that a package _**must not**_ write to the assets folder.
A>
A> Among several reasons for this one stands out: in cases a package is loaded and caching is on (the default) then the assets folder is shared by all projects/people who also loaded that package.

#### Tatin and Cider

If the project manager [Cider](https://github.com/aplteam/cider) is installed you may take advantage of it:

If you are going to install packages into a project managed by Cider then you may specify a Cider alias in order to identify the first part of the install path.

* If the selected Cider project has only one Tatin folder defined in its config file then that one is taken.

* If there are multiple Tatin folders defined the user is questioned which one she wants to install into.

It is also possible to specify the package folder explicitly:

```
]Tatin.InstallPackages [tatin]<pkg-name> [<cider-alias/]/my-path
```

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

But how does MarkAPL find its assets? Well, Tatin injects a namespace `TatinVars` into `#._tatin.aplteam_MarkAPL_11_0_1.code`, and that namespace carries several variables, among them these:

* `HOME` carries the path to the directory where the package was loaded from
* `ASSETS` holds the path to the assets relative to `HOME`.

  If there are not assets then `ASSETS` is an empty vector.

I> Note that there is also a function [`GetFullPath2AssetsFolder`](#GetFullPath2AssetsFolder) available in `TatinVars`.

```
      #._tatin.aplteam_MarkAPL_11_0_1.code.TatinVars.HOME
/Foo/packages/aplteam-APLTreeUtils2-1.1.1
```

That means that any MarkAPL function can refer to `HOME` with `##.TatinVars.HOME`.

`TatinVars` holds more potentially important data; details are discussed at [Tatin Variables](#).

What else lives in `#._tatin`?


```
      #._tatin.⎕nl 9
aplteam_APLTreeUtils2_1_1_1
aplteam_FilesAndDirs_5_0_1 
aplteam_MarkAPL_11_0_1     
aplteam_OS_3_0_1           
```

All packages, whether principal ones or dependencies, are stored in `#._tatin`. For the principal packages a reference is injected into the target namespace., in our case `#.Foo`.

Note that by naming convention packages are always loaded into either `#._tatin` or `⎕SE._tatin`.

### Installing several packages at once

Note that `InstallPackages` accepts several package IDs, separated by commas:

```
      ]tatin.InstallPackages Tester2,MarkAPL,Laguntza /Foo/packages
```

This will load three packages and all their dependencies at once. You might find this significantly faster than installing them one-by-one.

### Checking out a package: `LoadPackages`

Let's assume that before actually installing it you first  want to check whether the package `MarkAPL` suits your needs. In this case you might not want to install it (yet) but just to load it into the workspace. 

That can be achieved with the `LoadPackages` user command. It loads the package into the workspace.


Notes:

* Loading a package in this way has one major purpose: to investigate it.

* Loading a package might well be different from installing a package: when loading a package the precise versions of dependency packages will be loaded, but when a package is installed that is not necessarily the case. 

  This is discussed in the paper `TatinsLoadAndUpdateStrategy.html`


Let's load the `MarkAPL` package into the workspace; for that we need to specify a URL and optionally a target namespace:

```
      ]tatin.LoadPackages [tatin]MarkAPL
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

Tatin has created a reference named `MarkAPL` in the target namespace `#`:

```
      #.⎕nl ⍳16
MarkAPL
_tatin 
```

That reference points to the namespace that holds the package as such, which is loaded into `_tatin`: this is the namespace Tatin uses to manage all packages.

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

`MarkAPL` is the package we asked for. It depends on two packages, `APLTreeUtils2` and `FilesAndDirs`. For these two packages references are injected. `FilesAndDirs` depends on `OS` but because that is not required by `MarkAPL` no reference to it is injected into MarkAPL's `code`, instead you would find such a reference in `#._tatin.aplteam_FilesAndDirs_5_0_1.code`.

Note that you may load multiple packages with a single call; if you do then separate them with commas.

### Misc

#### Scanning Registries

The fact that Tatin scans Registries in order to find a package can be put to good use when developing packages:
you can run your own Tatin server on, say, your own machine, and give it the highest priority. You can then publish new versions of a package on that server first. 

That way Tatin would find the package on your local machine even when they are not loaded as principal packages but just as dependencies.
 
Later, when the package is ready, you could publish it to, say, the principal Tatin server on `https://tatin.dev`, and --- don't forget that step! --- delete it from your local Registry.


A> ### Having the same package in more than one Registry
A>
A> In case you juggle with the same package in several Registries you might well be interested in getting a full list.
A> The `]ListPackages` user command has a syntax for this:
A>
A> ```
A>       ]ListVersions [*]example-versions 
A> ```
A>
A> This would check all known Registries with a priority greater than 0 for `example-versions`, and list all hits.

The fact that Registries with a priority of `0` are not scanned by Tatin allows you to include a Registry like `https://test.tatin.dev` in your user settings. You don't really want that Registry to participate in a scan, but that way you can still execute commands like `]tatin.ListPackages` etc. on it.

A> ### Scanning for dependencies
A>
A> Note that Tatin does not only scans all known Registries with a priority greater than zero for principal packages, it also scans all those Registries for dependencies as well. 


#### Deprecated packages

Every piece of software will become obsolete one day. Packages are no exception. If a package is not needed anymore, or is obsolete because there is a better one available, it's time to mark it as deprecated.

This can be done with the user command `]Tatin.DeprecatePackage`. In short what the user command does is to publish the latest version available yet as a new version with an increased minor version number.

A> ### On deleting packages
A>
A> Depending on the delete policy operated on a server you might as well delete all obsolete packages, but we discourage you from doing so.
A>
A> The reason is that one of Tatin's design goals was to make a build 100% reproducible. This is only achievable if packages are not deleted from a server. That's the reason why the principal Tatin Registry operates a non-delete policy.

For example, let's assume these three packages are published:


```
aplteam-Foo-1.0.0
aplteam-Foo-1.1.0
aplteam-Foo-1.1.1
```

Executing:

```
]Tatin.DeprecatePackage https://your-Registry/aplteam-Foo-1
```

will make the Tatin Registry publish a new version `aplteam-Foo-1.2.0` on your behalf which is almost identical with version 1.1.1 except that it has two additional properties in its config file: `deprecated` with the value 1 and `comment` which carries the comment in case you've specified one with `-comment=`; this should be used to explain why a package got marked as deprecated, so it will be something along the lines of "See package Foo-Boo".

From now on both the "Packages" web page and `]Tatin.ListPackages` won't list these four packages anymore.

Note that `]Tatin.ListDeprecated` is designed to list just the deprecated packages. If you want the list to include also the earlier versions --- which are now sort of hidden by 1.2.0 --- then you need to specify the `-all` flag. 

With `-all` a matrix with two columns rather than one is returned, with the second column carrying an asterisk for those packages that actually  do carry `deprecated←1` in their config file. That would be at least the very last one.

##### Side effects of deprecating a package

If you try to load or install a package that is marked as deprecated then you will be asked whether you really want that, but if you insist then you will get what you asked for.

Note however that this is only true when you ask explicitly for the last package (the one with `deprecated←1`) and when you specify just the major version number.

In our earlier example that would be either

```
]Tatin.LoadPackages https://your-registry/aplteam-Foo-1
```

or

```
]Tatin.LoadPackages https://your-registry/aplteam-Foo
```

If you ask _explicitly_ for an _earlier_ version (one that has no property `deprecated` in its config file) then that version would be loaded (or installed) without further ado, because Tatin would just assume that you know what you are doing.

Note that the API functions for loading / installing packages would not complain or warn you at all. 

A> ### Mistakenly deprecated a package?
A>
A> There is an easy escape route: just publish the package again with an increased minor version number but `deprecated` either set to 0 or removed from the config file, and the package is back on track. 
A>
A> If `comment` was not empty then that should be removed or emptied.
A> 
A> Once you've done that the very latest published package would no longer carry a "deprecated" flag with the value 1, and therefore it would no longer fulfill the criteria of a deprecated package.


#### Tatin Variables

For every package Tatin will establish a couple of constants. Because APL has no concept of constants, they are emulated via niladic functions.

They are injected into a namespace `TatinVars` which in turn is injected into the `code` namespace.

Some of them always exist, some of them only under certain circumstances.


##### ASSETS

The path to the package's assets relative to `HOME`. Is empty in case there are no assets.

See also the [GetFullPath2AssetsFolder](#GetFullPath2AssetsFolder) function.


##### CONFIG

This is a simple character vector that stems from the file `apl-package.json` of the given package.


##### DEPENDENCIES

A vector of character vectors with the package IDs of the packages the package in question depends on.


##### GetFullPath2AssetsFolder

This is a function which returns the result of the expression `HOME,'/',ASSETS` if both `HOME` and `ASSETS` are not empty _and_ `HOME` exists on disk. If `HOME` is empty or does not exist on disk then just `ASSETS` is returned. 

When accessing assets you are advised to always use the `GetFullPath2AssetsFolder` function. Why? Imagine the following scenario as an example: you've loaded packages into a clear workspace, set `⎕WSID` and then saved that WS. Later you make sure that the assets folder of the package becomes a sibling of the workspace. You might than move the WS with the assets folder elsewhere, even on a different machine. The expression `HOME,'/',ASSETS` would then fail.

The function would not find `HOME` and there return just `ASSETS`, and that allows you to still access the assets sucessfully.


##### HOME

Is a character vector holding the path of a folder that hosts the package. 

There is an exception: when the package was brought into the workspace with `LoadPackages` rather than `LoadDependencies` that has no assets. This is because without assets `LoadPackages` loads the package into a temp folder, brings the package into the WS and then deletes the temp folder, because without assets there is no need to leave a footprint behind.

In this case `HOME` is set to `''`.


##### ID

The full package name. This will include a build ID if there is any, so it is not necessarily identical with the package ID.


##### LX

This might or might not exist. If it does exist then it means that the package config file defined a function name as `lx`, and that this function was executed successfully. `LX` holds the result that is returned by that function if it did return a result. If it doesn't `LX` is an empty vector.

Note that if there is no `lx` defined in a package config file, or if it is empty, or the function crashed (that will be trapped and ignored by Tatin) then there is no `LX`.


##### URI

Character vector that holds the address of a Tatin server or the full name of a ZIP file.
