[parm]:title             = 'Release Notes'
[parm]:toc               = 2
[parm]:collapsibleTOC    = 1
[parm]:leanpubExtensions = 1




# Release Notes

Tatin release notes contain information regarding actions that need to be executed before a new version can be used; this regards almost exclusively the server.

## Version 0.94.0 from 2023-04-28

**Important**: though this release is not exactly coming with a breaking change, it is something close to that: this version can only cooperate with Cider 0.25.0 or later!

That's because the Cider configuration property `tatinFolder` has been replaced by the two properties `dependencies.tatin` and `dependencies_dev.tatin`.

Aprt from using compatible versions of Cider and Tatin no user action is required because Cider inspects the config file and suggest an automated conversion whe `tatinFolder` is detected.

In addition Cider would also remove the now deprecated property `githubUsername` from the Cider config file.

Also, `UnInstallPackage` got renamed: it's now `UnInstallPackages` (plural!). This is true for both the API function and the user commands. Strictly speaking this is actually a breaking change though probably nobody is affected.

## Version 0.93.0 from 2023-04-18

No breaking changes, no user actions required.


## Version 0.92.0 from 2023-04-03

No breaking changes, but this version is required to overcome a Dyalog bug introduced in March 2023.

## Version 0.91.0 from 2023-03-21

* **Breaking change**: When a version number is passed to `BuildPackage` *with* a build number then this build number is accepted as  it is; formerly it was bumped.

* A version number must now contain exactly three dots used to part major, minor and patch number. A build ID must be marked by a `+`.


## Version 0.90.1 from 2023-03-11

No user actions required.


## Version 0.90.0 from 2023-02-27

This version comes with a number of breaking changes!

Syntax and behaviour of `LoadDependencies` as well as `]LoadDependencies` have changed: The default space a package is loaded into depends on the argument: usually it's `#` (as before), but it will be `⎕SE` in case `[MyUCMDs]` is specified. 

In addition the API function has changed in terms of its arguments.

* Behaviour of the user command has changed

## Version 0.89.0 from 2023-02-07

Affects only the server; there are no changes in the client.

**If you run a Tatin server then you must check your INI file!**

* The `Secure` property in the INI file now rules just the protocol the server is running: 1 makes it use https while a 0 makes it use http, though only when `port` is zero, which is usually the case

  This effects only the communication as such, **not** the protocol of the base tag.

* The `base` property now must define both the protocol and the domain name but not a specific port.

  This rolls back a change that was (wrongly) introduced with version 0.81.0

Note that this version will throw an error in case `base` does not define both protocol and domain name.


## Version 0.88.0 from 2023-02-06

* New INI category `[LICENSE]` added for licenses, see the INI template

* If the category `[LICENSE]` exists, the licenses accepted by the server are listed on the home page, otherwise that menu item will not show.

* Any attempt to publish a package without valid license information is rejected by the Tatin server in case licences are defined in the INI file

* The "assets" property was inconsistently defined. It now must be a single folder within the package.

* A new property `license` got introduced which on https://tatin.dev must point to one of the defined licenses.

  There is a maintenance function that will inject it into all existing packages and set it to "MIT". If you don't want that you must amend the function accordingly.

* A new property `isUserCommand` got introduced which is a Boolean

  There is a maintenance function that will inject this flag into all existing packages, deleting `userCommandScript` along the way. If `userCommandScript` is not empty, the contents will go on the new property "files", see next topic.

* A new property `files` got introduced. This can be empty, a single file or a comma-separated list of files names. They must be defined relative to the project.

  Such files are copied to the root of a package by `BuildPackage`. 

## Version 0.87.0 from 2023-02-01

No user actions required.

## Version 0.86.3 from 2023-01-31

No user actions required, just one important bug fix.

## Version 0.86.2 from 2023-01-29

No user actions required, just one important bug fix.


## Version 0.86.1 from 2023-01-27

No user actions required. Just two important bug fixes.

## Version 0.86.0 from 2023-01-26

No user actions required.

* New package property "userCommandScript" introduced
* The document "PublishingPackages.md" has a new sub chapter "User Command packages"
* Syntax change: `InstallPackages` now creates the target folder if it does not already exist
* `LoadDependencies` now understands `[MyUCMDs]` 
* `]InstallPackages` now understands `[MyUCMDs]` as target folder
* Server: The "Packages" page has an additional column: "UC" (user command)
* The User Command `]ListPackages` has an additional modifier: `-uc=`
* Bug fixes
  * `]PackageConfig -edit` caused an index error under some circumstances
  * `]PackageConfig` did not handle neither unknown registries nor unknown packages well

## Version 0.85.0 from 2023-01-09

This version comes with a potentially breaking change: the method Pack has been renamed to `BuildPackage`, and the user command `]Tatin.Pack` accordingly to `]Tatin.BuildPackage`.

The user command has an additional modifier `-version=`.

If you call the API function from you own code you must make changes.

Other changes:

* The API method `BuildPackage` requires three parameters as right argument, and accepts an optional
  left argument. This is different from `Pack`.
* The package parameter `lx` was not allowed to carry a dot. That was too restrictive, and the
  check has been removed.
* Check added to `]Tatin.UpdateTatin`: requires at least 20 MB WSSIZE

## Version 0.84.0 from 2023-01-06

No user actions required.

## Version 0.83.2 from 2023-01-03

No user actions required.

## Version 0.83.1 from 2023-01-03

No user actions required.

## Version 0.83.0 from 2022-12-26

No user actions required.

## Version 0.82.2 from 2022-12-19

No user actions required.

## Version 0.82.1 from 2022-12-19

**Client**

Executing a client maintenance file was buggy: it did not fetch packages in sub folders under some circumstances.

Make sure to execute `2022-12-19-MakePackageCompatibleWith_82_0.aplf` again to convert all packages correctly.
 
## Version 0.82.0 from 2022-12-25

**General**

This version comes with one potentially breaking change: the package property `info_url` was renamed to `project_url`.

This requires action for all packages that already exist, be it Client or Server

**Client**

This version comes with a new user command `]Tatin.Maintenance` and a file in the sub folder `Maintenance/`:

* `2022-12-19-MakePackageCompatibleWith_82_0.aplf`

Call the `]Tatin.Maintenance <path>` user command to execute this script so that in all packages found in `<path>` the name `info_url` is changed to `project_url`.

This will also attempt to update any ZIP files as long as they are siblings of a file `apl-package.json`.

**Server**

This version comes with a new maintenance file `Convert_InfoUrl_to_ProjectUrl.aplf` that will be executed once by the server. 

The file will rename the property `info_url` to `project_url` in all packages managed by the server. Because the script will be executed automatically by the server no action needs to be taken.

## Version 0.81.0 from 2022-12-12

**Server**

### The INI entry [CONFIG]base

This is a **Breaking Change**!

Until version 0.81.0 this was something like `https://tatin.dev` -- that's wrong!

The protocol and the port are both defined by their own properties in the INI file, to "base" should be just the domain name.

Therefore the INI entry must be checked and changed:

From `https://tatin.dev` to `tatin.dev`


### New INI property "[CONFIG]MaintenancePath"

With this version a new INI entry got introduced: `MaintenancePath`. This entry **must be added** to the INI file.

This defines a folder that is designed to contain `*.aplf` files. Such files are loaded by the server, the code is executed and then the file(s) are renamed from, say, `foo.aplf` to `foo.aplf.executed`.

The purpose is to provide an easy way to massage the data in the Registry. The original application was the need to polish tags for many packages.

`MaintenancePath` usually points to a path within the Server's own directory, so `{home}` can be used.

For example:

```
MaintenancePath='{home}\Maintenance\'
```

### New INI property [EMAIL]gatekeeper

`gatekeeper` was introduced in order to allow somebody to take care of newly published packages, in particular the tags.

It might be empty meaning that no actions will be taken. Instead it might be a vector of text vectors, each carrying an email address.

Whenever a package is deleted or published an email is send to the gatekeeper.