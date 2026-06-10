# Developing

!!! abstract "To make changes or add new features you need a good understanding of the basic design of Tatin."


## :fontawesome-solid-code: Tatin code

Four ordinary namespaces contain the Tatin code.

-----------|---
`Client`   | The code executed on the Client side of Tatin.
`Server`   | The code to run a Tatin Server.
`Registry` | All code shared by a Tatin client and a Tatin server.
`Admin`    | Helpers useful to administrate Tatin, for example creating a new version, performing maintenance tasks etc.


## :fontawesome-solid-sitemap: Updating Tatin's package dependencies

Tatin depends on a few Tatin packages, but they cannot be used to load them – the classic bootstrap problem.

To update packages installed in `packages/` or `packages_dev/`, run:

```
]ReInstallDependencies /path/to/Tatin/packages -update
```

Notes: 

* If you want to check what Tatin would do, specify the `-dry` flag: this causes the function to report what it would do without actually doing it.

* To upgrade to a newer major version, use the `-major` flag.

Re-installing into `packages/` is not sufficient on its own; the code (and any associated assets) must be copied from packages into the `APLSource/` folder. Only then can Tatin make use of these packages. There is a helper available for this:

```
#.Tatin.Admin.CopyPackagesToAPLSource 1
```

The right argument must be a 1, otherwise the function will throw an error.
The left argument is optional and must be a flag. Default is 0, and a 1 forces a dry run, meaning that actions to be taken will be reported without actually carrying them out.

!!! danger "Make sure you do not make changes to any of those packages."

    That is a mistake that is easy to make, because it is not obvious what code is part of a package and what code isn't! That's why the packages are installed in the `packages/` folder: that documents not only the packages, it is a record of the code as well.

    When code that came from a package is changed, Link will save it on disk, and that appears to be fine. Until a new version of the package comes along, you re-install all packages in the `packages/` folder and then call the `Admin.CopyPackagesToAPLSource` helper - and your change is gone!

    If you need to change code that came from a package, you must change the package itself!

## :fontawesome-solid-sitemap: Other Dependencies

-----------|---
[`Plodder`](https://github.com/aplteam/Plodder) | A fully-fledged HTTP server based on Rumba and Conga
[`RumbaLean`](https://github.com/aplteam/RumbaLean) | An implementation of HTTP/1.1 in APL

These two dependencies are external to Tatin. Therefore, any modifications or improvements must be made directly in their own source projects, not within Tatin.

These two dependencies must be copied into the folder `Tatin/Assets/Runtime/`.


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

but only if the variable `DEVELOPMENT` is not yet set (is undefined). Setting `DEVELOPMENT` to 1 tells Tatin to execute user commands and API calls using the code in `#`, where Link will save any changes you make.

If `DEVELOPMENT` is set to 0, Cider won’t ask the question, and will execute code in `⎕SE` as usual.


## :fontawesome-solid-server: Developing with a running server

You could run a Tatin server as an open Cider project
and investigate what the code in the running server is doing, with Link saving any changes and additions you make.

You might even want to run the server in one workspace as an opened Cider project, while running the test cases in another workspace, also as an opened Cider project.

You would need to be very careful lest you lose code. (See warning box below.)

Suppose you want to run the Tatin server that is part of the Tatin project.
When the Tatin test cases are executed, Tatin would ask you whether you want to start this server automatically.
(This is not about `https://test.tatin.dev`.)

However, when the server is started as part of the tests, it is NOT opened as a Cider project, and changes would not be tracked by Link.
To link the running server code to its source files:

1. Open the Tatin project with `]CIDER.OpenProject` with the `watch` parameter set to `'both'`.
1. Run the function `#.Tatin.TestCasesServer.RunTests`


## :fontawesome-solid-clone: Opening Tatin as a project in two workspaces

In developing Tatin, it is natural to have two Dyalog instances running: one for the client code and one for the server code.

The test server must be run in its own instance: you cannot run both the client and the server in the same workspace.

!!! danger "Opening Tatin as a project in two different workspaces, and changing code in both is dangerous!"

With .NET, you can limit the danger:

-   Set Link’s `Notify` parameter to 1. That makes Link print to the session whenever it updates a file or the workspace, so you get some feedback on what is happening. Ensure you watch this!
-   Set Link’s `watch` parameter to `'both'` in both workspaces.

!!! warning inline end "Without .NET"

    On non-Windows platforms with no .NET available, `watch=both` is not an option, so that is particularly dangerous.

Then when you change an APL object in one workspace, it will not only be written to disk: Link will **also** bring that change into the other workspace.

This is particularly important when you change code in the `Tatin.Registry` namespace, because that code is shared between the client and the server.

**Watching Link’s reports in the session**
is important: the .NET mechanism used by Dyalog works _most of the time_ but not always, so it is important to watch for problems.

If you just want to run the test server (without changing code), close the project before executing

    #.Tatin.TestCasesServer.RunTests


## :fontawesome-solid-bug: Trapping errors

Error trapping is active, so if you change a function and inject a typo, it will trigger error trapping when the code gets executed.

!!! tip inline end "`⍝TODO⍝` reminders"

    `⍝TODO⍝` is a reminder that won’t go unnoticed: a test case detects these markers and reports them.

To avoid locking horns with error trapping, you could put into `OnRequest`

    ⎕TRAP←0 'S'  ⍝TODO⍝

Also, make `⎕TRAP` a local variable in `OnRequest`.


## :fontawesome-solid-terminal: Special REST commands

A Tatin server can support several special REST commands for developing and testing.

These commands are enabled (or not) by the INI entry `[CONFIG]SpecialCommands`.
They should never be enabled on a production server.

For example, one command returns an HTML page with all the available commands: navigate to `https://localhost:5001/v1/list-commands`.

The other commands do not return HTML but trigger actions.




