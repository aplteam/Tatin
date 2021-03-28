[parm]:title             = 'Tatin Intro'
[parm]:leanpubExtensions = 1


# Publishing Packages

## Precondition: API key

Whether you want to publish to the principal Tatin server at <https://tatin.dev> or your own Tatin Server or a Tatin Server that someone in your company runs, first you need an API key. "API key" is just a fancy expression for a password that is used by an application.

API keys are only required for publishing and possibly deleting packages, but not for consuming them.


### The Server


#### The principal Tatin Server

If you want to publish on `https://tatin.dev` you need to ask [kai@aplteam.com](mailto:kai@aplteam.com) for an API key.


#### The Tatin Test Server

The Tatin Test Server publishes an API key on its website; it's "Tatin-Test-API-Key". It allows you to publish anything you want, including any group name.

Notes:

* Be aware that the Tatin Test Server is reset every now and then, so whatever you publish will disappear sooner or later
* You cannot publish anything with the groups "aplteam" or "dyalog"



#### Running your own Tatin Server 

If you run your own Tatin Server we suggest that you create a UUID and use that as an API key. 

In order for the API key to be accepted by the Tatin Server it must be added to the file `Credentials.txt` in the Registry's root directory. The file will most likely already exist but might be empty.

Make sure that you specify it as either

```
groupname={api-key}
```

or

```
*={api-key}
```

In the first case somebody who provides that API key may publish packages only for the group "groupname".

In the second case it's a kind of master password: it allows the creation of packages with _any_ group name.

The two scenarios can be mixed:

```
group1='abc'
group2='xyz'
*='other'
```

This means that one can only publish packages with the groupname "group1" with the API key "abc", packages with the groupname "group2" with the API key "xyz", and anything else with the API key "other".

Note that `*=` means that no API key is required. That's the same as having not credentials file, but it can be useful together with other group names:

```
group1='abc'
group2='xyz'
*=
```

This is interpreted as "require API keys for the groups "group1" and "group2" but allow anything else without an API key".

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


```
]TATIN.PublishPackage /path2package/group-name-1.2.3.zip [tatin]
```

Both calls would attempt to publish the package `group-name-1.2.3` to the principal Tatin Server represented by the alias `[tatin]`.

I> You can also create a ZIP file with the `]TATIN.Pack` command and specify the ZIP file as argument.


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

Or visit the web site: <https://tatin.dev>: at the bottom of the home page the server mentions the "delete" policy it operates.