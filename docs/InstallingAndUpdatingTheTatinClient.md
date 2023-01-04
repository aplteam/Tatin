[parm]:leanpubExtensions = 1
[parm]:title             = Tatin Installing and Updating
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3
[parm]:numberHeaders     = 2 3 4 5 6


# Installing and Updating the Tatin Client

## Introduction

You don't need to worry about installing Tatin if you use version 19.0 or later of Dyalog: Tatin will be available in `⎕SE` after a standard installation anyway.

However, installing and updating is, as far as the Tatin client is concerned, the same thing, because updating the Tatin client means removing the old version and installing a new one.

## Requirements

* Tatin needs a Unicode version of Dyalog

* Dyalog version 18.0 or better

* Link version 3.0.8 or better

Note that when you call `]Tatin.Init` Tatin will check whether those requirements are met.

## How to install the Tatin Client

Instructions:

1. Download the latest release of the Tatin client from <https://github.com/aplteam/Tatin/releases>

2. Unzip it into the `MyUCMDs/` folder --- there is now a folder `Tatin/`

W> You _must not_ install it into any other folder, even if that folder is scanned by Dyalog for user commands: that would not work.
W>
W> However, this might change with a later version.

Where to find the `MyUCMDs/` folder depends on your operating system, but this gives you the answer in any case:

```
⎕SE.Tatin.GetMyUCMDsFolder''
```

Note that this folder is created by the Dyalog APL installer under Windows but it won't exist under Linux and Mac OS in versions before 19.0, so you need to create the folder yourself on non-Windows platform.

Any newly started instance of Dyalog 18.0 or later will now come with the Tatin user commands.

As a side effect of executing any of the Tatin user commands the Tatin API will become available via `⎕SE.Tatin`.

I> If you want the Tatin API to be available right from the start: this is discussed under "[Initializing Tatin](#)".

Putting Tatin into this folder has the benefit that it will be available in all suitable versions of Dyalog APL installed on your machine. It has the drawback that this is a user-specific folder.

Tatin requires version 18.0 Unicode or better, therefore the `]TATIN` user commands won't be listed in earlier versions of Dyalog or any Classic version.


## Initializing Tatin

As already mentioned, Tatin comes with a self-initializing feature: once installed any suitable version of Dyalog will provide a list of the Tatin user commands once you enter:

```
      ]tatin -?
```

The script `Tatin.dyalog` is the interface between the Dyalog user command framework and the Tatin API.

When any of the Tatin user commands is executed it will check whether the API is already loaded with:

```
0<⎕NC '⎕SE.Tatin'
```

If that's not the case it will...

  1. load the code into `⎕SE._Tatin`
  2. create a namespace `⎕SE.Tatin` 
  3. establish functions in `⎕SE.Tatin` that represents Tatin's API


## On `setup.dyalog`

Now you might want the Tatin API to be around right from the start, so that you can invoke any of the Tatin API functions without first executing any of the Tatin user commands. 

What is the application for this? Well, you might want to have an automated build process available right from the start, for example.

I> If you are not interested in this or use 19.0 or later, skip this and carry on with "Updating Tatin".


The way to achieve that goal requires the introduction or modification of a file `setup.dyalog` in your `MyUCMDs/` folder. Note that on non-Windows platforms the name of the file must be lowercase.

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

### There is no such script yet

Create one that looks like this:

```
:Namespace SetItUp

    ∇ {r}←Setup arg;⎕IO;⎕ML;dmx
      r←⍬
      ⎕IO←1 ⋄ ⎕ML←1
      :Trap ⎕SE.SALTUtils.DEBUG↓0
          ⎕←AutoloadTatin ⎕SE.SALTUtils.DEBUG
      :Else
          dmx←⎕DMX
          ⎕←'Setup.dyalog has a problem and was not executed successfully:'
          ⎕←↑'  '∘,¨dmx.DM
      :EndTrap
    ∇

    ∇ r←AutoloadTatin debug;wspath;path2Config
      r←0 0⍴''
      :Trap debug/0
          :If ~IfAtLeastVersion 18
              r←'Tatin not loaded: not compatible with this version of Dyalog'
          :ElseIf 80≠⎕DR' '              ⍝ Not in "Classic"
              r←'Tatin not loaded: not compatible with Classic'
          :Else
              ⎕SE.⎕EX¨'_Tatin' 'Tatin'
              wspath←GetMyUCMDsFolder '/Tatin/Client.dws'
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

      IfAtLeastVersion←{
      ⍝ ⍵ is supposed to be a number like 15 or 17.1, representing a version of Dyalog APL.
      ⍝ Returns a Boolean that is 1 only if the current version is at least as good.
          ⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'
      }

    ∇ r←{OS}GetMyUCMDsFolder add
      ⍝ Returns standard path for Dyalog's MyUCMDs folder.\\
      ⍝ Works on all platforms but returns different results.\\
      ⍝ Under Windows typically:\\
      ⍝ `C:\Users\{⎕AN}\Documents\MyUCMDs\Foo'  ←→ GetMyUCMDsFolder 'Foo'
      ⍝ ⍺ is optional and only specified by test cases: simulating different versions of the operating system.
       :If 0=⎕NC'OS'
           OS←##.APLTreeUtils2.GetOperatingSystem''
       :EndIf
       add←{(((~'/\'∊⍨⊃⍵)∧0≠≢⍵)/'/'),⍵}add
       :If 'Win'≡OS
           r←##.FilesAndDirs.ExpandPath(2⊃4070⌶0),'\..\MyUCMDs',add
       :Else
           r←(2 ⎕NQ'.' 'GetEnvironment' 'Home'),'/MyUCMDs',add
       :EndIf
    ∇

:EndNamespace
```

### There is already such a script

Copy the functions `IfAtLeastVersion`, `GetMyUCMDsFolder` and `AutoLoadTatin` from above into your own `setup.dyalog` script and then make sure that `AutoLoadTatin` is called from your `Setup` function.


## Updating Tatin

Although you _could_ update your Tatin client by repeating the steps listed under "How to install the Tatin client" there is an easier way to do this; just execute:

```
]Tatin.UpdateClient
````

If there is a later version available all necessary steps will be executed; eventually the new version number will be reported.

Notes:

* The command will put the release notes on display

* This feature was introduced in 0.78.1, so it's not available in earlier versions

  The API equivalent `⎕SE.Tatin.Update 0` however was introduced in 0.78.0.

* Although Tatin is updated on disk, the workspace from which the command was executed is not for technical reasons --- start a new instance of Dyalog to get the latest version
