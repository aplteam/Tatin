[parm]:title             = 'Tatin: Server Tips'
[parm]:leanpubExtensions = 1
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3
[parm]:numberHeaders     = 2 3 4 5 6


# Server: Tips and tricks

Once you've installed a server there are a couple of things that need to be taken care of.

## Maintenance

### Tags

The most important thing is to watch tags. Tags can be very useful to find a package, but the problem is that package authors tend to use different tags for the same thing, use legal but different spelling (UK versus US) or invalid spelling, tags that make no sense like adding the group name or "dyalog" etc.

That means that for tags to work there has to be a gatekeeper who is responsible for correcting/removing/adding tags.

That gatekeeper needs to be able to execute code on the server, but only once. The idea is to correct problems in the package config files somehow.

A> ### The package config file and the ZIP file 
A>
A> Note that changing the config file is enough: If the file got changed then Tatin will make sure that the new version is automatically also added to the ZIP file of the package, effectively overwriting the old version of the package file. 

This can be achieved by uploading an `.aplf` text file (read: a function) into a folder that is defined in the INI file as `[CONFIG]MaintenancePath`.

If one or more of such files are found by the Tatin Server while doing housekeeping, they are loaded into the server and executed. Once executed the files are renamed by adding an extension `.executed`.

For example, if there is a file `RemoveDyalogFromTags.aplf` then it is loaded into an unnamed namespace and called with a right argument `G` (for "globals"). Once executed the file is then renamed to `RemoveDyalogFromTags.aplf.executed`.

That makes sure the code is not executed again, but it is also useful for documenting what code was executed, and when.

#### Crashing maintenance files

Like any other program, a maintenance file may crash. If that happens the server carries out the following steps:

1. Report it to the log file
2. Send an email reporting the crash with details to the maintainer (if enabled in the INI file)
3. Rename the file from `*.aplf` to `*.crashed` --- we don't want that function to be executed again


## Developing

If you want to make changes or add new features you need a good understanding of the basic design of Tatin.


### Structure

#### Main namespaces

Four ordinary namespaces contain all the Tatin code:

`Admin`

: Contains helpers useful to administrate Tatin, for example creating a new version, performing maintenance tasks etc.

`Client`

Contains the code executed on the Client side of Tatin.

`Server`

Contains the code to run a Tatin Server
 
`Registry`

Contains all code that is shared by a Tatin client and a Tatin server.

#### Other stuff

There are some more ordinary namespaces that are used by Tatin

`Plodder`

: A fully-fledged HTTP server that is based on Rumba and Conga

: For details see <https://github.com/aplteam/Plodder>

`RumbaLean`

: An implementation of HTTP 1.1 in APL

: For details see <https://github.com/aplteam/RumbaLean>

These two are not part of the Tatin project.


### Version

Note that by design new versions always comprehend both the server and the client, so the version number is always the same for both.


### Developing with a running server

You might want to run a server while Tatin is an open Cider project. The running server allows you to investigate what the code is doing, and at the same time, any changes and additions would be tracked by Link.

You might even want to run the server in one workspace as an opened Cider project and at the same time run the test cases in another workspace, also as an opened Cider project. Of course you need to be very careful because otherwise you might loose code.

Let's assume that you want to run the Tatin server that is part of the Tatin project. When the Tatin test cases are executed, Tatin would ask you whether you want to start the server automatically -- that is the server we are talking about, **not** https://test.tatin.dev.

However, when the server is started as part of the tests it is NOT opened as a Cider project, and changes would not be tracked by Link. If you want that then execute the following steps instead:

1. Open the Tatin project with `]Cider.OpenProject` with the `watch` parameter set to "both".

1. Run the function `#.Tatin.TestCasesServer.RunTests`

!> ### A word of warning
=> Opening Tatin as a project in two different workspaces, and then make changes to the code in both of them is of course dangerous!
=>
=> On Windows or when .NET is available you can limit the danger by doing this:
=> 
=> * Make sure that Link's `Notify` parameter is set to 1. That makes Link print to the session whenever it updates a file or the workspace, so you get some feedback on what is happening. Make sure you watch this!
=> 
=> * Make sure that you set Link's `watch` parameter to "both" in both workspaces. 
=>
=>   That ensure that when you change an APL object in on workspace, it will not only be written do disk but Link will also bring that change into the other workspace.
=> 
=> This is particularly important when you change code in the `Tatin.Registry` namespace, because that code is shared between the client and the server.
=> 
=> Taking these measure is important because the mechanism used by Dyalog works most of the time but not always (it's a .NET-problem!), so it is important to watch out for such problems.
=> 
=> On non-Windows platforms with no .NET available, `watch=both` is not an option at the time of writing (July 2024), so that is particularly dangerous.

If you just want to run the test server, close the project before executing `#.Tatin.TestCasesServer.RunTests`.

The main handlers are:

  * `#.Tatin.Server.OnRequest`
  * `#.Tatin.Server.OnHouseKeeping`

`OnRequest` will eventually call one of these:

  * `Handle_GET`
  * `Handle_PUT_And_POST`
  * `Handle_Delete`

These will call the Tatin functions that perform the real actions.

#### Error trapping

Keep in mind that error trapping is active, so when you change a function and inject a typo this will trigger error trapping  once your code gets executed.

If there is any danger of you locking horns with error trapping, consider putting this into `OnRequest`:

`⎕TRAP←0 'S'  ⍝TODO⍝`   

Also, make `⎕TRAP` a local variable in `OnRequest`.

`⍝TODO⍝` is a reminder that won't go unnoticed: there is a test case that will detect these markers and report them, so it's pretty hard to forget them.


## Misc

### Special REST commands 

A Tatin server can offer several special REST commands only useful for a developer when testing Tatin. They should never be available on a production server.

Whether these commands would be carried out is decided by the INI entry `[CONFIG]SpecialCommands`.

One of the commands will return an HTML page with all available commands. We use this as an example.

In a Browser enter this URL:

```
https://localhost:5001/v1/list-commands
```

Note that with the exception `list-commands`, these commands do not return HTML, they rather trigger actions.


### Executing the Tatin test suite

The test framework used is very powerful, and offers lots of options. Naturally only the basics are covered here. 

For more information refer to <https://github.com/aplteam/Tester2>

#### Execute the complete test suite

This can be achieved by executing:

```
#.Tatin.TestCases.RunTests
```

This prepares the test framework and then executes all tests in debug mode, meaning that in case something goes wrong, the framework will stop and you can investigate right away,

You will be asked whether you want to copy the test data to a temp folder in preperation.

On Windows you will also be asked whether you want to start a test server. Usually you will answer both questions with "yes". On Non-Windows platforms you will be asked to start the server yourself before carrying on.

#### Execute particular tests or group(s) of tests

Sometimes it makes sense to execute not all but a small subset of test cases. In this case you might not need test data, or a running test server, depending on that test cases you are about to execute.

This can be achieved as well; first you need to excute:

```
#.Tatin.TestCases.Prepare
```

This initializes Tatin as a client and prepares for creating a code-coverage report. It also creates a number of references needed by the tests.

You only need to call `Prepare` once.

In a second step you can excute one or more tests. A couple of examples:

Execute one particular test of the `UC` group:

```
#.Tatin.TestCases.T.RunThese 'UC' 600
```

Execute several tests of the `UC` group:

```
#.Tatin.TestCases.T.RunThese 'UC' (600 601 602)

```

Execute all tests belonging to the `UC` group:

```
#.Tatin.TestCases.T.RunThese 'UC'
```

#### Execute just batch tests

A small number of tests require a user that can be asked to perform actions, like closing an edit window. 

Sometimes you might want to execute only tests that do not require a human in front of the monitor. These are called batch tests.

These tests can be executed by executing:

```
#.Tatin.TestCases.RunBatchTests 1
```

The 1 required as right argument is just a safety net against accidental calls.

By default error trapping is in place: in case a test case fails or crashes, this is covered, and the test framework carries on. 

If you want batch tests to stop in case of a problem, you must specify the optional `debug` flag as left argument:

```
1 #.Tatin.TestCases.RunBatchTests 1
```

### Creating a new version

1. Check `#.Tatin.Registry.Version` for being correct
2. Check `#.Tatin.Registry.History` for being correct
3. Check the document `docs/ReleaseNotes.md` for being correct
4. Ask Cider how to "Make" a new version with `]Cider.Make`

It will tell you to execute:

```
#.Tatin.Admin.Make 0
```

The right argument is a batch flag: it tells the function whether a human is available (0) or not (1). If there is, progress is reported to `⎕SE`. Naturally the latter is used in  order to automatically create a new version.

Note that if the batch flag is 0, the function will print a statement to the session which, when executed, will install the new version.

### Licensing


#### INI entries

The names of the licenses as well as the URLs that are to be accepted by a server must be defined in the INI file of the server within the `[LICENSE]` section.

Note that the INI section `[LICENSE]` _may_ exist, but it does not have to: if it does not, then no menu item "Licensing" will show in the main menu of the website, and the server will accept any license, including packages that do not even carry a property `license`.


#### The menu item "Licensing"

The text shown on the web page is defined in the document "Licensing.html" in the `html/` folder.

#### A "LICENSE" file

By convention a file named "LICENSE" when placed in the root of the project will be copied automatically to the root of a package when build by `BuildPackage`. This convention is independent from the INI file.






