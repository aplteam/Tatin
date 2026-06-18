---
title: "Update older versions"
description: "How to update older versions of Tatin, including special steps for OneDrive users"
<!-- keywords: onedrive,update,versions -->
---
# Update older versions

!!! abstract "How to update Tatin versions older than 0.105.0, and how to update when using OneDrive"


## Versions before 0.105.0

Tatin Version 0.105.0 introduced the [`]Tatin.Update` user command](user-commands.md#update).

To update an earlier version:

1.  Remove `Tatin/` from the `MyUCMDs/` folder. (See [Enable the API](install-tatin.md#enable-the-api).)
2.  Download and install Tatin from scratch. (Also Cider, if you are using it.)
3.  Review your `setup.dyalog` script if you are using one.

## OneDrive and versions before 0.114.0

OneDrive is cloud storage provided by Microsoft for backing up your personal folders.
A Windows user `JohnDoe` who enables OneDrive changes his Documents folder:

    C:\Users\JohnDoe\Documents\             ⍝ from
    C:\Users\JohnDoe\OneDrive\Documents\    ⍝ to

The Dyalog [installation folder](install-tatin.md#installation-folder) is (by default) in the Documents folder, e.g.

    Dyalog APL Files                  ⍝ version-agnostic
    Dyalog APL-64 19.0 Unicode Files  ⍝ version-specific

Before version 0.114.0, Tatin read environment variable `USERPROFILE` to find the Documents folder.
But `USERPROFILE` does not reflect use of OneDrive!
An update of Tatin would apparently succeed but, written to the wrong Documents folder,
would not appear in subsequent launches of Dyalog.

Since version 0.114.0, Tatin uses the experimental I-beam `4070⌶0` to recognise a Documents folder in OneDrive.

If you are using OneDrive and a version of Tatin older than 0.114.0:

1.  Determine your Tatin home: the relative path from your OneDrive Documents folder in which your Tatin files are kept, i.e.

        <dyalog-install-folder>/SessionExtensions/CiderTatin

1.  Add to SALT's `cmddir` the path

        C:/Users/<⎕AN>/OneDrive/Documents/<tatin-home>

    See `]SALT.Settings -??` for help.
    
1.  Remove from SALT's `cmddir` the path

        C:/Users/<⎕AN>/Documents/<tatin-home>

1.  Remove from your file system folder

        C:/Users/JohnDoe/Documents/<tatin-home>

Updates will then work as expected.

??? danger "Reverting to a version older than 0.114.0"

    If you revert to a Tatin version older than 0.114.0, for example with

        ]activate -reset

    you also recreate the problem.
