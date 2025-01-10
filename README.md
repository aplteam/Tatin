# Tatin - a Package Manager for Dyalog APL

Tatin is a community project. It is available as Open Source under the (pretty relaxed) MIT license.

A Tarte Tatin is a nice way to package Apple's.

## Documentation

The documentation is available on [Tatin's principal server](https://tatin.dev/v1/documentation "Link to https://tatin.dev/v1/documentation").

## Overview

Tatin consists of three modules:

* `Client` 
* `Server` 
* `Registry` - all code that is shared between client and server

Tatin clients and servers may run under Windows, Linux and Mac-OS.

Tatin requires a Unicode version of Dyalog and at least version 18.2; the Classic version is not supported.

## Installing and updating the Tatin Client

### 18.2

The document [Installing And Updating The Tatin Client](https://tatin.dev/Assets/docs/InstallingAndUpdatingTheTatinClient.html "Link to InstallingAndUpdatingTheTatinClient.html on the Tatin server") discusses how to install the Tatin client.

### 19.0

This version comes with Tatin. Because it is experimental, it needs to be activated:

```
]activate tatin
```

Or, if you want to use both, Tatin and the project manager [Cider](https://github.com/aplteam/Cider "Link to Cider on GitHub"):

```
]activate all
```

## Usage

Once you've installed the Tatin client, you have access to <https://tatin.dev>, the principal Tatin server.

The document [First Steps With Tatin](https://tatin.dev/Assets/docs/FirstStepsWithTatin.html "Link to FirstStepsWithTatin.html on the Tatin server") will get you started.

## Tatin Server 

You might find it useful to run your own Tatin server. For example, all packages used within a company could be served by a Tatin Server within your company LAN.

You may also keep a local Registry on your own machine, for example for development work. From a consumer's perspective there is no difference between consuming a package that is coming from a Tatin Server or from a local Registry.

The document [_Installing The Tatin Server_](https://tatin.dev/Assets/docs/InstallingTheTatinServer.html "Link to InstallingTheTatinServer.html on the Tatin server") discusses how to install the Tatin Server.

## Contributing to the code 

Before going into details please read [CONTRIBUTING](https://github.com/aplteam/tatin/blob/main/CONTRIBUTING.md "Link to the file CONTRIBUTING.md on GitHub in the root of the Tatin repository")
 first. The next step is to consult the document [_Tatin For Contributors_](https://tatin.dev/Assets/docs/TatinForContributors.html "Link to TatinForContributors.html on the Tatin server"); it discusses how one can contribute to the documentation or the code or both.

-----

Latest revision 2025-01-09


