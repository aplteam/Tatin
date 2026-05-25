---
title: 'Testing Tatin'
description: 'How to execute the test suite, and how to build a new version.'
keywords: 'apl, dyalog, github, tatin, test, testing'
---
# Testing Tatin


!!! abstract "Before submitting a pull request for your changes, confirm they pass the tests."


The Tester2 framework used for testing Tatin is very powerful, and offers lots of options.
Only the basics are covered here.

:fontawesome-brands-github:
[Tester2](https://github.com/aplteam/Tester2)<br>
`]ADOC #.Tatin.Tester2` (reference)


1.  **Open** Tatin in a new instance of Dyalog.

        ]CIDER.OpenProject /path/to/Tatin

1.  **Prepare** the test framework.

        #.Tatin.TestCases.Prepare

    This initializes Tatin as a client and prepares for creating a code-coverage report.
    It also creates a number of references needed by the tests.

    It changes the current directory, establishes all required references and instantiates the `Tester2` class as `T`.

    You need call `Prepare` only once.


1.  **Run** the tests.


## :fontawesome-solid-play: Run the full test suite

        #.Tatin.TestCases.RunTests

This runs all the tests in Debug mode, so if something goes wrong the framework will stop and you can investigate right away,

You will be asked if you want to copy the test data to a temporary folder in preparation.
The usual answer is Yes.

=== ":fontawesome-brands-windows: Windows"

    You will be asked if you want to start a test server.
    The usual answer is Yes.

=== ":fontawesome-brands-linux: Linux  :fontawesome-brands-apple: macOS"

    You will be asked to start the server yourself before carrying on.
    **With this procedure for starting a Test Server, testing cannot be automated.**

    You will be shown a command like

        )Load /path/2/test-server/RunTatinServer.dws

    Copy the command and run it in a new Dyalog instance.
    The command will load and run the server in a temporary directory.

??? detail "What RunTests does"

    -   Changes the current directory
    -   Establishes all required references
    -   Instantiates the `Tester2` class as `T`
    -   Starts a local Tatin test server if you confirm (Windows), or helps you start a test server (other platforms)
    -   Calls the `T.Run` function to run all the test cases, including those that communicate with a locally running Tatin test server and the principal Tatin server available at <https://tatin.dev>


## :fontawesome-solid-circle-play: Run selected tests

Executing the full test suite takes considerable time.
Also, caching is switched off (except when caching itself is tested).
You will often want to run only parts of the test suite.

The tests are grouped, with the grouping reflected in the names of the test functions,
for example, `Test_API_001` and `Test_UserCommand_001`.



### Choose tests

You can now list the groups and the number of tests in them:

          T.ListGroups
     Test_API             27
     Test_Build            1
     Test_Cache           10
     Test_CheckVersions    6
     ...

You can also list tests whose names match a pattern:

          T.ListTestFunctions 'Scan*'
     Test_ScanRegistries_002  Search for a specific package wit...
     Test_ScanRegistries_003  Enforce a Registry scan after def...
     Test_ScanRegistries_004  Enforce a Registry scan after def...
     Test_ScanRegistries_005  Enforce a Registry scan. The firs...

The first comment line after any header lines is displayed.

Specify `'view'` as the left argument to display the list in a read-only Editor window.


### Run one or more tests

The first example below runs the `Test_UC_600` function, and so on.

        #.Tatin.TestCases.T.RunThese 'UC' 600            ⍝ one test
        #.Tatin.TestCases.T.RunThese 'UC' (600 601 602)  ⍝ three tests
        #.Tatin.TestCases.T.RunThese 'UC'                ⍝ whole group
        #.Tatin.TestCases.T.RunThese 'API,Misc'          ⍝ two groups
        #.Tatin.TestCases.T.RunThese '~UserCommand'      ⍝ all except..

Depending on which test cases you select, you might not need test data, or even a running test server,


## :fontawesome-solid-list-check: Run batch tests

Batch tests do not require user interaction.

To run only the batch tests:

    #.Tatin.TestCases.RunBatchTests 1

<!-- FIXME What – what, no preparation? -->

The 1 required as right argument is a protection against accidental calls.
<!-- FIXME Eh? -->


## :fontawesome-solid-eject: Abort a test run

You might need to abort the test suite, for example if a test reveals a severe bug that makes running the remaining tests pointless.

Resist the temptation to use `)reset`; instead make the test suite clean up after itself:

    #.Tatin.TestCases.T.QuitTests



## :fontawesome-solid-bug: Debug mode

Errors are trapped by default: if a test case fails or crashes, the test framework carries on.

In Debug mode, the test suite stops on errors to allow you to investigate.

Functions `RunThese` and `RunBatchTests` both take a flag as an optional left argument.

The default value is 0.
When set to 1, tests are run in Debug mode.

    1 #.Tatin.TestCases.T.RunThese 'UC' (600 601 602)
    1 #.Tatin.TestCases.RunBatchTests 1

<!-- Assume these are executed by #.Tatin.TestCases.RunTests and #.Tatin.TestCases.Prepare

## Prepare for testing

### Prepare client

To run the test suite, prepare the client.

    #.Tatin.Admin.Initialize_Client

### Prepare server

If you also want to run the test server, independently from the test suite, prepare the server – but in its own own workspace.

    #.Tatin.Admin.Initialize_Server
 -->


## :fontawesome-solid-code-pull-request: A new version for testing

In a normal workflow you create a new version of Tatin only _after_ passing all the tests.

But there are scenarios in which you need a new version _in order_ to run the tests.

For example, suppose one group of tests executes user commands.
If your code changes affect the commands, then you need the changed code in `⎕SE` for testing – but that requires that you first create a new version.

For this reason, a test checks that the version number in the workspace and in `⎕SE` match.


## :fontawesome-solid-gears: Automated builds

You can run batch tests as part of an automated build process;
start the test suite either from APL or from the command line.


### Running tests from APL

    #.Tatin.TestCases.RunBatchTests 1

The test suite itself starts (and shuts down) a Tatin server; Debug mode is off.

The function ignores the few test cases that require human interaction

`RunBatchTests` checks the command line that launched Dyalog to see if `OFF2=1` was specified
then, after the last test case

----------|-------------------------
specified | If all tests passed, executes `⎕OFF`; otherwise `⎕OFF 123`.<br><br>The calling environment can see whether all the tests were passed or not.
not       | A message is printed to the session, indicating success or failure.

!!! warning

    `OFF=1` in the command line would also work, but would kill Plodder, the underlying HTTP server used by Tatin.
    That might be too early: for example, you could not then get a code coverage report.


### Running tests from the command line

The Tatin root directory contains shell scripts that run the batch tests.

    RunTests.bat // Windows
    RunTests.sh  // Linux, macOS


These are templates: check their contents, you might need to make amendments.

## :fontawesome-solid-comments: Notes

### Port 5001

By default, the test cases use port 5001 for communication between the client and the Test Server.

Change the INI files for both server and client if that does not work for you.

### Testing on a stand-alone Tatin server

You do not have to run the test cases from the Tatin client.

To start and run a local Tatin test server yourself, in a new Dyalog instance

    ]CIDER.OpenProject /path/to/Tatin
    #.Tatin.TestCasesServer.RunTests

!!! danger "Any code changes you make will be written back to disk."
<!-- FIXME Avoid danger with ]CIDER.CloseProject ? -->

### Stress testing

You might be tempted to run the client tests in multiple instances to put some pressure on the Tatin Server.

!!! warning "The client tests are not suitable for this."

For example, the tests in the `Cache` group _must_ be executed in sequence, as they rely on each other. Generally in testing, this should be avoided but here, for technical reasons, it’s a must.
Running this group in parallel breaches this, and is certain to fail.

