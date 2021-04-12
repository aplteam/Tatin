[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin for Contributors'


# Tatin for Contributors

If you want to contribute to the [Tatin project on GitHub](https://github.com/aplteam/Tatin) or make adjustments to Tatin for an in-house project, this document will help you.

Tatin is published under the MIT license, so everybody is welcome to contribute to the code. It is not owned by anybody, it is rather a community project.

This is not an introduction into how to contribute to a project that is hosted on GitHub. If you are not familiar with that then google for "contribute to a github project".


## Tatin is managed by acre

Note that Tatin is managed by the [acre project management tool](https://github.com/the-carlisle-group/Acre-Desktop).
If you are not familiar with acre you are advised to spend an hour or so playing with it before using it for serious work.

Though it is possible making changes to Tatin or adding code without acre, using acre makes this much easier.


## Requirements

In order to work on Tatin you need at least Dyalog 18.0 Unicode (it will never run in Classic). 

You need one of: 

* Windows
* Linux
* Mac-OS. 

The Pi is not supported but that restriction might be lifted with a later version. AIX will not be supported.


## How to work on Tatin

After downloading Tatin from GitHub and saving it somewhere, say in `C:\Tatin`, you issue the command 

```
]acre.OpenProject C:\Tatin #.Tatin
``` 

and you are ready to go. 

Note that there is no need to save a workspace or anything: every function, operator, class, interface or namespace script changed in `#.Tatin` will be automatically saved to disk by acre.


## Prepare either the Client or the Server

If you want to run any Tatin client code execute the function

```
#.Tatin.Admin.Initialize_Client
```

If you want to run the Tatin Server execute the function

```
#.Tatin.Admin.Initialize_Server
```

You are advised _not to run_ the Client and the Server in the same workspace.


## Execute the test cases

It is recommended to start a fresh APL session and then load Tatin into the CLEAR WS before running the test cases.

A> ### Creating a new version
A>
A> Creating a new version is actually discussed later in this document, but there are situations when you need to create a new version _before_ you execute the test cases.
A>
A> The reason for this is that one group of test cases executes user commands. If they are affected by anything you've contributed then naturally you want the new version to be available in `⎕SE` for execution, but that is only possible if you create a new version first.

By default port 443 is used for the test cases. You may change the INI files for both server and client if that does not work for you.

In order to execute the full test suite you need to start a Tatin Server first. For that execute the following steps:

1. Instantiate Dyalog Unicode 18.0 or later

2. Execute this:

   ```
   ]acre.OpenProject /path/to/Tatin #.Tatin
   ```

3. Execute this:

   ```
   #.Tatin.TestCasesServer.RunTests
   ```

   This function changes the current directory, establishes all required references and then instantiates the `Tester2` class under the name `T` before finally calling the `T.Run` function; this will start a Tatin server.


Now you are ready to execute the test suite.

1. Instantiate Dyalog Unicode 18.0 or later

2. Execute this:

   ```
   ]acre.OpenProject /path/to/Tatin #.Tatin
   ```

3. Execute this:

   ```
   #.Tatin.TestCases.RunTests
   ```

   This changes the current directory, establishes all required references, instantiates the `Tester2` class under the name `T` before finally calling the `T.Run` function; this will run all test cases, including those that communicate with the Tatin test server and the principal Tatin server available at <https://tatin.dev>

A> ### On test cases
A>
A> The procedure outlined in this document discusses just how to run tests in case you expect them to succeed. The test framework offers much more than that: it is flexible and powerful; for details refer to <https://github.com/aplteam/Tester2>
A>
A> If you want (or must) take advantage of the test framework's features in order to, say, hunt down a bug, then you should look into the two functions `#.Tatin.TestCases.RunTests` and `#.Tatin.TestCasesServer.RunTests`.
A>
A> In particular the `Prepare` function, which is called by the `RunTests` functions, is important: it instantiates the `Tester2` class as `T`, and that's the starting point for whatever you are trying to achieve.


## Do your thing

Now that you have a working version of Tatin on your machine you can start contributing.

If you find parts of this document confusing, outdated, unclear or missing bits and pieces: change it; that might well be your first valuable contribution.

Whether you improved the documentation or fixed a bug or added a feature, at the end of the day you need to create a Pull Request (PR). That will make the people in charge of the Tatin project check your contribution. At the time of writing that is APL Team Ltd, but this might (and eventually will) change in the future of course.


## How to create new versions

Usually your job is done once you've created a Pull Request (PR). However, here we document what the administrator of the Tatin project on GitHub needs to do once she has accepted at least one PR or finished her own work on a branch.

In order to create new versions of the Client and the Server all you need to do is to execute:

```
{noQLXFlag} #.Tatin.Admin.Make {type}
```

* `noQLXFlag` is an optional Boolean that defaults to 0. Setting this to 1 makes sense only for debugging purposes.

* `type` must be an integer in the range of 0, 1, 2 or 3.

   | 0 | The version number is not changed apart from the build ID which is always bumped
   | 1 | The patch number is bumped
   | 2 | The minor version is bumped; the patch number is set to 0
   | 3 | The major version is bumped; minor and patch number are set to 0

Note that the `Make` function will fire up two instances of Dyalog APL, one for creating the client version, one for creating the server version. `noQLXFlag`, if 1,  prevents the interpreter from running the code straight away. 

A> ### The `load` and `lx` command line parameters
A> Despite its name `noQLXFlag` is not associated with `⎕LX`: for this to work the command line parameters `load` and `lx` are invoked, and `-x` is added in case `noQLXFlag` is 1, preventing the interpreter from excuting the expression noted as `lx.` 
A>
A> These were introduced in 18.0.

The `Make` function performs the following steps:

1. It runs `Tatin.Admin.MakeClient`

1. It compiles the documentation (markdown) to HTML files and copies them around

1. It runs `#.Tatin.Admin.MakeServer`

In the process the `Dist/` folder will be recreated from scratch. The `.zip` files in `Dist/` are to be released on GitHub.

There will be three zip files:

```
Tatin-Client-{major}.{minor}.{patch}.zip
Tatin-Documentation-{major}.{minor}.{patch}.zip
Tatin-Server-{major}.{minor}.{patch}.zip
```
