---
title: "GitHub rate limits"
description: "How GitHub API rate limits affect Tatin and how to work around them"
<!-- keywords: git, github, limit -->
---
# GitHub rate limits



!!! abstract "GitHub API rate limits can affect Tatin; here's how to work around them."

There is no limit for accessing [GitHub](https://github.com) with a browser, but there are limits for what you can do when accessing GitHub via its API.


## GitHub’s limit policy

GitHub has a fairly complex limit policy, which means that above a certain threshold, further requests will be rejected for a period of time, typically one hour.

It is very unlikely that an ordinary Tatin user could hit this limit, because with a Tatin client, the only command that accesses GitHub via the API is `UpdateTatin`. With a Tatin server, it does not matter at all.

However, there might be circumstances where you hit this anyway because other parts of your workflow also access GitHub. An example would be a test suite that accesses GitHub. If this runs several times, it might exhaust the limit.

You can overcome the limitation by specifying a [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens "Link to GitHub`s documentation") (PAT). Save the PAT in the Tatin client folder in a file named `GitHub-personal-token.txt`, and the problem is solved: the restrictions get relaxed to where they affect only abusers.

