[parm]:title             = 'Tatin Intro'
[parm]:leanpubExtensions = 1
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3


# Publishing Packages

## Precondition: API key

Whether you want to publish to the principal Tatin server at <https://tatin.dev> or your own Tatin Server or a Tatin Server that someone in your company runs, first you need an API key. "API key" is just a fancy expression for a password that is used by an application.

API keys are only required for publishing and possibly deleting packages, but not for consuming them.

They are saved in the user settings --- for details see the document "Tatin User Settings".


### The Server


#### The principal Tatin Server

If you want to publish on `https://tatin.dev` you need to ask [kai@aplteam.com](mailto:kai@aplteam.com) for an API key.


#### Credentials for the Tatin Test Server

The Tatin Test Server publishes an API key on its website; it's "Tatin-Test-API-Key". It allows you to publish anything you want, including any group name.

Notes:

* Be aware that the Tatin Test Server is reset every now and then, so whatever you publish will disappear sooner or later
* You cannot publish anything for the groups "aplteam" and "dyalog"


#### Where are API keys saved?

API keys are saved in the user settings file. The quickest and yet save way to edit that file is via the user command:

```
      ]TatIN.UserSettings -edit      
```

#### Credentials for your own Tatin Server 

If you run your own Tatin Server we suggest that you create a UUID and use that as an API key. 

In order for an API key to be accepted by a Tatin Server it must be added to the file `Credentials.txt` in the Registry's root directory. The file might or might not exist, and it might be empty.

Make sure that you specify it as either

```
group1={api-key}
```

or

```
*={api-key}
```

In the first case somebody who provides that API key may publish packages only for the group "group1".

In the second case it's a kind of master password: it allows the creation of packages with _any_ group name.

The two scenarios can be mixed:

```
group1='abc'
group2='xyz'
*='other'
```

This means that one can only publish packages with the groupname "group1" with the API key "abc", packages with the groupname "group2" with the API key "xyz", and anything else with the API key "other".

Note that `*=` means that no API key is required. On its own it's the same as having no credentials file, but it can be useful together with other group names:

```
group1='abc'
group2='xyz'
*=
```

This is interpreted as "require API keys for the groups "group1" and "group2" but allow anything else without an API key".

Finally you can allow anybody to publish packages under a particular group name without providing an API key:

```
group1='abc'
group2=
group3=''
*='other'
```

This means:

* You must provide "abc" as an API key for the group "group1"
* You may publish packages to the groups "group1" and "group2" without an API key 
* For any group name but "group1", "group2" and "group3" you must specify "other" as API key

### The Client

On the client side the API key must go into the user configuration file: the file `tatin-client.json`.

It already has an API key for every Server defined in the file, but it's empty.


## Publishing


### Preparing

#### How to structure a package

A Tatin package requires all source code (functions, operators, classes, interfaces and namespace scripts) to be separated from other files (like CSS files, EXEs, DLLs etc.).

Tatin calls the former "source" and the latter "assets". 

What is what is defined in the package configuration file which _must_ exist to make a folder a Tatin package.


#### The package configuration file

What is required and how to create and change a package configuration file is discussed in the document [PackageConfiguration](./PackageConfiguration.html ),


#### The dependency file

This file is only required when the package has dependencies.

Note that in case you specify a dependency that does not (yet?!) exist on the Registry then this has no consequences. The reason is that when a bunch of packages is published then there might well be mutual dependencies. Insisting on dependencies already being published would not work out well then.


### Final step

Once the preparation is done the final step is easy. You may specify the folder hosting the package:

```
]TATIN.PublishPackage /path2package [tatin]
```

The folder may or may not carry a trailing `/`.

This would attempt to publish the package `group-name-1.2.3` to the principal Tatin Server represented by the alias `[tatin]`.

You can also create a ZIP file with the `]TATIN.Pack` command and specify the ZIP file as argument:

```
]TATIN.PublishPackage /path2package/group-name-1.2.3.zip [tatin]
```


## Deleting packages

Whether you can delete a package once it was published depends on the policy the server operates:

* "Any": You may delete any package
* "JustBetas": You may delete only beta versions
* "None": You cannot delete a packages at all

Note that anything that carries something that is not a digit after the second dot in the version number and before the build separator --- a `+` (recommended) or a `.` (deprecated) --- qualifies as a beta version.

Examples:

```
apltree-Foo-1.0.0                 ⍝ Not a beta
apltree-Foo-1.0.0+123             ⍝ Not a beta
apltree-Foo-1.0.0-alpha-1         ⍝ A beta
apltree-Foo-1.0.0-alpha-1+123     ⍝ A beta
```

You can find out which policy the server operates in two ways:

* Execute this user command:

  ```
  ]Tatin.GetDeletePolicy [tatin]
None
  ```

Or visit its web site, for example <https://tatin.dev>: at the bottom of the home page the server mentions the "delete" policy it operates.

## Developing strategies

Let's imagine that you are supposed to develop Tatin packages for your employer, the company "XYZ".

* You run a Tatin server on your local machine, known by the alias `[my]`.

  This is just for you, nobody else. The purpose of this server is to publish packages to it at a very early stage.

  It has the highest priority of all Registries, ensuring that in case a package lives on several Registries it is found on `[my]` first.

* Your team runs a Tatin Server on the Intranet of your company. It carries the alias `[my-team]`.

  This is used to publish beta versions that your team might want to use. This has the second-highest priority.

* Your packages also have dependencies on packages published on Tatin's principal server, known as `[tatin]`.

  Of the three Registries this one might have the lowest priority or the highest, depending on your goals.

* You might also have the test Registry defined in your user settings, but with a priority of `0` so that it will be ignored when scanning Registries, but you could still mess around with it.

You can now develop a package `Foo` and publish it on `[my]`, probably several times until it is stable.

You would then publish it on `[my-team]`. At the same time you would either delete the package from `[my]` or, if you want `[my]` to be ignored altogether, make its priority negative.

Your team can use your pacakage by referring to the team Registry.

When all is good the beta is promoted to an official release and publish to the Tatin company server. At the same time the package would be deleted from the Team server.

