[parm]:title             = 'Tatin User Setting'
[parm]:toc               = 2 3 4
[parm]:collapsibleTOC    = 1
[parm]:leanpubExtensions = 1




# Tatin User Settings

## Introduction

Tatin uses a file to remember all Tatin Registries you want to work with, and possibly other user-specific settings as well. We refer to this file as the user settings file.

When you start using Tatin for the very first time with 18.0 (when Tatin is not part of a standard installation of Dyalog APL) there is no such file, and therefore Tatin will create one in a specific location. 

### The default file

That default file will only have one Tatin Registry defined in it: the principal Tatin server, available via the URL `https://tatin.dev/`. It has an alias `tatin` assigned to it, so you can address it as `[tatin]` with all user commands that require a Registry as parameter.

### Where does it live?

This default file will be created in the user's home folder; the API function  `⎕SE.Tatin.GetUserHomeFolder''` does return that folder.


### What's the name of that file?

The name of the file is `tatin-client.json`.


### May I edit it?

Of course you are free to edit that file with any editor. However, keep in mind that you are in charge for making sure that the contents of the file is valid JSON5[^JSON5]: if it's not, Tatin will crash.

If you are familiar with JSON5 syntax and want to edit the file it is recommended to use

```
]TATIN.Usersettings -edit
```

This will allow you to edit the file, but Tatin will check the file afterwards in order to make sure that nothing invalid goes ever into the file.

### What does Tatin do at start-up time?

When Tatin is initialized[^init] it creates an instance of the `UserSettings` class with the name `MyUserSettings` which lives in `⎕se.Tatin`.

If the constructor does not get a fully qualified name of the user settings file as an argument then it performs two steps:

1. It looks for a file `.tatin` in that folder.

   If the file exists and is not empty then it is expected to point to a user settings file, and Tatin will go for that file.

   We will discuss soon under which circumstances such a file might be useful.

2. In case there is no file `.tatin` in that folder, or the file is empty, Tatin will look for a user settings file in the default folder.

   * If that file exists then Tatin will instantiate it

   * If the file does not exist then it will be created with default settings


### Syncing file and workspace

#### Changes made to the file

If you change the file that Tatin has instantiated by editing it, and have an APL session up and running, then your change does not have an impact on the APL session. 

However, you can force Tatin to bring the session in line with the file by executing:

```
      ]TATIN.Init
```

#### Changes made in the workspace

If you manipulate the instance in the workspace, then the changes won't be written to file. You need to call the monadic `Save` method (with a `1` as right argument) to make your changes permanent.


### Summary

In most scenarios you will probably be happy with having just one user settings file for Tatin, and having it in its default location.

You may however want to have your own Tatin Registries, for example for private projects.

##  Adding and removing Registries

You can manipulate the `MyUserSettings` instance via its methods.

We are now going to add a registry, list all registries and then delete that registry, getting us back to where we started from.

### What have we got?

Let's list all registries currently defined:

```
      ⎕se.Tatin.MyUserSettings.ListRegistries 0
 Alias  URI                 Port  Priority  API-key 
 -----  ------------------  ----  --------  ------- 
 tatin  https://tatin.dev/     0       100  ***
```

This is because originally Tatin only knows about the principal Tatin server.

Let's add a made-up registry.

#### Create an instance of the `DefineRegistry` class.

Let's assume that you work for a company "MyCompany", and that this company entertains a Tatin Server with the URL https://tatin.mycompany.com.

In order to add that Registry to the user settings file you must first instantiate the `DefineRegistry` class. You may specify the URL and the alias in several ways; for details on the `DefineRegistry` class execute this:

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
│priority│0                           │
└────────┴────────────────────────────┘
      ]box off
```

#### Settings in der file

* `uri` and `alias` are already set by the constructor.
* `port` is 0 which means that it will fall back to 80 for `http://` and 443 for `https://`.
* `priority` may be useful for defining the sequence in which Registries are scanned in case no Registry was provided. The Registry with the highest number is scanned first, and the first hit wins.
* `api_key` must be set only when the Registry is managed by a Tatin server _and_ you want to publish packages, or delete packages if that is permitted by that Tatin server.

#### Adding the Registry

Adding a registry is achieved by calling the `AddRegistry` method, and providing an instance of the `DefineRegistry` class as argument:


```
      ⎕se.Tatin.MyUserSettings.AddRegistry #.myReg
```

Now we would expect two Registries:

```
      ↑⎕se.Tatin.MyUserSettings.registries.(alias uri priority)
 tatin  https://tatin.dev/            100
 myc    https://tatin.mycompany.com/   90
```

The priority is not 0 anymore but 90: any 0 is replaced by the lowest number yet minus 10.

Note that so far we have changed the user settings in the workspace, _not_ on file. This allows you to experiment with certain settings without making the change permanent. That means that other sessions won't be affected.


W> _Don't_ add the Tatin Test Registry permanently to the user settings file
W>
W> The simple reason is that under certain circumstances Tatin scans all Registries in order to find a package, and usually you don't want to include the Test Registry in such a scan.


## Putting the user config file elsewhere

There might be scenarios when the default location for the user config file is not suitable for you.

* If you cannot make frequent changes to the Tatin user settings file in its default location (because of red tape) due to, say,  company constraints, then of course it need to go elsewhere.

* Your computer is used by several people, and they all (or at least two of them) need access to the Tatin user settings file.

   You could still use the default location, but because that location is user specific, every user would require her own user settings file, which is something you might or might not want to avoid.

In the aforementioned cases as well as other scenarios you need more freedom than what is provided by default.

For that you must create a user settings file in a specific location. In order to achieve that we re-instantiate the class `UserConfig`, and we provide a path to the folder where the file should live:

```
      ⎕SE.Tatin.MyUserSettings←⎕NEW ⎕SE.Tatin.UserSettings (,⊂'/path2/user_config_file/')
      ⍴⎕←1 ⎕se.Tatin.ListRegistries 0
 https://tatin.dev  tatin   100
1 3
      ⍴⎕←⎕se.Tatin.MyUserSettings.ListRegistries 0
 Alias  URI                 Port  Priority  API-key 
 -----  ------------------  ----  --------  ------- 
 tatin  https://tatin.dev/     0       100  ***      
3 5
```

Notes:

* We use the same name as before (`MyUserSettings`) because all Tatin user commands as well as all Tatin API functions assume the existence of an instance of the class `UserSettings` with that name.
* Note that the API key is replaced by asterisks unless you specify a `1` as right argument to `ListRegistries`,
* When you fire up a new session of Dyalog APL right  now, it would still look for the user settings file in its standard location.

### Make the switch permanent

In order to make this user settings file the default file, that is the file Tatin will instantiate the next time Dyalog APL is fired up, we need to make sure that a file `.tatin` in the default folder (that's the one returned by `⎕SE.Tatin.GetUserHomeFolder''`) contains a path pointing to that folder.

You can do this yourself, but you can also ask the instance for doing the job for you:

```
      ⎕SE.Tatin.MyUserSettings.MakeDefaultFile
```

From now on the file `MyUserSettings.path2config` is pointing to will be used to determine the user settings.

[^JSON5]: Tatin uses [JSON5](https://json5.org/ "Link to the JSON5 web site")  rather than JSON.

[^init]: Tatin will be initialized either explicitly by the `startup.dyalog` script or as a side effect when the first Tatin user command is issued. See [Installing and updating the Tatin Client](./InstallingAndUpdatingTheTatinClient.html "InstallingAndUpdatingTheTatinClient.html") for details.