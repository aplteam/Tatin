[parm]:numberHeaders = 2 3 4 5 6
[parm]:title         = 'CopyReg'
[parm]:toc           = 2 3 4 5


# Copy Registry

## History

2024-07-01

:This is a re-write with significant changes after the implementation of a rough prototype.

2024-07-01

: Parameter `noDeps` added
     

## Why / what for

There are at least two scenarios when a user command `]CopyRegistry` and its API equivalent are needed:

* In case access to `https://tatin.dev` is restricted in a company by firewall rules
* One wants to have access to the data of the principal Tatin registry without Internet access.

In both cases, copying the data from https://tatin.dev to a local disk makes sense. It also makes perfect sense to synchronize occasionally.

`CopyRegistry` requires a Tatin server to run on the "from" Registry but not on the "to" Registry. When a Tatin server manages the "to" Registry, you are advised to pause it during the execution of `CopyRegistry`.
`CopyRegistry` copies just packages but no meta data.

Note that dependencies are always copied as well in case the number of packages to be copied is reduced in any way excepts when `-noDeps` is specified.

## Syntax

```
]CopyRegistry [<url>] <path> -full -force -latest -group= -list= -dry 
```

`URL`

: This must be the URL of the Registry from which the packages will be copied. It might be an alias like `[tatin]`. The Registry must be managed by a Tatin Server.

: If this is omitted, then it defaults to `[tatin]`.

`path`

: Path to the folder that holds the data of a Tatin Registry. 

: In case the Registry is managed you are advised to stop the server before executing `]CopyRegistry` (or its API equivalent), and restart it afterwards.


## Details

### Copy data

Note that deprecated packages are NEVER copied.

#### The default

Without specifying a Tatin server URL and any flags/options the command copies the latest version of every major version (if not already available in the target Registry) from the principal Tatin registry:

   ```
   ]CopyRegistry /path/2/Registry/data
   ```

If instead you want to copy just the highest major version of all packages from a company Registry:

   ```
   ]CopyRegistry [my-company] /path/2/Registry/data -latest
   ```

#### The `-full` flag

If you want to copy ALL versions of ALL packages, specify the `-full` flag. 

Note that `-latest` and `-full` are mutually exclusive.

#### The `-force` flag

By default packages that are already available in the target Registry are not copied. This can be changed with the `-force` flag.


#### The `-latest` option

When this option is specified, then only the hightest major version number of a package is copied.

Note that `-latest` and `-full` are mutually exclusive.


#### The `-group=` option

In case you want to copy only packages of a specific group, you may set this option, for example:

```
]CopyRegistry [tatin] /path/2/Registry/data -sync -group=dyalog
```

However, packages from other groups might still be copied eventually in case they are required as dependencies.


#### The `-list=` option

This can be used to specify a list of package IDs.

Packages can be specified in three different ways:

* With their full name, including the full version number
* By group name, package name and major version number
* Just by group name and package name

No matter which option you use, all packages in the list must be specified consistantly in the same way, otherwise an error is thrown.

You may use `⎕SE.Tatin.ListPackages` to produce a list of packages.


`-list=` can be one of:

* A comma-separated list of packages
* A path to a file that contains the list of packages to be copied; must start with `file://`
* The fully qualified name of a variable like `#.VarsName` or `⎕SE.VarsName`. Must then be either a  vector of text vectors or a simple text vector with comma-separated package IDs.

#### The `-dry` flag

Use this flag to prevent the user command as well as its API equivalent to actually do something: the API function would return a list of package IDs that would actually be copied, including required dependencies. The user command would print the list to `⎕SE`.

This is true even when `-list=` is specified. The resulting list might be different from what was specified on `-list=` for two reasons:

* Packages that are not available on the given Registry, or have been deprecated, are removed from the list
* Dependencies that are required by packages on the list but are not on the list themselves are added

#### The `-noDeps` flag

If this is specified no dependencies are added.

In real life it is hard to see an application for this, but it is useful for test cases.

That's the reason why this flag is not documented in the user command help.


## Additional REST command "SYNC"

In addition to the user command and its API eqivalent there should be a REST command "SYNC". 

This command would require one argument: the URL or alias of the managed Tatin Registry to copy from. 

It acts on the latest versions of all packages by default.

This would not accept any requests while "SYNC" is carried out, and re-create all meta-data after the copy operation, and then start handling requests again.

### Parameters

The following parameters might be specifid: 

|Name    |Default|
|--------|-------|
|`full`  |      0|
|`force` |      0|
|`latest`|      0|

### Authorization

The introduction of "SYNC" as a REST command obviously requires authorization, and the introduction of the concept of a superuser, because the currently implemented stuff authorizes a user to act on a certain group (or groups), not on the entire Registry.

However, it should be noted that the concept of a superuser is sooner or later very likely to be needed for other purposes anyway.

## Road Map

1. In a first step the user command and the API function will be implemented.

2. The REST command "SYNC" and its associated enhancement of the authorization concept is only going to be implemented when really needed, and after Dyalog gives the okay.



