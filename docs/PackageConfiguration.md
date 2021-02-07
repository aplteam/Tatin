[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin's Package Configuration'


# Tatin's package Configuration File

## Overview 

Every package has a configuration file: that's one of the things that actually make it a package. It defines all there needs to be defined in order to consume the package, and to announce its existence to the world.

This is an example:

```
{
  alias: "",
  api: "DotNetZip",
  date: "2020-05-16",
  description: "Zipping and unzipping with.NET Core on all major platforms",
  files: "",
  group: "aplteam",
  name: "DotNetZip",
  project_url: "https://github.com/aplteam/DotNetZip",
  source: "DotNetZip.aplc",
  tags: "zip-tools;windows;mac-os;linux",
  version: "0.5.4",
}
```
## Details

### Introduction

In the workspace a simple namespace can be a used for package configuration. On file it is saved as JSON5.

Tatin's API offers a function `Tatin.InitialisePackage` that can be used to create a package config file.

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

The user command aquivalent is `]tatin.packageconfig`


### User defined variables

You may define your own variables in a package configuration file.

However, since we might add Tatin-specific variables at a later stage there is a danger of name clashes. This is avoided by a simple rule:

The names of user defined variables _must_ start with an underscore.

If you specify any variable with a name that Tatin does not know about and that does not start with an underscore an error will be thrown.


### Tatin's package configuration variables

#### alias

By default a package is established in the target space under its own name. However, for ease of use but also in order to avoid possible name clashes, an alias can be defined. If not empty the package must be addressed by the alias rather than its own name.

#### api

There are two different scenarios:

* The package consists of a single function or a single operator or a single class or a single namespace, be it scripted or not

* The package consists of several functions, operators, classes or namespaces

In the former case what is the api of the package is obvious, and there is no need to even specify it: Tatin will recognize that the name of that single function or single operator or single class or single namespace must be the API of the package, and act accordingly.

If it's a single function (not that this is recommended!) and the name of the package is `Foo`, then calling the function is identical with the package name.

In the latter case it is not obvious at all what the API should be, and the user must specify it.

Also, while a single namespace is by default the API, the user might want to expose only a subset of functions/operators from that namespace, and in that case the user must specify "api" as well.

Namespaces are special: imagine a situation when you have a single namespace that contains, say, a hundred functions of which only one should be exposed. If that function is called `Run` then of course the api needs to become `api←'Run'`.

If the name of the package is `Foo` and it is loaded into `#.MyPkgs` then calling the function requires:

```
#.MyPkgs.Foo.Run
```

If you want to expose two functions, `CreateParameterSpace` and `Run`, then the api needs to be specified as:

```
api←`CreateParameterSpace,Run`
```

Calling the two functions would look similar to this:

```
parms←#.MyPkgs.Foo.CreateParameterSpace ⍬
#.MyPkgs.Foo.Run parms
```

Notes: 

* If specified "api" must be either a single name or a list of comma-separated names. Names must be relative, never absolute, therefore they must never start with `#` or `⎕`.

* Niladic functions _cannot_ become part of an API. Tatin will create references in the target namespace, and onme cannot create a reference for a niladic function.

#### assets

This must be a simple text vector that is one of:

* A single filename
* A single folder name
* A simple text vector representing a mixture of file names and folder names separated by `,`.

The path must be relative to the package since the file(s) or folder(s) are part of the package. For that reason the path may not contain a "`:`" under Windows, and not start with "`/`" or with "`./`". If it does anyway an error is thrown.

There is one exception: when an absolute path is specified but it's partly identical with the source path of the package then Tatin removes the source part and makes the path(s) silently relative. 

Note that when the package configuration file is written to disk the existence of the specified assets is checked. If any of them do not exist an error is thrown.

#### date

The date of the package. This is not necessarily the publishing date.

#### description

A short description of what the package is supposed to do, or what kind of problems it solves. This is supposed to be readable by and meaningful to humans.

This information is typically used when a human accesses a Tatin Server with a Browser.

#### group

The group part of the package ID[^id]

#### name

The name part of the package ID[^id]

#### project_url

The URL that points to something like GitHub. An example is `http://github.com/aplteam-MarkAPL-9.2.0`.

#### source

The name of a text file (that contains code) or a folder (that contains a collection of code files).

If it's a single file it might be anything with the extension `.aplf` (a function), `.aplo` (an operator), `.aplc` (a class script), `.apln` (a namespace script) or `.apli` (an interface script).

If it's a folder it might contain any number and mixture of the aforementioned files. Any files with other extension are misplaced and will be ignored entirely.

If `source` is left empty Tatin will attempt to identify the source itself.

* If there is a single script file found with one of the aforementioned extensions that file will become the source.

* If there is no file with such an extension, all folders are investigated except those mentioned as "assets". If there is just one folder left that carries one or more files with the aforementioned extensions then that folder will become the source.

* If Tatin cannot establish the source an error will be thrown, and the user _must_ specify "source".

#### tags

A simple text vector, possibly empty (though that is not recommended), that should contain a comma-separated list of tag words. These can be helpful to filter packages when searching for a solution to a particular problem.

#### version

The version[^version] part of the package ID[^id]

Examples for valid version numbers are `1.2.3`, `1.2.3-beta1`, `1.2.3-beta1.30164` and `18.0.0.30165`

An optional build number is ignored by Tatin.

For details see the [Tatin and Semantic Versioning](./SemanticVersioning.html "SemanticVersioning.html") document. 

### Access after loading a package

Whether you load a package with `LoadPackage` or `LoadDependencies`, the contents of the configuration file is available as readable JSON under the name `∆CONFIG` together with `∆URI` and `∆HOME`.

Note that `∆HOME` will be empty in case two conditions are met:

* The package was brought intot the workspace with `LoadPackage` (as opposed to `LoadDependencies`)
* The package does not have any assets

All of them are niladic functions because that's how we emulate constants in APL.

[^id]: A package ID consists of `{group}-{name}-{major.{minor}.{patch}`
[^version]: A version is built from the major number, the minor number and the version number, 