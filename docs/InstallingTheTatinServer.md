[parm]:title             = 'Tatin Server Installtion'
[parm]:leanpubExtensions = 1


# Installing the Tatin Server

## Introduction

While the Tatin Client is coming with version 19.0 and later, the Tatin Server always needs to be installed in case you want to use it.

After downloading it from <https://github.com/aplteam/Tatin/releases> you need to unzip it into a folder where the Tatin Server is supposed to live.

First you need to amend the file `server.ini`.

Note that this is an old-school INI file. Well, almost: it comes with a number of features that are unusual for INI files. We just mention the most important ones here; for details see <https://github.com/aplteam/IniFiles>.

* There are data types: text needs to go between 'quotes', everything else is considered a number
* You may define local variables

A> ### What is a local variable?
A>
A> On top of the INI file, before any `[SECTION]` is defined, the local variable `home` is defined. It carries the value `<INIFILE>`.
A>
A> Further down the local variable is referenced as `{home}`; that simply means that `{home}` will be replaced by `<INIFILE>` once the INI file is instantiated. 
A>
A> What happens to the string `<INIFILE>` later is a Tatin convention, not a feature of the INI file: when the Tatin Server loads the INI file it will replace `<INIFILE>` by the fully qualified folder that INI file was loaded from.

## Settings to pay attention to

The INI file is well documented, so we won't discuss the meaning of the different sections and settings. Most of the settings don't need changing, so we will just draw your attention to those you are likely to change:

* `Registry`

This defines the path to where the Registry lives that is managed by the Tatin Server.

* `Base`

Replace this by your domain name, or "localhost" in case you just want to run a Tatin Server on your local machine for your own purposes, for example for checking it out.

* `Title`

When you use a Browser for accessing a Tatin server then `Title` defines what we will see as the tab title in the browser.

* `Caption`

This defines what all the HTML pages will display as `<h1>`.

* The section `[CERTIFICATES]` 

  A certificate is required in case you want to use https, a must on the Internet these days.
You probably want to use your own one.

  For more details on certificates see the next topic
  

* `[WINDOWEVENTLOG]write`

  If you run the Tatin Server as a Windows Service set this to 1. It won't cause harm in case it is 1 but does _not_ run as a Windows Service.


## On Certificates

Note that in case you want your Tatin server to serve requests from the Internet --- as opposed to an Intranet --- it is strongly recommended to hide the Tatin Server behind an industrial-strength HTTP server like Apache.

Such a server is able to deal with attacks and has also all sorts of security measures build into it, so it's much safer to run Tatin behind it.

There is a separate document available that discusses how to do this: RunDyalogBehindApache.html

In case you hide the Tatin Server behind, say, an Apache server, there might be no need to use encryption (https) except avoiding security warnings from browser, in case users access the Tatin Server also with a browser.


## How to start the Tatin server

After having made the necessary adjustments in the INI file you could of course simply start an instance of Dyalog 18.0 Unicode or better with ample memory, and load the workspace.

Most errors that could occur (bugs in Tatin etc.) are trapped and will return a 500 (Internal Server Error) but not prevent the server from running. However, there are errors that might bring the server down like an aplcore or a WS FULL.

In such an event you are most likely interested in the server being restarted automatically.


### Windows 

Under Windows you are advised to run the Tatin Server as a Windows Service. Such a service can be configured so that it is restarted automatically in case of a failure.


### Linux and Mac OS

Under these operating systems you are advised to run the Tatin Server in a Docker image. 

A [Dyalog docker image](https://hub.docker.com/r/dyalog/dyalog "Link to the download page") is available for download.


## Testing and Debugging

For testing and debugging you might want to change these settings:

* `[CONFIG]DisplayRequests`
* `LogHTTPToSession`
* `TestFlag`; in case this is 1 a Tatin Server supports additional commands:

   * `GetServerPath`
   * `RecompileIndex`
   * `Stop`
   * `Shutdown`
   * `Crash`

* `ReloadWS`   
* The settings in the `[LOGFILE]` section



## Misc

When you see the term "Plodder" somewhere: This is a generalized HTTP server that is used by Tatin behind the curtains. Plodder is in turn based on Rumba and Conga.

For details see:

* <https://github.com/aplteam/Plodder>

* <https://github.com/aplteam/RumbaLean>