# Copy Registry

## Why / what for

There are at least two cases when a user command `]CopyRegistry` is needed:

* In case access to `https://tatin.dev` is restricted in a company by firewall rules.

* One wants to have access to the data of the principal Tatin registry without Internet access.

In both cases it makes sense to copy the data from https://tatin.dev to a local disk. It also makes perfect sense to syncronize every now and then.


## Syntax

```
]CopyRegistry <url> <path> -full -sync -group=
```

`url`: Must be the URL of the Registry data is going to be copied from. Might be an alias like `[tatin]`. The Registry must be managed by a Tatin Server.

`path`: Path to the folder that holds the data of a Tatin Registry. You are advised to stop the server before `]CopyRegistry` is executed, and restart it after.


## Details

### Copy data

#### The default

In order to copy everything from the principal Tatin registry:

```
]CopyRegistry [tatin]
```

By default this will copy the best version of every major version of all packages except those that are deprecated.

#### The `-full` flag

If you want to copy all versions of all packages, specify the `-full` flag. However, note that deprecated packages are never copied over.

#### The `-sync` flag

If you have once copied a Registry, and now just want to get all new packages and the latest versions of packages you already got, specify the `-sync` flag.

#### The `-group=` option

In case you want to copy only packages of a specific group, you may set this option, for example:

```
]CopyRegistry [tatin] /path/2/Registry/data -sync -group=dyalog
```

