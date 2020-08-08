# Tatin for developers

If you want to contribute to the [Tatin project on GitHub](https://github.com/aplteam/Tatin) or make adjustments to Tatin for an in-house project, this document will help you.


## Tatin is managed by acre

Note that Tatin is managed by the [acre project management tool](https://github.com/the-carlisle-group/Acre-Desktop).

Though it is possible making changes to Tatin or adding code without acre, it is much easier to use acre.


## Requirements

In order to work on Tatin you need at least Dyalog 18.0 Unicode (it will never run in Classic). 

You need one of: Windows, Linux, Mac-OS. The Pi is not supported but that restriction might be lifted with a later version. AIX will never be supported.


## How to work on Tatin

After downloading Tatin from GitHub and saving it somewhere, say in `C:\Tatin`, you issue the command 

```
]acre.OpenProject C:\Tatin #.Tatin
``` 

and you are ready to go. 

Note that there is no need to save a workspace or anything: every function, operator, class, interface or namespace script changed in `#.Tatin` will be automatically saved to disk by acre.


## Prepare the Tatin Client

If you want to use the Tatin client module execute the function

```
#.Tatin.Admin.Initialize_Client
```


## Prepare the Tatin Server

If you want to run the Tatin Server execute the function

```
#.Tatin.Admin.Initialize_Server
```


## Execute the test cases

Note that by default port 443 is used for the test cases. You may change the INI files for both server and client if that does not work for you.

Note that in order to execute the full test suite you need to start a Tatin Server first. For that execute the following steps:

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

   This will run all test cases, including those that communicate with the Tatin test server.



## How to create new versions

In order to create new versions of either client or server follow these steps:

1. Change either the `#.Tatin.Client.Version` or the `#.Tatin.Server.Version` function or both.

1. Run either the `#.Tatin.Admin.MakeClient` or the `#.Tatin.Admin.MakeServer` function.

   These functions put everything together needed to run either the client or the server. Eventually it is all copied into a ZIP file. The ZIP file will be saved in the `Dist/` folder and can be published as a release to GitHub.

   Note that in case you need to create both Client and Server you need to restart with a fresh instance of Dyalog after having called the first `Make` function.