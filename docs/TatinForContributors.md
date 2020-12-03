[parm]:leanpubExtensions = 1
[parm]:title             = 'Tatin for Contributors'


# Tatin for Contributors

If you want to contribute to the [Tatin project on GitHub](https://github.com/aplteam/Tatin) or make adjustments to Tatin for an in-house project, this document will help you.

Tatin is published under the MIT license, so everybody is welcome to contribute to the code. It is not owned by anybody, it is rather a community project.

This is not an introduction into how to contribute to a project that is hosted on GitHub. If you are not familiar with that then google for "contribute to a github project".


## Tatin is managed by acre

Note that Tatin is managed by the [acre project management tool](https://github.com/the-carlisle-group/Acre-Desktop).
If you are not familiar with acre you are advised to spend an hour or so playing with it before using it for serious work.

Though it is possible making changes to Tatin or adding code without acre, it is much easier to use acre.


## Requirements

In order to work on Tatin you need at least Dyalog 18.0 Unicode (it will never run in Classic). 

You need one of: Windows, Linux, Mac-OS. The Pi is not supported but that restriction might be lifted with a later version. AIX will not be supported.


## How to work on Tatin

After downloading Tatin from GitHub and saving it somewhere, say in `C:\Tatin`, you issue the command 

```
]acre.OpenProject C:\Tatin #.Tatin
``` 

and you are ready to go. 

Note that there is no need to save a workspace or anything: every function, operator, class, interface or namespace script changed in `#.Tatin` will be automatically saved to disk by acre.


## Prepare either the Client or the Server

If you want to tun any Tatin client code execute the function

```
#.Tatin.Admin.Initialize_Client
```

If you want to run the Tatin Server execute the function

```
#.Tatin.Admin.Initialize_Server
```

You are advised not to run the Client and the Server in the same workspace.


## Execute the test cases

It is recommended to start a fresh APL session and then load Tatin into the CLEAR WS before running the test cases.

A> ### Creating a new version
A>
A> Creating a new version is actually discussed later in this document, but there are situations when you need to create a new version _before_ you execute the test cases.
A>
A> The reason for this is that one group of test cases executes user commands. If they are affected by anything you've contributed than naturally you want the new version available in `⎕SE` for execution, but that is only possible if you create a new version first.

By default port 443 is used for the test cases. You may change the INI files for both server and client if that does not work for you.

In order to execute the full test suite you need to start a Tatin Server first. For that execute the following steps:

1. Instantiate Dyalog Unicode 18.0 or later

2. Execute this:

   ```
   ]acre.OpenProject /path/to/Tatin #.Tatin
   ```

3. Execute this:

   ```
   #.Tatin.Admin.Initialize_Server
   ```

   This changes the current directory, loads required dependencies and establishes all required references.

4. Execute this:

   ```
   #.Tatin.TestCasesServer.Prepare
   ```

   This instantiates the `Tester2` class under the name `T`.

5. Execute this:

   ```
   #.Tatin.TestCasesServer.T.Run 1
   ``` 

   This will start a Tatin server.


Now you are ready to execute the test suite.

1. Instantiate Dyalog Unicode 18.0 or later

2. Execute this:

   ```
   ]acre.OpenProject /path/to/Tatin #.Tatin
   ```

3. Execute this:

   ```
   #.Tatin.Admin.Initialize_Client
   ```

   This changes the current directory, loads required dependencies and establishes all required references.

4. Execute this:

   ```
   #.Tatin.TestCases.Prepare
   ```

   This instantiates the `Tester2` class under the name `T`.

5. Execute this:

   ```
   #.Tatin.TestCases.T.Run 1
   ``` 

   This will run all test cases, including those that communicate with the Tatin test server and the principal Tatin server available at <https://tatin.dev>


## Do your thing

Now that you have a working version of Tatin on your machine you can start contributing.

If you find parts of this document confusing, outdated, unclear or missing bits and pieces: change it: that might well be your first valuable contribution.

Whether you improved just documentation or fixed a bug or added a feature, at the end of the day you need to create a Pull Request (PR). That will make the people in charge of the Tatin project check your contribution. At the time of writing that is APL Team Ltd, but this might (and eventually will) change in the future of course.


## How to create new versions

Usually your job is done once you've created a Pull Request (PR). However, here we document what the administrator of the Tatin project on GitHub needs to do once she has accepted at least one PR or finished her own work on a branch.

In order to create new versions of either the Client or the Server the following steps need to be executed:

1. Change the `#.Tatin.Registry.Version` function; there is a `#.Tatin.Client.Version` as well as a `#.Tatin.Server.Version` function, but they both just call `#.Tatin.Registry.Version` anyway.

1. Run `#.Tatin.Admin.Make`

   This function will first fire up a session and put together a Client. Along the process it might well ask some questions.

   It will then fire up a second session and put together a Server.

   Along the process any existing `.zip` files in the `Dist/` folder will be deleted, and new ones with the current version number will be created. These `.zip` files is what should be released on GitHub as a new release.

Notes:

| Created:       | 2020-08-11
| Latest update: | 2020-08-19