[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin: Package Configuration'
[parm]:toc               = 2 3 4
[parm]:numberHeaders     = 2 3 4 5 6


# Tatin's Package Configuration File

## Overview 

Every package has a configuration file: that's one of the things that make it a package. It defines all that is required to consume the package and to announce its existence to the world.

This is an example:

```
{
  api: "DotNetZip",
  assets: "",
  description: "Zipping and unzipping with.NET Core on all major platforms",
  documentation: "",
  exclude: "",
  files: "",
  group: "aplteam",
  io: 1,
  license: "MIT",
  lx: "",
  maintainer: "kai@aplteam.com",
  minimumAplVersion: "18.2",
  ml: 1,
  name: "DotNetZip",
  os_lin: 1,
  os_mac: 1,
  os_win: 1,
  project_url: "https://github.com/aplteam/DotNetZip",
  source: "DotNetZip.aplc",
  tags: "zip-tools",
  tatin_version: "0.103.0",
  userCommandScript: "",
  version: "0.5.4",
}
```

This is saved in a file `apl-package.json` which must live in the root of what is a package.

Notes:

* You might see `wx` in an older package: with version 0.61.0 `wx` was removed from package config files.
* When viewing a package config file on a Tatin Server you will also see `date`: this is injected by the Tatin server: it is the package's publishing date.

## Details

### Introduction

In the workspace, a simple namespace can be used for package configuration. On file, it is saved as JSON5. Tatin's API offers a function `Tatin.InitialisePackage` that can be used to create a package config file.

It can be fed with an empty vector as the right argument: then just defaults are established.

Instead, you may create a namespace and populate that namespace with Tatin package configuration variables which are discussed underneath. In this case, the values in the namespace overwrite the defaults.

Example:

```
      parms←⎕NS''
      parms.group←'aplteam'
      parms.name←'Foo'
      parms.version←'1.0.0'
      Tatin.InitialisePackage parms 
```

The user command equivalent is `]tatin.PackageConfig`

I> Instead of `]tatin.PackageConfig -edit` you may also enter `]tatin.CreatePackage`


### User-defined variables

You may define your own variables in a package configuration file.

However, since more Tatin-specific variables might be added at a later stage there is a danger of name clashes. This is avoided by a simple rule:

I> The names of user-defined variables _must_ start with an underscore

If you specify any variable with a name that Tatin does not know about and that does not start with an underscore an error will be thrown.


### Tatin's package configuration variables

#### api

"api", if not empty,  must be the name of the namespace that will contains the public interface of what's in the package. "API" is a good name for this.

`api` is used by the Tatin API function `CreateAPIfromCFG`. This function would create functions in the `api` namespace that act as the public interface, returning references to functions, operators, interfaces, classes, namespaces and variables.

See the "Syntax Reference" document for details.


#### assets

If this is empty then the package has no assets. Instead it can point to a folder hosting assets. 

The folder must be relative to the package since the folder is part of the package. For that reason, a folder may not contain a "`:`", and not start with "`/`". If it does anyway an error is thrown.

There is one exception: when an absolute path is specified but it's partly identical to what will become `HOME` (the folder where the package lives) then Tatin removes that part silently, making it effectively relative. 

Notes:

* When the package configuration file is written to disk, the existence of "assets" is checked. If it's not a folder an error is thrown.

  See also the [`GetFullPath2AssetsFolder`](#GetFullPath2AssetsFolder) function.

* The `assets\` folder must be considered read-only. Do not write to it from a package!

* Check the "[files](#)" property for files like "ReadMe.txt" and the like.

* A file named "LICENSE" in the root of a project will always be copied to the root of a package by convention when a package is build.

A> ### Accessing assets from a class instance
A>
A> In case you need to access assets from an instance of a class in a package you have two choices:
A>
A> 1. Add to the class a function like this:
A> 
A>    ```
A>    r←GetAssetFolder
A>    r←##.TatinVars.GetFullPath2AssetsFolder
A>    ```
A> 
A> 2. Use the expression `⊃⊃⎕CLASS ⎕THIS` to find out where the class script lives.
A> 
A>    Therefore the following expression returns the path to the assets:
A> 
A>    ```
A>    (⊃⊃⎕CLASS ⎕THIS).##.TatinVars.GetFullPath2AssetsFolder
A>    ```

A> ### Platform dependent assets
A> 
A> There is no general solution for the problem of platform-dependent assets. One way to solve this is to use [`lx`](#) for this, see there.

#### deprecated

A Boolean that is optional. 

It is injected into a package config file by the `]Tatin.DeprecatePackage` command. A 1 means that this package is deprecated.


#### deprecate_comment

An optional character vector.

It is injected into a package config file by the `]Tatin.DeprecatePackage` command.

You are supposed to give a hint why a package became deprecated, for example, "See package XYZ instead".


#### description

A short description of what the package is supposed to do, or what kind of problems it solves. This is supposed to be readable and meaningful to humans.

This information is typically used when a human accesses a Tatin Server with a Browser.

`description` _must not_ be empty.

#### documentation

This can be one of:

* A URL pointing to an online help resource

  It is identified by starting with either "`http://`" or "`https://`".

* A local path pointing to a file (or program) within the package

  In this case, it _must_ be a relative path since you cannot know in advance where your package ends up.

  It must start with "`./`".

* A pointer to a function or a variable inside the package

  It must start with "`⎕THIS.`", and whatever follows must be valid APL name(s). Examples:

  ```
  ⎕THIS.ShowHelp
  ⎕THIS.Admin.ShowHelp
  ```

Content that does not qualify for one of these options will be rejected.

#### exclude

This may or may not exist. If it does exist it must be one of:

* A single file- or directory name 
* A comma-separated list of files and/or directories

All entries must be relative to `source`, and they must exist as a file or a directory, otherwise an error is thrown.

!> ### What is "exclude" good for?
=> 
=> If you want a particular repository to not only be available as a Tatin package but also from GitHub, then there is the problem of how to specify `⎕IO` and `⎕ML`.
=> 
=> Tatin packages allow these values to be defined in the package config file, and that works just fine for packages.
=> 
=> If you want to bring in just the `APLSource/` folder, you have to take care of `⎕IO` and `⎕ML` yourself. The obvious choice is to define two files, `⎕IO.apla` and `⎕ML.apla`, which will be loaded by Link and used to set the two system variables.
=> 
=> But those two files are not required by the package - it would be nice to be able to exclude them from being added to the package when it is built. `exclude` would allow just that:
=> 
=> ```
=> exclude : "⎕IO.apla, ⎕ML.apla",
=> ```
=> 
=> Because these files have non-ANSI characters in their filenames, adding them to a ZIP file on one platform would currently cause problems when unzipping it on different platform, and this problem is unlikely to go away, and there is nothing we can do about this: it's a ZIP problem.
=> 
=> This is just one example when `exclude` can be put to good use.

For better compatability this property is not injected into new packages but accepted as an optional parameter.
This might be changed with version 1.0.0 of Tatin.

#### files

You might want to get one or more specific files into the root of the package although they are not really assets. 

Typical examples are "LICENSE" and "ReadMe.[md\|txt\|html]". Strictly speaking they are not assets because the package will still function perfectly well without them. Also, you want them to go to the root of the project, not into a sub-folder, so that they stand out. 

That can be achieved by adding them to the "files" property. `files` can be one of:

* Absent
* Empty
* A single file
* A comma-separated list of files

Note that if it specifies a sub-folder, `BuildPackage` will copy the folder from that project-specific sub-folder to the root of the package.

See also "[assets](#)".

I> Note that a file `LICENSE` in the root of a project is by convention copied to the root of a package when a package is build.



#### group

The "group" part of the package ID[^id]

A group may be the name of a user, the owner, a company, an application name, a publisher or anything else that makes sense. It's totally up to you and might well depend on who is running the Tatin Server you want to publish to.

You can define a default for `group` in the user settings file. The default will be injected when a new package is created.

#### license

This may be empty, or it may specify a license such as:

```
  license: "MIT",
```

You may not be able to publish a package to a Tatin registry without specifying a license: this depends on the licensing policy of a particular registry. The main Tatin registry <https://tatin.dev> is an example: you *must* specify a license in order to publish a package to it.
Note that you can specify a default license in your user settings:

```
]TATIN.UserSettings -edit
```

At the bottom there are defaults defined for `license` and `source` and possibly other properties. The default will be injected when a new package is created.

Both the user command `]Tatin.ListLicenses` and the API function `⎕SE.Tatin.ListLicenses` can be used to get a list of all licenses tolerated by a Tatin Registry.


#### lx

This is optional: it may or may not exist, and it might be empty if it does exist.

In case it is not empty it must be the name of a niladic or monadic function that resides in the top-level namespace of the package (_not_ in what might be defined as API!) or a shared method of a class.

This function will be executed by either `LoadPackages` or `LoadDependencies` _after_ all dependencies have been loaded and all refs got established (read: at a very late stage).

If the function is monadic it will be fed with the path where the package lives on disk. If the package was brought into the WS by `LoadPackages` and has no assets then the right argument will be empty.

The function must return a result which is assigned to `TatinVars.LX` inside the package namespace. Without an `lx` function there won't be a variable `LX` in `TatinVars`.[^TatinVars]

The `lx` function will be executed under error trapping, and any errors will be silently ignored. If you do not want this then you have two options:

* Make `⎕TRAP` a local variable in the `lx` function and assign `⎕TRAP←0 'S'` to it to make any problem pop up straight away

* Put `:TRAP ⋄ :EndTrap` around the code in the `lx` function and deal with problems yourself, for example in the `:Else` branch.

Note that the existence of a variable `TatinVars.LX` indicates that there was an `lx` function executed successfully, even when `TatinVars.LX` is empty.

If no variable `TatinVars.LX` exists then there was either no `lx` function defined in the package config file or the function did crash.

##### Applications

There are two obvious applications for this:

* For initializing a package right after bringing it into the workspace
* For dealing with platform-dependent assets

#### maintainer

This may be left empty. If set it must be an email address. 

These formats are valid:

```
your name <your.name@your-domain.com>
your.name <your.name@your-domain.com>
your.name@your-domain.com
```

Note that any double quotes will be removed.

If this is empty the server will, when the package is published, check whether there is a group home page. If that's the case, then there is an email address associated with that group, and that email address is then assigned to `maintainer`.

You can define a default for `maintainer` in the user settings file. The default will be injected when a new package is created.

#### minimumAplVersion

A character vector that must contain something like "18.2". 18.2 is the minimum version for any Tatin package, for Tatin itself needs at least version 18.2.

#### ml

An integer that will be assigned to `⎕ML`.

#### name

The "name" part of the package ID[^id]


#### os_lin

A Boolean; a 1 means that the package runs under Linux.

#### os_mac

A Boolean; a 1 means that the package runs under Mac-OS.

#### os_win

A Boolean; a 1 means that the package runs under Windows.

#### project_url

A URL that points to something like GitHub. 

An example is `https://github.com/aplteam/MarkAPL`

It's supposed to point to a place on the Web where the project is hosted that the package was built from.


#### source

This defines the source code file(s) that are going to be part of the package.

Must be either the name of a text file that contains code or a folder that contains a collection of code files. `source` _must not_ be empty.

If it's a single file it might be anything with the extension `.aplc` (a class script), `.apln` (a namespace script), `.aplf` (a function) or `.aplo` (an operator).

The `.dyalog` extension is supported for limited backward compatibility --- Tatin does not guarantee complete compatibility with SALT. The `.dyalog` extension is still used by the user command framework, therefore Tatin must support it: a user command might well be delivered as a Tatin package. Note that outside this context using this extension is not encouraged.

If `source` is a folder, it might contain any number and mixture of the aforementioned files. Any files with other extensions will be ignored.

`source` must be relative to the root of the package.

Not that you may specify a default source in your Tatin user settings.  The default will be injected when a new package is created.


##### Cider and Tatin

If you manage a project with Cider then you might wonder why both have a property `source` in their configuration file. The reason is that the Cider config file describes what's going on in the project while the Tatin package config files describe what is going on in the package that will eventually be consumed by a user.

Picture the following project "Foo" which consists of a single class `Foo`:

```
/Foo/
     APLSource/
               Admin/
               ...
               TestCases/
               ...
               Foo.aplc
     cider.config
     apl-package.json
     README.md
```

In `cider.config` the `source` parameter must be set to `APLSource` because that's where all the code lives. 

In `apl-package.json` however, `source` may be set to `APLSource/Foo.aplc` because you might decide that this is what will end up in the package.

A slightly more complex example with a namespace that hosts several functions:

```
/Goo/
     APLSource/
               Admin/
               ...
               TestCases/
               ...
               Goo/
                  Function1.aplf
                  Function2.aplf
     cider.config
     apl-package.json
     README.md
```

In this case, the `source` in the package could become `APLSource/Goo` because`Admin` and `TestCases` do not have to be part of the package.


#### tags

A simple text vector with a comma-separated list of tags (keywords). These can be helpful to filter packages when searching for a solution to a particular problem.

`tags` must not be empty if you wish to publish a package to a Tatin server because such a package would not be accepted by the server.

Tags should only be related to the problems one can solve with a particular package. There is no need to specify the platform since they have their own properties: `os_lin`, `os_mac`, `os_win`. Those got introduced with version 0.81.0.

There is also no point in adding tags like "dyalog" or "apl" to a package: Tatin is a Dyalog APL package manager...

Note that people in charge of the principal Tatin server will have an eye on the tags, and might silently correct them to keep them consistent and meaningful.

#### tatin_version

The Tatin version number without any build ID the config data was created / changed by.

You should not edit this because it is overwritten before saving the data anyway.

#### userCommandScript

If a package is a user command then this must contain the path to the user command script relative to the projects root. `InstallPackages` uses this to identify a user command script and to move it from the source folder (if any) to the root of the install folder.

This optional property was introduced with version 0.86.0. It might not exist in older versions of a package. If it does not exist then Tatin assumes that the package in question is not a user command.

Note that for a package to be a user command, the package must be constructed in a particular way. This is discussed in the "Publishing Packages" document.


#### version

The "version"[^version] part of the package ID[^id]

Examples of valid version numbers are:

```
1.2.3
1.2.3-beta1
1.2.3-beta1+30164
18.0.0+30165
```

The optional build number, separated by the `+` sign, is ignored by Tatin.

For details see the [Tatin and Semantic Versioning](./SemanticVersioning.html "SemanticVersioning.html") document. 

#### APL System variables: ⎕IO and ⎕ML {#SysVars}

By default the package configuration file carries the values of the two Dyalog parameters (environment variables) `Default_IO` and `Default_ML` for the system variables `⎕IO` and `⎕ML`, or, if these are not defined, `⎕IO←1` and `⎕ML←1` which are the built-in defaults. 

Tatin uses these values for setting the system variables accordingly in any namespace that is created by either the `LoadPackages` or the `LoadDependencies` function _before_ any code is loaded into them. This is important because that makes any sub-namespace created later on inherit those values.

If you are tempted to create files names `⎕IO.apla` and `⎕ML.apla` and leave it to Link to use them in order to set `⎕IO` and `⎕ML`. Although that would work, for packages your are strongly advised to not do this.

See [exclude](# `exclude`) for details.


#### Injected values

##### date

The user must not specify "date", but when a package is published, the server will inject "date" as a timestamp in the format `yyyymmdd.hhmmss`. 

This date might play an important role in determining the precedence of versions. This is because although it's obvious which version is "better" when you look at these two packages:

```
group-name-1.0.0
group-name-1.1.0
```

it is less obvious when you look at these:

```
group-name-1.0.0-alpha
group-name-1.1.0-beta
```

and it cannot be determined at all with these packages:

```
group-name-1.0.0-TryFeature1
group-name-1.1.0-FixFor234
```

Since packages, once published, cannot be altered, it is safe to assume that the publishing date determines the correct order. However, as long as the version consists of just digits and dots, and possibly a build number, `date` does not play a role in determining precedence.


##### url

* When a package is loaded or installed from a Tatin Server, "url" is injected and points back to that server.

* When a package is loaded or installed from a file, "url" is injected and points to that file.

## Misc

### GetFullPath2AssetsFolder

In case [`assets`](#assets) is not empty this function returns a simple char vector that represents the _full path_ to the assets, using something like:

```
  HOME,'/',ASSETS
```

* If `HOME` is empty the function returns just `ASSETS`
* If `ASSETS` is empty the functions returns `''`
* If `HOME` is not empty but does not exist on disk just `ASSETS` is returned




[^id]: A package ID consists of `{group}-{name}-{major}.{minor}.{patch}`

[^version]: A version is built from the major number, the minor number and the version number, optionally followed by a build number

[^TatinVars]: The Tatin package variables are discussed in detail in the document `FirstStepsWithTatin.html`


















