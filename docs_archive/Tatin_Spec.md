[parm]:leanpubExtensions = 1
[parm]:numberHeaders     = 6
[parm]:saveHTML          = 1
[parm]:title             = Tatin
[parm]:toc               = 6
[parm]:cssURL            = ⎕NULL
[parm]:linkToCSS         = 0
[parm]:collapsibleTOC    = 1
[parm]:width             = 1200


# Tatin

## Overview

Tatin is a package manager written in APL, targeting APL developers. 

## Terms

### Project

In this document the term "project" is loosely used to refer to anything that contains files that can be converted into a package. 

A project may contain files and folders that aid in the development of the package, but are not included in the resulting package. The management of the project is outside the scope of Tatin. The only requirement is that source code is stored in a format supported by Link. For project management consider Link[^Link] or acre[^acre] combined with a version control system like Git[^git].

### Package {#pkg_def}

A package provides a module of code with a clearly defined API. These modules form building blocks for the development of other modules or applications. A package may therefore depend on other packages and consume them via their APIs.

A package consists of:

  * A file [describing the package](#Package config file).

  * A file defining the [dependencies](#Dependency file) of the package, if any.

  * Source code must be one of:

    * A single file
    * A single folder

A package name must:

  1. be a valid APL name.
  1. consist of nothing but ASCII (**not** ANSI) characters.

### Package ID

Within a Registry a package is uniquely identified by its `group`, `name` and `version`. 

The ID string for a package is formed by combining `group`, `name` and `version` with a dash.

Examples: 

* `aplteam-APLTreeUtils-3.1.3_alpha`
* `aplteam-APLTreeUtils-3.1.3-beta`
* `aplteam-APLTreeUtils-4.0.0`

However, note that due to [SimVer](http://simver.org/ "Link to a definition of what SimVer is") the `{major}` number is kind of different from `{minor}.{patch}`; in short these are completely different packages:

* `aplteam-APLTreeUtils-1.0.0`
* `aplteam-APLTreeUtils-2.0.0`

That means they are considered to be as different as `aplteam-Foo-1.0.0` and `aplteam-Goo-1.0.0`.

### Registry

A Registry is a collection of files and folders. A Tatin server manages all the packages saved in such a folder and makes them available via a RESTful interface. A Tatin client is capable of accessing local (not managed by a Tatin server) as well as remote (managed) Registries.

A local Registry can be created anywhere on the filesystem where the user has read and write access. ([Link to an example](#Example for a Registry))

### Alias

The term "alias" is used for two different things in this document:

#### Registry alias

In the [client's config file](#Client Settings) (which can also be referred to as user settings) one can assign an alias to any of the Registries defined in that file. This simplifies addressing a Registry when using the Tatin API.

Note that such an alias is _not_ case sensitive.

#### Package alias

One can assign an [alias to a package dependency](#Dependency file). This potentially simplifies addressing a package dependency in the source code.

## The Modules

Tatin consists of three main modules:

| Name                          | Description |
| ----------------------------- | ------------|
| [`Tatin.Client`](#Client)     | Client      |
| [`Tatin.Server`](#Server)     | Server      |
| [`Tatin.Registry`](#Registry) | Code that acts on Registries |

The three modules interact with each other via clearly defined APIs so as to separate their roles and make it easier to extend in the future. 

Notes:

* The `Tatin.Registry` module is not used by the APL programmer but by the `Tatin.Client` and the `Tatin.Server` modules.

* The user interacts with the `Tatin.Server` module via `Tatin.Client` which in turn communicates with the Server via the HTTP protocol.

## Loading Tatin into `⎕SE`

When loaded into `⎕SE`, Tatin will be placed into a sub namespace of `⎕SE._Tatin`. From a user's perspective this does not matter however because the API (and _only_ the API) will be established in `⎕SE.Tatin`.

## Loading packages into the workspace

Packages will be brought into the WS by establishing them as sub-namespaces within either `#._tatin` or `⎕SE._tatin`. The sub-namespace's name is determined by the full name of the package. For example, for a package `example-foo-2.3.1` a sub-namespace `#|⎕SE._tatin.example_foo_2_3_1 `is established which holds the code and some variables discussed later.

Then a reference is established in the target namespace, that is the namespace the user has specified. For a target namespace `#.MyApp` that would result in a reference `#.MyApp.Foo` in case no alias was specified. This reference will point to the API inside `#|⎕SE._tatin.example_foo_2_3_1`. 

This same mechanism is used for all packages; it makes sure that only the API is exposed to the consumer. Note that the API may be a single function, a class or a namespace, and is defined in the package's optional "api" config file property.

## Client (`Tatin.Client`)

The Client module implements most of the features required in the framework; it is the main module of Tatin. It has its own configuration file ([Client Settings](#)) to keep track of user preferences, in particular the Registries the user potentially wants to interact with.

### API

All API functions throw an error in case something goes wrong.

#### The "InitialisePackage" method

Syntax: `⍬} ← {configNamespace} InitialisePackage (folder)`

| Parameter | Type | Desc |
| --- | --- | --- |
| `folder` | string | Name of a folder hosting the package. If empty this defaults to the current directory.|
| `configNamespace` | namespace | Optional. Typically the result of the function `InitPackageConfig`.<<br>>Use this to set parms like "group" and "name" etc.|

| Output |
| --- |
| `⍬` |

The `InitialisePackage` method is used to prepare a folder to be used as a package as well, or to create a new folder designed to hold a package.

Note that when there is already a file "apl-package.json" then `InitialisePackage` throws an error.

The following actions are performed:

1. If `folder` does not exist yet, it is created.

2. If `source` does not exist yet, then a folder with that name is created within `folder`.

3. A config file with default values is created. Note that this needs to be edited by the user since `InitialisePackage` cannot know the values for `group`, `name` and `version` although they are mandatory; this does not hold in case a left argument was specified.

One can specify `group`, `name` and `version` by executing these steps:

1. Create a configuration space by calling `InitPackageConfig` and assign it to, say, `Foo`

2. Assign proper values to `group`, `name` and `version` in `Foo`

3. Specify `Foo` as left argument to `InitialisePackage`

#### The "Pack" method

Syntax: `zipfile ← Pack (project_path target_path)`  

| Parameter | Type | Desc |
| --- | --- | --- |
| `project_path` | string | Path to a project folder. |
| `target_path` | string | Path to a target folder where the zipped package is to be created. |

| Output | Type | Desc |
| --- | --- | --- |
| `zipfile` | string | Full path to zipfile created. |

The client uses the `Pack` method to create a zip file that contains all the files needed to publish a package to a Registry.

`Pack` takes a path to a project folder and a target folder. It inspects the project folder and validates that it contains all files required. Then the [package config file](#Package config file) and the optional [Dependency file](#) are checked to ensure they are well formed. If all is fine, it proceeds to add the required files to a zip archive. 

Everything the `source` parameter within the package config file is pointing to is added to the archive. When this parameter is empty the Client Config setting for "source" is checked. If that is not empty then it is taken. If that is empty, too, then the home folder of the package is investigated: if that carries exactly one sub folder then it is assumed that this folder carries the source code. If there are mutiple folders, or a single folder does not carry any files with APL source code extensions, then an error is thrown.

The optional `assets` property is a whitelist of files and/or folders that should also be added to the resulting package. This allows adding files to the package that are not source files. The items included in the whitelist will keep their relational structure, e.g. `docs/help.md` will not only include the help.md file but place it into a docs folder within the package.

Assets must be specified relative to the package source. There is one exception: in case an absolute path is specified but that path is identical to the source path then it's just removed.

The resulting zip file will be named `{group}-{name}-{version}.zip` and placed in `target_path`.


#### The "PublishPackage" method

Syntax: `{⍬} ← {registry} PublishPackage (package)`

Publish `package` to `registry`.


| Parameter | Type | Desc |
| --- | --- | --- |
| `package` | string | Either the path to a package folder or to a package zip file. |
| `registry` | string | (Optional) URI or alias for a Registry (defaults to "defaultRegistry" in client settings). |


| Output |
| ------ |
| `⍬`    |

* If `package` is a ZIP file then that file was typically created by the `Pack` method.

* If it points to a folder then it is assumed that this is a project folder. In that case `PublishPackage` calls the method `Pack` itself, producing the required ZIP file in a temp folder, which is then published to the given Registry.


#### Retrieving packages

Packages retrieved from a Registry can either be saved in a folder, typically in order to become part of a project, or just brought into the workspace, typically to try them out. The former is achieved by the `InstallPackage` method while the latter is achieved by the `LoadPackage` method. Installed packages and their dependencies can be brought into the workspace with the `LoadDependencies` method.

Both methods require an `identifier` (see below) in order to identify a package in a Registry.

Packages are loaded either into `#._tatin` or `⎕SE._tatin`. 

Sub-namespaces are compiled from `{groupname}-{packagename}-{version}`. Any characters that are not permitted in APL names are replaced by an underscore character (`_`)


##### The "identifier" 

The `identifier` may be just a package ID. In that case Tatin attempts to retrieve that package from one of the Registries defined in the Client config file in the order they are defined; the first one wins.

However, usually the `identifier` carries also information that identifies a particular Registry. It can be specified in different ways.

* If the HTTP protocol is specified then `identifier` is a URL identifying a package managed by a Tatin server. 

*  It can also  be an alias as in `[MyAlias]`. 

   Note that Tatin allows but does not require a `/` (or `\`) between the Registry alias and the package ID.

* As a path that points to a folder that contains the Registry's `tatin_index.json` file.

* `identifier` can also specify a package locally. In this case the "file://" protocol must be specified. There are two ways:

   * As a path that points to a package folder. This folder must contain the ZIP file.

   * As a path that points to a package ZIP file.

###### Registry scan

If the `identifier` is a Package ID then it may be prefixed with a URL or a Registry alias. An alias is defined by surrounding it with square brackets. If this is done then only that Registry is queried for the package in question. If the package cannot be found in the given Registry an error is thrown.

If no Registry is specified, only a Package ID, then all Registries defined in the Client's config file are queried for the package in the order that is specified by the `priority` property: the Registry with the highest number is scanned first. Once the package with the given package ID is found the scanning stops.

Examples:

```
https://tatin.com/groupName-packageName-1.1.0-beta
[DYALOG]toolgroup-Conga-3.2.1
aplteam-Conga-3.2.1
```

##### "InstallPackage"

Syntax: `⍬ ← InstallPackage (identifier target_folder)`
 
| Parameter | Type        | Desc |
| --------- | ----------- | ---  |
| `identifier`    | string | Specifies a particular package (as described above).       |
| `target_folder` | string | Path to a folder where the specified package is installed. |

| Output |
| ------ |
| `⍬`    |

The purpose of this method is to retrieve the package (and all its dependencies), unzip it and then copy it to the `target_folder`. Then the fully qualified package URI is added to the [Dependency file](#) in the `target_folder` (if the file is missing it is created).

Finally the dependency tree is added to the file `apl-buildlist.json` or, if it does not exist yet, it is created. This file contains all the top-level packages and their dependencies.

This is all done in the file system.

Use the `LoadDependencies` method to read the [Dependency file](#) and load the installed packages into the active workspace.

Note that in case different packages required the same package but with different version numbers then a certain strategy called the "minimal version strategy" is applied. This is quite a complex topic that is discussed in a separate document.

For a detailed general discussion of this strategy see <https://research.swtch.com/vgo>, in particular the "Minimal Version Selection" PDF.


##### "UninstallPackage"

We are going to need an `UninstallPackage` method at a later stage, although a package can be removed simply by deleting it from the file system.

##### "LoadDependencies"

Syntax: `ref ← LoadDependencies (target_folder target_space)`

| Parameter       | Type        | Desc |
| --------------- | ----------- | ---  |
| `target_folder` | string      | Specifies a folder containing previously installed packages. |
| `target_space`  | string      | Path to a namespace in the APL workspace. |

| Output |
| ------ |
| `⍬`    |

This method reads the file "apl-buildlist.json" found in the specified `target_folder` and then loads the packages from the filesystem into the active workspace, generating the dependency tree as described above.

Note that in the process Tatin will check whether the dependeny file was changed _after_ the build list was created or modified. If so the build list will be re-created.

Use this method to get all packages into the APL workspace that were installed by the [InstallPackage](#InstallPackage) method.


##### "LoadPackage"

Syntax: `ref ← LoadPackage (identifier target_space)`

| Parameter | Type        | Desc |
| --------- | ----------- | ---  |
| `identifier`   | string | Specifies a particular package.           |
| `target_space` | string | Path to a namespace in the APL workspace. |

| Output | Type      | Desc |
| ------ | --------- | ---- |
| `ref`  | reference | Reference to the package loaded into the WS. |

This method brings the specified package as well as all of its dependencies into the APL workspace but does not store anything in the file system. Use this to load a package dynamically for the duration of the session.

The package is retrieved in one way or another, depending on `identifier`. 

* If `identifier` is a package folder then it is loaded from that folder. 

  Any folder that carries a config file and the source file or source folder specified in that config file qualifies as a package folder.

* In all other cases `LoadPackage` unzips the package in a temp folder and then loads the package into the workspace.

Note that while `LoadPackage` attempts to delete the temp folder after having loaded the requested package (and any possible dependencies) into the workspace there is a scenario when the temp folder cannot be deleted and is rather assigned to `∆Home_Dir` (which otherwise would be empty): when a package depends on file assets in order to function. Naturally these file assets need to be stored somewhere, and the package needs to be able to access them.

##### Loading into the workspace

Loading into the workspace means that the code is established in a namespace path defined by the group, name and version of the package as per:

`[#|⎕SE]._tatin.group_name_version`

All characters in `version` that are not permitted in APL names are replaced by an underscore (`_`)  character.

The root space `[#|⎕SE]` is chosen so that it is the same as for the target_space.

Finally, a reference to the package's API is injected into the `target_space`. If an alias is defined for that package then the alias defines the name of the reference, otherwise the name of the package is used.

Examples:

Package APLTreeUtils:

```json
{
  "group": "aplteam",
  "name": "APLTreeUtils",
  "version": "5.1.0",
  "source": "APLSource/",
  "api":  "APLTreeUtils"
}
```

Load simple:

```apl
      ref ← LoadPackage 'aplteam-APLTreeUtils-5.1.0' #.MyApp
      ref
#._tatin.aplteam_APLTreeUtils_5_1_0
      #.MyApp.APLTreeUtils
#._tatin.aplteam_APLTreeUtils_5_1_0.APLTreeUtils
```

Load using alias "A51":

```apl
      ref ← LoadPackage 'A51@aplteam-APLTreeUtils-5.1.0' #.MyApp
      ref
#._tatin.aplteam_APLTreeUtils_5_1_0
      #.MyApp.A51
#._tatin.aplteam_APLTreeUtils_5_1_0.APLTreeUtils
```

Note that loading packages is recursive, and transitive dependencies will therefore be loaded in the same way with references established on each level, thereby creating a tree of dependencies.

These constants are created in each package space:

* `∆HOME_DIR` specifies the path to the package folder on disk. 

   This can be referenced by the package code when accessing package resources.

* `∆URI` carries the name of the Registry or the name of the file/folder the package was originally retrieved from.

* `∆CONFIG` carries the package's configuration as readable JSON.

### Client Settings

There is a client configuration file tatin-client.json ([link to the schema](#Client config file)) that keeps track of global user settings.

| Property     | Type   | Desc |
| ------------ | ------ | ---  |
| `registries` | array  | Array of Registry objects.|
| `source`     | bool   | Default is empty. |

Note: If you publish packages and always use the same name for source folders for packages then specify the name of that folder as `source` so that it becomes a default. Can be overwritten for a specific package.

An entry in `registries` would carry these pieces of information:

| `url`        | string | A URL
| `alias`      | string | Optional
| `port`       | int    | Defaults to 0, meaning that the protocol rules: 80 or 443
| `priority`   | int    | For the first entry this defaults to 100
| `api_key`    | string | Optional; used for authentication

Note that after the first registry `priority` defaults to the lowest value minus 10.

By default the user settings are saved/searched for in the user's home folder.


## Server (`Tatin.Server`)

The server module implements a RESTful HTTP server. It exposes resources that can be accessed and modified if authorised.

The communication part is handled by Plodder[^plodder].

### Errors

On error, one of the below HTTP status codes is returned.

| Error Code| Error Type | Desc |
|:--- |:--- |:--- |
| 400 | Bad Request           | Invalid request like an invalid package ID like more than two hyphens. |
| 401 | Unauthorized          | Authentication or authorization error. |
| 404 | Not Found             | Requests to a missing resource. |
| 500 | Internal Server Error | Server error. |
| 501 | Not implemented       | Using an HTTP verb that has not been implemented (PATCH, DELETE, ...) |


### ContentType


### API {#ServerAPI}

The API allows listing and adding packages.

#### List packages

`GET /v1/packages`

Available parameters:

| Parameter | Type | Desc |
| --- | --- | --- |
| `per_page` | number | Max number of items returned in result set (default 100). |
| `page` | number | Current page of the collection (default 1). |
| `group` | string | Pattern that is matched against group names. |
| `tags` | string | One or more tags, separated by comma. |
| `name` | string | Pattern that is matched against package names. |


Returns a list with `group` and `name` but no versions.


`GET /v1/package/{ID}`

Available parameters:

| Parameter | Type | Desc |
| --- | --- | --- |
| `per_page` | number | Max number of items returned in result set (default 100). |
| `page` | number | Current page of the collection (default 1). |

`ID` must specify `{group}-{name}`.

Lists all versions found for the given package.

Note that you may also specify parts of the version number. All variations supported are:

```
`GET /v1/package/{group}-{name}`
`GET /v1/package/{group}-{name}-{Major}`
`GET /v1/package/{group}-{name}-{Major.Minor}`
```

#### Publish a package {#server_publish_package}

`POST /{packageID}`

To publish a package simply POST the package zip file. The response is either 201 ("Created") on a successful operation, or an error code otherwise.

The zip file must contain a valid package as defined above.

An authentication key must be provided in the header for the POST to be accepted by the Server.

#### Get package

`GET /{package-id}`

Get a package by providing the fully qualified name for the package, i.e. `group-name-version`. The response is either 200 on a successful operation or an error code otherwise.

The Content-Type on a successful operation is `application/zip`.

## Registry (`Tatin_Registry`) {#Tatin-Registry}

This module carries the code that is shared by the client and the server.

The `Tatin.Registry` module manages the storage and retrieval of packages. No authentication is performed in this module.

This module is called directly by either the client or the server module.

The `Tatin.Registry` module always acts locally, either under the umbrella of a client or a server.


### API {#regapi}

#### The `CreateRegistry` method

Syntax: `rc ← CreateRegistry folder`

Create a new Registry in `folder`.

| Output | Type | Desc |
| --- | --- | --- |
| `rc` | number | Return code (0 for success, otherwise error code). |

This method is available only for creating a Registry locally (via the Tatin Client) since for a server creating its Registry is either part of the installation (Windows) or the configuration (other operating systems).

#### The `Index.Create` method {#create_index}

Syntax: ` {index} ← Index.Create force`

Create index for a Registry. 

The index is used for fast search operations. The index is basically a simple vector of folder names that are build by the pattern `{group}-{name}-{version}`.

It is both returned as a shy result and written to a file `tatin_index.json` in the Registry's folder.

| Parameter | Type | Desc |
| --- | --- | --- |
| `force` | number [0,1] | If `1` forces re-creation of index even if it already exists. |

| Output | Type | Desc |
| --- | --- | --- |
| `index` | string | simple vector with package folder names, separated by CRs. |


#### The `ListPackages` method  {#Reg_ListPackages}

Syntax: `packages ← ListPackages (pattern)`

| Parameter | Type | Desc |
| --- | --- | --- |
| `pattern` | string | search pattern; do not use anything that cannot be part of a valid package ID. |

| Output | Type | Desc |
| --- | --- | --- |
| `packages` | array | List of package IDs. 

Search Registry for packages matching `pattern` which is matched against `group` and `name`. 


Examples:

```
[MyAlias]                          ⍝ All packages of the given Registry
[MyAlias]{group}                   ⍝ All packages of the given group
```


#### The `ListPackageVersions` method  {#Reg_ListPackageVersions}

Syntax: `packages ← ListPackageVersions (package)`

| Parameter | Type | Desc |
| --- | --- | --- |
| `package` | string | must be valid `{group}-{name}`. |

| Output | Type | Desc |
| --- | --- | --- |
| `packages` | array | Array of package config objects ([the schema](#Package config file) for the given package) 

Lists all versions of the given package. If no package with the given `group` and `name` can be found then `⍬` is returned.


#### The `PublishPackage` method {#registry_publish_package}

Syntax: `rc ← PublishPackage (packageZip)`

Add a package to the Registry.


| Parameter | Type | Desc |
| --- | --- | --- |
| `packageZip` | string | Path to zip file containing a package. |

| Output | Type | Desc
| --- | --- | --- |
| `rc` | Boolean | 0 for okay |



#### The `GetPackage` method{#GetPackage}

Syntax: `zipFile ← GetPackage {packageID}`

Retrieve a package from the Registry. Returns the path to a package zip file.

| Parameter | Type | Desc |
| --- | --- | --- |
| `packageID` | string |  A [Package ID](#). |

| Output | Type | Desc |
| --- | --- | --- |
| `zipFile` | string | File path to package zipfile. |


#### Withdrawing a package (Delete)

We believe that nothing that was published should ever be deleted. For that reason there is no method available to achieve that.

This restriction might be lifted in the future.

However, note that with a local Registry withdrawing a package can be easily achieved anyway by simply removing the folder holding the package. In such a case the index needs to be rebuilt --- see [CreateIndex](#create_index).


#### Updating a package

A package cannot be updated. If there is a need to update a package a new version must be created.

This restriction is set in stone and is not negotiable.


## Misc

### Config and meta files 


#### Client config file

This document comes with a file "tatin-client-schema.json" that defines the schema of a package config file.

This file defines some Client-specific parameters, in particular Registries aliases.

Example:

```json
{
    "defaultRegistry": "tatin",

    "registries": [
        {
            "alias": "",
            "uri": "C:/Users/me/myregistry"
            "port": 0
            "priority": 100
            "api_key": "This and that"
        },
        {
            "alias": "dyalog",
            "uri": "https://packages.dyalog.com",
            "priority": 200
            "api_key": "SomethingDifferent"
        },
        {
            "alias": "myCompany",
            "uri": "http://packages.my-company.com",
            "port": 8080
            "priority": 300
            "api_key": ""
        },
        {
            "alias": "tatin",
            "uri": "http://tatin.com",
            "port": 0
            "priority": 400
            "api_key": ""
        }
    ]
}
```


#### Package config file

This file defines a package within a project folder.

This document comes with a file "apl-package-schema.json" that defines the schema of a package config file.

Example:

```json
{
  "decription": "Date and Time related stuff",
  "assets": [
     "license.txt",
     "README.md"
  ],
  "group": "aplteam",
  "name": "DateAndTime",
  "source": "APLSource/",
  "version": "1.2.0"
}
```

Note that the trailing slash on `source` is not required but makes it clear that it is a folder.


#### Dependency file

The file "apl-dependencies.txt" is a simple text file defining dependencies of a package. It is created/changed by the `InstallPackage` method, but it might also be edited/changed by a user.

Syntax: `alias@packageURI` where `alias` is optional.

Examples:

```
https://tatin.com/aplteam-Tester2-5.1.0
C:/Repos/MyPrivateRepo/aplteam-Tester2-5.1.0
R@https://packages.carlisle-group.com/carlisle/Rumba/3.2.0
```

Note that the last line defines an alias "R" for "Rumba".

#### Build List

The file "apl-buildlist.json" is created by Tatin when the `InstallPackage` is invoked

This file is used to rebuild an application. It is created by traversing the file "apl-dependencies.txt".

Note that the file will be re-created if Tatin finds that the file "apl-dependencies.txt" was changed after the build list file was created.

The file makes sure that rebuilding the application without changing the dependency file will always result in exactly the same build.

### Data storage in Registries

#### Overview

Data is stored in the file system: there is no database involved.

When a Registry is managed by a Server a file `tatin_index.json` will be created. The file will be re-created whenever the Server is started.

Meta data regarding packages might be stored at a later stage in sub folders following certain naming conventions.


#### Example for a Registry

If the name of the folder holding a Registry is `Foo` then this is how the content of a Registry would like like:

```
/Foo/
  Group1-Pack_1-1.0.0/
    apl-package.json
    apl-dependencies.txt
    Group1-Pack_1-1.0.0.zip
  Group1-Pack_1-2.0.0/    
    apl-package.json
    apl-dependencies.txt
    Group1-Pack_1-2.0.0.zip
  Group1-Pack_1-2.1.0/
    apl-package.json
    apl-dependencies.txt
    Group1-Pack_1-2.1.0.zip
  Group1-Pack_2-1.1.0/
    apl-package.json
    apl-dependencies.txt
    Group1-Pack_2-3.0.0.zip
  Group2-Pack_1-1.0.0/
    apl-package.json
    apl-dependencies.txt
    Group2-Pack_1-1.0.0.zip
  Group1-Pack_b-1.0.0/
    apl-package.json
    apl-dependencies.txt
    Group2-Pack_b-1.0.0.zip
  Group1-Pack_c-1.0.0/
    apl-package.json
    apl-dependencies.txt
    Group2-Pack_c-1.0.0.zip
```

Note that packages in different groups may share the same name.

A Registry might live on a different machine; then the client must access any packages within that Registry via the HTTP protocol and the server's REST interface.

A Registry might live locally. In that case it can also be addressed via the file protocol. If no Tatin server is running on the local machine then this is the only way to access the Registry, though one could access a single zipped file comprising a package by passing a full path. 

In such a case the last part of the path will be converted into a package ID automatically.


## CPU versus disk space

It is not clear whether packages should be saved as ZIP files _**and**_ unzipped as well. The ZIP files are required for delivery. Keeping the package unzipped might speed up some search operations. Those will certainly be needed at a later stage, for example searching for particular code snippets or comments etc. However, the package configuration file and the dependency file are always available unzipped.

For the time being the packages are stored unzipped in a sub-folder `data\`. This can be switched off, and all the `data\` folders deleted, without causing trouble. 

### Authentication

Bearer authentication is used when accessing protected resources. API keys can be generated by authenticated users with specific access permissions.

For the time being there is just one API key used for POST operations in order to simulate authentication which will be implemented at a later stage.


[^Link]: `Link` from Dyalog is designed to link any ordinary namespace in an APL workspace to a folder. APL objects changed via the editor are automatically saved/changed in that folder or a sub folder.<<br>>
<https://github.com/Dyalog/link>

[^acre]: `acre` is a project management tool written by Phil Last and supported by the Carlisle Group that allows saving APL objects automatically in files.<<br>>
<https://github.com/the-carlisle-group/Acre-Desktop>

[^git]: Git is a distributed version-control system for tracking changes in source code during software development.<<br>>
<https://en.wikipedia.org/wiki/Git>

[^plodder]: `Plodder` is a generic HTTP server that allows to easily implement any HTTP server.<<br>>
<https://github.com/aplteam/Plodder>