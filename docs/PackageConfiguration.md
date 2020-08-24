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

### alias

By default a package is established in the target space under its own name. However, for ease of use but also in order to avoid possible name clashes, an alias can be defined. If not empty the package must be addressed by the alias rather than its own name.

## api

Defines the API of the package. In the example the package consists of a single class named `DotNetZip`, therefore the class name is identical with the API. Similarly, if the package consists of a single function --- not that this is recommended! --- the name of the function is the API. And finally with a single class the interface is just the name of the class.

Things are different with namespaces, and with collections of namespaces and/or classes: In that case the names of some of the functions (for namespaces) or some of the classes might become the API.

### date

The date of the package. This is not the publishing date.

### description

A short description of what the package is supposed to do, or what kind of problems it solves. This is supposed to be readable by and meaningful to humans.

### files

...

### group

The group part of the package ID[^id]

### name

The name part of the package ID[^id]

### project_url

The URL that points to something like GitHub. An example is `http://github.com/aplteam-MarkAPL-9.2.0`.

### source

The name of a text file (that contains code) or a folder (that contains a collection of code files).

### tags

A simple text vector, possibly empty (though that is not recommended), that should contain semicolon-separated lists of tag words. These can be helpful to filter packages when searching for a solution to a particular problem.

### version

The version[^version] part of the package ID[^id]

[^id]: A package ID consists of `{group}-{name}-{major.{minor}.{patch}`
[^version]: A version is built from the major number, the minor number and the version number, and possibly a build number (which is not recorded in the package configuration file). 

  Examples for valid version numbers are `1.2.3` and `18.0.0.30165`