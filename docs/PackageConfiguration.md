[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin's Package Configuration'
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3


# Tatin's package Configuration File

## Overview 

Every package has a configuration file: that's one of the things that make it a package. It defines all that is required in order to consume the package, and to announce its existence to the world.

This is an example:

```
{
  api: "DotNetZip",
  description: "Zipping and unzipping with.NET Core on all major platforms",
  files: "",
  group: "aplteam",
  name: "DotNetZip",
  info_url: "https://github.com/aplteam/DotNetZip",
  source: "DotNetZip.aplc",
  tags: "zip-tools;windows;mac-os;linux",
  version: "0.5.4",
  io: 1,
  ml: 1,
  wx: 1,
}
```

This is saved in a file `apl-package.json` which must live in the root of what is a package.

## Details

### Introduction

In the workspace a simple namespace can be a used for package configuration. On file it is saved as JSON5. Tatin's API offers a function `Tatin.InitialisePackage` that can be used to create a package config file.

It can be fed with an empty vector as right argument: then just defaults are established.

Instead you may create a namespace and populate that namespace with Tatin package configuration variables which are discussed underneath.

Example:

```
      parms←⎕NS''
      parms.group←'aplteam'
      parms.name←'Foo'
      parms.version←'1.0.0'
      Tatin.InitialisePackage parms 
```

The user command equivalent is `]tatin.PackageConfig`


### User defined variables

You may define your own variables in a package configuration file.

However, since more Tatin-specific variables might be added at a later stage there is a danger of name clashes. This is avoided by a simple rule:

| **The names of user defined variables _must_ start with an underscore** |

If you specify any variable with a name that Tatin does not know about and that does not start with an underscore an error will be thrown.


### Tatin's package configuration variables

#### api

"api", when not empty,  must be a single name or a single class _but neither a function nor an operator_. It must be relative, never absolute; therefore it must never start with `#` or `⎕`.

There are several scenarios:

1. The package consists of a single class or a single namespace, be it scripted or not.

1. The package consists of a single function or operator.

1. The package consists of several objects: a mixture of functions, operators, classes and / or namespaces. All objects are public.

I> Note that you _must not_ specify the name of a function or an operator as the API in any of these cases.
I> 
I> This restriction helps to avoid confusion, but there is also a technical issue: Tatin needs to establish references to the API, and although in Dyalog one can establish references (kind of) to monadic, ambivalent and dyadic functions, this is not possible for niladic functions and operators.


##### Package consists of a single namespace

* If you don't specify `api` then the name of the namespace is the API. 

* If you do specify `api` then it must be the name of the namespace. In that case the _contents_ of the namespace becomes the API.


##### Package consists of a single class

* If you don't specify `api` then the name of the class is the API. 

* If you do specify `api` then it must be the name of the class. In that case everything in the class with `:Access Public Shared` becomes the API.


##### Single function or operator

If the name of the package is `Foo`, and the name of the function is `MyFns`, then it is called as `Foo.MyFns`. The function may be niladic, monadic, ambivalent or dyadic.

The same holds true for an operator.

In this particular case `api` _must not_ be defined (remain empty).


##### Mixture of several APL objects

* If `api` is not set then all top-level objects of the package become the API: functions, operators, namespaces, classes , interfaces.
* If `api` is set then it must point to one of the namespaces or classes, or a sub-namespace (using dotted syntax), or a class in a sub-namespace. Then just the objects in what `api` is pointing to become the API.


##### Restricting what's "public"

The user might want to expose only a subset of functions/operators of a namespace (classes have a public interface anyway), and in that case the user must not only specify `api`, but also structure her code accordingly.

If the name of the package is `Foo`, and it is loaded into `#`, and you want to expose only the functions `Run` and `CreateParmSpace`, then the recommended way of doing this is to create a sub-namespace with the name (say) `MyAPI` and populate it with two functions:

* `Run`:

  ```
  Run←{⍺←⊢ ⋄ ⍺ ##.Run ⍵}
  ```

* `CreateParmSpace`:

  ```
  CreateParmSpace←{##.CreateParmSpace ⍵}
  ```

Finally you need to specify `api: "MyAPI"` in the package config file.

Calling the function `Run` (after loading the package) would then require:

```
      #.Foo.Run
```

To the outside world only two functions are visible:

```
      #.Foo.⎕nl ⍳16
#.Foo.Run
#.Foo.CreateParmSpace
```

Similarly, if your package `Foo` consist of the two namespaces `Boo` and `Goo`, and `Run` and `CreateParmSpace` live in `Boo`, then you could also have a sub-namespace `Boo.API` that hosts `Run` and `CreateParmSpace`, and `api` would be `Boo.API`, while calls are still `Foo.Run` and `Foo.CreateParmSpace`.


#### assets

If not empty (no assets) it points to a folder holding the assets. The path must be relative to the package since the folder is part of the package. For that reason the path may not contain a "`:`" under Windows, and not start with "`/`". If it does anyway an error is thrown.

There is one exception: when an absolute path is specified but it's partly identical with what will become `HOME` (the folder where the package lives) then Tatin removes that  part silently, making the path effectively relative. 

Note that when the package configuration file is written to disk the existence of the assets folder is checked. If it does not exist an error is thrown.

See also the [`GetFullPath2AssetsFolder`](#GetFullPath2AssetsFolder) function.

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
A> 2. Use the expression `⊃⊃⎕CLASS ⎕THIS` in order to find out where the class script actually lives.
A> 
A>    Therefore the following expression returns the path to the assets:
A> 
A>    ```
A>    (⊃⊃⎕CLASS ⎕THIS).##.TatinVars.GetFullPath2AssetsFolder
A>    ```


#### description

A short description of what the package is supposed to do, or what kind of problems it solves. This is supposed to be readable by and meaningful to humans.

This information is typically used when a human accesses a Tatin Server with a Browser.

`description` _must not_ be empty.

#### GetFullPath2AssetsFolder

In case [`assets`](#assets) is not empty this function returns a simple char vector that represents the _full path_ to the assets, using something like:

```
  HOME,'/',ASSETS
```

If `assets` is empty the functins returns `''`.

#### group

The group part of the package ID[^id]

A group may be the name of a user, the owner, a company, an application name, a publisher or anything else that makes sense. It's totally up to you and might well depend on who is running the Tatin Server you want to publish to.

#### lx

This is optional: it may or may not exist, and it might be empty if it does.

In case it is not empty it must be the name of a niladic or monadic function that resides in the top-level namespace of the package (_not_ in what might be defined as API!) or a shared method of a class.

This function will be executed by either `LoadPackage` or `LoadDependencies` _after_ all dependencies have been loaded and all refs got established.

If the function is monadic it will be fed with the path where the package lives on disk. If the package was brought into the WS by `LoadPackage` and has no assets then the right argument will be empty.

The function may or may not return a result. A result is assigned to the Tatin package variable `LX`. If there is no result `LX` becomes an empty vector. Without an `lx` function there won't be a variable `LX`.[^TatinVars]

The `lx` function will be executed under error trapping, and any errors will be silently ignored. If you do not want this then you have two options:

* Make `⎕TRAP` a local variable in the `lx` function and assign `⎕TRAP←0 'S'` to it to make any problem popping up straight away

* Put `:TRAP ⋄ :EndTrap` around the code in the `lx` function and deal with problems yourself

Note that the existence of a variable `LX` indicates that there was an `lx` function successfully executed.

#### name

The name part of the package ID[^id]

#### info_url

A URL that points to something like GitHub. 

An example is `https://github.com/aplteam/MarkAPL`

It's supposed to point to a place on the Web where the project that package was constructed from is managed, or at least to provide information about the project like background, license, author etc.

#### source

This defines the source code file(s) that are going to be part of the package.

Must be either the name of a text file that contains code or a folder that contains a collection of code files. `source` _must not_ be empty.

If it's a single file it might be anything with the extension `.aplc` (a class script), `.apln` (a namespace script), `.apli` (an interface script), `.aplf` (a function) or `.aplo` (an operator).

If it's a folder it might contain any number and mixture of the aforementioned files. Any files with other extensions will be ignored.

`source` must be relative to the root of the package.


#### tags

A simple text vector, possibly empty (though that is not recommended), that should contain a comma-separated list of tags (key words). These can be helpful to filter packages when searching for a solution to a particular problem.

`tags` must not be empty if you wish to publish a package to a Tatin server because such a package would not be accepted by the server.

#### version

The version[^version] part of the package ID[^id]

Examples for valid version numbers are:

```
1.2.3
1.2.3-beta1
1.2.3-beta1+30164
18.0.0+30165
```

The optional build number, separated by the `+` sign, is ignored by Tatin.

For details see the [Tatin and Semantic Versioning](./SemanticVersioning.html "SemanticVersioning.html") document. 

#### APL System variables: ⎕IO, ⎕ML, ⎕WX {#SysVars}

By default the config namespace carries the values of the three Dyalog parameters `default_io`, `default_ml` and `default_wx` for the three system variables `⎕IO`, `⎕ML` and `⎕WX`. 

Tatin uses these values for setting the three system variables accordingly in any namespace that is created by either the `LoadPackage` or the `LoadDependencies` function _before_ any code is loaded into them. This is important because that makes any sub-namespace created later on inherit those values.


#### Injected values

##### date

The user must not specify "date", but when published the server will inject it as a timestamp in the format `yyyymmdd.hhmmss`. 

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

* When a package is loaded or installed from a Tatin Server, "url" is injected, and points back to that server.

* When a package is loaded or installed from a file, "url" is injected, and points to that file.

### Access after loading a package

Whether you load a package with `LoadPackage` or `LoadDependencies`, the contents of the configuration file is available as readable JSON as a character vector under the name `CONFIG` together with `ID`, `URI`, `HOME` and possibly `LX`. All these pieces of information are available in the namespace `TatinVars` which is injected into the `code` namespace.

Note that `HOME` will be empty in case two conditions are met:

* The package was brought into the workspace with `LoadPackage` (as opposed to `LoadDependencies`)
* The package does not have any assets

All of them are niladic functions because that's how we emulate constants in APL.

There _might_ be a variable `LX` in case the package used the [`lx`](#) mechanism for initializing itself.

[^id]: A package ID consists of `{group}-{name}-{major.{minor}.{patch}`

[^version]: A version is built from the major number, the minor number and the version number, optionally followed by a build number

[^TatinVars]: The Tatin package variables are discussed in detail the document `FirstStepsWithTatin.html`