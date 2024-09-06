[parm]:title             = 'Tatin: Server Installtion'
[parm]:leanpubExtensions = 1
[parm]:toc               = 2 3 4 5 6
[parm]:numberHeaders     = 2 3 4 5 6


# Installing and Updating the Tatin Server

## Introduction

While the Tatin Client is coming with version 19.0 and later automatically, the Tatin Server always needs to be installed in case you want to run your own managed Tatin Registry.

After downloading it from <https://github.com/aplteam/Tatin/releases> you need to unzip it into a folder where the Tatin Server is supposed to live.


## Requirements

* Dyalog Unicode 18.0 or better
* Windows or Linux

  For the time being neither the Pi nor AIX are supported. The PI might be added at a later stage.

## Configuration: the INI File

First, you need to amend the file `server.ini`.

A> ### Plodder
A>
A> Tatin uses Plodder (<https://github.com/aplteam/Plodder>) as an HTTP server. 
A>
A> The INI file is originally a Plodder INI file with some additional settings used on the application level.

Note that this is an old-school INI file. Well, almost: it comes with several features that are unusual for INI files. We just mention the most important ones here; for details see <https://github.com/aplteam/IniFiles>.

* There are data types: text needs to go between 'quotes', and everything else is considered a number
* You may define local variables

A> ### What is a local variable?
A>
A> On top of the INI file, before any `[SECTION]`, the local variable `home` is defined. It carries the value `<INIFILE>`.
A>
A> Further down this local variable is referenced as `{home}`; that simply means that `{home}` will be replaced by `<INIFILE>` once the INI file is instantiated. 
A>

### `<INIFILE>` {#INIFILE}

When the Tatin Server loads the INI file it will replace the string `<INIFILE>` with the fully qualified directory the INI file was loaded from.

### Settings to pay attention to

The INI file is well documented, so we won't discuss the meaning of the different sections and settings. Most of the settings don't need changing, so we will just draw your attention to those you are likely to change:


#### [CONFIG]AppName

This defines the name used by Tatin for logging into the Windows Event Log. 

The parameter has no meaning on non-Windows platforms, and is ignored in case `[LOGGING]WindowsEventLog` is 0 rather than 1.


#### [CONFIG]Registry

This is the path where the Registry lives that is managed by the Tatin Server.

#### [CONFIG]Base

Replace this with your domain name, or "localhost" in case you just want to run a Tatin Server on your local machine for your own purposes, for example for checking it out.

Never add a port number to `Base`; see `[CONFIG]BaseTagPort` for this.


#### [CONFIG]BaseTagPort

Leave this alone in case the Tatin Server listens to either port 80 (http://) or 443 (https://). 

In case you run the Tatin Server on a non-standard port like, say, 9999, then you would set `BaseTagPort` to 9999. This makes Tatin inject that port number into the HTML "base" tag, so that for example links in the Tatin documentation would continue to work.

However, when your Tatin Server runs behind, say, an Apache Server, then Tatin would listen to a non-standard port used for the sole purpose of communicating with the Apache Server. In this case, you would leave `BaseTagPort` alone, except when the Apache Server itself listens to a non-standard port: then `BaseTagPort` needs to be _that_ port.

See also `[CONFIG]Base`.


#### [CONFIG]Title

When you use a Browser for accessing a Tatin server then `Title` defines what will become the window or tab title in the browser.


#### [CONFIG]Caption

This defines what all the HTML pages will display as `<h1>`.


#### [CONFIG]ReloadWS

If this is 1 Tatin will frequently check whether the workspace `Server.dws` was changed since it was loaded. If it was then Tatin will load it, meaning that it will kind of restart itself.

Whether this is a good idea in production is debatable, but it can be helpful in development.


#### [CONFIG]DeletePackages

This setting defines whether a user might delete a package. The setting may become one of these:

| 0 | Deleting packages is not allowed
| 1 | Deleting packages is allowed
| 2 | Only beta versions may be deleted 

The principal Tatin server does not allow the deletion of anything. The simple reason for this policy is that we want to guarantee that a build can always be reproduced.

A> ### Beta versions
A>
A> What qualifies as a beta version? Here are some examples:
A> ```
A> group-foo-1.0.0              ⍝ not a beta
A> group-foo-1.0.0+123          ⍝ not a beta
A> group-foo-1.0.0-fix          ⍝ a beta
A> group-foo-1.0.0-fix+123      ⍝ a beta
A> group-foo-1.0.0-beta-23+123  ⍝ a beta
A> ```


#### The section [CONFIG]Secure

Flag that defines whether certificates (https) are used or not (http).


#### The section [CERTIFICATES]{#certificates}

A certificate is required in case you want to use https, a must on the Internet these days.
You probably want to use your own one.

For more details on certificates see "On Certificates"


#### The section [EMAIL]{#EMAIL}

A Tatin server can send emails, broadcasting any crashes. For that, you must specify a couple of things in this section.

The INI file is well documented, so you should have no trouble making the necessary adjustments.
 

## On Logging

### Logging on file

Tatin will always write to the log file, but how much information is written can be influenced by settings in the INI file.

There are two different levels available for logging:

* High- (or application-) level logging should always be done. Only then is usage data available.

  Note that IP addresses are _not_ logged at this level.

* Low-level logging is controlled by the INI file's `LogHTTP`, `LogConga`, and `LogRumba` properties. These can be useful for debugging. They log IP addresses which might be illegal in certain countries.

### The Windows Event Log

Under Windows, you may let Tatin write to the Event Log by setting `WindowsEventLog` to 1.

This parameter is ignored on non-Windows platforms and has no effect under Windows when Tatin is not running as a Windows Service.

If you do run the Tatin Server as a Windows Service then set this to 1. Start, Pause, Stop and crashes are then reported to the Windows Event Log.

## On Certificates{#certificates2}

Note that in case you want your Tatin server to serve requests from the Internet --- as opposed to an Intranet --- it is strongly recommended to hide the Tatin Server behind an industrial-strength HTTP server like Apache.

Such a server can deal with attacks and has also all sorts of security measures built into it, so it's much safer to run Tatin behind it.

There is a separate document available that discusses how to do this: [Run Dyalog behind Apache](./RunDyalogBehindApache.html "RunDyalogBehindApache.html").

In case you hide the Tatin Server behind, say, an Apache server on the same machine there might be no need to use encryption (https).

## The `[MSG]` section

This section can be useful in case you want to inject a message into every HTML page delivered by Tatin.

A typical application is the announcement of downtime due to maintenance.

The section has two values, `Text` and `CSS`. In case `Text` is not empty it is injected as `<div><p>{text}</p>?</div>`. If `CSS` is not empty it is injected into the `<div>` as `style="..."`.

## The `[APP]` section {#the_app_section}

This section tells Plodder where to find the application-specific logic (Tatin).

* `Context`

   This defines the namespace all Tatin-specific handlers live in.

* The `On*` handlers

  These are the Tatin-specific entry points. You might want to add something to `OnHouseKeeping`, or add a handler `OnHeader`, but that is pretty unusual.


## How to start the Tatin server

After having made the necessary adjustments in the INI file you could of course simply start an instance of Dyalog with ample memory, and load the workspace. `#.Tatin.Server.Run 1` is executed via `⎕LX`, and your server is up and running.

Most errors that could occur (bugs in Tatin etc.) are trapped and will return a 500 (Internal Server Error) but would not prevent the server from running. However, some errors might bring the server down like an aplcore or a WS FULL.

In such an event you are most likely interested in the server being restarted automatically.


### Windows 

Under Windows you have two options:

* Run the Tatin Server as a Windows Service
* Run it in a Docker container

Both options allow running the Server so that it is restarted automatically in case of a failure or a reboot.

Running the server as a Windows Service gives you the best performance, but running it in a Docker container is still surprisingly fast, given that it runs a (very basic) version of Linux in a virtual machine.

If you want to run the Tatin server as a Windows Service you can put the workspace `InstallAsWindowsService.dws` to good use: it will install Tatin as a Windows service. Note that this requires admin rights.


### Linux

Under Linux, you are advised to run the Tatin Server in a Docker image. 


### Docker: required amendments 

#### The file `Dockerfile`

1. Linux Version

   Specify both the name of the desired distribution and the version number in the `FROM` clause at the top of the file. In the template, this is "Ubuntu" and "22.04".

2. It is a Docker convention to specify the Docker username and email address of a maintainer in the `MAINTAINER` clause.

3. Dyalog APL

   Before anything else make sure that you copy the appropriate version of Dyalog APL into the folder that holds the Docker-related files.

4. Dockerfile

   This file defines what docker should put into the container. In particular, it must point to the desired version of Dyalog APL, so check the variables `DYALOG_RELEASE`, `DYALOG_VERSION` and `DYALOG_DEBFILE`.

5. Do **not** change the `WORKDIR`!

6. Do not change `DYALOG_SERIAL`: this license number is explicitly reserved for Tatin servers.

#### The file `entrypoint`

In this file, a couple of environment variables are defined that might not be set to your taste: `TRACE_ON_ERROR`, `SINGLETRACE` and `CLASSICMODE`. 

#### The file `CreateTatinDockerContainer.sh`

1. You must change the `source` parameter so that it points to the folder that hosts the Tatin server data.

2. You might need to change port 443, defined with the `-p` flag.

   This can only ever be 80 or 443 on your local machine if the Tatin server is not exposed to the Internet because in that scenario Tatin should run behind a web server like Apache. In that case, Apache would listen to 80 or 443 but communicate with the Tatin server on a different port.

3. The second port exposed in that script is used for connecting with Ride to the interpreter, if ever. (Note that the INI file rules whether the interpreter allows a Ride or not)

### Docker workflow

Execute these steps:

1. Call  `./BuildImage.sh` for creating the image
2. Call  `./CreateTatinDockerContainer.sh` for creating the container from that image
3. Call  `start-tatin.sh` to start the container; this script ensures that the container is restarted after a crash or auto-started after a reboot

## Testing and Debugging

For testing and debugging you might want to change these settings:

* `[CONFIG]DisplayRequests`
* `LogHTTPToSession`
* `TestFlag`; in case this is 1 a Tatin Server supports additional commands. To get a list of these commands execute "list-commands". Naturally, this makes sense only under program control, not from a browser.
* `ReloadWS`
* The settings in the `[LOGFILE]` section



## Misc

When you see the term "Plodder" somewhere: This is a generalized HTTP server that is used by Tatin behind the curtains. Plodder is in turn based on Rumba and Conga.

For details see:

* <https://github.com/aplteam/Plodder>

* <https://github.com/aplteam/RumbaLean>


## Updating the Server

Before updating the server **you must read the release notes!** The reason is that an update might be as easy as copying the workspace over while the server is running but as complex as requiring several actions while the server is down for maintenance.

### The Workspace

A running server might frequently check whether the workspace on disk was changed since the server was started if configured accordingly. If that is the case the server will load the workspace again. This allows an easy update in case no complex actions are required. 

I> This mechanism is active by default but might be switched off with `[CONFIG]ReloadWS` in the INI file

Naturally, the server will produce an error message for a short period during the reload; expect 10 seconds or more, depending on the number of packages managed by the server.


## The INI file

Entries in the INI file might have been added or removed. Whether that is the case will be revealed by the release notes. If something has changed follow the release notes. _Do not replace the INI file!_

The server checks the INI file for having been changed, and if that is the case re-initialize the INI file. However, whether that works or not depends on the kind of change: a number of settings are required at a very early stage, and cannot be changed later on. Again the release notes will tell.

## Assets

What kind of actions need to be taken, if any, is revealed by the release notes. Typically the subfolder `docs/` needs to be replaced: this folder carries the documentation.

## The folder Maintenance/

First of all, never replace the folder `maintenance/`: its content documents what changes have been carried out towards the packages in the past, and you don't want to lose this.

If the new one is not empty then copy the content over. Maintenance files can be used to carry out changes on all or some of the packages managed by that server, like adding a new property to the package config files of all packages.







