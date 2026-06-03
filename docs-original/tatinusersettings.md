---
title: 'Tatin: User Setting'
description: ''
keywords: 
---
# Tatin User Settings

## Introduction

Tatin uses a file to remember all Tatin Registries you want to work with, and possibly other user-specific settings as well. We refer to this file as the user settings file.

When you start using Tatin for the very first time there is no such file, and therefore Tatin will create one in a specific location. 

Once Tatin is installed, when you fire up an instance of Dyalog APL the contents of the file is used to instantiate the `Tatin.UserSettings` class. The instance is assigned to `⎕SE.Tatin.MyUserSettings`. From then on any changes to the file with an external editor _do not_ affect `⎕SE.Tatin.MyUserSettings`!

`⎕SE.Tatin.MyUserSettings` provides several properties that can be referenced as well as several methods that can be issued to manipulate the user settings.

For example, this call:

```
      ]Tatin.ListRegistries
Alias                    URL         ID  Port  Priority No-Caching Proxy
-----------------------  ----------  --- ----  -------- ---------- -----
https://tatin.dev/       tatin       ...    0       100           0
https://test.tatin.dev/  tatin-test  ...    0         0           0

```

shows most of the data that is saved in the user settings for registries, except the API key(s).

If you would like to see the API keys as well specify the `-full` flag.


### The default file

That default file will have two  Tatin Registries defined in it: 

* The principal Tatin server, available via the URL `https://tatin.dev/`

   It has an alias `tatin` assigned to it, so you can address it as `[tatin]` with all user commands that require a Registry as a parameter, though if you don't specify any server at all, they will act on the principal server by default.

* The Tatin Test server, available via the URL `https://test.tatin.dev/`

   It has an alias `tatin-test` assigned to it, so you can address it as `[tatin-test]` with all user commands that require a Registry as a parameter.

   It has a priority of `0` assigned to it which means that it will _not_ participate in Registry scans.

   Registry scans are performed by Tatin when you ask for a package but do not specify a Registry. Tatin scans all Registries in order of their priorities (highest one first) but ignores those with a priority that is `0`.


### Where does the file live?

This default file will be created in the user's home folder; the API function `⎕SE.Tatin.GetUserHomeFolder''` does return that folder.

You may also ask the user command with:

```
]UserSettings -home
```


### What's the name of the file?

The name of the file is `tatin-client.json`.


### May I edit the file?

Of course you are free to edit that file with any editor. However, keep in mind that you are in charge of making sure that the contents of the file is valid JSON5[^JSON5]: if it's not, Tatin will crash.

If you are familiar with JSON5 syntax and want to edit the file it is recommended to use:

```
]TATIN.UserSettings -edit
```

This will allow you to edit the file contents, but Tatin will check it afterward to make sure that nothing invalid ever goes into the file.

Note that Dyalog 18.2 and later recognize JSON5 and highlight any syntax errors.

### What does Tatin do at start-up time?

When Tatin is initialized[^init] it creates an instance of the `UserSettings` class with the name `MyUserSettings` which lives in `⎕se.Tatin`. (Strictly speaking it lives actually in `⎕SE._Tatin`; in `⎕SE.Tatin` there is just a niladic function `MyUserSettings` that returns a reference to `⎕SE._Tatin.MyUserSettings`)

If the constructor does not get a fully qualified name of the user settings file as an argument then it performs two steps:

1. It looks for a file `.tatin` in the user's home folder.

   If the file exists and is not empty then it is expected to point to a user settings file, and Tatin will go for that file.

   We will discuss soon under which circumstances such a file might be useful.

2. In case there is no file `.tatin` in that folder, or the file is empty, Tatin will look for a user settings file in the default folder.

   * If that file exists then Tatin will instantiate it

   * If the file does not exist then it will be created with default settings


### Synchronizing file and workspace

#### Changes made to the file

If you change the file that Tatin has instantiated by editing it with an external editor, and have an APL session up and running, then your change does not have an impact on the APL session. 

However, you can force Tatin to bring the session in line with the file by executing:

```
      ]TATIN.Init
```

#### Changes made in the workspace

If you manipulate the instance in the workspace, then the changes won't be written to disk. You need to call the monadic `Save` method (with a `1` as the right argument) to make your changes permanent.

#### Comments

Note that JSON5 allows two different types of comments:

##### Block comments

Everything between `/*` and `*/` is recognized as a comment, like this:

```
/*
  This is a comment that...
  stretches over several lines
*/.
```

##### Line comments

This is an example of a line that is recognized as a comment:

```
// This is a comment line
```


### Summary

In most scenarios, you will probably be happy with having just one user settings file for Tatin, and having it in its default location.

You may however want to have your own Tatin Registries, for example for private projects.

## Adding and removing Registries

You can manipulate the `MyUserSettings` instance via its methods.

We are now going to add a registry, list all registries, and then delete that registry, getting us back to where we started.

### What have we got?

Let's list all registries currently defined:

```
      ⎕se.Tatin.MyUserSettings.ListRegistries 0
Alias      URL                     Port  Priority No caching Proxy API-key
-----      ------------------      ----  -------- ---------- ----- -------
tatin      https://tatin.dev/         0       100          0           ***
tatin-test https://test.tatin.dev/    0         0          0           ***
```

This is because originally Tatin only knows about the principal Tatin server and its cousin, the test server.

Note that the API key is not listed when a zero is provided as the right argument.

Let's add a made-up registry.

#### Create an instance of the `DefineRegistry` class.

Let's assume that you work for a company "MyCompany", and that this company entertains a Tatin Server with the URL `https://tatin.mycompany.com`.

To add that Registry to the user settings file you must first instantiate the `DefineRegistry` class. You may specify the URL and the alias in several ways; for details on the `DefineRegistry` class execute this:

```
]adoc ⎕se.Tatin.DefineRegistry
``` 

We will pass a simple text vector that specifies the alias (between `[]`) and the URI:

```
      #.myReg←⎕NEW ⎕SE.Tatin.DefineRegistry (,⊂'[myc]https://tatin.mycompany.com')
      #.myReg.varsList
 uri  alias  port  api_key  priority 
      ]box on
      {⍵,⍪#.myReg.(⍎¨⍵)}'uri' 'alias' 'port' 'api_key' 'priority'
┌────────┬────────────────────────────┐
│uri     │https://tatin.mycompany.com/│
├────────┼────────────────────────────┤
│alias   │myc                         │
├────────┼────────────────────────────┤
│port    │0                           │
├────────┼────────────────────────────┤
│api_key │                            │
├────────┼────────────────────────────┤
│priority│[Null]                      │
└────────┴────────────────────────────┘
      ]box off
```

"id" is not mentioned here, because it is optional, and `DefineRegistry` will assign a freshly generated UUID to it for you. Refer to [The "id"](#) for details.

#### Settings in the file

* `uri` and `alias` are already set by the constructor.
* `port` is 0 which means that it will fall back to 80 for `http://` and 443 for `https://`.
* `priority` decides in which order Registries are scanned in case no Registry was provided. The Registry with the highest number is scanned first, and the first hit wins.
  
  `⎕NULL` will be converted once the instance is added to the user settings, see there.
 
  Note that a priority of `0` or less means that the registry will **not** participate in a Registry scan.
* `api_key` must be set only when the Registry is managed by a Tatin server _and_ you want to publish packages, or delete packages (if that is permitted by that Tatin server at all) and credentials are required for those operations.

#### Adding the Registry

Adding a registry is achieved by calling the `AddRegistry` method, and providing an instance of the `DefineRegistry` class as an argument:


```
      ⎕se.Tatin.MyUserSettings.AddRegistry #.myReg
```

Now we would expect three Registries:

```
      ↑⎕se.Tatin.MyUserSettings.registries.(alias uri priority)
 tatin       https://tatin.dev/           100
 myc         https://tatin.mycompany.com/  90
 tatin-test  https://test.tatin.dev/        0
```

The priority is not `⎕NULL` anymore but 90: any `⎕NULL` is replaced by the lowest number yet minus 10.

A> ### Regarding priorities
A> What happens when you add a Registry with `priority` being `⎕NULL` and the lowest Registry so far is 1?
A> 
A> In that case Tatin assigns new values to all Registries except those with a priority of zero which will remain untouched.
A> 
A> The new priorities will not change the order of the priorities, and the lowest one will be 100 or greater.

So far we have changed the user settings in the workspace, _not_ on file. This allows you to experiment with certain settings without making the change permanent; other sessions won't be affected.

If you want to make your changes permanent you must call the `Save` method and provide a 1 as the right argument.


## Putting the user config file elsewhere

There might be scenarios when the default location for the user config file is not suitable for you.

* If you cannot make frequent changes to the Tatin user settings file in its default location due to, say,  company constraints, then of course it needs to go elsewhere.

* Your computer is used by several people, and they all (or at least two of them) need write access to the Tatin user settings file.

   You could still use the default location, but because that location is user-specific, every user would require her own user settings file, which is something you might or might not want to avoid.

In the aforementioned cases as well as other scenarios you need more freedom than what is provided by default.

For that, you must create a user settings file in a specific location. To achieve that we re-instantiate the class `UserConfig`, and we provide a path to the folder where the file should live:

```
      p←,⊂'/path2/user_config_file/'
      ⎕SE._Tatin.Client.MyUserSettings←⎕SE._Tatin.Client.⎕NEW ⎕SE.Tatin.UserSettings p
      ⍴⎕←1 ⎕se.Tatin.ListRegistries 0
tatin      https://tatin.dev       ... 0 100 0
tatin-test https://test.tatin.dev  ... 0   0 0
2 7
      ⍴⎕←⎕se.Tatin.MyUserSettings.ListRegistries 0
 Alias  URL                  Port  Priority No caching Proxy API-key
 -----  ------------------   ----  -------- ---------- ----- -------
 tatin  https://tatin.dev/      0       100          0           ***
 test-tatin  https://tatin.dev/ 0       100          0           ***
2 7
```

Notes:

* We use the same name as before (`MyUserSettings`) because all Tatin user commands as well as all Tatin API functions assume the existence of an instance of the class `UserSettings` with that name.
* API keys are not shown unless you specify a `1` as the right argument to `ListRegistries`
* When you fire up a new session of Dyalog APL right  now, it would still look for the user settings file in its standard location.

### Make the switch permanent

To make this user settings file the default file, meaning that this file will be instantiated the next time Dyalog APL is fired up, we need to make sure that a file `.tatin` in the default folder (that's the one returned by `⎕SE.Tatin.GetUserHomeFolder''`) contains a path pointing to that folder.

You can do this yourself, but you can also ask the instance for doing the job for you:

```
      ⎕SE.Tatin.MyUserSettings.MakeDefaultFile 1
```

From now on, the file `MyUserSettings.path2config` is pointing to, will be used to determine the user settings.

## Other settings

You can specify these pieces of information as well:

`group`

: The name your packages will use.

`license`

: The license you usually use to publish a package.

`maintainer`

: The email address of the maintainer of your packages (most likely your email address).

`source`

: The name of a folder in your package where all source files are stored.

These define the defaults to be used when a new package is created.


`id`

: A unique key that can be used to identify a Registry definition in the user settings file when neither the URL nor an alias can be used for this. 

However, because mot of the time URL or alias are sufficient for this, setting `id` is optional.

## Editing the file

Editing the file with an editor is possible but has the disadvantage that you might make a mistake without noticing.

If you find using an instance of `DefineRegistry` and the `Add` method too cumbersome but want to edit the file use this:

```
]UserSettings -edit
```

This checks the file and tries hard to make sure that it is valid and fulfils Tatin's needs.

### The "id"

Because it must be possible to define more than one set for the same URL --- for different groups! --- in the user settings, the URL does not necessarily qualify as a unique key for a Registry. Neither does the alias, because it is optional, and you may reset it to "undefined".

So we need a unique key for this (though admittedly not many will be in need for this). That's why you may set "id". 

If you use the `DefineRegistry` class then "id" will be a newly created UUID. If you prefer to add a new Registry to the user settings by editing the user settings file then you should add "id" yourself. 

This has only an impact locally in a scenario mentioned above, and that's why this is optional.



[^JSON5]: Tatin uses [JSON5](https://json5.org/ "Link to the JSON5 web site") rather than JSON.

[^init]: Tatin will be initialized either explicitly or as a side effect when the first Tatin user command is issued. See ["Installing and updating the Tatin Client"](installingandupdatingthetatinclient.md) for details.



