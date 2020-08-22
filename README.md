# Tatin - a Package Manager for Dyalog APL

Tatin is a community project. It is available as Open Source under the (pretty relaxed) MIT license.

A Tarte Tatin is a nice way to package APpLe's.

## Overview

Tatin consists of three modules:

* `Client` - the client
* `Server` - the Server
* `Registry` - all code that is shared between the client and the server.

Client as well as Server run under Windows, Linux and Mac-OS.

Tatin requires Dyalog APL 18.0 Unicode or better. It will be part of 19.0 Dyalog APL installatio.

Documentation is available via the `docs/` folder but also as part of a release, in particular the documents `InstallingTheTatinClient.html` and `InstallingTheTatinServer.html`.

## Usage

Once you've installed the Tatin client you have access to <https://tatin.dev>, the principal Tatin server.

The document `FirstStepsWithTatin.html` in the docs/ folder will get you started.

## Tatin Server 

You might find it useful to run your own Tatin server. For example, all packages used within a company could be served by a Tatin Server within your company LAN.

You may also keep a local Registry on your own machine, for example for development work. From a consumer's perspective there is no difference between consuming a package that is coming from a Tatin Server or from a local Registry.



## Contributing to the code 

There is a document "TatinForContributor.html" available in the `docs/` folder that discusses how one can contribute to the documentation or the code or both/

-----

Latest revision 2020-08-15
