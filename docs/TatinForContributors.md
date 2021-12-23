[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin for Contributors'
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3
[parm]:numberHeaders     = 2 3 4 5



# Tatin for Contributors

If you want to contribute to the [Tatin project on GitHub](https://github.com/aplteam/Tatin) or make adjustments to Tatin for an in-house project, this document will help you.

Tatin is published under the MIT license, so everybody is welcome to contribute to the code. It is not owned by anybody, it is rather a community project.

This is not an introduction into how to contribute to a project that is hosted on GitHub. If you are not familiar with that then google for "contribute to a github project".


## Tatin is managed by Cider

Note that Tatin is managed by the [Cider project management tool](https://github.com/aplteam/Cider).
If you are not familiar with Cider you are advised to spend some time playing with it before using it for serious work. 30 minutes should suffice.

Though it is possible making changes to Tatin or adding code without Cider, using Cider makes this easier.


## Requirements

In order to work on Tatin you need at least Dyalog 18.0 Unicode (it will never run in Classic). 

You need one of: 

* Windows
* Linux
* Mac-OS. 

The Pi and AIX are not supported but that restriction might be lifted with a later version.


## How to work on Tatin

After downloading Tatin from GitHub and saving it somewhere, say in `C:\Tatin`, you issue the command 

```
]Cider.OpenProject C:\Tatin
``` 

and you are ready to go. 

Note that there is no need to save a workspace or anything: every function, operator, class, interface or namespace script changed in `#.Tatin` will be automatically saved to disk by [Link](https://github.com/dyalog/link).


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

Use `]Cider.OpenProject` to do this.

A> ### Creating a new version
A>
A> Creating a new version is actually discussed later in this document, but there are situations when you need to create a new version _before_ you execute the test cases.
A>
A> The reason for this is that one group of test cases executes user commands. If they are affected by anything you've contributed then naturally you want the new version to be available in `⎕SE` for execution, but that is only possible if you create a new version first.

By default port 5001 is used for the test cases. You may change the INI files for both server and client if that does not work for you.

In order to execute the full test suite you need to start a Tatin Server first. For that execute the following steps:

1. Instantiate Dyalog Unicode 18.0 or later

2. Execute:

   ```
   ]Cider.OpenProject /path/to/Tatin
   ```

3. Execute:

   ```
   #.Tatin.TestCasesServer.RunTests
   ```

   This function changes the current directory, establishes all required references and then instantiates the `Tester2` class under the name `T` before finally calling the `T.Run` function; this will start a Tatin server.


Now you are ready to execute the test suite.

1. Instantiate Dyalog Unicode 18.0 or later

2. Execute:

   ```
   ]Cider.OpenProject /path/to/Tatin 
   ```

3. Execute:

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

## Updating Tatin packages used by Tatin

Although Tatin depends on a couple of Tatin packages, it cannot be used to load those packages; the common bootstrap problem.

For that reason the packages installed in the packages\ folder are copied over to the APLSource\ folder. That allows loading the packages with Link.

If you need to add a package then you need to perform a couple of steps:

* Install that package in packages\ (or packages_dev/ if its only required for the test cases)
* Add the package to the file TatinPackages.config
* Call `#.Tatin.Admin.UpdatePackages 1`

For further details see the comments in the function `UpdatePackages`.


## Do your thing

Now that you have a working version of Tatin on your machine you can start contributing.

If you find parts of this document confusing, outdated, unclear or missing bits and pieces: change it; that might well be your first valuable contribution.

Whether you improved the documentation or fixed a bug or added a feature, at the end of the day you need to create a Pull Request (PR). That will make the people in charge of the Tatin project check your contribution. At the time of writing that is APL Team Ltd, but this might (and eventually will) change in the future of course.


## How to create new versions

### Overview {#ov1}

Usually your job is done once you've created a Pull Request (PR). However, here we document what the administrator of the Tatin project on GitHub needs to do once she has accepted at least one PR or finished her own work on a branch.

In order to create new versions of the Client _and_ the Server you need to perform two steps:

1. Bump the version number: major, minor or patch number. Leave the build number and the version date alone: they will be twisted as part of the build process automatically.

2. Execute:

   ```
   {noQLXFlag} #.Tatin.Admin.Make 1
   ```

### Details

* `noQLXFlag` is an optional Boolean that defaults to 0. Setting this to 1 makes sense only for debugging purposes.

* `⍵` must be 1. This is a simple safety net against accidental calls.

Notes:

* The build ID is always bumped when you create a new version.
* The `Make` function will fire up two instances of Dyalog APL, one for creating the client version, one for creating the server version. `noQLXFlag`, if 1,  prevents the interpreter from running the code straight away. 

A> ### The `load` and `lx` command line parameters
A> Despite its name `noQLXFlag` is not associated with `⎕LX`: for this to work the command line parameters `load` and `lx` are invoked, and `-x` is added in case `noQLXFlag` is 1, preventing the interpreter from executing the expression noted as `lx.` 
A>
A> If this looks unfamiliar to you: these were introduced in 18.0.

The `Make` function performs the following steps:

1. It runs `Tatin.Admin.MakeClient`

1. It compiles the documentation (markdown) to HTML files and distribute the files

1. It runs `#.Tatin.Admin.MakeServer`

In the process the `Dist/` folder will be recreated from scratch. The `.zip` files in `Dist/` are to be released on GitHub. The `Dist/` folder will not appear on GitHub due to `.gitignore`.

There will be three zip files:

```
Tatin-Client-{major}.{minor}.{patch}.zip
Tatin-Documentation-{major}.{minor}.{patch}.zip
Tatin-Server-{major}.{minor}.{patch}.zip
```

### Create just a new Client (or Server) version

#### Overview {#ov2}

If you have worked just on the Client or just the Server you may be inclined to save time by creating not both. and also avoid compiling the documentation.

However, there is some danger to get it wrong:

* Client and Server share the code in the namespace `Registry`, so you just **must** make sure that nothing in that namespace was changed, otherwise you should create both Client and Server

* The build number is bumped, and that's how it should be, but as a result the ZIP created will have different build number for Client and Server.

Therefore, as a rule of thumb, **always** create both Client and Server in case you want to publish that version. 


#### How-to

You may create just the client side with:


Note also that 


## Creating a proofread document

There is a function that creates a single HTML file from all the Tatin markdown documentation. That makes proofreading significantly easier:

```
      htmlFilename←#.Tatin.Admin.CreateProofReadDocument 1
```

Now open that file with the word processor of your choice and use its spell-checking capabilities.

