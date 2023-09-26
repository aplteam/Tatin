[parm]:leanpubExtensions = 1
[parm]:title             = Tatin Installing and Updating
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3
[parm]:numberHeaders     = 2 3 4 5 6


# Installing and Updating the Tatin Client

## Introduction

You don't need to worry about installing Tatin if you use version 19.0 of Dyalog: In 19.0 Tatin just needs to be activated.

In 18.0 and 18.2 you need to install Tatin yourself.

## Requirements

* Tatin needs a Unicode version of Dyalog

* Dyalog version 18.0 or better

* Link version 3.0.8 or better

Note that when you call `]Tatin.Init` Tatin will check whether those requirements are met.

## How to activate Tatin in 19.0

In order to activate Tatin, execute

```
]Activate -??
```

and follow the instructions that suit you best.


## How to install in 18.0 and 18.2

Instructions:

1. Download the latest release of the Tatin client from <https://github.com/aplteam/Tatin/releases>

2. Unzip it into one of the potential target folders

It's your choice whether to install in into a folder associated with a particular version or to the version agnostic folder, making it available to all suitable versions of Dyalog.

You must install into a folder `SatrtupSession/`. Where that folder lives depends on your operating system. The following examples are for 18.2 64-bit:


### Windows

```
C:\Users\<⎕AN>\Documents\Dyalog APL 18.2 Unicode Files\     ⍝ 32-bit
C:\Users\<⎕AN>\Documents\Dyalog APL-64 18.2 Unicode Files\  ⍝ 64-bit
C:\Users\<⎕AN>\Documents\Dyalog APL Files\                  ⍝ version agnostic
```

Once the folder `StartupSession/Tatin/` is in place, any newly started version of Dyalog comes with the user command `]Tatin.*`.


### Linux

```
/home/<⎕AN>/dyalog.182U32.files  ⍝ 32-bit
/home/<⎕AN>/dyalog.182U64.files  ⍝ 64-bit
/home/<⎕AN>/dyalog.files         ⍝ version agnostic
```

Note that your intended target directory might not exist yet.

Once the folder `StartupSession/Tatin/` is in place, any newly started version of Dyalog comes with the user command `]Tatin.*`.

### Mac OS

```
/Users/<⎕AN>/dyalog.182U32.files  ⍝ 32-bit
/Users/<⎕AN>/dyalog.182U64.files  ⍝ 64-bit
/Users/<⎕AN>/dyalog.files         ⍝ version agnostic
```

Note that your intended target directory might not exist yet.

Once the folder `StartupSession/Tatin/` is in place, any newly started version of Dyalog comes with the user command `]Tatin.*`.


I> Note that there is no point in having a function `Run.aplf` in place with 18.0 and 18.2: only in 19.0 did Dyalog add the feature the a function `Run.aplf` will be loaded and executed as part of Dyalog's bootstrapping procedure. In earlier versions such a function is loaded but not executed.


As a side effect of executing any of the Tatin user commands the Tatin API will become available via `⎕SE.Tatin`.

If you want the Tatin API to be available right from the start: this is discussed next.


## Initializing Tatin

As already mentioned, Tatin comes with a self-initializing feature: once installed, any suitable version of Dyalog will provide a list of the Tatin user commands once you enter:

```
      ]tatin -?
```

The script `Tatin.dyalog` is the interface between the Dyalog user command framework and the Tatin API.

When any of the Tatin user commands is executed it will check whether the API is already loaded. If it's not available yet, it will be loaded.


## On `setup.dyalog`



Now you might want the Tatin API to be around right from the start, so that you can invoke any of the Tatin API functions without first executing any of the Tatin user commands. 

I> What is the application for this? Well, you might want to have an automated build process available right from the start, for example.
I>
I> If you are not interested in this, or use 19.0 or later, skip this and carry on with "Updating Tatin".

The way to achieve that goal requires the introduction or modification of a file `setup.dyalog` in your `MyUCMDs/` folder. 

Where to find the `MyUCMDs/` folder depends on your operating system

* On Windows it's usually `C:\Users\{username}\Documents\`
* On Linux (including the PI) it is `/home/{username}/`
* On Mac OS it is `/Users/{username}/`

Note that only on Windows is the folder created as part of the installation routine. On other platform you must create the folder yourself.

A> ### How does `setup.dyalog` work?
A>
A> The magic behind this is that whenever an instance of Dyalog is fired up, it checks whether such a script exists. If that is the case it checks whether there is a function `Setup`. 
A>
A> If there is such a function then it is expected to be monadic; it will be executed automatically as part of the instantiating process of Dyalog APL.
A>
A> This can be used for many things like...
A>
A> * making changes to the session
A> * specifying function keys 
A> * loading stuff into `⎕SE`
A> 
A> In version 19.0 the `Run.aplf` function offers a better way to achieve that, probably rendering `setup.dyalog` superfluous.

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

    ∇  r←{current}GetProgramFilesFolder postFix;version;aplVersion;OS
      ⍝ Returns standard path for Dyalog's version-specific program files folder.\\
      ⍝ Works on all platforms but returns different results.\\
      ⍝ Under Windows typically:\\
      ⍝ `C:\Users\<⎕AN>\Documents\Dyalog APL[-64] 19.0 Unicode Files' ←→ GetMyUCMDsFolder
      ⍝ ⍺ is optional and defaults to 0, meaning the version-agnostic folder is returned.
      ⍝ If ⍺←1, the folder associated with the currently running version of Dyalog is returned.
       current←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'current'
       OS←3↑1⊃# ⎕WG'APLVersion'
       postFix←{(((~'/\'∊⍨⊃⍵)∧0≠≢⍵)/'/'),⍵}postFix
       aplVersion←# ⎕WG'APLVersion'
       :If current
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

Copy the functions `IfAtLeastVersion`, `GetProgramFilesFolder`, `AddPathToCmdDir` and `AutoLoadTatin` from above into your own `setup.dyalog` script and then make sure that `AutoLoadTatin` and `AddPathToCmdDir` are called from your `Setup` function.


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








