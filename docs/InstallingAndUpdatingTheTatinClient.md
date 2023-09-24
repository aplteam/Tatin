[parm]:leanpubExtensions = 1
[parm]:title             = Tatin Installing and Updating
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3
[parm]:numberHeaders     = 2 3 4 5 6


# Installing and Updating the Tatin Client

## Introduction

You don't need to worry about installing Tatin if you use version 19.0 of Dyalog: In 19.0 Tatin just needs to be activated.

In 18.0 and 18.2 you need to install Tatin youself.

## Requirements

* Tatin needs a Unicode version of Dyalog

* Dyalog version 18.0 or better

* Link version 3.0.8 or better

Note that when you call `]Tatin.Init` Tatin will check whether those requirements are met.

## How to activate Tatin in 19.0

In order to activate Tatin, the folder `[DYALOG]/Experimental/CiderTatin` needs to be copied into one of the following folders:

### Windows

```
C:\Users\<⎕AN>\Documents\Dyalog APL 19.0 Unicode Files\StartupSession\    ⍝ 32-bit
C:\Users\<⎕AN>\Documents\Dyalog APL-64 19.0 Unicode Files\StartupSession\ ⍝ 64-bit
C:\Users\<⎕AN>\Documents\Dyalog APL Files\StartupSession\                 ⍝ version agnostic
```

It's you choice whether you want to install in into a folder associated with a particular version or the version agnostic folder.

Once the folder `CiderTatin/` is in place, any newly started version of Dyalog comes with the user commands `]Tatin.*` as well as `]Cider.*`; the APIs are both available via `⎕SE.Tatin` and `⎕SE.Cider`.

### Linux

```
/home/<⎕AN>/dyalog.190U32.files ⍝ 32-bit
/home/<⎕AN>/dyalog.190U64.files ⍝ 64-bit
/home/<⎕AN>/dyalog.files        ⍝ version agnostic
```

Note that your intended target directory might not exist yet.

Once the folder `CiderTatin/` is in place, any newly started version of Dyalog comes with the user commands `]Tatin.*` as well as `]Cider.*`; the APIs are both available via `⎕SE.Tatin` and `⎕SE.Cider`.

### Mac OS

```
/Users/<⎕AN>/dyalog.190U32.files ⍝ 32-bit
/Users/<⎕AN>/dyalog.190U64.files ⍝ 64-bit
/Users/<⎕AN>/dyalog.files        ⍝ version agnostic
```

Note that your intended target directory might not exist yet.

Once the folder `CiderTatin/` is in place, any newly started version of Dyalog comes with the user commands `]Tatin.*` as well as `]Cider.*`; the APIs are both available via `⎕SE.Tatin` and `⎕SE.Cider`.

## How to install in 18.0 and 18.2

Instructions:

1. Download the latest release of the Tatin client from <https://github.com/aplteam/Tatin/releases>

2. Unzip it into one of the potential target folders

It's you choice whether to install in into a folder associated with a particular version or the version agnostic folder.


### Windows

```
C:\Users\<⎕AN>\Documents\Dyalog APL 19.0 Unicode Files\StartupSession\    ⍝ 32-bit
C:\Users\<⎕AN>\Documents\Dyalog APL-64 19.0 Unicode Files\StartupSession\ ⍝ 64-bit
C:\Users\<⎕AN>\Documents\Dyalog APL Files\StartupSession\                 ⍝ version agnostic
```

Once the folder `Tatin/` is in place, any newly started version of Dyalog comes with the user command `]Tatin.*`.

### Linux

```
/home/<⎕AN>/dyalog.190U32.files ⍝ 32-bit
/home/<⎕AN>/dyalog.190U64.files ⍝ 64-bit
/home/<⎕AN>/dyalog.files        ⍝ version agnostic
```

Note that your intended target directory might not exist yet.

Once the folder `Tatin/` is in place, any newly started version of Dyalog comes with the user command `]Tatin.*`.

### Mac OS

```
/Users/<⎕AN>/dyalog.190U32.files ⍝ 32-bit
/Users/<⎕AN>/dyalog.190U64.files ⍝ 64-bit
/Users/<⎕AN>/dyalog.files        ⍝ version agnostic
```

Note that your intended target directory might not exist yet.

Once the folder `Tatin/` is in place, any newly started version of Dyalog comes with the user command `]Tatin.*`.


I> Note that there is no point in having a function `Run.aplf` in place with 18.0 and 18.2: only in 19.0 did Dyalog add that feature. In earlier versions such a function is loaded but not executed.


As a side effect of executing any of the Tatin user commands the Tatin API will become available via `⎕SE.Tatin`.

I> If you want the Tatin API to be available right from the start: this is discussed under "[Initializing Tatin](#)".


## Initializing Tatin

As already mentioned, Tatin comes with a self-initializing feature: once installed, any suitable version of Dyalog will provide a list of the Tatin user commands once you enter:

```
      ]tatin -?
```

The script `Tatin.dyalog` is the interface between the Dyalog user command framework and the Tatin API.

When any of the Tatin user commands is executed it will check whether the API is already loaded. If it's not available yet, it will be loaded.


## On `setup.dyalog`

Now you might want the Tatin API to be around right from the start, so that you can invoke any of the Tatin API functions without first executing any of the Tatin user commands. 

What is the application for this? Well, you might want to have an automated build process available right from the start, for example.

I> If you are not interested in this or use 19.0 or later, skip this and carry on with "Updating Tatin".

The way to achieve that goal requires the introduction or modification of a file `setup.dyalog` in your `MyUCMDs/` folder. Note that on non-Windows platforms the name of the file must be lowercase.

Where to find the MyUCMDs/ folder depends on your operating system

* On Windows it's usually C:\Users\<username>\Documents\
* On Linux (including the PI) it is /home/<username>/
* On Mac OS it is /Users/<username>/

A> ### How does `setup.dyalog` work?
A>
A> The magic behind this is that whenever an instance of Dyalog is fired up it checks whether such a script exists. If that is the case it checks whether there is a function `Setup`. 
A>
A> If there is such a function then it is expected to be monadic; it will be executed automatically as part of the instantiating process of Dyalog APL.
A>
A> This can be used for many things like...
A>
A> * making changes to the session
A> * specifying function keys 
A> * loading stuff into `⎕SE`
A> 
A> In version 19.0 the `Run.aplf` function offers a better way to achieve that, rendering any `setup.dyalog` superfluous.

### There is no such script yet

Create one that looks like this:

```
:Namespace SetItUp

    ∇ {r}←Setup arg;⎕IO;⎕ML;dmx
      r←⍬
      ⎕IO←1 ⋄ ⎕ML←1
      :Trap ⎕SE.SALTUtils.DEBUG↓0
          ⎕←AutoloadTatin ⎕SE.SALTUtils.DEBUG
          ⎕←AddPathToCmdDir path
      :Else
          dmx←⎕DMX
          ⎕←'Setup.dyalog has a problem and was not executed successfully:'
          ⎕←↑'  '∘,¨dmx.DM
      :EndTrap
    ∇

    ∇ r←AutoloadTatin debug;wspath;path2Config
      r←0 0⍴''
      :Trap debug/0
          :If 0=⎕SE.⎕NC'_Tatin'  ⍝ In 19.0 it moste likely will already be there!
          :AndIf ~IfAtLeastVersion 18
              r←'Tatin not loaded: not compatible with this version of Dyalog'
          :ElseIf 80≠⎕DR' '              ⍝ Not in "Classic"
              r←'Tatin not loaded: not compatible with Classic'
          :Else
              ⎕SE.⎕EX¨'_Tatin' 'Tatin'
              wspath←GetProgramFilesFolder '/CiderTatin/Tatin/Client.dws'
              '_Tatin'⎕SE.⎕CY wspath
              path2Config←⊃⎕nparts ⎕SE._Tatin.Client.FindUserSettings ⎕AN
              'Create!'⎕SE._Tatin.Client.F.CheckPath path2Config
              'Tatin'⎕SE.⎕NS''
              path2Config ⎕SE._Tatin.Admin.EstablishClientInQuadSE ⍬
          :EndIf
      :Else
          r←'Attempt to load Tatin failed with ',⎕DMX.EM
      :EndTrap
    ∇

    ∇ r←AddPathToCmdDir path;res;sep;paths;qdmx
     ⍝ Make sure that SALT will find the Tatin user command
      r←0 0⍴''
      :Trap 0
          :If 'Win'≡3↑1⊃# ⎕WG'APLVersion'
              path←{'\'@(⍸'/'=⍵)⊣⍵}path
              res←{'\'@(⍸'/'=⍵)⊣⍵}⎕SE.SALT.Settings'cmddir'
              sep←';'
              paths←sep(≠⊆⊢)res
          :Else
              path←{'/'@(⍸'\'=⍵)⊣⍵}path
              res←{'/'@(⍸'\'=⍵)⊣⍵}⎕SE.SALT.Settings'cmddir'
              sep←':'
              paths←sep(≠⊆⊢)res
          :EndIf
          :If ~(⊂path)∊paths ⍝ Already known?
              {}⎕SE.SALT.Settings'cmddir ,',path,' -permanent'
          :EndIf
      :Else
          qdmx←⎕DMX
          ⎕←'Attempt to add <',path,' to the search paths for user commands failed (',qdmx.EM,', RC=',(⍕qdmx.EN),')' ⋄ →0
     :EndTrap
    ∇

      IfAtLeastVersion←{
      ⍝ ⍵ is supposed to be a number like 15 or 17.1, representing a version of Dyalog APL.
      ⍝ Returns a Boolean that is 1 only if the current version is at least as good.
          ⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'
      }

    ∇  r←{OS}GetProgramFilesFolder add;version;aplVersion
      ⍝ Returns standard path for Dyalog's version-specific program files folder.
      ⍝ Works on all platforms but returns different results.
      ⍝ Under Windows typically:
      ⍝ `C:\Users\<⎕AN>\Documents\Dyalog APL[-64] 19.0 Unicode Files'  ←→ GetMyUCMDsFolder
      ⍝ ⍺ is optional and only specified by test cases: simulating different operating systems.
       :If 0=⎕NC'OS'
           OS←3↑⊃# ⎕WG'APLVersion'
       :EndIf
       add←{(((~'/\'∊⍨⊃⍵)∧0≠≢⍵)/'/'),⍵}add
       aplVersion←# ⎕WG'APLVersion'
       :If OS≡'Win'
           version←((∨/'-64'⍷1⊃aplVersion)/'-64'),' ',({⍵/⍨2>+\⍵='.'}2⊃aplVersion),' ',(80=⎕DR' ')/'Unicode'
           r←(2 ⎕NQ #'GetEnvironment' 'USERPROFILE'),'\Documents\Dyalog APL',version,' Files',add
       :Else
           version←({'.'~⍨⍵/⍨2>+\⍵='.'}2⊃aplVersion),((80=⎕DR' ')/'U'),((1+∨/'-64'⍷1⊃aplVersion)⊃'32' '64')
           r←(⊃⎕SH'echo $HOME'),'/dyalog.',version,'.files',add
       :EndIf
      ∇

:EndNamespace
```

### There is already such a script

Copy the functions `IfAtLeastVersion`, `GetProgramFilesFolder` and `AutoLoadTatin` from above into your own `setup.dyalog` script and then make sure that `AutoLoadTatin` is called from your `Setup` function.


## Updating Tatin

Just execute:

```
]Tatin.UpdateTatin
````

If there is a later version available all necessary steps will be executed; eventually the new version number will be reported.

Notes:

* The command will put the release notes on display

* This feature was introduced in 0.78.1, so it's not available in earlier versions

  Note that the API equivalent `⎕SE.Tatin.Update 0` was introduced in 0.78.0.

* Although Tatin is updated on disk, the workspace from which the command was executed is not for technical reasons --- start a new instance of Dyalog to get the latest version




