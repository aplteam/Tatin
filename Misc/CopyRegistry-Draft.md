# Copy Registry

## History

1. First draft created on 2024-06-17
2. Two amendments on 2024-06-28
   * Definition of `-list` enhanced: 
     * Might be a variable name as well
     * Definition of what might be specified clarified
   * Topic "Additional REST command "SYNC" added

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
]CopyRegistry <url> <path> -full -sync -dry -group= -list=
```

`URL`: This must be the URL of the Registry from which the packages will be copied. It might be an alias like `[tatin]`. The Registry must be managed by a Tatin Server.

`path`: Path to the folder that holds the data of a Tatin Registry. You are advised to stop the server before `]CopyRegistry` is executed, and restart it afterwards.

## Details

### Copy data

#### The default

To copy everything from the principal Tatin registry:

```
]CopyRegistry [tatin] /path/2/Registry/data
```

By default this will copy the best version of every major version of all packages except those that are deprecated.

#### The `-full` flag

If you want to copy all versions of all packages, specify the `-full` flag. However, note that deprecated packages are never copied over.

#### The `-sync` flag

If you have once copied a Registry and now just want to get all packages added since then and the latest versions of packages you already have, specify the `—sync` flag.

### The `-dry` flag

Use this flag for a report of what `CopyRegistry` would do without actually doing it.

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


## Additional REST command "SYNC"

In addition to the user command and its API eqivalent there should be a REST command "SYNC". 

This command would require one parameter: the URL of the managed Tatin Registry to copy from.

No other parameters are allowed/required then, and it always acts on all packages as if `-sync` was specified.

This obviously requires authorization, and the introduction of the concept of one or more super users, because the currently implemented stuff authorizes a user to act on a certain group (or groups), not on the entire Registry.




