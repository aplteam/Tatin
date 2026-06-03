---
title: 'Tatin: Caching'
description: ''
keywords: 
---
# Caching in Tatin


## Background

When a Tatin package and its dependencies are installed or loaded, it seems to be a good idea to save those packages in a machine-specific cache because obviously when the package is requested again, be it by the same user but for a different purpose or a different user, downloading should be avoided because it's already saved on the machine.

And that's exactly what Tatin does by default, with two exceptions:

1. Packages that are betas are never cached.

   The goal is to not clutter the cache with short-lived beta versions.

1. In case a server operates an "Any" delete policy, no packages of that registry will be cached.

   Once a package got deleted it should not be available anymore, neither from the registry itself nor from the cache.

   Note that we advise operating a "none" or "Betas-only" policy on non-local Tatin servers.

## Influencing caching

Caching can be influenced by setting particular parameters in `⎕SE.Tatin.MyUserSettings`, an instance of the `UserSettings` class, but also by setting particular parameters in the registries saved in the user settings.

These parameters allow you to...

* define the folder that hosts the cached packages

* toggle caching on a global level  

* disable caching for particular registries

Note that disabling caching in either way means that packages are neither written to nor read from the cache.


## Parameters

### In `MyUserSettings`

These parameters have global scope: they affect _all_ registries.


#### `caching`

This is a Boolean that defaults to 1. Settings this to 0 means no caching takes place: no reading from the cache, and no writing to the cache.


#### `path2cache`

There is no default, meaning that the folder that hosts cached packages depends on the operating system.

The function `GetPathToPackageCache` returns either the value of `MyUserSettings.path2cache` or the OS-specific default path if `path2cache` is empty.

This property's main purpose is to allow test cases using a temp folder: the tests should not temper with the default cache.


### Registries saved in the user settings

Adding a registry to the user settings requires...

* creating an instance of the `Define Registry` class 
* amended the properties of that instance
* add the instance with the `Add` method to `MyUserSettings`

One of the parameters of an instance of `DefineRegistry` is `noCaching`. This is a Boolean that defaults to 0, meaning that packages from that registry will be cached unless caching is switched off on a global level via `MyUserSettings.caching`.

If it is 1 instead then packages from that registry will never be cached. 

This is typically used when you have a local Tatin Server running, and you are fiddling with packages managed by that server.

## The user command `Cache`

The user command `]Tatin.Cache` helps manage the cache. It can be used to list the contents of the cache as well as to clear the cache.

Enter `]Tatin.Cache -??` for details.




