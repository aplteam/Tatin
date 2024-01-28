[parm]:title             = 'Release Notes'
[parm]:toc               = 2 2
[parm]:leanpubExtensions = 1




# Release Notes

Tatin release notes contain information regarding actions that need to be executed before a new version can be used, or outstandingly important pieces of information.

This document does not come with a complete list of fixes, added features etc. Consult [Tatin on GitHub](https://github.com/aplteam/Tatin) for that.

## Version 0.104.1 from 2024-01-28

* The client requires a server on 0.104.1 as well

## Version 0.104.0 from 2024-01-22

* The result of both `]ListRegistries` and the corresponding API function return a different (extended) result now.

  This implies that older versions of Tatin than 0.104.0 are incompatible with this new version, therefore you are forced to update.

  Apart from the update no action is required.

## Version 0.103.2 from 2024-01-16

* No action required.

## Version 0.103.1 from 2023-12-14

* No action required.

## Version 0.103.0 from 2023-11-04

* No action required but note that the result of the API function `LoadPackages` has changed.

## Version 0.102.3 from 2023-10-13

* No action required

## Version 0.102.2 from 2023-10-09

* No action required

## Version 0.102.1 from 2023-10-07

* Most importantly, a bug fix in `]Tatin.CiderUpdate`

## Version 0.102.0 from 2023-10-04

* Most importantly, a revised install procedure

## Version 0.101.2 from 2023-09-30

* Very important bug fix in `UnInstallPackages`

## Version 0.101.1 from 2023-09-26

Two massive changes:

* This version is only compatible with Cider 0.36.0 or later

* The installation folder is not `MyUCMDs/` anymore. However, `]Tatin.UpdateTatin` of your old version cannot know about this, therefore you have to take action once in order to get Tatin into the right folder. 

  See the "InstallingAndUpdatingTheTatinClient.html" document for details.

* Note that in the future `]Tatin.UpdateTatin` will use the new installation folder 

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



































