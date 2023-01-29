[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin's Package Configuration'
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3 4
[parm]:numberHeaders     = 2 3 4 5 6


# Tatin's package Configuration File

## Overview 

Every package has a configuration file: that's one of the things that make it a package. It defines all that is required to consume the package and to announce its existence to the world.

This is an example:

```
{
  api: "DotNetZip",
  assets: "",
  description: "Zipping and unzipping with.NET Core on all major platforms",
  documentation: "",
  group: "aplteam",
  project_url: "https://github.com/aplteam/DotNetZip",
  io: 1,
  ml: 1,
  name: "DotNetZip",
  source: "DotNetZip.aplc",
  tags: "zip-tools",
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

| **The names of user-defined variables _must_ start with an underscore** |

If you specify any variable with a name that Tatin does not know about and that does not start with an underscore an error will be thrown.


### Tatin's package configuration variables

#### api

"api", if not empty,  must be a single name or a single class _but neither a function nor an operator_. It must be relative to `source`.

It might use dottet syntax.

There are several scenarios:

1. The package consists of a single class or a single namespace, be it scripted or not.

1. The package consists of a single function or operator.

1. The package consists of several objects: a mixture of functions, operators, classes and/or namespaces. All objects are public.

A> ### Single functions 
A>
A> You _must not_ specify the name of a function (or an operator) as the API in any of these cases.
A> 
A> This restriction helps to avoid confusion, but there is also a technical issue: Tatin needs to establish references to the API, and although in Dyalog one can establish references (kind of) to monadic, ambivalent, and dyadic functions, this is not possible for neither operators nor niladic functions.


##### A single namespace

* If you don't specify `api` then the name of the namespace is the API. 

  For example, if the package name is `pkgName` and the namespace's name is `foo` and it has a function `Hello`, then you call `Hello` with:

  `pkgName.foo.Hello`

* If you do specify `api` by assigning an APL name to it (=no extension), then it must be the name of the namespace. In that case, the _contents_ of the namespace become the API.

  For example, if the package name is `pkgName` and the namespace's name is `foo` and it has a function `Hello`, then you specify `api` as `foo` and call `Hello` with:

  `pkgName.Hello`


##### A single class

* If you don't specify `api` then the name of the class is the API. 

  For example, if the package name is `pkgName` and the class name is `foo` and it has a function `Hello`, then you call `Hello` with:

  `pkgName.foo.Hello`

* If you do specify `api` then it must be the name of the class. In that case, everything in the class with `:Access Public Shared` becomes the API.

  For example, if the package name is `pkgName` and the class name is `foo` and it has a publicly shared function `Hello`, then you call `Hello` with:

  `pkgName.Hello`


##### A single function or operator

If the name of the package is `pkgName`, and the name of the function is `MyFns`, then it is called as `pkgName.MyFns`. The function may be niladic, monadic, ambivalent or dyadic.

The same holds for an operator.

In this particular case `api` _must not_ be defined (remain empty).


##### A mixture of several APL objects

* If `api` is not set then all top-level objects of the package become the API: functions, operators, namespaces, classes, interfaces.

* If `api` is set then it must point to one of the namespaces or classes, or a sub-namespace (using dotted syntax), or a class in a sub-namespace. Then just the objects in what `api` is pointing to become the API.


##### Restricting what's "public"

The user might want to expose only a subset of functions/operators of a namespace (classes have such an interface anyway: `:Public Shared`), and in that case, the user must not only specify `api`, but also structure her code accordingly.

If the name of the package is `pkgName`, and it is loaded into `#`, and you want to expose only the functions `Run` and `CreateParmSpace`, then the recommended way of doing this is to create a sub-namespace with the name (say) `MyAPI` and populate it with two functions:

* `Run`:

  ```
  Run←{⍺←⊢ ⋄ ⍺ ##.Run ⍵}
  ```

  (Assumes that `Run` takes an optional left argument)

* `CreateParmSpace`:

  ```
  CreateParmSpace←{##.CreateParmSpace ⍵}
  ```

  (Assumes that `CreateParmSpace` does not accept a left argument)

Finally, you need to specify `api: "MyAPI"` in the package config file.

Calling the function `Run` (after loading the package) would then require:

```
      #.PkgName.Run
```

To the outside world, only two functions are visible:

```
      #.PkgName.⎕nl ⍳16
#.Foo.Run
#.Foo.CreateParmSpace
```

Similarly, if `PkgName` consists of the two namespaces `Boo` and `Goo`, and `Run` and `CreateParmSpace` live in `Boo`, then you could also have a sub-namespace `Boo.API` that hosts `Run` and `CreateParmSpace`, and `api` would be `Boo.API`, while calls are still `PkgName.Run` and `PkgName.CreateParmSpace`.


#### assets

If this is empty then the package has no assets.

Instead it can point to a single file (typically `LICENSE`) or a folder or several files and folders, separated by a comma.

Any folder must be relative to the package since the folder is part of the package. For that reason, folders may not contain a "`:`" under Windows, and not start with "`/`". If one does anyway an error is thrown.

There is one exception: when an absolute path is specified but it's partly identical to what will become `HOME` (the folder where the package lives) then Tatin removes that part silently, making it effectively relative. 

Notes:

* When the package configuration file is written to disk the existence of any assets is checked. If one does not exist an error is thrown.

  See also the [`GetFullPath2AssetsFolder`](#GetFullPath2AssetsFolder) function.

* The assets\ folder must be considered read-only. Never write to it from a package!

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

#### deprecated

An optional Boolean.

It is injected into a package config file by the `]Tatin.DeprecatePackage` command. A 1 means that this package is deprecated.


#### deprecate_comment

An optional character vector.

It is injected into a package config file by the `]Tatin.DeprecatePackage` command.

Supposed to give a hint why a package is deprecated, for example, "See package XYZ instead".


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


#### GetFullPath2AssetsFolder

In case [`assets`](#assets) is not empty this function returns a simple char vector that represents the _full path_ to the assets, using something like:

```
  HOME,'/',ASSETS
```

* If `HOME` is empty the function returns just `ASSETS`
* If `ASSETS` is empty the functions returns `''`
* If `HOME` is not empty but does not exist on disk just `ASSETS` is returned

#### group

The group part of the package ID[^id]

A group may be the name of a user, the owner, a company, an application name, a publisher or anything else that makes sense. It's totally up to you and might well depend on who is running the Tatin Server you want to publish to.

#### lx

This is optional: it may or may not exist, and it might be empty if it does exist\.

In case it is not empty it must be the name of a niladic or monadic function that resides in the top-level namespace of the package (_not_ in what might be defined as API!) or a shared method of a class.

This function will be executed by either `LoadPackages` or `LoadDependencies` _after_ all dependencies have been loaded and all refs got established.

If the function is monadic it will be fed with the path where the package lives on disk. If the package was brought into the WS by `LoadPackages` and has no assets then the right argument will be empty.

The function may or may not return a result. A result is assigned to the Tatin package variable `LX`. If there is no result `LX` becomes an empty vector. Without an `lx` function there won't be a variable `LX`.[^TatinVars]

The `lx` function will be executed under error trapping, and any errors will be silently ignored. If you do not want this then you have two options:

* Make `⎕TRAP` a local variable in the `lx` function and assign `⎕TRAP←0 'S'` to it to make any problem popping up straight away

* Put `:TRAP ⋄ :EndTrap` around the code in the `lx` function and deal with problems yourself, for example in the `:Else` branch.

Note that the existence of a variable `LX` indicates that there was an `lx` function successfully executed.

#### maintainer

This may be left empty. If set it must be an email address. 

These formats are valid:

```
your name <your.name@your-domain.com>
your.name <your.name@your-domain.com>
your.name@your-domain.com
```

Note that any double quotes will be removed.

If this is empty the server will, when the package is published, check whether there is a group home page. If that's the case then there is an email address associated with that group, and that email address is then assigned to `maintainer`.

#### minimumAplVersion

A character vector that must contain something like "18.0". 18.0 is the minimum version for any Tatin package, for Tatin itself needs at least version 18.0.

#### name

The name part of the package ID[^id]


#### os_win

A Boolean; a 1 means that the package runs under Windows.

#### os_mac

A Boolean; a 1 means that the package runs under Mac-OS.

#### os_lin

A Boolean; a 1 means that the package runs under Linux.


#### project_url

A URL that points to something like GitHub. 

An example is `https://github.com/aplteam/MarkAPL`

It's supposed to point to a place on the Web where the project that the package was built from is hosted.


#### source

This defines the source code file(s) that are going to be part of the package.

Must be either the name of a text file that contains code or a folder that contains a collection of code files. `source` _must not_ be empty.

If it's a single file it might be anything with the extension `.aplc` (a class script), `.apln` (a namespace script), `.aplf` (a function) or `.aplo` (an operator).

The `.dyalog` extension is supported for limited backward compatibility --- Tatin does not guarantee complete compatibility with SALT. The `.dyalog` extension is still used by the user command framework, therefore Tatin must support it: a user command might well be delivered as a Tatin package. Note that outside this context using this extension is not encouraged.

If `source` is a folder it might contain any number and mixture of the aforementioned files. Any files with other extensions will be ignored.

`source` must be relative to the root of the package.

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

In `apl-package.json` however `source` may be set to `APLSource/Foo.aplc` because you might decide that this is what will end up in the package.

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

In this case, the `source` in the package could become `APLSource/Goo` while `Admin` and `TestCases` are most likely not copied over into the package.

Of course, one could rearrange the code and copy `APLSource/Goo/*` from the project into `Goo/` in the package. That would get rid of one level that is not required in the package, and `source` in the package config file could be just `Goo`.


#### tags

A simple text vector, possibly empty (though that is not recommended), that should contain a comma-separated list of tags (keywords). These can be helpful to filter packages when searching for a solution to a particular problem.

`tags` must not be empty if you wish to publish a package to a Tatin server because such a package would not be accepted by the server.

Tags should only be related to the problems one can solve with a particular package. There is no need to specify the platform since they have their own properties: `os_lin`, os_mac`, `os_win`. Those got introduced with version 0.81.0.

There is also no point in adding tags like "dyalog" or "apl" to a package: Tatin is a Dyalog APL package manager...

Note that people in charge of the principal Tatin server will have an eye on the tags, and might silently correct them to keep them consistent and meaningful.


#### userCommandScript

If a package is a user command then this must contain the path to the user command script relative to the projects root. `InstallPackages` uses this to identify a user command script and to move it from the source folder (if any) to the root of the install folder.

This optional flag was introduced with version 0.86.0. It might not exist in older versions of a package. If it does not exist then Tatin assumes that the package in question is not a user command.


#### version

The version[^version] part of the package ID[^id]

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

By default the config namespace carries the values of the two Dyalog parameters `default_io` and `default_ml` for the system variables `⎕IO` and `⎕ML`. 

Tatin uses these values for setting the system variables accordingly in any namespace that is created by either the `LoadPackages` or the `LoadDependencies` function _before_ any code is loaded into them. This is important because that makes any sub-namespace created later on inherit those values.


#### Injected values

##### date

The user must not specify "date", but when a package is published the server will inject "date" as a timestamp in the format `yyyymmdd.hhmmss`. 

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



[^id]: A package ID consists of `{group}-{name}-{major}.{minor}.{patch}`

[^version]: A version is built from the major number, the minor number and the version number, optionally followed by a build number

[^TatinVars]: The Tatin package variables are discussed in detail in the document `FirstStepsWithTatin.html`
