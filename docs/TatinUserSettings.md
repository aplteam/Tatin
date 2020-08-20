[parm]:title             = 'Tatin User Setting'
[parm]:toc               = 2 3 4
[parm]:collapsibleTOC    = 1
[parm]:leanpubExtensions = 1




# Tatin User Settings

## Introduction

Tatin uses a file to remember all Tatin Registries you want to work with, and possibly other user-specific settings as well. We refer to this file as the user settings file.

When you start using Tatin for the very first time with 18.0 (when Tatin is not part of a standard installation of Dyalog APL) there is no such file, and therefore Tatin will create one in a specific location. 

### The default file

That default file will only have one Tatin Registry defined in it: the principal Tatin server, available under the address `https://tatin.dev/`. It has an alias `tatin` assigned to it, so you can address it as `[tatin]` with all user commands that require a Registry as parameter.

### Where does it live?

This default file will be created in the user's home folder; the API function  `⎕SE.Tatin.GetUserHomeFolder''` does return that folder.

### What's the name of that file?

The name of the file is `tatin-client.json`.


### May I edit it?

If you are famailiar with [JSON5](https://json5.org/) your are free to edit that file with any editor, but keep in mind that you are in charge for making sure that the contents of the file is valid JSON5. If it's not, Tatin will crash.

Changing the contents of that file by other means --- discussed next --- is much saver as it would check your input and also make  sure that the contents of the file is always valid (syntactically correct).

### What does Tatin do with the file?

When Tatin is initialized (that is discussed in detail in the document "InitializingTatin") in creates an instance of the `UserSettings` class with the name `MyUserSettings`. The constructor gets the fully qualfied name of the user config file as an argument and is therefore able to represent that file. If it does not exist yet it is created.


### Summary

In most scenarios you will probably be happy with having just one user settings file for Tatin, and having it in its default location.

You may however want to have your own Tatin Registries, for example for private projects.

##  Adding and removing Registries

You can manipulate the `MyUserSettings` instance via its methods.

We are now going to add a registry, list all registries and then delete that registry, getting us back to where we started from.

### What have we got?

Let's list all registries currently defined:

```
      ⎕se.Tatin.MyUserSettings.ListRegistries ⍬
 Alias  URI                 Port  Priority  API-key 
 -----  ------------------  ----  --------  ------- 
 tatin  https://tatin.dev/     0       100     
```

This is because originally Tatin only knows about the principal Tatin server.

Let's add a made-up registry.

#### Create an instance of the `DefineRegistry` class.

Let's assume that you work for a company "MyCompany", and that this company entertains a Tatin Server under the address https://tatin.mycompany.com.

In order to add that Registry to the user settings file you must first instantiate the `DefineRegistry` class. You may specify the URL and the alias in different ways, execute `]adoc ⎕se.Tatin.DefineRegistry` for details on that class.

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

Notes:

* `uri` and `alias` are already set by the constructor
* `port` is 0 which means that it will fall back to 80 for `http://` and 443 for `https://`
* `priority` may be useful for defining the sequence in which Registries are scanned in case no Registry was provided. The Registry with the highest number is scanned first.
* `api_key` must be set only when the Registry is managed by a Tatin server _and_ you want to publish packages.

#### Adding the Registry

Adding a registry is achived by calling the `AddRegistry` method and providing an instance of the `DefineRegistry` class as argument:


```
      ⎕se.Tatin.MyUserSettings.AddRegistry #.myReg
```

Now we would expect two Registries:

```
      ↑⎕se.Tatin.MyUserSettings.registries.(alias uri priority)
 tatin  https://tatin.dev/            100
 myc    https://tatin.mycompany.com/   90
```

Note that the priority is not 0 anymore but 90: Any 0 is replaced by the lowest number yet minus 10. `priority` is used to dertermine the sequence in which the Registries are scanned in case the user asks for a specific package without specifying any registry at all.



## Putting the user config file elsewhere

There might be scenarios when the default location for the user config file is not suitable for you.

* If you cannot save the Tatin user settings file in its default location due to, say,  company constraints, then of course it need to go elsewhere.

* If you have a roaming profile, and you use different computers but expect the same environment no matter which PC you are actually using.

* You computer is used by several people, and they all (or at least two of them) need access to the Tatin user settings file.

   You could still use the default location, but because that location is user specific, every user would have its own user settings file, which is something you might or might not want to avoid.

In any of the aforementioned cases you need more freedom than what is provided by default.

For that you must create a user settings file in a specific location. In order to achieve that we re-instantiate the class `UserConfig`, and we provide a path to the folder where the file should live:

```
      ⎕SE.Tatin.MyUserSettings←⎕NEW ⎕SE.Tatin.UserSettings (,⊂'/path/to/user_config_file/')
      ⍴⎕←⎕se.Tatin.ListRegistries ⍬
 https://tatin.dev  tatin 
1 2
      ⍴⎕←⎕se.Tatin.MyUserSettings.ListRegistries⍬
 Alias  URI                 Port  Priority  API-key 
 -----  ------------------  ----  --------  ------- 
 tatin  https://tatin.dev/     0       100          
3 5
```

Notes:

* We use the same name as before (`MyUserSettings`) because all Tatin user commands as well as all Tatin API functions assume the existence of an instance of the class `UserSettings` with that name.
* There are two ways to list the registries: the first one provides just the alias and the uri while the second one provides _all_ data.
* When you fire up a new session of Dyalog APL right  now, it would still look for the user settings file in its standard location.

### Make the switch permanent

In order to make the switch permanent you need to set the `permanent` flag to 1:

```
      ⎕SE.Tatin.MyUserSttings.permanent←1
```

From now on this user settings file will be used.

A> ### How is a user settings file made permanent?
A>
A> When in need for a user settings file, Tatin checks its own home folder --- which is returned by `⎕SE.Tatin.GetUserHomeFolder''` --- and looks for a file `.tatin`. If that file does not exist or is empty, it carries on with the default.
A>
A> If it does exist it is expected to contain a path pointing to a folder that hosts a user settings file.
A>
A> This implies that you can go back to the default by deleting the `.tatin` file, or by removing its contents.

You could also specify the permanent flag already when instantiating the class `UserSettings`:

```
      path←'/path/to/user_config_file/'
      ⎕SE.Tatin.MyUserSttings←⎕new ⎕se.Tatin.UserSettings path  1
```

Note the 1 at the end: this defines `permanent`. This tells the `UserSettings` class that from now on this user settings file shall be used whenever a new instance of Dyalog is started.

Note that this also allows easy switching between several user settings files by simply adjusting the contents of the `.tatin` file.