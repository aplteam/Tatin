[parm]:title             = 'Tatin Intro'
[parm]:leanpubExtensions = 1


# Publishing Packages

## Precondition: API key

Whether you want to publish to the principal Tatin server at <https://tatin.dev> or your own Tatin Server or a Tatin Server that someone in your company runs, first you need an API key. "API key" is just a fancy expression for a password that is used by an application.

API keys are only required for publishing, not for consuming packages.


### The Server


#### The principal Tatin Server

If you want to publish on `https://tatin.dev` you need to ask [kai@aplteam.com](mailto:kai@aplteam.com) for an API key.


#### The Tatin Test Server

The Tatin test Server publishes its one and only API key on its website; it's "Tatin-Test-API-Key". It allows you to publish anything you want, including an group name.

However, be aware that the Tatin Test Server is reset every now and then, so whatever you publish will disappear sooner or later.


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


### The Client

On the client side the API key must go into the user configuration file: the file `tatin-client.json`.

It already has an API key for every Server defined in the file but it's empty.


## Publishing


### Preparing

#### How to structure a package

A Tatin package requires all source code (functions, operators, classes, interfaces and namespace scripts) to be separated from other files (like CSS files, EXEs, DLLs etc.).

Tatin calls the former "source" and the latter "assets". 

What is what is defined in the package copnfiguration file which _must_ exist to make something a Tatin package.


#### The package configuration file

What is required and how to create and change a package configuration file is discussed in the document [PackageConfiguration](./PackageConfiguration.html ),


#### The dependency file

This file is only required when the package has dependencies.

Note that in case you specify a dependency that does not (yet?!) exists on the Registry then this has no consequences. The reason is that when a bunch of packages is published then there might well be mutual dependencies. Insisting on dependencies already being published would not work out well then.


### Final step

Once the preparation is done the final step is easy:

```
]TATIN.Publish /path2package/group-name-1.2.3.zip [tatin]
```

This publishes the package `group-name-1.2.3` to the principal Tatin Server represented by the alias `[tatin]`.