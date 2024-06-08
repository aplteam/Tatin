# Copy Registry

## Why / what for

There are at least two scenarios when a user command `]CopyRegistry` is needed:

* In case access to `https://tatin.dev` is restricted in a company by firewall rules
* One wants to have access to the data of the principal Tatin registry without Internet access
In both cases, copying the data from https://tatin.dev to a local disk makes sense. It also makes perfect sense to synchronize occasionally.
`CopyRegistry` requires a Tatin server to run on the "from" Registry but not on the "to" Registry. When a Tatin server manages the "to" Registry, you are advised to pause it during the execution of `CopyRegistry`.
`CopyRegistry` copies just packages but no meta data.

## Syntax

```
]CopyRegistry <url> <path> -full -sync -dry -group=
```

`URL`: This must be the URL of the Registry from which the packages will be copied. It might be an alias like `[tatin]`. The Registry must be managed by a Tatin Server.

`path`: Path to the folder that holds the data of a Tatin Registry. You are advised to stop the server before `]CopyRegistry` is executed and restart it afterwards.

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
