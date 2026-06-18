---
title: "Development Workflow"
description: "Suggested workflow for developing and publishing Tatin packages across local, team, and corporate registries"
keywords: 
---
# Development workflow

!!! abstract "Suggested workflow for developing and publishing Tatin packages across local, team, and corporate registries"


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

You would then publish it on `[my-team]`. At the same time, you would either delete the package from `[my]` or set the registry's priority to zero so scans ignore it.

When all is good, publish the beta as a production release on the corporate server.
At the same time, you might delete the package from the Team server.
