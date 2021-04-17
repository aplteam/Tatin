[parm]:leanpubExtensions = 1
[parm]:title             = Tatin Installing and Updating



# Installing and Updating the Tatin Cleint

## Introduction

Note that you need to worry about this only if you use version 18.0 or 18.1: with later versions Tatin will be available in `⎕SE` after a standard installation anyway.

However, installing and updating is, as far as the Tatin client is concerned, _the same thing_, because updating the Tatin client basically means removing the old version and installing a new one.

## How to install the Tatin Client

Instructions:

1. Download the latest release of the Tatin client from <https://github.com/aplteam/Tatin/releases>

2. Unzip it _into_ the `MyUCMDs/` folder.   

Where to find the `MyUCMDs/` folder depends on your operating system:

* Under Windows it is 

  `(2 ⎕nq # 'GetEnvironment' 'USERPROFILE'),'\Documents\MyUCMDs\'`

* On non-Windows platforms it is `$HOME/MyUCMDs/`

Note that this folder is created by the Dyalog APL installer under Windows but _not_ under Linux and Mac-OS, so you need to create the folder yourself on non-Windows platform.

Any newly started instance of Dyalog 18.0 or later will now come with the Tatin user commands.

As a side effect of executing any of the Tatin user commands the Tatin API will become available via `⎕SE.Tatin`.

I> If you want the Tatin API to be available right from the start: this is discussed under "[Initializing Tatin](#)".

Putting Tatin into this folder has the benefit that it will be available in all suitable versions of Dyalog APL installed on your machine. It has the drawback that this is a user-specific folder.

Tatin requires version 18.0 Unicode or better, therefore the `]TATIN` user commands won't be listed in either earlier versions of Dyalog or in any Classic version.


## Initializing Tatin

As already mentioned, Tatin comes with a self-initializing feature: once installed any suitable version of Dyalog will provide a list of the Tatin user commands once you enter:

```
      ]tatin -?
```

The script `Tatin.dyalog` is the interface between the Dyalog user command framework and the Tatin API: 

When any of the Tatin user commands is executed it will check whether the API is already loaded (`0<⎕NC '⎕SE.Tatin'`)

If that's not the case it will...

  1. copy the code into `⎕SE._Tatin`
  2. create a namespace `⎕SE.Tatin` 
  3. establish references in `⎕SE.Tatin` pointing to the public functions in `⎕SE._Tatin`. 


## On `setup.dyalog`

Now you might want the Tatin API to be around right from the start, so that you can invoke any of the Tatin API functions without first executing any of the Tatin user commands. 

What is the application for this? Well, you might want to have an automated build process available right from the start, for example.

I> If you are not interested in this, skip the rest of this document


The way to achieve that goal requires the introduction or modification of a file `setup.dyalog` in your `MyUCMDs\` folder.

A> ### How does `setup.dyalog` work?
A>
A> The magic behind this is that whenever an instance of Dyalog is fired up it checks whether such a script exists. If that is the case it checks whether there is a function `Setup`. 
A>
A> If that is the case it is expected to be a monadic function which will be executed automatically as part of the instantiating process of Dyalog APL.
A>
A> This can be used for many things like...
A>
A> * making changes to the session
A> * specifying function keys 
A> * loading stuff into `⎕SE`

### There is no script `setup.dyalog` yet

Create one that looks like this:

```
:Namespace SetItUp

    ∇ {r}←Setup arg;⎕IO;⎕ML;dmx
      r←⍬
      ⎕IO←1 ⋄ ⎕ML←1
      :Trap ⎕SE.SALTUtils.DEBUG↓0
          AutoloadTatin ⍬
      :Else
          dmx←⎕DMX
          ⎕←'Setup.dyalog has a problem and was not executed successfully:'
          ⎕←↑'  '∘,¨dmx.DM
      :EndTrap
    ∇

    ∇ {r}←AutoloadTatin dummy;wspath;path2Config
      r←⍬
      :If IfAtLeastVersion 18
          ⎕SE.⎕EX¨'_Tatin' 'Tatin'
          wspath←(GetMyUCMDsPath),'/Tatin/Client.dws'
          '_Tatin'⎕SE.⎕CY wspath
          path2Config←⎕SE._Tatin.Client.FindUserSettings ⎕AN
          'Create!'⎕SE._Tatin.Client.F.CheckPath path2Config
          'Tatin'⎕SE.⎕NS''
          path2Config ⎕SE._Tatin.Admin.EstablishClientInQuadSE ⍬
      :EndIf
    ∇

      IfAtLeastVersion←{
      ⍝ ⍵ is supposed to be a number like 15 or 17.1, representing a version of Dyalog APL.
      ⍝ Returns a Boolean that is 1 only if the current version is at least as good.
          ⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'
      }

    ∇ r←GetMyUCMDsPath
      :If 'Win'≡3⍴1⊃# ⎕WG'APLVersion '
          r←(⊃⎕SH'ECHO %USERPROFILE%'),'\Documents\MyUCMDs\'
      :Else
          r←(⊃⎕SH'echo $HOME'),'/MyUCMDs/'
      :EndIf
    ∇

:EndNamespace
```

### There is already a script `setup.dyalog`

Make sure that you copy the functions `IfAtLeastVersion`, `GetMyUCMDsPath` and `AutoLoadTatin` from above into your own `setup.dyalog` script and then make sure that `AutoLoadTatin` is called from your `Setup` function.