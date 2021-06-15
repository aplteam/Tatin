# Tatin Road Map


## Dropping packages

First and foremost the INI entry "DeletePackages" deccides which strategy a server might follow:

* Allow dropping any packages
* Disallow dropping _any_ packages
* Allow dropping only versions with a major number 0 - early betas
* Allow dropping any betas: anything that carries something after the minor number

In any case dropping means "moving of the Registry", so nothing will ever be deleted.

## Uninstalling packages

We need an API function `Tatin.UninstallPackage` and the corresponding user command `]TATIN.UninstallPackage` in the long run.


Got this from Gil:

> Btw, I was thinking about the uninstall package feature. Presumably you would need to rebuild the dependency tree on all actions (install/upgrade/unistall), right? 
>
> An upgrade of a dependency might trigger an upgrade/downgrade/removal of transient dependencies. In terms of whether or not to remove unused files from the target folder, that could be left as a separate action or parameter.

The rebuild needs to be smart! If something got updated to a better version by being requested, and then the package disappears that requested that better version, then we still want to keep the better version.

## Enforce usage of a particular version

If I learn that my package `Foo` needs `Boo 1.0` but `Goo` and `Zoo` are quite happy with --- and requests --- `Boo 1.1` then we currently do not have the means to make all three happy: everybody is expected to get along with `Boo 1.1`...

If `Foo` declares

```
aplteam-boo-1.0.0!
```

we could treat this as "I need `Boo 1.0.0`, no matter what!"


## `CheckForBetterVersions`

How does it compare these three versions:

```
boo-foo-2.0.0-beta
boo-foo-2.0.0-alpha
boo-foo-1.0.0
```

??

