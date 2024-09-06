[parm]:title             = 'Tatin: Syntax Reference'
[parm]:toc               = 2 3 
[parm]:leanpubExtensions = 1
[parm]:numberHeaders     = 2 3 4 5 6


# Tatin Syntax Reference

## User Commands

Every user command comes with at least two levels of help, and a few even with a third level:

1. `-?` shows a brief description and the syntax
2. `-??` shows a detailed description of the command and its arguments and options
3. `-???` shows examples (only available for some commands)

If the third level is available then `-??` shows this at the bottom:

```
]{user-command} -??? ⍝ Enter this for examples                                        
```


## The API

The API is established in `⎕SE.Tatin`. These are almost exclusively dfns that call a function in `⎕SE._Tatin`.

While `⎕SE._Tatin` holds all packages loaded into `⎕SE`, among them those required by the Tatin client, `⎕SE.Tatin` holds the public interface of the Tatin client. A user is supposed to call functions in `Tatin` but not `_Tatin`.

The API functions are listed alphabetically.


### BuildPackage

```
zipFilename←BuildPackage parameterSpace
```

ZIPs all files that are required for a package according to the specified parameters and creates a ZIP file containing these files in `parameterSpace.targetPath`.

Requires a namespace with parameters as right argument, typically created by calling `CreateBuildParms` which requires a path to the project as right argument:

```
   parms←⎕SE.Cider.CreateBuildParms '/path/2/project`
   parms.⎕nl 2
dependencyFolder
projectPath     
targetPath   
tatinVars   
version         
```

#### dependencyFolder

A folder with packages the project depends on. Might be empty, in case there are'nt any dependencies.


#### projectPath

The folder the package is going to be created from. To be specified as the right argument of `CreateBuildParms`.


#### targetPath

The folder the ZIP file is created in.

Defaults to `projectPath` in case `targetPath` is empty.


#### `tatinVars`

Reference pointing to the `TatinVars` namespace of the package. Required if `TatinVars.CONFIG` in the workspace should be updated (build number).


#### version{#version-parms}

Must be one of:

* A rule how to modify the version number in the package config file
* An empty character vector
* A character vector that replaces "version" in the package config file

A> ### The version number
A>
A> The problem with version numbers is that a package configuration file **must** contain a version number, but many programmers want to have the version number also available in their code. So which one rules?
A>
A> Clearly there is no right or wrong answer here: it depends on personal preferences, or the work flow.
A>
A> `BuildPackage` is part of Tatin, therefore it takes care of the `version` information in the package configuration file. Everything else is left to the user.

##### "version" starts with a "+"

The "+" makes it a rule. It must come with three digits separated by dots. The digits may be just 0 or 1.

The rules:

* `+0.0.1` bumps the patch number
* `+0.1.0` bumps the minor number and resets the patch number
* `+1.0.0` bumps the major number and resets both the patch number and the minor number


##### "version" does not start with a "+"

* If `version` is empty then just the build number is bumped
* If `version` is not empty but does not carry a build number then it replaces the version information but the build number, which is bumped
* If `version` is not empty and includes a build number then it replaces the version information including the build number, and that build number is **not** bumped


#### Dependencies

If `dependencyFolder` is empty `BuildPackage` tries to establish whether the package depends on other packages:

1. It checks whether the package is managed by Cider (read: has a file `cider.config`). If that is the case it checks the property `[CIDER]dependencies:tatin` in that file. If it defines a folder then it is taken.

   Refer to the Cider documentation on `dependencies:tatin` for details.

2. If the package is not managed by Cider then Tatin assumes that package dependencies (if any) would be installed into a subfolder `packages/` (convention).

3. If there is no subfolder `packages/`, or if it does not host a file `apl-dependencies.txt`, then Tatin looks for a file `apl-dependencies.txt` in the root of the package project.

4. If the package is not managed by Cider and depends on packages that are installed in a different subfolder than `packages/`, then the name of the subfolder must be passed as `dependencyFolder` in the parameter space.

If no file `apl-dependencies.txt` can be detected then Tatin will assume that the package does not depend on other packages.


### CheckForLaterVersion

```
 r←{flags} CheckForLaterVersion path
```

Checks whether there are later versions available for the principal packages installed in `path`.

The optional left argument must, if specified, be an integer that may carry flags as a single integer:

|Value|Description
|-----|---------------------------------------------------------------------
|0    | No flag set, same as no argument at all
|1    | Major: should rather later major versions be listed? Defaults to 0
|2    | Dependencies: should dependencies be checked as well? Defaults to 0
|3    | Both flags set

By default, only minor and patch number are part of the check. By specifying 1 as `major` you may change this default behaviour and list any later major versions instead.

Note that this function scans all known registries with a priority greater than zero.

Returns a matrix with five columns:

|Col  | Info
|-----| ----
|[;1] |Original package ID
|[;2] |Latest package ID
|[;3] |Original URL
|[;4] |Flag; 1 means later version is available
|[;5] |URL the latest version was found but empty in case it's identical with [;3]


### ClearCache
```
(rc report)←ClearCache url
```

Clears the cache, which is the folder `GetPathToPackageCache` points to.

* If `url` is empty all subdirectories but `temp\` are removed
* If `url` is not empty then only the given domain is removed from the cache

### CopyRegistry
```
list←CopyRegistry parms 
```

This command copies packages from a managed Tatin Registry (by default `[tatin]`) to a local folder.

There might be a Tatin Server running on the local target folder, but this is not a requirement. In fact any running local server must be paused or stopped while `CopyRegistry` is running.

By default all packages are copied, even deprecated ones.

Packages that are already saved in the target folder are not requested again, but check the `-force` flag.

`CopyRegistry` was introduced with version 0.110.0, therefore you cannot use it on Tatin servers that run earlier versions than that.

The function takes one mandatory argument: a parameter namespace typically created by calling [CreateCopyRegistryParms](#), and then amended.

Note that you must set two of the parameters, `url` and `path`. The other parameters have default values.

### CreateAPIfromCFG

```
{noOf}←{names} CreateAPIfromCFG (refTosourceNS cfg)
```

This function creates cover functions for everything that is supposed to become the public interface of a package. 

By default the contents of the package becomes the public interface: `⎕NL 2 3 4 9`. However, if there is a function `Public` available, then this is expected to return a list of simple text vectors defining the public interface. `CreateAPIfromCFG` will use the result of such a function if it finds one in the root of the given namespace.

Alternatively, you can pass a list of names as left argument to `CreateAPIfromCFG` - that would take precedence.

It is possible to keep `names` very simple by specifying a single name, but it can also be complex and comprehend the names of functions, operators, variables, interfaces, classes and namespace, simple and scripted. It can also use dotted syntax to define names within namespaces, though only one level deep.

!> ### Tips and hints
=> You may call `CreateAPIfromCFG` when initialising a package after loading it (from a function that is executed by the package's `lx` parameter, see "Tatin's Package Configuration File" for details).
=> 
=> Alternatively, you may call it as part of the package creation process, making it permanent. 


#### Typical scenarios

1. The package consists of a single class or a single namespace, be it scripted or not

1. The package consists of a single function or operator

1. The package consists of several objects: a mixture of functions, operators, classes and/or namespaces

A> ### Single functions 
A>
A> You _must not_ specify the name of a function (or an operator) as the API in any of these cases.
A> 
A> This restriction helps to avoid confusion, but there is also a technical issue: Tatin needs to establish references to the API, and although in Dyalog one can establish references (kind of) to monadic, ambivalent, and dyadic functions, this is not possible for neither operators nor niladic functions.


##### A single namespace

* If you don't specify `api` then the name of the namespace is the API. 

  For example, if the package name is `pkgName` and the namespace's name (see the `source`  parameter) is `foo` and it has a function `Hello`, then you call `Hello` with:

  `pkgName.foo.Hello`

* If you do specify `api` by assigning an APL name to it, then it must be the name of the namespace. In that case, the _contents_ of the namespace becomes the API.

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



### CreateBuildParms

```
r←CreateBuildParms path
```

Creates a namespace with parameters for the `BuildPackage` function.

Contains these parameters:

```
dependencyFolder
projectPath          ⍝ Set to `path`
targetPath
version
tatinVars
```

### CreateCopyRegistryParms
```
parms←CreateCopyRegistryParms y
```

Returns a namespace with parameters required by the [`CopyRegistry`](#) function.

`y` can either be a namespace with some or all of the parameters that might be defined in a parameter namespace for `CopyRegistry`.


Of the parameters two MUST be specified: 

`path` 

: Defines a local folder where the packages are going to be saved.

`url`

: The url of the Tatin Registry to be copied from.

The folllowing parameters can be used to amend the behaviour of `CopyRegistry` according to your needs:

* `force`
* `latest`
* `group`
* `list=`
* `dry`
* `verbose=`

All these flags and options are documented as part of the `]CopyRegistry` user command, for details see there.

There is one exception: by specifying `noDeps←1` one can prevent dependencies from being copied, and the documentation of the user command `]CopyRegistry` does not talk about this option. The reason is that this is only useful for test cases.


### CreateReInstallParms

```
r←CreateReInstallParms
```

Creates a namespace with default parameters; it can be passed as (optional) left argument to the [`ReInstallDependencies`](#ReInstallDependencies) function, in particular, `noBetas`, `update` and `dry`.

### DeletePackages

```
(statusCode errMsg)←DeletePackages (regID packageIDs)
```

Deletes one or more packages, usually several versions of the same package.

Whether deleting packages from a Tatin Registry is possible at all depends on the delete policy it operates, which is in turn determined by the server's INI setting `[CONFIG]DeletePackages`. See [`GetDeletePolicy`](#GetDeletePolicy). The principal Tatin server operates a "None" policy, meaning that you cannot delete anything from it.

!> ### Why can't I delete a package from the Tatin server?
=> The main design objective was to make sure that a build that includes packages from the principal Tatin Registries can always be reproduced in precisely the same way. 
=>
=> If deleting a package is allowed --- even when it is a beta version --- then this cannot be guaranteed.
=>
=> If you happen to publish a package and realize seconds later that you made a formidable mistake? Well, you increase the patch number, fix the problem and publish a new version, that's the only way.

In order to delete a package you must identify the package precisely:

```
<group-name>-<package-name>-<precise_version_number>
```

You may delete several packages in one go by specifying several complete package IDs as a nested vector. However, all packages will be deleted from the same Registry identified by `regID`. `regID` can be a URL or a Registry alias or a Registry ID.

The function returns an HTTP status code and a message, which will be empty in case of success.


### DeprecatePackage

```
msg←DeprecatePackage y
```

Declares a package to be deprecated.

`y` must provide three pieces of information:

* A Registry URL or a Registry alias
* A comment like "See package xyz instead"
* A package ID that provides group name, package name and optionally a major version number

  If no major version number is provided, then the function acts on _all_ major versions of that package.

Note that because the Registry must be defined no scanning takes place with this function.


### FindDependencies

```
r←{depth} FindDependencies (target pkgList [verbose])

```

`target` can be any of the following:

* A Registry alias
* `[*]` for all defined Registries with a priority greater than 0
* A URL pointing to a Tatin server 
* A folder

The first three options will eventually become the folder where the packages of a Registry are stored.

Scans `folder` recursively for a file "apl-dependencies.txt". Folders with such a file will be searched for packages defined in `pkgList`. Useful to find out where one or more packages are used.

`pkgList` must be a simple char vector with a list of packages separated by commas.

The packages can be specified fully or partially specified. "Group" and "Version" can be omitted while "Name" is mandatory. You can specify a major version, but "minor" and "patch" are ignored if specified.

Note that the search is *not* case-sensitive.

Returns a fully qualified list of all matches. 

By default only the folder containing a file "apl-dependencies.txt" with at least one of the defined packages is returned.

If a 1 is passed as `verbose` (optional, defaults to 0) the actual package folders will be returned instead of the hosting folder(s), revealing the precise version(s) installed.

The optional left argument can be used to limit the number of levels to be searched recursively. A server sets this to 1 because it knows that it only needs to search the sub folders of the Registry folder, which greatly reduces the time spent on the task.

The user can use it in the same way if she knows exactly what is stored where.


### GetDeletePolicy

```
r←GetDeletePolicy url
```

Takes the alias or the URL of a server like https://tatin.dev or an alias and returns the delete policy operated by that server.

Returns one of "None", "Any", "JustBetas":

* "None" means a package, once published, cannot be deleted                                
* "Any" means any package can be deleted                                                    
* "JustBetas" means that only beta versions can be deleted                                

### GetDependencyTree    

```
tree←{append} GetDependencyTree x
```

Takes `identifier` (`x`) and returns the dependencies as a matrix.

`identifier` must be one of:

* an HTTP request
* a folder holding a package (like file://C:\Temp\{group}-{name}-{major.minor.patch}\\)
* a path to a package in a registry (like C:\MyReg\\{packageID})
* a package ID; Tatin will then attempt to find that package in the Registries defined in the Client's config file.

Returns a dependency tree as a matrix:

|[;1] | Flag that indicates whether it is a principal package (1) or a dependency (0)
|[;2] | PackageID of what required that dependency
|[;3] | Full package ID
|[;4] | The full URL (either a local path (without protocol) or http(s)://...)

This function requires the version number to be fully specified.

Note that the function accepts an optional left argument, but this should not be specified by a user: it is only used internally.

#### Optional left argument `append`

The optional left argument defaults to 0, meaning a saved dependency tree is replaced. By passing a 1 as the left argument one can add to the saved dependency tree.


### GetNoCachingFlag

```
flag←GetNoCachingFlag uri
```

Takes a URI or an alias and tries to find that URI in the `MyUserSettings` instance.
If found the value of the `noCaching` property is returned. 

If URI is unknown a 0 is returned.


### GetPathToPackageCache
```
r←GetPathToPackageCache
```

The user settings rule:

* If `MyUserSettings.path2cache` is not empty then that path is returned, otherwise:

* The function returns the standard path for caching which depends on the operating system


### GetUserHomeFolder    

```
path←{aplVersion} GetUserHomeFolder append
```

Returns the standard path for any user-specific data.

Works on all platforms but returns different results.

`⍵`, if not empty, is added to the resulting path.


!> ### On Windows 
=> It is typically:
=> ```
=> `C:\Users\%USERPROFILE%\AppData\Roaming\Tatin'     ←→ GetUserHomeFolder ''
=> `C:\Users\%USERPROFILE%\AppData\Roaming\Tatin\foo' ←→ GetUserHomeFolder 'foo'
=> ```
!> ### On Linux
=> ```
=> '/home/{⎕AN}/Tatin'     ←→ GetUserHomeFolder ''
=> '/home/{⎕AN}/Tatin/foo' ←→ GetUserHomeFolder 'foo'
=> ```
!> ### On Mac-OS
=> ```
=> '/Users/{⎕AN}/Tatin'     ←→ GetUserHomeFolder ''
=> '/Users/{⎕AN}/Tatin/foo' ←→ GetUserHomeFolder 'foo'
=> ```

`⍺` is optional and only specified by test cases in order to simulate different versions of APL.

### InitialisePackage

```
config←{configParms} InitialisePackage folder
```

Takes a folder (`⍵`) and initializes it so that it can be a package.

This means in particular to create the folder (although it might already exist) and creating a package config file with default settings or what `⍺` specifies: one can pass a config namespace as `⍺`, typically created by a call to [`InitPackageConfig`](#InitPackageConfig).

There must be no config file yet, otherwise an error is thrown.

### InitPackageConfig

```
cfg←{projectPath}  InitPackageConfig y
```

Returns a namespace with default values useful for the function [`InitialisePackage`](#InitialisePackage).

`⍵` might be empty; then it is ignored. Alternatively, it might be a namespace with variables. If it is then the variables in that namespace overwrite the defaults.

`projectPath` is optional. It is used only in case `source` is not specified, not even as a global default in the user settings.


### InstallPackages

```
r←{noBetas} InstallPackages (identifiers targetFolder)
```

Installs one or more packages (`identifiers`) in `targetFolder`.

`identifiers` must be a simple character vector, specifying one or more comma-separated packages (items).

Each item must be one of:

* an HTTP request for a package
* a ZIP file holding a package
* a folder holding a package (like `file://C:\Temp\group-name-version\`)
* a path to a package in a registry (like `[RegistryAlias]{group}-{name}-{major.minor.patch}` or `C:\MyReg\{group}-{name}-{major.minor.patch})`
* a package ID; Tatin will then attempt to find that package in the Registries defined in the Client's config file
* The internal alias `[MyUCMDs]` (case independent); this will then be replaced by the actual path to the `MyUCMDs/` folder followed by the name specified or, if none was specified, the name of the package

You may omit minor+patch or even major+minor+patch in order to install the latest version.

By default beta versions are considered in case the package ID is incomplete, but you can suppress them by passing `1` as `⍺`.

`r` is a nested vector of character vectors with the full names of all principal packages installed. The length will match the number of packages specified as `identifiers`.

Notes:

* The target folder will be created if it does not already exist
* The package ID(s) might use any case, meaning that if the package's name is `foo-Goo-1.2.3` then you might as well spell it `foo-GOO-1.2.3` or `FOO-goo-1.2.3`: it would not make a difference 


### ListDeprecated

```
r←{all} ListDeprecated uri
```

Lists all packages that are deprecated but only if they are the last published version of any given major version number.

This default behaviour can be changed with the `-all` flag: then all versions of any major version that is marked as deprecated are listed. 


`uri` must be one of:

* A path to an install folder, defined by the presence of a file `apl-buildlist.json`
* A path to a Registry and optionally a (possibly incomplete) package ID


### ListCache

```
r←{fullpath} ListCache y
```

Lists the contents of the Tatin package cache. Refers to the `MyUserSettings` instance of the class `UserSettings`.

`y` must be one of:

* A character vector with a Registry domain name or a Registry alias or empty
* A nested vector of length 2: first item see above, second must be a Boolean that defaults to 0.

  This is interpreted as `principalFlag`.

The optional left argument `fullpath` defaults to 0, when just domain names and package IDs are reported. If it is 1 then the full paths are reported instead.

The result is a vector with as many items as there are domains represented in the cache with at least one package.
Each item is a two-element vector:

 * The first item holds the url of the domain
 * The second item holds a vector of char vectors with the package names

In case the cache is empty an empty vector is returned.


### ListLicenses

```
r←{verbose} GetNoCachingFlag url
```

`verbose` defaults to 0 but might be 1.

* With `verbose←0` a list with the names of all licenses tolerated by the given managed Tatin Registry is returned. Might be empty.

* With `verbose←1` a matrix with two columns and zero or more rows is returned:

  * `[;1]` Names of all licenses 
  * `[;2]` URLs of all licenses


### ListPackages         

```
mat←{parms} ListPackages uri
```

Lists all packages of a given Registry except when the last package of a major version number is marked as deprecated --- see `ListDeprecated` for listing those.

`uri` must be one of:

* A path to an install folder, defined by the presence of a file `apl-buildlist.json`
* A path to a Registry and optionally a (possibly incomplete) package ID


#### Right argument

##### Folder

In case a folder was specified a two-column matrix is returned:

|[;1] |Carries the package ID
|[;2] |Carries a star for principal packages

##### Registry

In case a Registry was specified, by default all packages saved in that Registry are returned, aggregated by major versions, as a two-column matrix.

You may specify a package ID without version number, or only part of the version number; then only matching packages are listed.

You may even specify just a package name, without a group name. That would not make a difference in case the name is only used once, but if it is used in several groups then all of them will be listed.


#### Left argument

Optionally `parms` can be specified. If specified this must be a namespace that must contain the variables `group`, `tags` and `aggregate`. It may contain `date`, `since`, `project_url` and/or `userCommand`.

The following parameters allow the user to select certain packages:

* Use `group` to specify the group.
* Use `tags` to specify one or more tags (simple comma-separated text vector); is case-independent.
* `userCommand`, if specified, must be a Boolean. If it is 1 only packages that are user commands are returned.
* Use `since` to specify a date; all packages published before that date will be ignored.

  `since` can be one of:

   * A character vector in the format `YYYY-MM-DD` or `YYYYMMDD` like `since←'2022-06-01'`
   * An integer in the format `YYYYMMDD` like `since←20220601`

The following parameters allow the user to influence what data is returned:

* If `date` is `1` an additional column is added to the result with the publishing date
* If `project_url` is `1` an additional column is added to the result with the `project_url`, if any
* If `aggregate` is `0` the data is not aggregated by minor and patch number; defaults to 1.

##### packageID

* `packageID` is empty and `aggregate` is 1 (the default):

  All packages are returned with the number of major versions in `[;2]`

* `packageID` is empty and `aggregate` is 0:

  All packages are returned; the second column carries `⍬`

* `packageID` specifies {name} and `aggregate` is 0:

  All packages that match `name` are returned; they might belong to different groups

* `packageID` specifies {group}-{name} and `aggregate` is 0:

  All versions of that package are returned

* `packageID` specifies {group}-{name} and `aggregate` is 1:

  All major versions of that package are returned

  `[;2]` carries the number of versions of each major version

* `packageID` specifies {group}-{name}-{major}; in this case `aggregate` is ignored:
   
  All versions (minor and patch) of that package are returned

* `packageID` specifies {group}-{name}-{major}-{minor}; in this case `aggregate` is ignored:

  All patch versions of that package are returned


#### Result

Returns a matrix with at least two and up to four columns. These columns are always returned:

|[;1] | Package name |
|[;2] | Carries the number of major versions |


* In case `date` was specified a column is added carrying the publishing date
* In case `project_url` was specified a column is added carrying the project URL (if any)

#### Deprecated packages

In case the last published version of a package carries a flag `deprecated` in its config file and that is a 1, such a package and all its predecessors with the same major version number _are not listed_.

To list just deprecated packages use `ListDepreciated`.


### ListRegistries       

```
r←ListRegistries type
```

Lists all registries defined in the Client's config file.

Returns a matrix with these columns:

|[;1] | Alias
|[;2] | URL
|[;3] | ID
|[;4] | Port
|[;5] | Priority
|[;6] | No-caching flag
|[;7] | Proxy
|[;8] | API key

"type" must be either 0 or 1 or empty:

* 1 means all data is listed
* 0 means the API key is not listed

Notes:

* The result of the API function and the user command differ
* When a Tatin Server is questioned by `ListRegistries` but does not respond, an error is thrown.


### ListTags             

```
list←{parms} ListTags y
```

Lists all tags.

`y` might be the URL of a Tatin server or a Registry alias (embraced by `[]`).

By default all tags of all packages are returned as a two-column matrix:

* `[;1]` carries the name of the tags
* `[;2]` carries the number of occurrences of that tag

Optionally `⍺` can be specified. Must be a namespace that might contain a variable `tags` which may specify one or more tags (simple comma-separated text vector). If that is the case only the tags shared by the packages that carry all of the specified tags will be returned.

### ListVersions         

```
mat←{dateFlag} ListVersions url
```

Lists all versions of a given package.

`url` must be one of:

* A package name
* A group name and a package name
* A URL pointing to a Registry together with a package name
* An alias pointing to a Registry together with a package name
* A (local) path to a Registry together with a package name

A package name may be either just the name or the group and the name. Additionally, you may either specify a major version number, or a major and a minor version number.

Specifying a patch number makes no sense. If it is specified anyway it is ignored.

Therefore the following arguments are all valid:

1. `example-versions`
2. `example-versions-1`
3. `example-versions-1.0`
4. `[tatin-test]versions`
5. `[tatin-test]example-versions`
6. `[tatin-test]example-versions-1`
7. `[tatin-test]example-versions-1.0`
8. `[tatin-test]example-versions-1.0.1 ⍝ Same as 7.`

In the first three cases all defined Registries with a priority greater than zero are scanned. A matrix with two columns is returned: URL and full package ID.

If a URL or an alias was specified the given Registry is questioned. A matrix with one column with full package IDs is returned.

You may omit the group name; that does not make a difference when the name is used only within one group anyway, but if it is used in more than one group, then all of them are listed.

If version precedence cannot be established from the version numbers alone (often a problem
with beta versions) then the publishing date is taken into account.                        

By default, the publishing date is not included, but you may change this by passing a 1 as `⍺`. In that case, an additional column is added to the result.

Note that the package ID might use any case, meaning that if the package's name is `foo-Goo` then you might as well spell it `foo-GOO` or `FOO-goo`: it would not make a difference 

### LoadDependencies

```
{r}←{flags} LoadDependencies y
```

Loads all packages according to a build list in a folder.

Requires one mandatory right argument and accepts up to two:

* A source folder (a folder with a build list)
* A target namespace

If the target namespace is not specified then it defaults to `#` except when `[MyUCMDs]` is specified as source folder: in that case it defaults to `⎕SE`.

The optional left argument `flags` can be used to define two flags which default to 0:

* `overwrite` enforces a load even if the package is already available in `#._tatin` or `⎕SE._tatin`
* `makeHomeRelative` influences the result of `HOME` and `GetFullPath2AssetsFolder`: rather than returning the full path only the folder holding the packages and its parent are returned, making it a relative path

A> ### Relative `HOME`
A>
A> In case Tatin packages become part of an application that is bundled with the Dyalog runtime you cannot use absolute paths for referring to assets for obvious reasons. 
A>
A> In that case the paths must be relative, and that's what the `makeHomeRelative` flag is for.

Returns a vector with references to the loaded packages (principal packages only, not dependencies).

#### MyUCMDs/

In case a Tatin package is a Dyalog user command it can be installed into the special folder `MyUCMDs/`. Where `MyUCMDs/` lives depends on the operating system.

Notes:

* `MyUCMDs` is case independent, so specifying `[MYUCMDS]` or `[myucmds]` does not make a difference
* In case no name is specified after `[MyUCMDs]` the name of the sub-folder is derived from the package name
* If you want to install multiple user command packages in one go you must not specify a name after `[MyUCMDs]`, otherwise an error is thrown


### LoadPackages

```
r←{noBetas} LoadPackages (identifiers targetSpace)
```

Loads packages dynamically into the workspace.

`identifiers` must be a simple character vector specifying one or more comma-separated packages (items).

Every single item must be one of:

* An HTTP request for a package
* A ZIP file holding a package
* A folder holding a package (like `file://C:/Temp/group-name-version`)
* A path to a package in a registry (like `[RegistryAlias]{packageID}` or `C:\MyReg\{packageID}'`)
* A package ID; Tatin will then attempt to find that package in one of the Registries defined in the
client's config file with a priority greater than 0.

  The first hit wins.

`targetSpace` must be a reference or a fully qualified name of an ordinary namespace, meaning the name must start with either `#` or `⎕SE`.

It might already exist, but if it doesn't it will be created. If it exists but is not an ordinary namespace an error is thrown.

Loads the package(s) into `(#|⎕SE)._tatin.{packageName}` and establishes a reference for every one of them in `targetSpace`

Loads all dependencies, if any, as well into `(#|⎕SE)._tatin` but does _not_ create references for them in `targetSpace`.

By default beta versions are considered in case the package ID is incomplete, but you can suppress them by passing `1` as `⍺`.

Returns the number of principal packages loaded.

Note that the package ID(s) might use any case, meaning that if the package's name is `foo-Goo-1.2.3` then you might as well spell it `foo-GOO-1.2.3` or `FOO-goo-1.2.3`: it would not make a difference 


### Ping                 

```
bool←Ping url
```

Establishes whether the host is up and running with very little overhead. If `url` (can also be an alias) points to a folder a 1 is returned if that folder exists, otherwise 0.

### PublishPackage       

```
{(statusCode errMsg zipFilename)}←{dependencies} PublishPackage (source registry)
```

Publishes a package.

1. Checks whether there is already such a package but with a different spelling in terms of case
1. Creates a zip file for the package in a Temp folder if required
1. Moves the zip file into the Registry, either via HTTP or directly.
1. Updates the Registry index in case it's a local Registry

`⍵` must be a two-item vector:

1. `source` → folder to create the package from
1. `registry` → registry to publish the package to (alias or url)

Note that if `⍵[1]` points already to a ZIP file only steps 3 and 4 are performed.

In case a folder is specified rather than a ZIP file then `PublishPackage` tries to establish whether the package depends on other packages. This is done by the API function `BuildPackage`, which is called by `PublishPackage` internally. 

The optional left argument `dependencies` is, when specified, passed as left argument to `BuildPackage`; see there for details.

The explicit result:

* `statusCode` is an HTTP code no matter whether it is an HTTP call or not
* `errMsg` is empty if `statusCode` is 200, otherwise it might carry additional information
* `zipFilename` is empty in case `source` is a ZIP file, otherwise it is the name of the ZIP file created

W> Note that the API function will publish the package no matter what the delete policy operated by the server is. 
W>
W> That is different from the user command which will ask the user for confirmation in case the user attempts to publish a package that cannot be deleted once published.

### ReInstallDependencies

```
{refs}←{parms} ReInstallDependencies (dependencies installFolder [Registry])
```

Re-installs all files in a given file `apl-dependencies.txt`.

Takes a folder that hosts a file `apl-dependencies.txt` as mandatory argument.

Optionally a second right argument might be specified: a Registry, either as a URL or an alias. Without this all known Registries with a priority greater than `0` will be scanned.

The file `apl-buildlist.json` as well as all directories in that folder will be deleted.
Then all packages listed in the file `apl-dependencies.txt` are re-installed from scratch. Lines in `apl-dependencies.txt` that start with a lamp character (`⍝`) are ignored.

Note that packages with different major version numbers are considered as different packages.

The left argument is optional and is, if specified, typically created by calling [`CreateReInstallParms`](#CreateReInstallParms).

It may carry three parameters:

* `noBetas`

   By default this is 0, meaning that beta versions are considered. Set this to 1 if you want betas to be ignored.

* `update`

  Defaults to 0, meaning that the same version is installed again even if a later version is available. Change this to 1 to force an update.

* `dry`

  Defaults to 0, meaning the function does business. Set this to 1 in order to get a report of what the function would do without actually doing it.

Notes:

* For every dependency this function performs a Registry scan, even if a Registry was specified.
* Packages that were installed from ZIP files are just re-installed from their ZIP files without further ado.

A> ### Registry scans
A>
A> Under certain circumstances Tatin performs a Registry scan: Tatin questions every Registry with a priority greater than 0 (highest priority number first) for hosting a particular package. The first hit wins. 
A>
A> For example, when `ReInstallDependencies` is called for all dependencies a Registry scan is performed.
A>
A> Note that when you installed a package from a Tatin Registry https://MyTatin.com and then later remove that Registry from your user settings, or set its priority to 0, effectively telling Tatin not to scan that Registry anymore, then `ReInstallDependencies` will **not** scan https://MyTatin.com  anymore, despite Tatin knowing perfectly well where the package in question was originally loaded from.

### ReadPackageConfigFile

```
cfg←ReadPackageConfigFile path
```

Takes a path to a package and returns the config file for that package as a namespace populated with variables.

`path` may or may not carry the filename (`apl-package.json`).

### UnInstallPackages

```
(list msg)←UnInstallPackage (packageID folder)
```

`UnInstallPackage` attempts to un-install the package `packageID` and all its dependencies, but the latter only in case they are neither principal packages nor required by other packages.

`folder` must host a Tatin dependency file. 

`folder` must be either a path or the (case independent) symbolic name `[MyUCMDs]` 

`[MyUCMDS]` would translate into `MyUCMDs/packages/`.

`packageID` might be a full package ID but also `<group>-<name>` or just `<name>`. However, in case more than one package qualifies an error is thrown.

Note that if `packageID` is empty a clean-up attempt is made.

`folder` may be a subfolder of an open Cider project. Tatin works out the correct one; if there are multiple Cider projects open the user is questioned.

`packageID` must be fully qualified: group + name + version.

If a package was installed with an alias you must un-install it by specifying the alias. 

If a package is installed twice, once with an alias and once without, running `]UnInstallPackage` on either of them does not uninstall the package but removes just the reference to it. Only when the other one is uninstalled as well is the package actually removed.

To keep things simple Tatin performs the following steps:
1. Checks whether the package ID is mentioned in the dependency file. If not an error is thrown
3. Removes `packagedID` from the dependency file
4. Re-compile the build list based on the new dependency file
5. Removes all packages that are not mentioned in the build list anymore

Returns a two-item vector:

1. List with the fully qualified names of all removed packages. Note that they might carry an alias.
2. Message, ideally empty. 
 
Note that removing the directories hosting the packages might fail for all sorts of reasons even
though the package and any dependencies were already successfully removed from both the dependency
file and the build list.


### Version              

```
r←Version
```

Returns "name", "version" and "date".























