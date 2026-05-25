---
title: 'Tatin & GitHub'
description: ''
keywords: 
---
# Tatin & GitHub


## Overview

Tatin is version controlled by Git and hosted on [GitHub](https://github.com).

There is no limit for accessing GitHub with a browser, but there are limits for what you can do when accessing GitHub via the API.


## GitHub's limit policy

GitHub has a fairly complex limit policy, which means that above a certain threshold further requests will be rejected for a period of time, typically one hour.

It is very unlikely that you will hit this limit if you are an ordinary Tatin user, because with a Tatin client, the only command that accesses GitHub via the API is `]TATIN.UpdateTatin`. With a Tatin server, it does not matter at all.

However, there might be circumstances where you hit this anyway because other parts of your workflow also access GitHub. In this case you can overcome the limitation by specifying a [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens "Link to GitHub`s documentation").

You can save the personal access token in the Tatin client folder in a file named `GitHub-personal-token.txt`, and the problem is solved. To be precise, there are still restrictions, but they are so relaxed that they will only affect the bad guys.

