# Tatin - Package Manager for Dyalog APL

Tatin consists of three modules:

* `Tatin` - the client
* `Tatin_Server`
* `Tatin_Registry` - all code that is shared between the client and the server.

The aim is to support Windows, Linux and Mac-OS for both the client and the server. 

Tatin requires Dyalog APL 17.1 Unicode or better.

## 1. Using Tatin

You need to clone the project first.

For loading the modules you need the project management software 
[acre](https://github.com/carlislegroup/acre-desktop). 
Make sure that you have acre installed and ready to use.

Note that acre tracks all changes and saves them to file. 

If you don't want that execute `]acre.CloseProject #.Tatin` after opening the project. 

## 1.1 Running a Tatin server

1. Fire up an instance of Dyalog APL Unicode 17.1 or better
2. Execute `]acre.OpenProject /path/to/Tatin #.Tatin`
3. Excute the function `#.Tatin.Admin.InitForDevelopment_Server`

Note that the Tatin project comes with a test Registry. 

Now you are ready to do these things:

1. Access the server from a browser by entering `http://localhost:8080` into the address bar
2. Run the server-related test cases from the client workspace - see there
3. Start the test server by executing `#.Tatin.Admin.RunTestServer 1`.

## 1.2 Using the Tatin client

At the time of writing 2020-05-04 Tatin is not yet available as a set of user commands or anything that can be loaded into `⎕SE` and then used via its API. 

However, it is easy to play around with it by performing the following steps:

1. Fire up an instance of Dyalog APL Unicode 17.1 or better
2. Execute `]acre.OpenProject /path/to/Tatin #.Tatin`
3. Excute the function `#.Tatin.Admin.InitForDevelopment_Client`

You could now execute the server-related test cases by executing

```
#.Tatin.TestCases.T.Run 1
```

## 2.0 Contributing to the code 

Once you have opened the Tatin project with the `]acre.OpenProject` command you are ready to make code changes.

In case you have a client and a server running at the same time it is recommended to make changes only in one workspace: prevent acre from tracking any changes in the other WS by executing `]acre.CloseProject -all`.

If you wish you may make changes to `#.Tatin` and then create a pull request.

## 3. Documenation

Tatin is under heavy develoment, therefore the documentation is pretty much constantly changing, and naturally the documentation might reflect what the software should be, not necessarily how it actually is right now.

The documentation is available as a Markdown document `Tatin.[md|html]` in the folder `Tatin/docs`.


## Known issues

* Currently neither the Client nor the Server has been tested under Mac-OS. All tests pass under Windows and Linux.
* When the server is stopped it cannot be restarted in the same session: you need to start it from a fresh session.
* The user command tests complain about Conga being already loaded; →⎕LC fixes the problem.

Latest revision 2020-07.16