# Tatin Road Map


## Uninstalling packages

We need an API function `Tatin.UninstallPackage` and the corresponding user command `]TATIN.UninstallPackage` in the long run.


Got this from Gil:

> Btw, I was thinking about the uninstall package feature. Presumably you would need to rebuild the dependency tree on all actions (install/upgrade/unistall), right? 
>
> An upgrade of a dependency might trigger an upgrade/downgrade/removal of transient dependencies. In terms of whether or not to remove unused files from the target folder, that could be left as a separate action or parameter.

The rebuild needs to be smart! If something got updated to a better version by being requested, and then the package disappears that requested that better version, then we still want to keep the better version.


Implemented but the parameter is still needed.