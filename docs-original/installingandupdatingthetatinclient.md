---
title: 'Tatin: Installing & Updating'
description: ''
keywords: 
---
# Installing and Updating the Tatin Client

## Introduction

You don't need to worry about installing Tatin if you use version 19.0 of Dyalog: In 19.0 Tatin just needs to be activated with the `]activate` user command.

In 18.2 you need to install Tatin yourself.

## Requirements

* Tatin needs a Unicode version of Dyalog

* Dyalog version 18.2 or better

* Link version 3.0.8 or better

Note that when you call `]Tatin.Init`, Tatin will check whether those requirements are met.


## Installing Tatin

### 19.0

Strictly speaking it is not necessary to install Tatin for 19.0, because Tatin is part of a 19.0-installation. However, before it can be used it must be activated. That's because in 19.0 it is still experimental.

Note that activating is available in 19.0 only. Activating is not supported in 18.2.

In order to activate Tatin, execute

```
]Activate -??
```

and follow the instructions.

### Activating, deactivating, resetting, updating

#### Activating
Activating means to copy Tatin (and possibly Cider) from the Dyalog installation directory's sub folder `Experimental\CiderTatin\` to either a version specific folder (the default) or a version agnostic folder in your home directory, and to instruct the user command framework to scan the chosen directory for user commands.

Which folder that is exactly depends on the operating system:

```
⍝⍝⍝ Version specific

⍝ Windows
<HOME>\Documents\Dyalog APL-64 19.0 Unicode Files

⍝ Others
<HOME>/dyalog.190U64.files

⍝⍝⍝ Version agnostic

⍝ Windows
<HOME>\Documents\Dyalog APL Files

⍝ Others
<HOME>/dyalog.files

```
#### Deactivating
Deactivating means to remove Tatin (and possibly Cider) from that folder. It has its own user command:

```
]Deactivate [all|cider|tatin] [-versionagnostic]
```
#### Resetting
Resetting means to replace the current version by the one the installation originally came with.

This can be useful when you have updated Tatin with `]UpdateTatin` and then find the new version to be buggy.
#### Updating
Updating means that the version that is currently available is updated to the latest version available from GitHub.

This can be achieved with the user command `]UpdateTatin`.


### 18.2

Instructions:

1. Download the latest release of the Tatin client from <https://github.com/aplteam/Tatin/releases>

2. Unzipping the file will produce a subdirectory named `Tatin/` that you should then place in the appropriate installation folder discussed in a second


### What is the correct installation folder?
Tatin must be installed into one of these folders dependening on your OS:

Windows:
```
C:\Users\<⎕AN>\Documents\Dyalog APL[-64] <version> Unicode Files\SessionExtensions\CiderTatin
```

Linux:
```
/home/<⎕AN>/dyalog.<version>U<bit>.files/SessionExtensions/CiderTatin
```

Mac OS:
```
/Users/<⎕AN>/dyalog.<version>U<bit>.files/SessionExtensions/CiderTatin
```
However, these folders are version specific. Instead you might consider installing them into a version
agnostic folder in order to make Tatin available to several versions of Dyalog at the same time.

For that install into one of these folders:
```
⍝ Windows
C:\Users\<⎕AN>\Documents\Dyalog APL Files\SessionExtensions\CiderTatin

⍝ Linux
/home/<⎕AN>/dyalog.files/SessionExtensions/CiderTatin

⍝ Mac OS
/Users/<⎕AN>/dyalog.files/SessionExtensions/CiderTatin
```

As a result you should see something like this:

```
⍝ Windows
...\Dyalog APL[-64] <version> Unicode Files\SessionExtensions\CiderTatin\Tatin

⍝ Linux & Mac OS
.../dyalog.<version><bit>.files/SessionExtensions/CiderTatin/Tatin

```


#### Tell Dyalog where to look for user commands

Though Tatin's user command script etc. is now in place, Dyalog does not know about it yet. To achieve that we have to add the folder to SALT's search path. This step needs to be carried out only once for version 18.2

Execute one of the following commands:

!> ### Windows 
```
]SALT.Settings cmddir ",C:\Users\<⎕AN>\Documents\Dyalog APL-64 18.2 Unicode Files\SessionExtensions\CiderTatin" -p
  
!> ### Linux
```
]SALT.Settings cmddir ",/home/<⎕AN>/dyalog.182U64.files/SessionExtensions/CiderTatin -p

!> ###  Mac OS
```
]SALT.Settings cmddir ",/Users/<⎕AN>/dyalog.182U64.files/SessionExtensions/CiderTatin" -p
```

Notes: 

* Note the comma (`,`) in front of the path: it tells SALT to _add_ the path, rather than using it as a replacement
* The `-p` stands for "permanent"; this makes sure your addition to the search path is permanent
* In case you installed Tatin into a version-agnostic folder you must specify that folder of course


Any newly started instance of Dyalog now comes with the user command `]Tatin.*`.

There is no point in having a function `Run.aplf` in place with 8.2: only in 19.0 did Dyalog add the feature that a function `Run.aplf` will be loaded and executed as part of Dyalog's bootstrapping procedure; in earlier versions such a function is not executed.

As a side effect of executing any of the Tatin user commands the Tatin API will become available via `⎕SE.Tatin`.

If you want the Tatin API to be available right from the start: this is discussed soon.


## Initializing Tatin

Once installed, any suitable version of Dyalog will provide a list of the Tatin user commands once you enter:

```
      ]tatin -?
```

The script `Tatin.dyalog` is the interface between the Dyalog user command framework and the Tatin API.

When any of the Tatin user commands is executed, it will check whether the API is already loaded --- that will be the case in 19.0 once Tatin is activated. If it's not available yet (18.2), it will be loaded.


## On `setup.dyalog` (18.2)

I> This is 18.2 only because in later versions of Dyalog, Tatin's API will be available in `⎕SE` right from the start anyway.
I> 
I> You might want the Tatin API to be available right from the start in earlier versions of Dyalog as well, so that you can invoke any of the Tatin API functions without first executing a Tatin user command. 
I> 
I> What is the application for this? Well, you might want to have an automated build process available, for example.
I>
I> If you are not interested in this: skip it and carry on with [Updating Tatin](#).

The way to achieve this goal requires the introduction or modification of a file `setup.dyalog` in your `MyUCMDs/` folder. 

Where to find the `MyUCMDs/` folder depends on your operating system:

* On Windows it's usually `C:\Users\{username}\Documents\`
* On Linux (including the PI) it is `/home/{username}/`
* On Mac OS it is `/Users/{username}/`

Note that only on Windows is the folder created as part of the installation routine. On other platforms you must create the folder yourself.

### How does `setup.dyalog` work?

Whenever an instance of Dyalog is fired up, it checks whether such a script exists. If that is the case it checks whether there is a function `Setup` in the script. 

If there is such a function then it is expected to be monadic; it will be executed automatically as part of the instantiating process of Dyalog APL.

This can be used for many things like...

* making changes to the session
* specifying function keys 
* loading stuff into `⎕SE`

In version 19.0 the `Run.aplf` function offers a better way to achieve that, rendering `setup.dyalog` superfluous.

### There is no such script yet

Create one that looks like this:

```
:Namespace SetItUp

    ∇ {r}←Setup arg;⎕IO;⎕ML;dmx
      r←⍬
      ⎕IO←1 ⋄ ⎕ML←1
      :If ~IfAtLeastVersion 19
      :AndIf 0=≢⎕←AutoloadTatin ⎕SE.SALTUtils.DEBUG
          {}⎕SE.SALTUtils.ResetUCMDcache -1
      :EndIf
    ∇

    ∇ r←AutoloadTatin debug;wspath;path2Config
      r←0 0⍴''
      :Trap debug/0
          :If 0=⎕SE.⎕NC'_Tatin'  ⍝ In 19.0 it most likely will already be there!
              :If ~IfAtLeastVersion 18
                  r←'Tatin not loaded: not compatible with this version of Dyalog'
              :ElseIf 80≠⎕DR' '              ⍝ Not in "Classic"
                  r←'Tatin not loaded: not compatible with Classic'
              :Else
                  ⎕SE.⎕EX¨'_Tatin' 'Tatin'
                  wspath←1 GetProgramFilesFolder '/SessionExtensions/CiderTatin/Tatin/Client.dws'
                  '_Tatin'⎕SE.⎕CY wspath
                  path2Config←⊃⎕nparts ⎕SE._Tatin.Client.FindUserSettings ⎕AN
                  'Create!'⎕SE._Tatin.Client.F.CheckPath path2Config
                  'Tatin'⎕SE.⎕NS''
                  path2Config ⎕SE._Tatin.Admin.EstablishClientInQuadSE ⍬
              :EndIf
          :EndIf
      :Else
          r←'Attempt to load Tatin failed with ',⎕DMX.EM
      :EndTrap
    ∇

      IfAtLeastVersion←{
      ⍝ ⍵ is supposed to be a number like 15 or 17.1, representing a version of Dyalog APL.
      ⍝ Returns a Boolean that is 1 only if the current version is at least as good.
          ⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'
      }

    ∇ r←{versionAgnostic}GetProgramFilesFolder postFix;version;aplVersion;OS
      ⍝ Returns the path to Dyalog's version-specific program files folder.\\
      ⍝ Works on all platforms but returns different results.\\
      ⍝ Under Windows typically:\\
      ⍝ `C:\Users\<⎕AN>\Documents\Dyalog APL[-64] 19.0 Unicode Files' ←→ GetMyUCMDsFolder
      ⍝ ⍺ is optional and defaults to 0, meaning the version-agnostic folder is returned.
      ⍝ If ⍺←1, the folder associated with the currently running version of Dyalog is returned.
       versionAgnostic←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'versionAgnostic'
       OS←3↑1⊃# ⎕WG'APLVersion'
       postFix←{(((~'/\'∊⍨⊃⍵)∧0≠≢⍵)/'/'),⍵}postFix
       aplVersion←# ⎕WG'APLVersion'
       :If versionAgnostic
           :If OS≡'Win'
               version←((∨/'-64'⍷1⊃aplVersion)/'-64'),' ',({⍵/⍨2>+\⍵='.'}2⊃aplVersion),' ',(80=⎕DR' ')/'Unicode'
               r←(2 ⎕NQ #'GetEnvironment' 'USERPROFILE'),'\Documents\Dyalog APL',version,' Files',postFix
           :Else
               version←({'.'~⍨⍵/⍨2>+\⍵='.'}2⊃aplVersion),((80=⎕DR' ')/'U'),((1+∨/'-64'⍷1⊃aplVersion)⊃'32' '64')
               r←(⊃⎕SH'echo $HOME'),'/dyalog.',version,'.files',postFix
           :EndIf
       :Else
           :If OS≡'Win'
               r←(2 ⎕NQ #'GetEnvironment' 'USERPROFILE'),'\Documents\Dyalog APL Files',postFix
           :Else
               r←(⊃⎕SH'echo $HOME'),'/dyalog.files',postFix
           :EndIf
       :EndIf
   ∇

:EndNamespace
```

### There is already such a script

Copy the functions `IfAtLeastVersion`, `GetProgramFilesFolder` and `AutoLoadTatin` from above into your own `setup.dyalog` script and then make sure that `AutoLoadTatin` is called from your `Setup` function. 

Also, call `{}⎕SE.SALTUtils.ResetUCMDcache -1` in case `AutoLoadTatin` returned an empty vector (read: was executed successfully) in order to make sure that the Tatin user commands are found.

## Updating Tatin

You've installed (18.2) or activated (later than 18.2) Tatin before and want to update it to the latest version.

In that case you might need to perform some action, depending on how old your version of Tatin is.

### Tatin versions before 0.105.0

Versions before 0.105.0 might have been installed into one of these folders:

```
C:\Users\<user>\Documents\MyUCMDs\     ⍝ Windows
/users/<user>/MyUCMDs/                 ⍝ Mac-OS
/home/<user>/MyUCMDs/                  ⍝ Linux
```

If that is the case then, in order to keep things simple, you are advised to remove the folder `Tatin` from the `MyUCMDs/` folder and install Tatin (and, if installed, Cider) from scratch rather than updating it.

If have loaded Tatin into `⎕SE` with a script `setup.dyalog` you might need to make amendment to it.


### Tatin version 0.105.0 and later

Once you have Tatin 0.105.0 (or later) installed in the right place you can use `]Tatin.UpdateTatin` for updating Tatin to a later version.

Just execute:

```
]Tatin.UpdateTatin
````

All necessary steps will be executed; eventually the new version number will be reported.

Notes:

* The command will put the release notes on display in your default browser

* Although Tatin is updated on disk, the workspace from which the update command was executed is not updated for technical reasons --- start a new instance of Dyalog to get the latest version


* 19.0 and later only: Tatin's `Update` command overwrites the version in the installation directory in your home directory, not the version that came originally with Dyalog APL; that remains unchanged.


### When updating goes wrong

Debugging is the process of removing bugs from code, while programming is how you introduce them in the first place.

There is always the possibility that the update process is itself buggy. Calling it again usually does not help, so you need an escape route.



=== "18.2 "

    The easiest way to recover it by uninstalling and then installing Tatin again.

=== "19.0 and later"

    1. Execute `]DeActivate tatin` --- that removes Tatin
    2. Execute `]Activate tatin` --- that brings back the version of Tatin that your installation originally came with
    3. Execute `]Tatin.UpdateTatin` --- that will try to update to the latest version












