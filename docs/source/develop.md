# Developing

!!! abstract "To make changes or add new features you need a good understanding of the basic design of Tatin."


## :fontawesome-solid-code: Tatin code

Four ordinary namespaces contain the Tatin code.

-----------|---
`Admin`    | Helpers useful to administrate Tatin, for example creating a new version, performing maintenance tasks etc.
`Client`   | The code executed on the Client side of Tatin.
`Registry` | All code shared by a Tatin client and a Tatin server.
`Server`   | The code to run a Tatin Server


## :fontawesome-solid-sitemap: Dependencies

-----------|---
[`Plodder`](https://github.com/aplteam/Plodder) | A fully-fledged HTTP server based on Rumba and Conga
[`RumbaLean`](https://github.com/aplteam/RumbaLean) | An implementation of HTTP 1.1 in APL

These two packages are used by, but do not form part of, the Tatin project.


## :fontawesome-solid-reply: Server handlers

The main server handlers are:

    #.Tatin.Server.OnRequest
    #.Tatin.Server.OnHouseKeeping

`OnRequest` will eventually call one of these:

    Handle_GET
    Handle_PUT_And_POST
    Handle_Delete

These call the Tatin functions that perform the real actions.


## :fontawesome-solid-certificate: Server certificates

The Tatin server comes with test certificates.

GitHub prohibits downloading certificates, so the certificate files have an additional extension `.RemoveMe` which needs, well… removing.

Check the folder `TestServer/Server/Assets/Runtime/Certificates`.



## :fontawesome-solid-person-digging: Set the DEVELOPMENT flag

By default, code for user commands and API calls is stored and executed in `⎕SE` – but

!!! danger "Link does not save changes to code in `⎕SE`."

This stumbling block was addressed in version 0.106.0
with the `⎕SE._Tatin.DEVELOPMENT` variable.
Now, when Cider opens the Tatin project it asks:

    Set DEVELOPMENT←1 in ⎕SE._Tatin?
    (Allows executing user command code in # rather than ⎕SE)
    (Y/n)

Setting the flag tells Tatin to execute user commands and API calls using the code in `#`, where Link will save any changes you make.

If the flag is not set Cider <!-- won’t ask the question, and  --> will execute code in `⎕SE` as usual.

If the flag is already set to zero, Cider will not ask if you want to change it.

<!-- 
FIXME
Can this be right? Cider will ask if you want the flag set, but only if the flag is already set?
 -->


## :fontawesome-solid-server: Developing with a running server

You could run a Tatin server as an open Cider project
and investigate what the code in the running server is doing, with Link saving any changes and additions you make.

You might even want to run the server in one workspace as an opened Cider project, while running the test cases in another workspace, also as an opened Cider project.

You would need to be very careful lest you lose code. (See warning box below.)

Suppose you want to run the Tatin server that is part of the Tatin project.
When the Tatin test cases are executed, Tatin would ask you whether you want to start this server automatically.
(Not `https://test.tatin.dev`.)

However, when the server is started as part of the tests it is NOT opened as a Cider project, and changes would not be tracked by Link.
To link the running server code to its source files:

1. Open the Tatin project with `]CIDER.OpenProject` with the `watch` parameter set to `'both'`.
1. Run the function `#.Tatin.TestCasesServer.RunTests`


## :fontawesome-solid-clone: Opening Tatin as a project in two workspaces

In developing Tatin it is natural to have two Dyalog instances running: one each for the client and server code.

The test server must be run in its own instance: you cannot run both the client and the server in the same workspace.

!!! danger "Opening Tatin as a project in two different workspaces, and changing code in both is dangerous!"

With .NET you can limit the danger:

-   Set Link’s `Notify` parameter to 1. That makes Link print to the session whenever it updates a file or the workspace, so you get some feedback on what is happening. Ensure you watch this!
-   Set Link’s `watch` parameter to `'both'` in both workspaces.

!!! warning inline end "Without .NET"

    On non-Windows platforms with no .NET available, `watch=both` is not an option, so that is particularly dangerous.

Then when you change an APL object in one workspace, it will not only be written to disk: Link will **also** bring that change into the other workspace.

This is particularly important when you change code in the `Tatin.Registry` namespace, because that code is shared between the client and the server.

**Watching Link’s reports in the session**
is important: the .NET mechanism used by Dyalog works _most of the time_ but not always, so it is important to watch for problems.

If you just want to run the test server, close the project before executing

    #.Tatin.TestCasesServer.RunTests


## :fontawesome-solid-bug: Trapping errors

Error trapping is active, so if you change a function and inject a typo, it will trigger error trapping when the code gets executed.

!!! tip inline end "`⍝TODO⍝` reminders"

    `⍝TODO⍝` is a reminder that won’t go unnoticed: a test case detects and reports these markers and reports them.

To avoid locking horns with error trapping, you could put into `OnRequest`

    ⎕TRAP←0 'S'  ⍝TODO⍝

Also, make `⎕TRAP` a local variable in `OnRequest`.


## :fontawesome-solid-chart-diagram: Updating Tatin’s own dependencies

Tatin depends on a couple of Tatin packages, but it cannot be used to load them – the classic bootstrap problem.

To update a package installed in the `packages/` folder, bring it into the `APLSource/` folder by other means:

-   A **single class or namespace script** can simply be copied over; for example, the `Tester2` class.
-   An **ordinary namespace** needs to be copied over as a folder; for example, `CommTools`.



## :fontawesome-solid-terminal: Special REST commands

A Tatin server can support several special REST commands for developing and testing.

These commands are enabled (or not) by the INI entry `[CONFIG]SpecialCommands`.
They should never be supported on a production server.

For example, one command returns an HTML page with all the available commands: navigate to `https://localhost:5001/v1/list-commands`.

The other commands do not return HTML but trigger actions.


