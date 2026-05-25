---
title: 'Tatin: OneDrive'
description: ''
keywords: 
---
# Tatin and OneDrive


## Background

OneDrive is cloud storage offered by Microsoft for backing up some of your personal folders. 

In the context of Tatin, the folder `Documents\` is of particular interest.

For decades, Dyalog has saved (or potentially saved) stuff in a version agnostic folder named `Dyalog APL Files` in the `Documents\` folder, and also version specific stuff. For example, for version 19.0 there is a folder `Dyalog APL-64 19.0 Unicode Files` created in `Documents/`.

Until version 0.114.0 Tatin  questioned the environment variable `USERPROFILE` in order to find out where to copy Tatin to. For example, for a user JohnDoe that would usually result in

```
C:\Users\JohnDoe\Documents\
```

This is true no matter whether OneDrive is used or not.

This means that in case OneDrive **is** used and the Documents folder is managed by OneDrive (the user might use OneDrive and still decide against this!), then `USERPROFILE` is misleading.

## Solution

Tatin now uses the --- at the time of writing --- inofficial I-beam `4070⌶0` which in the second item of the result gives the location of the Dyalog files folder for the currently running version of Dyalog, for example for a user JohnDoe:

```
      2⊃4070⌶0
C:\Users\JohnDoe\OneDrive\Documents\Dyalog APL-64 19.0 Unicode Files
```

With version 0.114.0 Tatin has adopted this and can therefore deal with a `Documents/` folder that is saved in OneDrive.

## Problems when updating an older version of Tatin

Any attempt to update an older version than 0.114.0 will appear to be successful, but after a restart you will still use the old version.

The reason for this is that older versions were installed into

```
C:\Users\JohnDoe\Documents\Dyalog APL-64 19.0 Unicode Files
```

while the updated version is copied into 

```
C:\Users\JohnDoe\OneDrive\Documents\Dyalog APL-64 19.0 Unicode Files
```

when your are running version 19.0

If this hits you your are advised to carry out these steps:

1. Add the path

   ```  
   C:/Users/<⎕AN>/OneDrive/Documents/Dyalog APL-64 19.0 Unicode Files/SessionExtensions/CiderTatin
   ```

   to SALT's `cmddir` and remove the path

   ```  
   C:/Users/<⎕AN>/Documents/Dyalog APL-64 19.0 Unicode Files/SessionExtensions/CiderTatin
   ```

   from it. 

2. Remove the folder

   ```  
   C:/Users/JohnDoe/Documents/Dyalog APL-64 19.0 Unicode Files/SessionExtensions/CiderTatin
   ```

   from your disk.


This solves the problem permanently in the sense that future updates will work as expected.

However, if you are going back to any ill-behaving version, for example by executing this command:

```
      ]activate -reset
```

then you are back on a version that won't work when an update is issued, until Dyalog ships a new version, when this document will change as well.
