[parm]:title             = 'Tatin Server Installtion'
[parm]:leanpubExtensions = 1
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3


# Installing the Tatin Server

## Introduction

While the Tatin Client is coming with version 18.1 and later automatically, the Tatin Server always needs to be installed in case you want to use it.

After downloading it from <https://github.com/aplteam/Tatin/releases> you need to unzip it into a folder where the Tatin Server is supposed to live.


## Configuration: the INI File

First you need to amend the file `server.ini`.

A> ### Plodder
A>
A> Tatin uses Plodder (<https://github.com/aplteam/Plodder>) as HTTP server. 
A>
A> The INI file is originally a Plodder INI file with some additional settings used on the application level.

Note that this is an old-school INI file. Well, almost: it comes with a number of features that are unusual for INI files. We just mention the most important ones here; for details see <https://github.com/aplteam/IniFiles>.

* There are data types: text needs to go between 'quotes', everything else is considered a number
* You may define local variables

A> ### What is a local variable?
A>
A> On top of the INI file, before any `[SECTION]` is defined, the local variable `home` is defined. It carries the value `<INIFILE>`.
A>
A> Further down the local variable is referenced as `{home}`; that simply means that `{home}` will be replaced by `<INIFILE>` once the INI file is instantiated. 
A>

### `<INIFILE>` {#INIFILE}

When the Tatin Server loads the INI file it will replace the string `<INIFILE>` by the fully qualified directory the INI file was loaded from.

### Settings to pay attention to

The INI file is well documented, so we won't discuss the meaning of the different sections and settings. Most of the settings don't need changing, so we will just draw your attention to those you are likely to change:


#### `[CONFIG]AppName`

This defines the name used by Tatin for logging to the Windows Event Log. 

The parameter has no meaning on non-Windows platforms, and is ignored in case `[LOGGING]WindowsEventLog` is 0 rather than 1.


#### `[CONFIG]Registry`

This defines the path where the Registry lives that is managed by the Tatin Server.

#### `[CONFIG]Base`

Replace this by your domain name, or "localhost" in case you just want to run a Tatin Server on your local machine for your own purposes, for example for checking it out.

Never add a port number to `Base`; see `[CONFIG]BaseTagPort` for this.


#### `[CONFIG]BaseTagPort`

Leave this alone in case the Tatin Server listens to either port 80 (http://) or 443 (https://). 

In case you run the Tatin Server on a non-standard port like, say, 9999, then you would set `BaseTagPort` to 9999. This makes Tatin inject that port number into the HTML "base" tag, so that for example links in the Tatin documentation would continue to work.

However, when your Tatin Server runs "behind", say, an Apache Server then Tatin would listen to a non-standard port used for the sole purpose of communicating with the Apache Server. In this case you would leave `BaseTagPort` alone, except when the Apache Server itself listens to a non-standard port: then `BaseTagPort` needs to be _that_ port.

See also `[CONFIG]Base`.


#### `[CONFIG]Title`

When you use a Browser for accessing a Tatin server then `Title` defines what will become the tab title in the browser.


#### `[CONFIG]Caption`

This defines what all the HTML pages will display as `<h1>`.


#### `[CONFIG]ReloadWS`

If this is 1 Tatin will check whether the workspace `Server.dws` was changed since it was loaded. If it was Tatin will load it, meaning that it will kind of restart itself.

Whether this is a good idea in production is debatable, but it can be helpful in development.


#### `[CONFIG]DeletePackages`

This setting defines whether a user might delete a package. The setting may become one of these:

| 0 | Deleting packages is not allowed
| 1 | Deleting packages is allowed
| 2 | Only beta versions may be deleted (major version number is 0)

The principal Tatin server only allows deleting beta versions. The simple reason for this policy is that we want to guarantee that a build can always be reproduced.


#### The section [CONFIG]Secure

Flag that defines whether certificates (https) are used nor not (http).


#### The section [CERTIFICATES]{#CERTIFICATES}

A certificate is required in case you want to use https, a must on the Internet these days.
You probably want to use your own one.

For more details on certificates see "On Certificates"


#### The section [EMAIL]{#EMAIL}

A Tatin server can send emails, broadcasting any crashed. For that you must specify a couple of things in this section.

The INI file is well dcoumented, so you should have no trouble to make the necessary adjustments.
 

## On Logging

There are two different levels available for logging:

* Low-level logging with `LogHTTP`, `LogConga` and `LogRumba`. These are useful for debugging. 

  The log file these pieces of information go into is situated in the `Rumba/` sub folder.

* High level logging with `Log` and `LogFolder`. 

  Note that IP addresses are _not_ logged at this level.

  * `Log` is a flag that indicates whether Tatin should log at all. In production it should always be 1.

  * `LogFolder` must specify the path the Log file lives in. 

    The name of the log file looks like `Tatin_{YYYYMMDD}.log`.

* `WindowsEventLog`

   This parameter is ignored on non-Windows platforms and has no effect under Windows when Tatin is not running as a Windows Service.

   If you do run the Tatin Server as a Windows Service then set this to 1. Start, Pause, Stop and any errors are then reported to the Windows Event Log.

## On Certificates

Note that in case you want your Tatin server to serve requests from the Internet --- as opposed to an Intranet --- it is strongly recommended to hide the Tatin Server behind an industrial-strength HTTP server like Apache.

Such a server is able to deal with attacks and has also all sorts of security measures built into it, so it's much safer to run Tatin behind it.

There is a separate document available that discusses how to do this: [Run Dyalog behind Apache](./RunDyalogBehindApache.html "RunDyalogBehindApache.html").

In case you hide the Tatin Server behind, say, an Apache server, on the same machine there might be no need to use encryption (https).

## The `[MSG]` section

This section can be useful in case you want to inject a message into every HTML page delivered by Tatin.

A typical application is the announcement of down time due to maintenance.

In case `Text` is not empty it is injected as `<div><p>{text}</p>?</div>`. If `CSS` is not empty it is injected into the `<div>` as `style="..."`.

## The `[APP]` section {#the_app_section}

This section tells Plodder where to find the application-specific logic (Tatin).

* `Context`

   This defines the namespace all Tatin-specific handlers live in.

* The `On*` handlers

  These are the Tatin-specific entry points. You might want to add something to `OnHouseKeeping`, or add a handler `OnHeader`, but that is pretty unusual.


## How to start the Tatin server

After having made the necessary adjustments in the INI file you could of course simply start an instance of Dyalog with ample memory, and load the workspace.

Most errors that could occur (bugs in Tatin etc.) are trapped and will return a 500 (Internal Server Error) but would not prevent the server from running. However, there are errors that might bring the server down like an aplcore or a WS FULL.

In such an event you are most likely interested in the server being restarted automatically.


### Windows 

Under Windows you might run the Tatin Server as a Windows Service. Such a service can be configured so that it is restarted automatically in case of a failure.


### Linux

Under Linux you are advised to run the Tatin Server in a Docker image. 

A [Dyalog docker image](https://hub.docker.com/r/aplteam/docker "Link to the download page") is available for download.


## Testing and Debugging

For testing and debugging you might want to change these settings:

* `[CONFIG]DisplayRequests`
* `LogHTTPToSession`
* `TestFlag`; in case this is 1 a Tatin Server supports additional commands. To get a list of these commands execute 'list-commands'. Naturally this makes sense only under program control, not from a browser.
* `ReloadWS`
* The settings in the `[LOGFILE]` section



## Misc

When you see the term "Plodder" somewhere: This is a generalized HTTP server that is used by Tatin behind the curtains. Plodder is in turn based on Rumba and Conga.

For details see:

* <https://github.com/aplteam/Plodder>

* <https://github.com/aplteam/RumbaLean>