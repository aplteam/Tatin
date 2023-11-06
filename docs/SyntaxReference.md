[parm]:title             = 'Tatin Syntax Reference'
[parm]:toc               = 2 3 
[parm]:collapsibleTOC    = 1
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

The API funcions are listed alphabetically.


### BuildPackage

```
zipFilename←BuildPackage parameterSpace
```

ZIPs all files that are required for a package and/or defined in the `apl-package.json` file  and (optionally) a dependency file from a given folder and creates a ZIP file containing these files in `targetPath`.

Requires a namespace with parameters as right argument, typically created by calling `CreateBuildParms` which requires a path to the project as right argument:

```
   parms←⎕SE.Cider.CreateBuildParms '/path/2/project`
   parms.⎕nl 2
dependencyFolder
projectPath     
targetPath      
version         

```

#### dependencyFolder

A folder with packages the project depends on. Might be empty, in case there are'nt any dependencies.

#### projectPath

The folder the package is going to be created from. To be specified as the right argument of `CreateBuildParms`.

#### targetPath

The folder the ZIP file is created in.

In case `targetPath` is empty it defaults to `projectPath`.


#### version

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

1. It checks whether the package is managed by Cider (read: has a file `cider.config`). If that is the case it checks the property `[CIDER]dependencies.tatin` in that file. If it defines a folder then it is taken.

   Refer to the Cider documentation on `dependencies.tatin` for details.

2. If the package is not managed by Cider then Tatin assumes that package dependencies (if any) would be installed into a subfolder packages/ (convention).

3. If there is no subfolder packages/, or if it does not host a file `apl-dependencies.txt`, then Tatin looks for a file `apl-dependencies.txt` in the root of the package project.

4. If the package is not managed by Cider and depends on packages that are installed in a different subfolder than packages/, then the name of the subfolder must be passed as `dependencyFolder` in the parameter space.

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

### CreateReInstallParms

```
r←CreateReInstallParms
```

Creates a namespace with default parameters; it can be passed as (optional) left argument to the [`ReInstallDependencies`](#ReInstallDependencies) function, in particular, `noBetas`, `update` and `dry`.

### DeletePackage

```
(statusCode errMsg)←DeletePackage uri
```

Deletes a package.

Whether deleting a package from a Tatin Registry is possible at all depends on the delete policy it operates, which is in turn determined by the INI setting `[CONFIG]DeletePackages`. See [`GetDeletePolicy`](#GetDeletePolicy).

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
* `[*]` for all defined Regiestries with a priority greater than 0
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
r←GetDeletePolicy uri
```

Takes a URI of a server like https://tatin.dev or an alias and returns the delete policy operated by that server.

Returns one of "None", "Any", "JustBetas":

* "None" means a package, once published, cannot be deleted                                
* "Any" means any package can be deleted                                                    
* "JustBetas" means that only beta versions can be deleted                                

### GetDependencyTree    

```
tree←GetDependencyTree x
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

### GetLicenses

```
r←{verbose} GetNoCachingFlag url
```

`verbose` defaults to 0 but might be 1.

* With `verbose←0` a list with the names of all licenses tolerated by the given managed Tatin Registry is returned. Might be empty.

* With `verbose←1` a matrix with two columns and zero or more rows is returned:

  * `[;1]` Names of all licenses 
  * `[;2]` URLs of all licenses


### GetNoCachingFlag

```
flag←GetNoCachingFlag uri
```

Takes a URI or an alias and tries to find that URI in the `MyUserSettings` instance.
If found the value of the `noCaching` property is returned. 

If URI is not found a 0 is returned.


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

Under Windows typically:

```
`C:\Users\%USERPROFILE%\AppData\Roaming\Tatin'     ←→ GetUserHomeFolder ''
`C:\Users\%USERPROFILE%\AppData\Roaming\Tatin\foo' ←→ GetUserHomeFolder 'foo'
```

On non-Windows platforms:

```
'/home/{⎕AN}/Tatin'     ←→ GetUserHomeFolder ''
'/home/{⎕AN}/Tatin/foo' ←→ GetUserHomeFolder 'foo'
```

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
cfg←InitPackageConfig y
```

Returns a namespace with default values useful for the function [`InitialisePackage`](#InitialisePackage).

`⍵` might be empty; then it is ignored. Alternatively, it might be a namespace with variables. If it is then the variables in that namespace overwrite the defaults.


### InstallPackages

```
r←{noBetas} InstallPackages (identifiers targetFolder)
```

Installs one or more packages (`identifiers` ) in `targetFolder`.

`identifiers` must be a simple character vector, specifying one or more comma-separated packages (items).

Each item must be one of:

* an HTTP request for a package
* a ZIP file holding a package
* a folder holding a package (like file://C:\Temp\group-name-version\\)
* a path to a package in a registry (like [RegistryAlias]{group}-{name}-{major.minor.patch} or C:\MyReg\\{group}-{name}-{major.minor.patch})
* a package ID; Tatin will then attempt to find that package in the Registries defined in the Client's config file.
* The internal alias `[MyUCMDs]` (case independent); this will then be replaced by the actual path to the `MyUCMDs/` folder followed by the name specified or, if none was specified, the name of the package`

You may omit minor+patch or even major+minor+patch in order to install the latest version.

By default beta versions are considered in case the package ID is incomplete, but you can suppress them by passing 0 as `⍺`.

`r` is a nested vector of character vectors with the full names of all principal packages installed. The length will match the number of packages specified as `identifiers`.

Notes:

* The target folder will be created if it does not already exist
* The package ID(s) might use any case, meaning that if the package's name is `foo-Goo-1.2.3` then you might as well spell it `foo-GOO-1.2.3` or `FOO-goo-1.2.3`: it would not make a difference 


### ListDeprecated

```
r←ListDeprecated uri
```

Lists all packages that are deprecated but only if they are the last published version of any given major version number.

This default behaviour can be changed with the `-all` flag: then all versions of any major version that is marked as deprecated are listed. 


`uri` must be one of:

* A path to an install folder, defined by the presence of a file `apl-buildlist.json`
* A path to a Registry and optionally a (possibly incomplete) package ID


### ListCache

```
r←{fullpath} Listcache uri
```

Lists the contents of the Tatin package cache. Refers to the `MyUserSettings` instance of the class `UserSettings`.

`uri` might be empty or a specific domain:

* In case it is empty all packages of all domains are listed
* In case it is a specific domain only packages of that domain are listed

The optional left argument `fullpath` defaults to 0, when just domain names and package IDs are reported. If it is 1 then the full paths are reported instead.

The result is a vector with as many items as there are domains represented in the cache with at least one package.
Each item is a two-element vector:

 * The first item holds the url of the domain
 * The second item holds a vector of char vectors with the package names

In case the cache is empty an empty vector is returned.

### ListPackages         

```
mat←{parms} ListPackages uri
```

Lists all packages of a given Registry except when the last package of a major version number is marked as deprecated --- see `ListDepreciated` for details.

`uri` must be one of:

* A path to an install folder, defined by the presence of a file `apl-buildlist.json`
* A path to a Registry and optionally a (possibly incomplete) package ID


#### Right argument

##### Install folder

In case an install folder was specified a two-column matrix is returned:

|[;1] |Carries the package ID
|[;2] |Carries a star for principal packages

##### Registry

In case a Registry was specified by default all packages saved in that Registry are returned, aggregated by major versions, as a two-column matrix.

You may specify an incomplete package ID; then only matching packages are listed.

You may even specify just a package name, without a group name. That would not make a difference in case the name is only used once, but if it is used in several groups then all of them will be listed.


##### uri

* `uri` is empty and `aggregate` is 1 (the default):

  All packages are returned with the number of major versions in `[;2]`

* `uri` is empty and `aggregate` is 0:

  All packages are returned; the second column carries `⍬`

* `uri` specifies {name} and `aggregate` is 0:

  All packages that match `name` are returned; they might belong to different groups

* `uri` specifies {group}-{name} and `aggregate` is 0:

  All versions of that package are returned

* `uri` specifies {group}-{name} and `aggregate` is 1:

  All major versions of that package are returned

  `[;2]` carries the number of versions of each major version

* `uri` specifies {group}-{name}-{major}; in this case `aggregate` is ignored:
   
  All versions (minor and patch) of that package are returned

* `uri` specifies {group}-{name}-{major}-{minor}; in this case `aggregate` is ignored:

  All patch versions of that package are returned

#### Left argument

Optionally `parms` can be specified. If specified this must be a namespace that must contain the variables `group`, `tags` and `aggregate`. It may contain `date`, `since`, `project_url` and/or `userCommand`.

The following parameters allow the user to select certain packages:

* Use `group` to specify the group.
* Use `tags` to specify one or more tags (simple comma-separated text vector); is case-independent.
* `userCommand`, if specified, must be a Boolean. If it is 1 only packages that are user commands are returned.
* Use `since` to specify a date; all packages published before that date will be ignored.

  `since` can be one of:

   * A character vector in the format `YYYY-MM-DD` or `YYYYMMDD` like `since←'2022-06-01'`
   * An integer in the format `YYYYMMDD` like like `since←20220601`

The following parameters allow the user to influence what data is returned:

* If `date` is `1` an additional column is added to the result with the publishing date
* If `project_url` is `1` an additional column is added to the result with the `project_url`, if any
* If `aggregate` is `0` the data is not aggregated by minor and patch number; defaults to 1.

#### Result

Returns a matrix with at least two and up to four columns. These columns are always returned:

|[;1] | Package name |
|[;2] | Carries the number of major versions |


In case `date` was specified, the result has one more column carrying the publishing date.

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
|[;3] | Port
|[;4] | Priority
|[;5] | No-caching flag
|[;6] | API key

"type" must be either 0 or 1 or empty:

* 1 means all data is listed
* 0 means the API key is not listed

Notes:

* The result of the API function and the user command differ

* When a Tatin Server is questioned by `ListRegistries` but does not respond an error is thrown.



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

`url` is one of:

* A package name
* A group name and a package name
* A URL pointing to a Registry together with a package name
* An alias pointing to a Registry together with a package name
* A (local) path to a Registry together with a package name

A package name may be either just the name or group and name. Additionally, you may either specify a major version number, or a major and a minor version number.

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
* `makeHomeRelative` influences the result of `HOME` and `GetFullPath2AssetsFolder`: rather then returning the full path only the folder holding the packages and its parent are returned, making it a relative path

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
* A folder holding a package (like file://C:/Temp/group-name-version)
* A path to a package in a registry (like [RegistryAlias]{packageID} or C:\MyReg\{packageID}')
* A package ID; Tatin will then attempt to find that package in one of the Registries defined in the
client's config file with a priority greater than 0.

  The first hit wins.

`targetSpace` must be a reference or a fully qualified name of an ordinary namespace, meaning the name must start with either `#` or `⎕SE`.

It might already exist, but if it doesn't it will be created. If it exists but is not an ordinary namespace an error is thrown.

Loads the package(s) into `(#|⎕SE)._tatin.{packageName}` and establishes a reference for every one of them in `targetSpace`

Loads all dependencies, if any, as well into `(#|⎕SE)._tatin` but does _not_ create references for them in `targetSpace`.

By default beta versions are considered in case the package ID is incomplete, but you can suppress them by passing 1 as `⍺`.

Returns the number of principal packages installed.

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

Note that if `⍵` points already to a ZIP file only steps 3 and 4 are performed.

`⍵` must be a two-item vector:

1. `source` → folder to create the package from
1. `registry` → registry to publish the package to (alias or url)



In case a folder is specified rather than a ZIP file then `PublishPackage` tries to establish whether the package depends on other packages. This is done by the API function `BuildPackage`, which is called by `PublishPackage` internally. 

The optional left argument `dependencies` is, when specified, passed as left argument to `BuildPackage`; see there for details.

The explicit result:

* `statusCode` is an HTTP code no matter whether it is an HTTP call or not.
* `errMsg` is empty if `statusCode` is 200, otherwise it might carry additional information.
* `zipFilename` is empty in case `source` is a ZIP file, otherwise it is the name of the ZIP file created.

W> Note that the API function will publish the package no matter what the delete policy operated by the server is. 
W>
W> That is different from the user command which will ask the user for confirmation in case the user attempts to publish a package that cannot be deleted once published.

### ReInstallDependencies

```
{refs}←{parms} ReInstallDependencies (dependencies installFolder [Registry])
```

Re-installs all files in a given file `apl-dependencies.txt`.

Takes a folder that hosts a file `apl-dependencies.txt` as mandatory argument.

The file apl-buildlist.json as well as all directories in that folder will be deleted.
Then all packages listed in the file apl-dependencies.txt are re-installed from scratch. Lines in apl-dependencies.txt that start with a lamp character (`⍝`) are ignored.

Note that packages with different major version numbers are considered as different packages.

By default all known Registries with a priority greater than 0 are scanned (highest priority number first), but you may specify a particular Registry as a third (optional) argument.

The left argument is optional and is, if specified, typically created by calling [`CreateReInstallParms`](#CreateReInstallParms).

It may carry three parameters:

* `noBetas`

   By default this is 0, meaning that beta versions are considered. Set this to 1 if you want betas to be ignored.

* `update`

  Defaults to 0, meaning that the same version is installed again even if a later version is available. Change this to 1 to force an update.

* `dry`

  Defaults to 0, meaning the function does business. Set this to 1 in order to get a report of what the function would do without actually doing it.

Notes:

* For every dependency this function performs a Registry scan
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

`packageID` might be a full package ID but also <group>-<name> or just <name>. However, in case more than one package qualify an error is thrown.

Note that if `packageID` is empty a clean-up attempt is made.

`folder` may be a subfolder of an open Cider project. Tatin works out the correct one; if there are multiple Cider projects open the user is questioned.

`packageID` must be fully qualified: group + name + version.

If a package was installed with an alias you must un-install it by specifying the alias. 

If a package is installed twice, once with an alias and once without, running `]UnInstallPackage` on either of them does not uninstall the package but removes just the reference to it. Only when the other one is uninstalled as well is the package actually removed.

To keep things simple Tatin performs the following steps:
1. Checks whether the package ID is mentioned in the dependency file. If not an error is thrown.
3. Removes `packagedID` from the dependency file.
4. Re-compile the build list based on the new dependency file.
5. Removes all packages that are not mentioned in the build list anymore.

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



