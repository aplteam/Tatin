[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin for Contributors'
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3
[parm]:numberHeaders     = 2 3 4 5



# Tatin for Contributors

## Scope of this document

If you want to contribute to the [Tatin project on GitHub](https://github.com/aplteam/Tatin) or make adjustments to Tatin for an in-house project, this document will help you.

Tatin is published under the MIT license, so everybody is welcome to contribute to the code. It is not owned by anybody, it is rather a community project.

This is not an introduction into how to contribute to a project that is hosted on GitHub. If you are not familiar with that then google for "contribute to a github project".

This document also discusses how to execute the test suite and how to build a new version of Tatin.


## Requirements

In order to work on Tatin you need at least Dyalog 18.0 Unicode (it will never run in Classic).

You need one of: 

* Windows
* Linux

The Pi and AIX are not supported, but that restriction might be lifted with a later version. Mac-OS is fine for running the client but not (yet) the server, therefore for development the Mac is not a choice for the time being.

You also need to have Git installed.


## Tatin is managed by Cider

Note that Tatin is managed by the [Cider project management tool](https://github.com/aplteam/Cider).
If you are not familiar with Cider you are advised to spend some time playing with it before using it for serious work. 30 minutes should suffice.

Though it is possible making changes or adding code to Tatin without Cider, using Cider makes it significantly easier. Also, the build process (which currently can run only on Windows) requires Cider.


## How to work on Tatin

After downloading/forking Tatin from GitHub and saving it somewhere, say in `C:\Tatin`, you issue the command 

```
]Cider.OpenProject C:\Tatin
``` 

and you are ready to go. 

Note that there is no need to save a workspace or anything: every function, operator, class, interface or namespace script changed in `#.Tatin` will automatically be saved to disk by [Link](https://github.com/dyalog/link).


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


## Updating Tatin packages used by Tatin

Although Tatin depends on a couple of Tatin packages, it cannot be used to load those packages; the common bootstrap problem.

For that reason the packages installed in the `packages/` folder are copied over to the `APLSource/` folder. That allows loading the packages with Link.

If you need to add a package then you need to perform a couple of steps:

* Install that package into `packages/`
* Call `#.Tatin.Admin.UpdatePackages ⍬`

For further details see the comments in the function `#.Tatin.Admin.UpdatePackages`.


## Do your thing

Now that you have a working version of Tatin on your machine you can start contributing.

If you find parts of this document confusing, outdated, unclear or missing bits and pieces: change it; that might well be your first valuable contribution.

Whether you improved the documentation or fixed a bug or added a feature, at the end of the day you need to create a Pull Request (PR). That will make the people in charge of the Tatin project check your contribution. At the time of writing that is Kai Jaeger, but this might (and eventually will) change in the future of course.

But before you can create a pull request you are supposed to run the tests in order to make sure that you did not break anything.


## Executing the test cases

There are two scenarios: 

1. During development you might want to execute all tests or just a specific group (or groups) of tests. 

   You are sitting in front of the monitor, and therefore tests can ask you to perform certain tasks, like selecting an option from a list etc.

   When a test fails then the test framework stops, and the developer can investigate on the spot.

1. You might want to execute the test suite automatically and in batch mode, meaning that the tests would not attempt to interact with a user. (This implies that test cases that depend on a user won't be executed. Tatin has very few test cases that fall into this category; 95% of the tests are batchable)

   This may be required by an automated build process.

   In this case any errors are trapped, and you get just either a single line that reports success or failure in the session or `⎕OFF` is executed, either without a code (in case of success) or the return code 123, indicating failure to the calling environment.

   Note that a single failing test case is considered as "failure" of the whole test suite, though the test framework will continue to execute all remaining tests.

We discuss the two different scenarios one after the other.

A> ### Creating a new version
A>
A> Creating a new version is actually discussed later in this document, but there are situations when you need to create a new version _before_ you execute the test cases.
A>
A> The reason for this is that one group of test cases executes user commands. If they are affected by anything you've changed then naturally you want the new version to be available in `⎕SE` for execution, but that is only possible if you create a new version first.
A>
A> For that reason one test actually checks whether the version number in the workspace and in `⎕SE` do match. If you are confident that this does not matter in your case just carry on.

### Testing while developing

#### Executing all tests

It is recommended to start a fresh APL session and then load the Tatin project into the CLEAR WS before running any test cases.

Use `]Cider.OpenProject` to do this.

By default the test cases use port 5001 for communication between the Test Server and the client. You may change the INI files for both server and client if that does not work for you.

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

   This function changes the current directory, establishes all required references and then instantiates the `Tester2` class under the name `T` before finally calling the `T.Run` function; this will start a Tatin server in debug mode.

   "Debug mode" means that in case of an error the interpreter stops. If you change functions at this stage those changes will be written back to disk, so be careful.


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

A> ### Execute the client test suite multiple times in parallel
A>
A> You might come up with the idea to start the client part of the tests multiple times in parallel in order to put some pressure on the Tatin Server.
A>
A> In general this is a good idea, but the client test suite is not suitable for this. For example, the tests that belong to the "Cache" group _must_ be executed one after the other, they rely on each other. Generally this should be avoided, but here for technical reasons it's a must. Running this group in parallel contradicts this, and is bound to fail.

#### Executing only particular tests

The `Tester2` test framework is flexible and powerful; for example, you may execute only the tests that focus on the Tatin Client API. The names of those tests are `Test_API_<number>`.

A> ### Why executing only a few tests?
A>
A> The full test suite is exhaustive, and for that reason it takes considerable time. Therefore you might be interested in executing only certain parts of the test suite. 
A>
A> The tests are grouped, and that is reflected by the names of the test functions. For example, the names `Test_API_001` and `Test_UserCommand_001` clearly state which group they belong to.

If you are not interested in executing only some of the test cases then skip this and carry on with "[Tests as part of an automated build](#)".

Before executing any test case call this function:

```
#.Tatin.TestCases.Prepare
```

This changes the current directory, establishes all required references and instantiates the `Tester2` class under the name `T`.

You can now list all groups of tests:

```
      T.ListGroups
 Test_API             27   
 Test_Build            1   
 Test_Cache           10   
 Test_CheckVersions    6   
 Test_ClientConfig    19   
 Test_Demo             9   
 Test_HTTP             6   
 Test_InstallAndLoad  24   
 Test_InstallLatest   11   
 Test_ListPkgs        22   
 Test_ListRegistries   1   
 Test_ListTags         6   
 Test_ListVersions     8   
 Test_Load            38   
 Test_LoadBest         4   
 Test_LX               5   
 Test_Misc            19   
 Test_Pack            19   
 Test_PkgCfg           9   
 Test_Publish         15   
 Test_ReInstall        7   
 Test_ScanRegistries   4   
 Test_Server          63   
 Test_Uninstall       15   
 Test_UserCommands    42   
 Test_ZZZ              4   
```

The number tells how many tests a group comprehends.

You can also list all tests, say for the group `SanRegistries`:

```
      T.ListTestFunctions 'Scan*'
 Test_ScanRegistries_002  Search for a specific package without specifying a Registry...
 Test_ScanRegistries_003  Enforce a Registry scan after defining a non-existing Regis...
 Test_ScanRegistries_004  Enforce a Registry scan after defining a non-existing Regis...
 Test_ScanRegistries_005  Enforce a Registry scan. The first "Registry" returns HTML ...  
```

Notes:

* The wildcard character (`*`) can be used to identify a group
* The first comment line after any header lines is displayed

You may specify `'view'` as left argument to force the result of that function into a read-only edit window.

Let's assume that you want to execute all tests of the group `API`:

```
T.RunThese 'API'
```

Or just the tests 8 and 20 of the group `API`:
 
```
T.RunThese 'API' (8 20)
```

Or run the groups `API` and `Misc`:

```
T.RunThese 'API,Misc'
```

Or run all tests but `UserCommand`:

```
T.RunThese '~UserCommand'
```

Last not least you may specify a 1 as left argument: this makes the test framework stop just before any particular test function is executed. This can be very handy in order to hunt down a bug, or any unexpected behaviour.

```
1 T.RunThese 'API'
```

The test framework offers many more options and features, refer to the documentation for exploring them: go to <https://github.com/aplteam/Tester2> (full picture) or execute `]ADOC #.Tatin.Tester2` (reference).


### Tests as part of an automated build

You may wish to execute the tests that do not require a human in front of the monitor as part of an automated build process.
Tatin is prepared for this.

You can start the test suite either from APL or from the command line.

#### Running the test suite from APL

Call this function:

```
#.Tatin.TestCases.RunBatchTests 1
```

The `1` provided as right argument is just an insurance against accidental calls.

When running the test suite with the batch flag set, as `RunBatchTests` does, is fundamentally different in several respects:

* A Tatin server that listens (by default) on port 5001 is started (and is also shut down) by the test suite itself.
* By default all errors are trapped. 

  If you need to track down a bug then you don't want this: in that case pass a `1` as left argument: this is treated as "debug" flag.

Of course `RunBatchTests` does not execute any test cases that require a human in front of the monitor, but the number of such tests is pretty small anyway.

`RunBatchTests` checks the command line:

* In case `OFF=1` was specified on the command line then `⎕OFF` is executed after the last test case got executed.

  If one or more test cases failed then `⎕OFF 123` is executed. That allows the calling environment to check whether the test suite was executed successfully in its entirety or not.

* If `OFF=1` was not specified a message is printed to the session, indicating success or failure.

#### Running the test suite from a console or terminal

There are two scripts available in the Tatin root directory:

1. `RunTests.bat` if you want to run the batch tests under Windows

2. `RunTests.sh` is you want to run the batch tests on a non-Windows platform

These are templates: check their contents, you might need to make amendments. 


## How to create new versions

### Overview {#ov1}

Usually your job is done once you've created a Pull Request (PR). However, here we document what the administrator of the Tatin project on GitHub needs to do once she has accepted at least one PR or finished her own work on a branch.

In order to create new versions of the Client and the Server you just need to call this function:

```
{noQLXFlag} #.Tatin.Admin.Make <batchFlag>
```

Syntax:

* The right argument must be a Boolean:
  * `0` means that a human is sitting in front of the monitor and can be asked questions or perform actions
  * `1` means that no human is available; use this in case you want to create a new version automatically, for example from a batch script
* `noQLXFlag` is an optional Boolean that defaults to `0`, see below for details.

  It would mean that the instances of Dyalog started to create the Client and the Server won't execute the `lx` command line parameter, allowing you to run the code in the Tracer.


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

If the right argument was a `0` then it will also ask you whether you want to attempt an update for all packages Tatin itself depends on, and it would also ask you whether the new version of the Tatin Client should be copied to the `MyUCMDs/` folder.

In the process the `Dist/` folder will be recreated from scratch. The `.zip` files in `Dist/` are to be released on GitHub. The `Dist/` folder will not appear on GitHub due to `.gitignore`.

There will be three zip files:

```
Tatin-Client-{major}.{minor}.{patch}.zip
Tatin-Documentation-{major}.{minor}.{patch}.zip
Tatin-Server-{major}.{minor}.{patch}.zip
```

## Creating a document for proofreading

There is a function that creates a single HTML file from all the Tatin markdown documentation. That makes proofreading significantly easier:

```
      htmlFilename←#.Tatin.Admin.CreateProofReadDocument 1
```

Now open that file with the word processor of your choice and use its spell-checking capabilities.

