[parm]:title             = 'Tatin & GitHub'
[parm]:toc               = 3
[parm]:collapsibleTOC    = 1
[parm]:leanpubExtensions = 1
[parm]:numberHeaders     = 2 3 4 5 6




# Tatin & GitHub


## Overview

Tatin is version controlled by Git and hosted on [GitHub](https://github.com), at the time of writing the largest open source hosting platform in the world.



## GitHub's limit policy

GitHub has a fairly complex limit policy, which means that above a certain threshold further requests will be rejected for a period of time, typically one hour.

It is very unlikely that you will hit this limit if you are an ordinary Tatin user, because with a Tatin client the only command that involves GitHub is `]TATIN.UpdateTatin` while with a Tatin server it does not matter at all.

However, there might be circumstances where you hit this anyway because other parts of your workflow also hit GitHub. In this case you can overcome the limitation by specifying a [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens "Link to GitHub`s documentation").

You can then save the personal access token in the Tatin client folder in a file "GitHub-personal-token.txt" and the problem is solved. To be precise, there are still restrictions, but they are so high that they should only affect the bad guys.