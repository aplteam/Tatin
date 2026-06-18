---
title: "User Settings"
description: "The Tatin user settings file and what each setting controls"
keywords: 
---
# User settings

!!! abstract "Settings govern your use of Tatin"


Your Tatin user settings specify your ‘known Registries’
– the Tatin Registries you want to use –
and some other settings you might use if you publish packages yourself.

When you launch Dyalog[^init], it reads your Tatin user-settings file

    tatin-client.json

into `⎕SE.Tatin.MyUserSettings`, a class instance.
If you don’t have a Tatin user-settings file, Dyalog creates one
in your [home folder](user-commands.md#user-settings).

The default user-settings file lists two registries:

          ]ListRegistries
     Alias       URL                     ...
     ----------  ----------------------- ...
     tatin       https://tatin.dev/      ...
     tatin-test  https://test.tatin.dev/ ...


## What does Tatin do at start-up time?

When Tatin is initialized[^init], it creates an instance of the `UserSettings` class with the name `MyUserSettings`, which lives in `⎕SE.Tatin`. Strictly speaking, it lives in `⎕SE._Tatin.Client`; in `⎕SE.Tatin` there is just a niladic function `MyUserSettings` that returns a reference to `⎕SE._Tatin.Client.MyUserSettings`.

If the constructor does not get a fully qualified name of the user settings file as an argument, then it performs two steps:

1. It looks for a file `.tatin` in the user's home folder.

   If the file exists and is not empty, then it is expected to point to a user settings file, and Tatin will go for that file.

   We will discuss soon under which circumstances such a file might be useful.

2. In case there is no file `.tatin` in that folder, or the file is empty, Tatin will look for a user settings file in the default folder.

   * If that file exists, then Tatin will instantiate it.

   * If the file does not exist, then it will be created with default settings.

## Edit your settings


??? tip "Edit your settings with the user command"

    You can use any editor to change your user-settings.

    On launching Dyalog,
    Tatin checks that your user-settings file is valid JSON5
    and signals any errors in it.

    If you use the user command
    ```
    ]TATIN.UserSettings -edit
    ```
    to edit the file, Tatin will check the file when you save it.

Other settings define the defaults used when you create a new package.

-----------|---------------------------------------------------------
group      | group name your packages will use
license    | license you usually use to publish a package
maintainer | email address of the maintainer of your packages
source     | name of a folder in your package where all source files are stored

!!! tip inline end ""

    JSON5 allows [comments](https://spec.json5.org/#comments).

Editing your user-settings file leaves your current user settings unchanged.
To update them from the file:

    ]TATIN.UserSettings -refresh

To save your current user settings to file:

    ⎕SE.Tatin.MyUserSettings.Save 1


## Cache settings

To reduce network operations, Tatin caches all packages by default, except

-   beta versions
-   packages from Registries with an `Any` delete policy

!!! tip "Best delete policies for remote Tatin Registries are `None` or `BetasOnly`."

Properties of `⎕SE.Tatin.MyUserSettings` control caching for all known Registries.

-----------|--------|----------------------------
caching    | flag   | whether caching is enabled
path2cache | string | path to cache folder; defaults according to OS

The `noCaching` flags in `tatin-client.json` toggle caching for specific Registries.

Caching is most commonly disabled for local Registries hosting packages being developed.



[`]TATIN.Cache`](user-commands.md#cache)


## Keeping settings elsewhere

For most purposes, all you need is a single user-settings file in its default location.

In some circumstances you might prefer to keep your user-settings file elsewhere:

-   You need different settings for corporate and personal projects.
-   You need to edit the settings but do not have write access to your home folder.
-   Your computer is shared with others, at least one of whom needs write access to the settings.

First, change the current user-settings location:
```
      p←,⊂'/path2/user_config_file/'
      ⎕SE._Tatin.Client.MyUserSettings←⎕SE._Tatin.Client.⎕NEW ⎕SE.Tatin.UserSettings p
      ⍴⎕←1 ⎕SE.Tatin.ListRegistries 0
tatin      https://tatin.dev       ... 0 100 0
tatin-test https://test.tatin.dev  ... 0   0 0
2 7
      ⍴⎕←⎕SE.Tatin.MyUserSettings.ListRegistries 0
 Alias  URL                        Port  Priority No caching Proxy API-key
 -----  ------------------         ----  -------- ---------- ----- -------
 tatin  https://tatin.dev/            0       100          0           ***
 test-tatin  https://test.tatin.dev/  0       100          0           ***
2 7
```
Then make the new location the default:
```
      ⎕SE.Tatin.MyUserSettings.MakeDefaultFile 1
```

## Adding and removing Registries

Tatin offers an alternative to editing `tatin-client.json` directly: you can add, modify, and remove Registries via the `MyUserSettings` instance and its methods. This approach has two advantages over direct JSON editing: changes remain in the workspace only until you explicitly save them (so you can experiment without affecting other sessions), and all changes are validated before being written to disk, which makes it harder to produce a broken settings file. The trade-off is that it requires more steps than opening the file in an editor.

We are now going to add a Registry, list all Registries, and then delete that Registry, getting us back to where we started.

### What have we got?

Let's list all Registries currently defined:

```
      ⎕SE.Tatin.MyUserSettings.ListRegistries 0
Alias      URL                     Port  Priority No caching Proxy API-key
-----      ------------------      ----  -------- ---------- ----- -------
tatin      https://tatin.dev/         0       100          0           ***
tatin-test https://test.tatin.dev/    0         0          0           ***
```

By default, Tatin only knows about the principal Tatin server and its cousin, the test server.

Note that the API key is not listed when a zero is provided as the right argument.

Let's add a made-up Registry.

### Create an instance of the `DefineRegistry` class

Let's assume that you work for a company "MyCompany", and that this company runs a Tatin Server with the URL `https://tatin.mycompany.com`.

To add that Registry to the user settings file, you must first instantiate the `DefineRegistry` class. You may specify the URL and the alias in several ways; for details on the `DefineRegistry` class, execute this:

```
]adoc ⎕se.Tatin.DefineRegistry
```

We will pass a simple text vector that specifies the alias (between `[]`) and the URL:

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

"id" is not mentioned here, because it is optional, and `DefineRegistry` will assign a freshly generated UUID to it for you. Refer to [The "id"](#the-id) for details.

### Settings in the file

* `uri` and `alias` are already set by the constructor.
* `port` is 0, which means that it will fall back to 80 for `http://` and 443 for `https://`.
* `priority` decides in which order Registries are scanned in case no Registry was provided. The Registry with the highest number is scanned first, and the first hit wins.

  `⎕NULL` will be converted once the instance is added to the user settings.

  Note that a priority of `0` or less means that the Registry will **not** participate in a Registry scan.
* `api_key` must be set only when the Registry is managed by a Tatin server _and_ you want to publish packages, or delete packages (if that is permitted by that Tatin server at all) and credentials are required for those operations.

### Adding the Registry

Adding a Registry is achieved by calling the `AddRegistry` method and providing an instance of the `DefineRegistry` class as an argument:


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

!!! detail "Regarding priorities"

    What happens when you add a Registry with `priority` being `⎕NULL` and the lowest Registry so far is 1?
    
    In that case Tatin assigns new values to all Registries except those with a priority of zero, which will remain untouched.

    The new priorities will not change the order of the priorities, and the lowest one will be 100 or greater.

### Making the changes permanent

So far we have changed the user settings in the workspace, _not_ on file. This allows you to experiment with certain settings without making the changes permanent; other sessions won't be affected.

If you want to make your changes permanent, you must call the `Save` method and provide a 1 as the right argument.

### Deleting the Registry

You can remove one Registry at a time from the user settings by calling the instance method `RemoveRegistry` of the `UserSettings` class by providing an [alias], a URI or an ID as right argument.

Note that specifying a URI might match more than one Registry. By default an error is thrown in such a case. If you are absolutely certain that you want to delete all Registries matching that URI you can specify a 1 as left argument, then the deletion of more than one Registry is performed.

However, you are advised to use IDs for removing Registries.

## The `id`

Most users never need to care about the `id` property.

However, a Registry definition still needs a unique identifier, because neither the URL nor the alias is guaranteed to be unique:

* The same Registry URL might appear more than once in your settings, for example for different groups or credentials.
* An alias is optional and can be changed or removed at any time.

For that reason, a Registry definition may contain an `id`.

When you create a Registry definition with the `DefineRegistry` class, Tatin automatically generates a UUID and assigns it to `id`.

If you edit the user-settings file manually, you may also specify an `id` yourself, although in most cases there is no need to do so.

The `id` is used only locally by Tatin to distinguish Registry definitions reliably. It has no special meaning outside your user settings.


[^init]: Tatin is initialized either explicitly or as a side effect when the first Tatin user command is issued. In Dyalog 19.0 and later, once Tatin has been `]activated`, it initializes automatically on launch. In 18.2, the user must take explicit action to achieve this.
