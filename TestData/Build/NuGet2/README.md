# NuGet

A tool to help use NuGet packages from Dyalog APL.

This code is used by [Cider](https://github.com/aplteam/Cider) to support NuGet packages as project dependencies. It requires Dyalog v19.0 and .NET 6.0 or later.

The code can also be used outside of Cider, but documentation is currently rudimentary, consisting only in the form of this README file and the example code in the `Tests/` folder.

## Introduction
The NuGet tool works by tapping into the "dotnet" command line tool to establish a folder as a .NET project, and use tools built in to .NET to load NuGet packages. It requires .NET 6.0 or later, and Dyalog APL must be configured to use the new .NET by setting DYALOG_NETCORE=1.

## Using NuGet with Cider

Please refer to the Cider documentation for instructions. At the time this was written, the user command to set up a NuGet dependency was `]CIDER.AddNuGetDependencies`.

## Brief API documentation

### `NuGet.Setup projectdir`
Makes the initial call to the dotnet command to create a .NET project in the named directory. This must be called first. Example:

```
      NuGet.Setup '/tmp/nuget-test'
Created project file "/tmp/nuget-test/nuget-test.csproj"
```

### `NuGet.Add projectdir packageid`

Adds a NuGet package as a dependency of the project found in the named directory. The package name can optionally be followed by a version number; if no version is provided the latest will be used. Example:

```
      NuGet.Add '/tmp/nuget-test' 'Clock/1.0.3'
Added/Updated:  Clock 
```

### `⎕USING←NuGet.Using projectdir`

Returns the ⎕USING setting that will make it possible to reference the entry points of the added packages. Example:

```
      ]box on
Was OFF
      NuGet.Using project_dir
┌────────────────────────────────────┬─────────────────────────────────────────┐
│,/tmp/nuget-test/published/Clock.dll│,/tmp/nuget-test/published/nuget-test.dll│
└────────────────────────────────────┴─────────────────────────────────────────┘
```

If you do not want to include the DLL which represents the empty C# executable that was created by the dotnet command, you can specify this as follows:

```
      '(includePrimary: 0)' NuGet.Using project_dir 
┌────────────────────────────────────┐
│,/tmp/nuget-test/published/Clock.dll│
└────────────────────────────────────┘
```

### `NuGet.Packages projectdir`

Returns the current list of dependencies::

```
      NuGet.Packages project_dir
┌─────────────┐
│┌─────┬─────┐│
││Clock│1.0.3││
│└─────┴─────┘│
└─────────────┘
```

### `NuGet.Version`

Returns the current NuGet version number:

```
      NuGet.Version
0.2.0
```


## Running the Tests

To run the tests in Dyalog version 19.0, you must:

* Make sure you have installed .NET 6.0 or later and set the configuration parameter DYALOG_NETCORE=1 (this is the default under Linux and macOS but not under Windows)
* Either load the Tatin package using `]TATIN.LoadPackages dyalog-nuget`, followed by `]get https://github.com/dyalog/nuget/tree/main/APLSource/Tests`, or
* `]get https://github.com/dyalog/nuget/tree/main/APLSource -unpack`, which will establish both `NuGet` and `Tests` in the workspace.

To get a list of runnable tests:

```
      Tests.test ''
The current test functions exist:
 test_clock  test_humanizer  test_htmlsanitizer  test_mailkit  test_parquet  test_selenium 
```

To run a test:

```
      Tests.test 'selenium'
Created project file "/tmp/nuget-test/nuget-test.csproj"
Added/Updated:  Selenium.WebDriver  Selenium.WebDriver.ChromeDriver 
Successfully loaded Dyalog - Home
```

Note that you cannot run more than one test per APL session, because once the DLL's are loaded by the interpreter, there is currently no way to unload them.