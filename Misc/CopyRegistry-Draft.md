[parm]:numberHeaders = 2 3 4 5 6
[parm]:title         = 'CopyReg'
[parm]:toc           = 2 3 4 5


# Copy Registry

## History

1. First draft created on 2024-06-17
2. Two amendments on 2024-06-28
   * Definition of `-list` enhanced: 
     * Might be a variable name as well
     * Definition of what might be specified clarified
   * Topic "Additional REST command "SYNC" added
3. A number of amendments on 2024-06-29
   * One argument is enough: must be the target folder, `[tatin]` is assumes as source
   * `-sync` is now the default, therefore there is no need for this option anymore
     
     Instead there is now an option `-force` that makes sure that even packages are copied that are already available in the target Registry.

     This appears to be closer to what's needed in real life.
   * The (new) option `-last` can be used to make sure that only the latest version of the hightest major version of each package is copied.
   * The REST-command "SYNC" got parameters.

4. Road Map added
     

## Why / what for

There are at least two scenarios when a user command `]CopyRegistry` and its API equivalent are needed:

* In case access to `https://tatin.dev` is restricted in a company by firewall rules
* One wants to have access to the data of the principal Tatin registry without Internet access.

In both cases, copying the data from https://tatin.dev to a local disk makes sense. It also makes perfect sense to synchronize occasionally.

`CopyRegistry` requires a Tatin server to run on the "from" Registry but not on the "to" Registry. When a Tatin server manages the "to" Registry, you are advised to pause it during the execution of `CopyRegistry`.
`CopyRegistry` copies just packages but no meta data.

Note that dependencies are always copied as well in case the number of packages to be copied is reduced in any way.

## Syntax

```
]CopyRegistry [<url>] <path> -full -force -last -group= -list= -dry 
```

`URL`: This must be the URL of the Registry from which the packages will be copied. It might be an alias like `[tatin]`. The Registry must be managed by a Tatin Server.

`path`: Path to the folder that holds the data of a Tatin Registry. You are advised to stop the server before `]CopyRegistry` is executed, and restart it afterwards.

## Details

### Copy data

Note that deprecated packages are NEVER copied.

#### The default

Examples

1. Copy the latest version of every major version (if not already available in the target Registry) from the principal Tatin registry:

   ```
   ]CopyRegistry /path/2/Registry/data
   ```

2. Copy the highest major version of all packages from a company Registry, and re-install:

   ```
   ]CopyRegistry [my-company] /path/2/Registry/data -last
   ```

#### The `-full` flag

If you want to copy all versions of all packages, specify the `-full` flag. 

Note that `-last` and `-full` are mutually exclusive.

#### The `-force` flag

By default packages that are already available in the target Registry are not copied. This can be changed with the `-force` flag.


#### The `-last` option

When this option is specified, then only the hightest major version number of a package is copied.

Note that `-last` and `-full` are mutually exclusive.


#### The `-group=` option
In case you want to copy only packages of a specific group, you may set this option, for example:

```
]CopyRegistry [tatin] /path/2/Registry/data -sync -group=dyalog
```

Packages from other groups might still be copied in case they are required as dependencies.


#### The `-list=` option

This can be one of:

* A comma-separated list of packages with at least the group name and the package name
* A path to a file that contains the list of packages to be copied; must start with `file://`
* Point to a variable like `#.VarsName` or `⎕SE.VarsName`. Must then be either a  vector of text vectors or a simple text vector with comma-separated names

One might specify a package by...

* group name and package name 
* group name and package name and the major version number

Nothing else is accepted.

#### The `-dry` flag

Use this flag for a report of what `CopyRegistry` would do without actually doing it.


## Additional REST command "SYNC"

In addition to the user command and its API eqivalent there should be a REST command "SYNC". 

This command would require one argument: the URL or alias of the managed Tatin Registry to copy from. 

It acts on the latest versions of all packages by default.

### Parameters

The following parameters might be specifid: 

|Name   |Default|
|-------|-------|
|`full` |      0|
|`force`|      0|
|`last` |      0|

### Authorization

The introduction of "SYNC" as a REST command obviously requires authorization, and the introduction of the concept of a superuser, because the currently implemented stuff authorizes a user to act on a certain group (or groups), not on the entire Registry.


## Road Map

1. In a first step the user command and the API function will be implemented.

2. The REST command "SYNC" and its associated enhancement of the authorization concept is only going to be implemented when really needed, and after Dyalog gives the okay.

   However, it should be noted that the concept of a superuser is sooner or later very likely to be needed for other purposes as well.





