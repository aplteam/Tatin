---
title: "Tatin: Install client"
description: "How to install the Tatin client in Dyalog 18.2."
keywords: apl,dyalog,install,tatin
---
# Install the Tatin client

!!! abstract "How to install the Tatin client in Dyalog 18.2"

Tatin is included in Dyalog 19.0+; in Dyalog 18.2 it has to be installed.

## Requirements

* Dyalog 18.2 **Unicode**
* [Link](https://dyalog.github.io/link/4.0/) version 3.0.8 or better

`]TATIN.Init` checks the requirements are met.


## Download

Download the latest release of the Tatin client.


<https://github.com/aplteam/Tatin/releases>

Unzip the file and move folder `Tatin/` to the installation folder.


## Installation folder

The installation folder is at `<path>/SessionExtensions/CiderTatin`
where `path` is:


=== "Version-specific"

    These file paths are specific to Version 18.2:
    ```
    /home/<⎕AN>/dyalog.182U<bit>.files                          ⍝ Linux
    /Users/<⎕AN>/dyalog.182U64.files                            ⍝ macOS
    C:\Users\<⎕AN>\Documents\Dyalog APL[-64] 18.2 Unicode Files ⍝ Windows
    ```

=== "Version-agnostic"

    These file paths make Tatin available to all Dyalog versions:
    ```
    /home/<⎕AN>/dyalog.files                  ⍝ Linux
    /Users/<⎕AN>/dyalog.files                 ⍝ macOS
    C:\Users\<⎕AN>\Documents\Dyalog APL Files ⍝ Windows
    ```


## Enable Tatin user commands

Include the installation folder in SALT's search path.

    ]SALT.Settings cmddir ",<installation-folder>" -p

The comma tells SALT to _extend_ its path, not replace it.
The `-p` flag makes the change permanent.

Test for inline help: in a new Dyalog session enter

    ]tatin -?


## Enable the API

Executing any Tatin command enables the [API](api.md).

!!! detail "Dyalog 19.0+ enables the Tatin API automatically as part of its startup procedure."

An automated build process might need to enable the API 
without first executing a command.
You can do this with a `setup.dyalog` script in your `MyUCMDs/` folder.

Default locations for the `MyUCMDs/` folder:

    /home/{username}/               ⍝ Linux
    /Users/{username}/              ⍝ macOS
    C:\Users\{username}\Documents\  ⍝ Windows

The Windows installer creates this folder;
on other platforms, create it yourself.


### Setup scripts

At launch, Dyalog looks for a monadic `Setup` function in a `setup.dyalog` script in the `MyUCMDs/` folder.

In version 19.0+ the `Run.aplf` function offers a better way to achieve that, making `setup.dyalog` superfluous.


There is a model setup script available: [`setup.dyalog`](assets/setup.dyalog) 

If you already have a setup script:

-   Copy these functions from the model script:: `IfAtLeastVersion`, `GetProgramFilesFolder` and `AutoLoadTatin`
-   Ensure your `Setup` function calls `AutoLoadTatin` and, if it returns an empty vector (success), reset the command cache:

        {}⎕SE.SALTUtils.ResetUCMDcache -1
