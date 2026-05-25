---
title: 'Tatin: About Publishing'
description: 'Introduction to publishing and licensing Tatin packages, with suggested development workflow'
keywords: apl,development,licence,package,version,tatin,workflow
---
# About publishing packages

!!! abstract "About publishing and licensing Tatin packages, with a development workflow"


## :fontawesome-solid-address-card: Package identity

A full package ID uniquely identifes a package.
It follows [semantic versioning](glossary.md) conventions
and has four parts:

    group-name-version+buildnumber


### Group

A group might be

-   the name of a company
-   your name, even just your first name
-   a term such as `aplteam` (but not that one)

If you publish your package to the [Principal Registry](https://tatin.dev),
maintain a home page there for the group:
include anything useful like background, motivation, contact details, whatever.

Home pages do not always make sense for a group,
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

    major.minor.patch-[description]

e.g.:

    1.2.3-beta-1
    1.2.3-fix-for-the-foo-problem
    1.2.3-issue-234

The description can include hyphens, but not a `+`, which serves as a delimiter.


### Build number

An integer that gets bumped (incremented) with each version.

    1.2.3+453
    1.2.3-beta-1+911

Tatin bumps but otherwise largely ignores build numbers.
Their only use is to distinguish builds when the version number does not change.

In most contexts build numbers need not be specified and Tatin does not display them.


## :fontawesome-solid-scale-balanced: Licences

Tatin is a community resource and offers software with minimal licence restrictions.
All licences on the Principal Registry give users great freedom.

!!! info inline end ""

    If you host a Tatin registry you can [set your own licence policy](install-server.md#).

To publish a package on the Principal Registry at [tatin.dev](https://tatin.dev)
or on the [test server](https://test.tatin.dev)
you must give it a `license` property with an acceptable value.

:fontawesome-solid-terminal:
[`]ListLicences`](user-commands.md#list-licences)<br>
:fontawesome-solid-code:
[`ListLicences`](api.md#list-licences)


## :fontawesome-solid-key: API keys

To publish a package (or delete or deprecate it)
you need an API key[^apikey] for the registry.

[^apikey]: Fancy expression for a password used by an application.


!!! detail inline end ""

    :fontawesome-solid-envelope:
    [Request an API key](mailto:info@tatin.dev?subject=Request%20for%20an%20API%20key&body=Group%20name:%20%0D%0AMy%20name:%20%0D%0ACompany%20name:%20(if%20relevant)%0D%0AMaintainer%20email%20address:%20%0D%0A)

    Include

    -   Your desired group name (case insensitive)
    -   Your real name
    -   Company name, if relevant
    -   Maintainer’s email address

### Tatin Principal Registry

To publish on the Principal Registry at [tatin.dev](https://tatin.dev)
first request an API key.

When you receive it, create a home page for your group at the registry.
<!-- FIXME How? -->


### Tatin Test Server

The Test Server publishes its API key on its [website](https://test.tatin.dev): `Tatin-Test-API-Key`.

You can publish on the Test Server anything you want,
using any group name except `aplteam` or `dyalog`.

The Test Server is reset now and then,
and whatever you publish there disappears.


### Your keys

Your API keys are saved in your [user settings](user-settings.md).
The quickest and safest way to edit them is with the command.

:fontawesome-solid-terminal:
[`]TATIN.UserSettings -edit`](user-commands.md#user-settings)


## :fontawesome-solid-code-branch: Development workflow

Suppose you develop Tatin packages for your employer, company XYZ.

1.  Run a Tatin server on your **local** machine; give it alias `[my]`.

    This is just for you, nobody else. This is where you first publish a package.

    Give it the highest priority of all registries, ensuring that when a package is on several registries it is found first on `[my]`.

1.  Run a **team** Tatin Server on the XYZ intranet; give it alias `[my-team]`.

    Use it to publish beta versions your team might want to use. Give it the second-highest priority.

1.  Run a **corporate** Tatin Server for production packages.

1.  Your packages might depend on packages on `[tatin]`.
    Of the four Registries, give this the lowest priority.

1.  You might also have the Tatin Test Server in your user settings, with a priority of zero.
    It will be ignored when registries are scanned, but you could still use it.

You can now develop a package `Foo` and publish it on `[my]`, probably several times until it is stable.

You would then publish it on `[my-team]`. At the same time, you would either delete the package from `[my]` or set the registry’s priority to zero so scans ignore it.

When all is good, publish the beta as a production release on the corporate server.
At the same time, you might delete the package from the Team server.

