[parm]:title             = 'Release Notes'
[parm]:toc               = 2
[parm]:collapsibleTOC    = 1
[parm]:leanpubExtensions = 1




# Release Notes

Tatin release notes contain information regarding actions that need to be executed before a new version can be used.

This document does not come with notes regarding fixes, added features etc. Consult [Tatin on GitHub](https://github.com/aplteam/Tatin) for that.

## Version 0.101.0 from 2023-09-26

Two massive changes:

* This version is only compatiable with Cider 0.36.0 or later!

* The installation folder is not `MyUCMDs/` anymore. See the "InstallingAndUpdatingTheTatinClient.html" document for details.

* Note that `]Tatin.UpdateTatin` will use the new installation folder and ask the user whether she wants to delete Tatin from `MyUCMDs/` if found there

If for whatever reason you update manually, then you must make sure that Tatin is removed from the `[MyUCMDs]` folder yourself.

## Version 0.100.2 from 2023-09-23

No breaking changes, no user actions required.

## Version 0.100.1 from 2023-08-28

No breaking changes, no user actions required.

## Version 0.100.0 from 2023-08-27

No breaking changes, no user actions required.

## Version 0.99.1 from 2023-08-05

No breaking changes, no user actions required.

## Version 0.99.0 from 2023-08-02

No breaking changes, no user actions required.

## Version 0.98.2 from 2023-07-14

This release addresses a bug in the server; the client has not been changed.

Update only required if you run a server.

## Version 0.98.1 from 2023-07-13

No breaking changes, no user actions required.

## Version 0.98.0 from 2023-07-05

* No breaking changes for the Tatin client, therefore there are no user actions required

* If you run a Tatin server you don't need to take action but you should be aware of a major change

Before version 0.98.0 credentials got stored in a file `Credentials.txt`. The format was:

```
<group>=<api-key>
```

The API-keys were stored as clear text. We don't want that anymore.

With version 0.98.0 credentials will be stored in a file `Credentials.csv`. The format is different:

```
<group>,<api-key-hash>,<Salt>
```

The server will convert `Credentials.txt` automatically into `Credentials.csv`. Afterwards there is a new file `Credentials.csv` while the old file `Credentials.txt` will be deleted.

Note that you might create at a later stage a new file `Credentials.txt` with entries like

```
<group-name>=<api-key>
```

or

```
<group-name>,<api-key>
```

That allows you to add new groups, or overwrite existing ones, for example when somebody lost the API-key.

The server will perform the following actions:

* Take the data and convert it
* Delete rows from `Credentials.csv` that are also contained in `Credentials.txt` (same group name)
* Add the data to `Credentials.csv` 
* Delete `Credentials.txt`

## Version 0.97.1 from 2023-06-30

No breaking changes, no user actions required.

## Version 0.97.0 from 2023-06-14

This version comes with several breaking changes:

* The `]FindDependencies` user command's `-detailed` property has been renamed to `verbose`
* The API function `FindDependencies` has a changed syntax and returns a changed result.


## Version 0.96.2 from 2023-06-08

No breaking changes, no user actions required.

## Version 0.96.1 from 2023-05-21

No breaking changes, no user actions required.

## Version 0.96.0 from 2023-05-18

No breaking changes, no user actions required.













