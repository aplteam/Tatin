---
title: 'Tatin: Server Installtion'
description: 'How to install and update your own Tatin registry server'
keywords: 'apl, dyalog, registry, server, tatin'
---
# Install a registry server

!!! abstract "How to install and update your own Tatin registry server"


## :fontawesome-solid-download: Download

Download the Tatin Server ZIP from the [Releases](https://github.com/aplteam/Tatin/releases) page
and unzip it into the installation folder.


## :fontawesome-solid-sliders: Configure

!!! detail inline end "Local variable"

    Before the first section declaration (`[CONFIG]`),
    local variable `home` is assigned `'<INIFILE>/'`.

    References to `{home}` get replaced by its value.

Edit the configuration file `Server/server.ini`.

Plodder INI files have unusual features.[^plodini]
The most important are

-   **typed data**: put text in quotes; anything else is numeric
-   you can define **local variables**



When the Tatin Server loads the INI file, it replaces `<INIFILE>` with the fully qualified path of the INI file.

See :fontawesome-brands-github: [aplteam/Plodder](https://github.com/aplteam/Plodder) for INI file settings.
Here are those you are likely to change for your Tatin server.


### `APP`

Connect Plodder to the Tatin logic: see [Plodder documentation](https://github.com/aplteam/Plodder).

The `On*` handlers are Tatin-specific entry points.
You might want to add something to `OnHouseKeeping`,
or add a handler `OnHeader`, but that is pretty unusual.


### `CERTIFICATES`

A certificate is required to use HTTPS.
(Recommended for public-facing servers.)

!!! tip "On the Web, use a reverse proxy to hide Tatin behind a Web server"

    If you use a [reverse proxy](secure-server.md#reverse-proxy), you might not need encryption (HTTPS) and certificates.


### `CONFIG`

---|---
AppName | Name used by Tatin for logging into the Windows Event Log.<br><br>The setting has no meaning on non-Windows platforms, and is ignored if `[LOGGING]WindowsEventLog` is 0.
Base<br>BaseTagPort | (Ignored from version 0.104.0.)
Caption | `H1` element for HTML pages.
DeletePackages | Deleting packages is: 0 – not allowed; 1 – allowed; 2 – allowed only for [betas](glossary.md).<br><br>The [Principal Registry](https://tatin.dev) will not delete anything. A build can always be reproduced.
Registry | Path to the the registry.
ReloadWS | Flag: whether Tatin frequently checks for and reloads new versions of workspace `Server.dws`, meaning it will (kind of) restart itself.<br><br>Not recommended in production, but can be helpful in development.
Secure | Flag: whether certificates are used (HTTPS) or not (HTTP).
Title | Browser window or tab title for HTML pages.


### `EMAIL`

Your Tatin server can send alerts by email.

### `LICENSE`

Names of the licences (and URLs to their definitions) the server accepts.

The INI section is optional.
if absent, the website shows no _Licensing_ menu item, and the server accepts any license, including packages that lack a `license` property.

By convention, `BuildPackage` copies any file `LICENSE` in the root of the project to the root of a package.
This convention is independent of the INI file.

The text on the server web page is defined in `Assets/snippets/Licensing.md`.



### `LOGGING`

Control how much information Tatin logs.

--------------------------------|---------------------------
Log                             | Flag: log at high level. Keep set.
LogHTTP<br>LogConga<br>LogRumba | Flags: log at low level.
WindowsEventLog                 | Flag: write to the Windows Event Log. (Recommended, but Windows only.)

IP addresses are not logged at the high level.
They are logged at the low level, which can be useful for development,
but in some jurisdictions may not be legal on internet servers.


### `MSG`

Inject a message into every HTML page; for example
to announce downtime due to maintenance.

-----|----------------------------------------------------
Text | Unless empty, inject as `<div><p>{text}</p></div>`
CSS  | Unless empty, inject into the Text `<div>` as `style="{css}"`


## :fontawesome-solid-laptop: Start a local Tatin server

Start an instance of Dyalog with ample memory, and load the workspace `Server.dws`.
The Latent Expression starts the server.
<!-- `#.Tatin.Server.Run 1` is executed via `⎕LX`, and your server is up and running. -->

Most foreseeable errors (bugs in Tatin etc.) are trapped
and return a 500 (Internal Server Error) response
but do not stop the server.
However, errors such as an aplcore or a WS FULL could bring the server down.

!!! tip inline end "On Windows :fontawesome-brands-windows:"

    Running the server as a Windows Service gives you the best performance, but running it in a Docker container is still surprisingly fast, given that it runs a (very basic) version of Linux in a virtual machine.

To have the server restarted automatically after a failure, run it

-   on Windows as a Windows Service
-   on Linux and Windows in a Docker container

To run the Tatin server as a Windows Service, use the workspace `InstallAsWindowsService.dws`,
which installs Tatin as a Windows service. (Requires admin rights.)


## :fontawesome-brands-docker: Configure Docker

To run Tatin in a Docker container,
first adjust the Docker configuration to your environment and needs.

### `Dockerfile`

This file defines what Docker should put into the container.

In particular, it must point to the desired version of Dyalog APL, so check the variables `DYALOG_RELEASE`, `DYALOG_VERSION` and `DYALOG_DEBFILE`.
Copy the appropriate version of Dyalog APL into the folder that holds the Docker-related files.

--------------|-----------------------
FROM          | Name of the desired Linux distribution and the version number.
MAINTAINER    | Your Docker username and email address.
WORKDIR       | Do **not** change this!
DYALOG_SERIAL | Do **not** change this! The licence number is explicitly reserved for Tatin servers.

### `entrypoint`

Environment variables
`TRACE_ON_ERROR`, `SINGLETRACE` and `CLASSICMODE`
might need adjusting to your taste.


### `CreateTatinDockerContainer.sh`

Change the `source` to the folder that hosts the Tatin server data.

!!! detail inline end ""

    Ports 80 and 443 respectively are the standard ports for HTTP and HTTPS.

The server listens to port 9090, which the default configuration exposes.
It is unsafe to remap this to ports 80 or 443 except on an isolated machine:
run a public Tatin server on the Web [behind a webserver](secure-server.md#reverse-proxy) such as Apache or Nginx.

The second port exposed in the script is for connecting to the interpreter with Ride,
if permitted by the INI file.


## :fontawesome-brands-docker: Docker workflow

Call:

1. `./BuildImage.sh` to create the image
1. `./CreateTatinDockerContainer.sh` to create the container from the image
1. `start-tatin.sh` to start the container; the script ensures the container is restarted after a crash or auto-started after a reboot


## :fontawesome-solid-bomb: Testing and debugging

For testing and debugging you might want to change in `server.ini`
the settings in the `LOGFILE` section,
and these flags in `CONFIG`:

-----------------|-----------------------------------------
DisplayRequests  | Make Rumba display every request.
LogHTTPToSession | Print HTTP requests to the session.
TestFlag         | Accept extra commands as REST requests.
ReloadWS         | Reload the server workspace if you detect a new one.








[^plodini]: See :fontawesome-brands-github: [aplteam/IniFiles](https://github.com/aplteam/IniFiles).
