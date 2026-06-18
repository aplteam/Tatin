---
title: "Before You Publish"
description: "Package identity, licences, and API keys: what you need before publishing a Tatin package"
keywords: 
---
# Before you publish

!!! abstract "Package identity, licences, and API keys explained"


## Package identity

A full package ID uniquely identifies a package on a particular Tatin Registry.
The version number follows [semantic versioning](glossary.md) conventions
and has three or four parts, the build number being optional:

    group-name-version[+buildnumber]


### Group

A group might be

-   the name of a company
-   your name, even just your first name
-   a term such as `aplteam` (but not that one)

If you publish your package to the [Principal Registry](https://tatin.dev),
maintain a group home page there for the group:
include anything useful like background, motivation, contact details, whatever.

On other Tatin Registries, home pages may or may not make sense for a group,
so a home page needs activating; see `GroupHomePages` in the INI file.


### Package name

The package name should suggest what the package does.

The combination of group and name must be unique,
but if your package does something very similar,
you _could_ use a name already used by a different group.
Be cautious about this; the practice could become unhelpful.


### Version

The version consists of three numbers separated by dots,
optionally followed by a description.

    major.minor.patch[-description]

e.g.:

    1.2.3
    1.2.3-beta-1
    1.2.3-fix-for-the-foo-problem
    1.2.3-issue-234

The description can include hyphens, but not a `+`, which serves as a delimiter.


### Build number (optional)

An integer that gets bumped (incremented) with each build.

    1.2.3+453
    1.2.3-beta-1+911

Tatin bumps but otherwise largely ignores build numbers.
Their only use is to distinguish builds when the version number does not change.

In most contexts build numbers need not be specified and Tatin does not display them.


## Licences

Tatin is a community resource and offers software with minimal licence restrictions.
All licences on the Principal Registry give users great freedom.

!!! info inline end ""

    If you host a Tatin registry you can [set your own licence policy](install-server.md#license).

To publish a package on the Principal Registry at [tatin.dev](https://tatin.dev)
or on the [test server](https://test.tatin.dev)
you must give it a `license` property with an acceptable value.


[`]ListLicences`](user-commands.md#list-licences)<br>

[`ListLicences`](api.md#list-licences)


## API keys

To publish a package (or delete or deprecate it)
you need an API key[^apikey] for the registry.

[^apikey]: Fancy expression for a password used by an application.


!!! detail inline end ""

    
    [Request an API key](mailto:info@tatin.dev?subject=Request%20for%20an%20API%20key&body=Group%20name:%20%0D%0AMy%20name:%20%0D%0ACompany%20name:%20(if%20relevant)%0D%0AMaintainer%20email%20address:%20%0D%0A)

    Include

    -   Your desired group name (case insensitive)
    -   Your real name
    -   Company name, if relevant
    -   Maintainer’s email address

### Tatin Principal Registry

To publish on the Principal Registry at [tatin.dev](https://tatin.dev)
first request an API key.

When you receive it, create a home page for your group at the registry by visiting [the groups page](https://tatin.dev/v1/groups) and then clicking on the name of your group.


### Tatin Test Server

The Test Server publishes its API key on its [website](https://test.tatin.dev): `Tatin-Test-API-Key`.

You can publish on the Test Server anything you want,
using any group name except `aplteam` or `dyalog`.

The Test Server is reset now and then,
and whatever you publish there will eventually disappear.


### Your keys

Your API keys are saved in your [user settings](user-settings.md).
The quickest and safest way to edit them is with the command.


[`]TATIN.UserSettings -edit`](user-commands.md#user-settings)


