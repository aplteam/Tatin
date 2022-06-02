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
3. `-???` shows examples (for some commands)

If the third level is available then `-??` shows this at the bottom:

```
]{API-Function-name} -??? ⍝ Enter this for examples                                        
```


## The API

The API is established in `⎕SE.Tatin`. These are almost exclusively dfns that call a function in `⎕SE._Tatin`.

While `⎕SE._Tatin` holds all code required for Tatin's client side, `⎕SE.Tatin` holds  the public interface.



### CheckForLaterVersion

```
 r←{flags} CheckForLaterVersion path
```

Checks whether there are later versions available for the principal packages installed in `path`.

The optional left argument must, if specified, be an integer that may carry flags as a single integer:

|Value|Description
|-----|---------------------------------------------------------------------
|0    | No flag set, same as no argument at all
|1    | Major: should later major version be listed as well? Defaults to 0
|2    | Dependencies: should dependencies be checked as well? Defaults to 0
|3    | Both flags set

By default only minor and patch are part of the check. By specifying 1 as `major` you may change this default behaviour and list any later major versions instead.

Note that this function scans all known registries with a priority greater than zero.

Returns a matrix with five columns:

|Col  | Info
|-----| ----
|[;1] |Original package ID
|[;2] |Lastest package ID
|[;3] |Original URL
|[;4] |Flag; 1 means later version is available
|[;5] |URL the latest version was found but empty in case it's identical with [;3]


### ClearCache
```
(rc report)←ClearCache dummy
```

Clears the cache, meaning that all sub directories but `temp\` are removed from the folder `GetPathToPackageCache` points to.

### CreateReInstallParms 

```
r←CreateReInstallParms
```

Creates a namespace with default parameters; it can be passed as (optional) left argument to the [`ReInstallDependencies`](#ReInstallDependencies) function, in particular `noBetas`, `update` and `dry`.

### DeletePackage        

```
(statusCode errMsg)←DeletePackage uri
```

Deletes a package.

Whether deleting a package from a Tatin Registry is possible at all depends on the delete policy it operates, which is in turn determined by the INI setting `[CONFIG]DeletePackages`. See [`GetDeletePolicy`](#GetDeletePolicy).

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

### GetNoCachingFlag

```
flag←GetNoCachingFlag uri
```

Take a URI or an alias and tries to find that URI in the `MyUserSettings` instance.
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

Takes a folder (`⍵`) and initialises it so that it can be a package.

This means in particular to create the folder (although it might already exist) and to create a package config file with default settings or what `⍺` specifies: one can pass a config namespace as `⍺`, typically created by a call to [`InitPackageConfig`](#InitPackageConfig).

There must be no config file yet, otherwise an error is thrown.

### InitPackageConfig

```
cfg←InitPackageConfig y
```

Returns a namespace with default values useful for the function [`InitialisePackage`](#InitialisePackage).

`⍵` might be empty; then it is ignored. Alternatively it might be namespace with variables. If it is then this namespace will be merged. Any settings in that namespace take precedence.

### InstallPackages

```
r←{noBetas} InstallPackages (identifiers targetFolder)
```

Installs one or more packages (`identifiers` ) in `targetFolder`.

`identifiers` must be a simple character vector, specifying one or more comma-separated packages (items).

Items must be one of:

* an HTTP request for a package
* a ZIP file holding a package
* a folder holding a package (like file://C:\Temp\group-name-version\\)
* a path to a package in a registry (like [RegistryAlias]{group}-{name}-{major.minor.patch} or C:\MyReg\\{group}-{name}-{major.minor.patch})
* a package ID; Tatin will then attempt to find that package in the Registries defined in the Client's config file.

You may omit minor+patch or even major+minor+patch in order to install the latest version.

By default beta versions are considered in case the package ID is incomplete, but you can suppress them by passing 0 as `⍺`.

`r` is a nested vector of character vectors with the full names of all principle packages installed. The length will match the number of packages specified as `identifiers`.


### ListCache
```
mat←{fullpath} Listcache uri
```

Lists the contents of the Tatin package cache. Refers to the `MyUserSettings` instance of the class `UserSettings`.

`uri` might be empty of a specific domain:

* In case it is empty all packages of of all domains are listed
* In case it is a specific domain only packages of that domain are listed.

The optional left argument `fullpath` defaults to 0, when just domain names and package IDs are reported.
If it is 1 then the full paths are reported instead.

The result is a vector with as many items as there are domains represented in the cache with at least one package.
Each item is a two-element vector:

 * The first item holds the url of the domain
 * The second item holds a vector of char vectors with the package names

In case the cache is empty an empty vector is returned.

### ListPackages         

```
mat←{parms} ListPackages uri
```

`uri` must be one of:

* A path to an install folder, defined by the presence of a file `apl-buildlist.json`
* A path to a Registry and optionally a (possibly incomplete) package ID

#### Install folder

In case an install folder was specified a two-column matrix is returned:

|[;1] |Carries the package IS
|[;2] |Carries a star for principal packages

#### Registry

In case a Registry was specified by default all packages saved in that Registry are returned, aggregated by major versions, as a two-column matrix.

You may specify an incomplete package ID; then only matching packages are listed.

You may even specify just a package name, without a group name. That would not make a difference in case the name is only used once, but if it is used in several groups then all of them will be listed.

Returns a matrix with two columns.

|[;1] | Package name
|[;2] | Carries the number of major versions

Optionally `parms` can be specified. This must be a namespace that must contain the variables `group`, `tags` and `aggregate`.

* `group` may specify the group
* `tags` may specify one or more tags (simple comma-separated text vector)
* `aggregate` is a Boolean that defaults to 1.

These combinations are available:

* `uri` is empty and `aggregate` is 0:

   All packages are returned; the second column carries `⍬`

* `uri` is empty and `aggregate` is 1 (the default):

   All packages are returned with the number of major versions in `[;2]`

* `uri` specifies {group}-{name} and `aggregate` is 0:

   All versions of that package are returned
* `uri` specifies {group}-{name} and `aggregate` is 1:

   All major versions of that package are returned

   `[;2]` caries the number of versions of each major version

* `uri` specifies {group}-{name}-{major}; in this case `aggregate` is ignored:
   
  All versions (minor and patch) of that package are returned

* `uri` specifies {group}-{name}-{major}-{minor}; in this case `aggregate` is ignored:

  All patch versions of that package are returned

### ListRegistries       

```
r←ListRegistries type
```

List all registries defined in the Client's config file.

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

Note that the result of the API function and the user command differ.

### ListTags             

```
list←{parms} ListTags y
```

`y` might be the path to a Registry or a Registry alias (embraced by `[]`).

By default all tags of all packages are returned.

Optionally `⍺` can be specified. Must be a namespace that might contain a variable `tags` which
may specify one or more tags (simple comma-separated text vector). If that is the case only
the tags shared by the packages that carry all of the specified tags.

### ListVersions         

```
mat←{dateFlag} ListVersions uri
```

`uri` is one of:

* A package name
* A group name and a package name
* A URL pointing to a Registry together with a package name and possible also a group name
* An alias pointing to a Registry together with a package name and possible also a group name
* A path to a Registry and "group" and "name" of a package

In the first and second case all defined Registries with a priority greater than zero are scanned. A matrix with two columns is returned: URL and full package ID.

If a URL or an alias was specified the given Registry is scanned. A matrix with one column with full package IDs is returned.

You may omit the group name; that does not make a difference when the name is used only within one group anyway, but if it is used in more than one group, then all of them are listed.

The package ID must not specify a version number.

By default the publishing date is not included, but you may change this by passing a 1 as `⍺`. In that case an additional column is added to the result.

### LoadDependencies     

```
{r}←LoadDependencies y
```

Requires two arguments:

* A folder with a build list (mandatory)
* A target namespace

You may specify an optional third argument: the `overwriteFlag` flag which defaults to 0.

Use `overwriteFlag` in case all packages should be loaded even if they already exist in `(#|⎕SE)._tatin`

Loads all packages and injects required references into `targetSpace`.

Returns a vector with references to the loaded packages (no dependencies, principal packages only).

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

Loads the package(s) into `(#|⎕SE)._tatin.{packageName}` and establishes a reference pointing to it in `targetSpace`

Loads all dependencies, if any, as well into `(#|⎕SE)._tatin` but _not_ into `targetSpace`.

By default beta versions are considered in case the package ID is incomplete, but you can suppress them by passing 1 as `⍺`.

Returns the number of packages installed, including dependencies.

### Pack                 

```
zipFilename←Pack (projectPath targetPath)
```

projectPath:

: folder to create a package from

targetPath:

: folder the package goes into

### Ping                 

```
bool←Ping uri
```

Establishes whether the host is up and running with very little overhead. If `uri` (can also be an alias) points to a folder a 1 is returned if that folder exists, otherwise 0.

### PublishPackage       

```
{(statusCode errMsg zipFilename)}←PublishPackage (source registry)
```

Publishes a package.

1. Checks for uniqueness of the given package/version combination.
2. Creates a dependency file for the package if required
3. Creates a zip file for the package in a Temp folder if required
4. Moves the zip file into the Registry, either via HTTP or directly.
5. Updates the Registry index in case it's a local Registry

Note that if `⍵` points already to a ZIP file only steps 4 and 5 are performed.

`⍵` must be a two-item vector:

1. `source` → folder to create package from
2. `registry` → registry to publish the package to (alias or uri)

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

Takes a folder that hosts a file apl-dependencies.txt as mandatory argument.

The file apl-buildlist.json as well as all directories in that folder will be deleted.
Then all packages listed in the file apl-dependencies.txt are re-installed from scratch.

Note that packages with different major version numbers are considered to be different packages.

By default all known Registries with a priority greater than 0 are scanned, but you may
specify a particular Registry as a third (optional) argument.

The left argument is optional and is, if specified, typically created by calling [`CreateReInstallParms`](#CreateReInstallParms).

It may carry three parameters:

* `noBetas`

   By default this is 0, meaning that beta versions are considered. Set to 1 if you want betas to be ignored.

* `update`

  Defaults to 0, meaning that the same version is installed again even if a later version is available now. Change to 1 to force an update.

* `dry`

  Defaults to 0, meaning the function does business. Set this to 1 in order to get a report of what the function would do without actually doing it.

Note that packages that were installed from ZIP files are just re-installed from their ZIP files.

### ReadPackageConfigFile

```
cfg←ReadPackageConfigFile path
```

Takes a path to a package and returns the config file for that package as a namespace populated with variables.

`path` may or may not carry the filename.

### UnInstallPackages

```
(list msg)←UnInstallPackage (packageID folder)
```

`folder` must carry a Tatin dependency file. 

`UnInstallPackage` attempts to un-install the package `packageID` and all its dependencies, but he latter only in case they are neither principal packages nor required by other packages.

`packageID` might be a full package ID but also <group>-<name> or just <name>. However, in case. In case more than one package qualify an error is thrown.

Note that if `packageID` is empty a clean-up attempt is made.

`folder` may be a sub folder of an open Cider project. Tatin works out the correct one; if there are multiple Cider projects open the user is questioned.

`packageID` must be fully qualified: group + name + version.

If a package was installed with an alias you must un-install it by specifying the alias. 

If a package is installed twice, once with an alias and once without, running `]UnInstallPackage` on either of them does not really un-install the package but removes just the reference to it. Only when the other one is un-installed as well is the package actually removed.

To keep things simple Tatin performs the following steps:
1. Checks whether the package ID is mentioned in the dependency file. If not an error is thrown.
3. Removes `packagedID` from the dependency file.
4. Re-compiles the build list based on the new dependency file.
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