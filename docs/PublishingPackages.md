[parm]:title             = 'Tatin: Publishing Pkgs'
[parm]:leanpubExtensions = 1
[parm]:toc               = 2 3 4
[parm]:numberHeaders     = 2 3 4 5 6



# Publishing Packages


## Licensing

### https://tatin.dev

If you want to publish packages to the Principal Tatin server (<https://tatin.dev>) then your package _must carry_ a property `license`, and its value  must be one of the licenses listed on the web page. All licenses that will be accepted offer a great deal of freedom to a user of a package: there are almost no restrictions.

Note that the same holds true for the test server (<https://test.tatin.dev>)

### Your own server

If you want to run your own server then you can do whatever you like, of course. The document  "Server --- Tips and Tricks" offers details.

## Groups, names and version numbers

A package ID consists of at least three parts:

* A group name
* A package name
* A version number

Optionally such an ID may also comprehend a build number that is separated from the version number by a plus (`+`).

### The Group

A group can be anything really:

* If you act on behalf of a company it might be the name of that company, like "Dyalog"
* If you are a freelancer it might be your name, or just your first name, like "davin"
* It might be a term used to indicate something, anything, like "aplteam"

Once you have chosen a group name, and published a package with that group name to the [principal Tatin Registry](https://tatin.dev "Link to tatin.dev"), you are advised to create a "home page" for that group. Use that for anything useful like background, motivation, contact details, whatever.

When a group is listed in a browser, the name of a group is converted into a link to that home page.

Of course, group-related home pages do not always make sense, therefore by default they are not active; see `GroupHomePages` in the INI file.

### The name

The name should give the user an idea of what a package might do. Group+name must be unique, but you might well use a name that is already used under a different group name, though this is not recommended.

### The version number

The version number must consist of three parts separated by dots:

* The major version number: the "1" in **1**.2.3
* The minor version number: the "2" in 1.**2**.3
* The patch number: the "3" in 1.2.**3**

Optionally additional information might be added. Examples are:

* 1.2.3-beta-1
* 1.2.3-fix-for-the-foo-problem
* 1.2.3-issue-234

There is one restriction: a `+` cannot be part of the name of a beta version. The reason for that is that finally a build number might be added to a version number, and a build number is separated from the rest of the version number by a plus (`+`) character. Examples:

* 1.2.3+453
* 1.2.3-beta-1+911

Build numbers are mostly not shown by Tatin.


## Precondition: API key

Whether you want to publish to the principal Tatin server at <https://tatin.dev> or your own Tatin Server or a Tatin Server that someone in your company runs, first you need an API key. "API key" is just a fancy expression for a password that is used by an application.

API keys are required for publishing --- and possibly deleting --- packages, but not for consuming them.

They are saved in the user settings --- for details see the document "Tatin User Settings".


### The Server


#### The principal Tatin Server

If you want to publish on `https://tatin.dev` you need to ask [info@tatin.dev](mailto:info@tatin.dev) for an API key.

You must provide these pieces of information:

* Your desired group name (case insensitive)
* Your real name
* If it's connected to a company, the company's name
* Email address (if different from the one you are using to send the email)

!> ### First step after receiving an API key
=> After having received an API key you must first create a home page for your group name on the server. Only then can you start publishing packages.

#### Credentials for the Tatin Test Server

The Tatin Test Server publishes an API key on its website; it's "Tatin-Test-API-Key". It allows you to publish anything you want, including any group name except a few reserved group names: "aplteam" and "dyalog".

Notes:

* Be aware that the Tatin Test Server is reset now and then, so whatever you publish will disappear sooner or later
* You cannot publish anything under the group names "aplteam" and "dyalog"


#### Where are API keys saved?

##### Client 

API keys are saved in the user settings file. The quickest and yet safe way to edit that file is via the user command:

```
      ]TatIN.UserSettings -edit      
```

##### Server

Credentials are saved in the file "Credentials.csv" in the Registry's home folder.

#### Credentials for your own Tatin Server 

If you run your own Tatin Server, we suggest that you create a UUID and use that as an API key. 

For an API key to be accepted by a Tatin Server, it must be added to a file `Credentials.txt` in the Registry's root directory. 

Make sure that you specify it as either

```
<group-name>,<api-key>
```

or

```
*,<api-key>
```

If the server finds such a file it will perform the following actions:

* Take the data and convert it to a different format
* Delete rows from `Credential.csv` that share a group name with `Credentials.txt`
* Create a Salt for every API key in `Credentials.txt`
* Convert every API-key and its Salt into a hash and add them together with the according group name to `Credentials.csv`
* Delete the file `Credentials.txt`

The format of the file `Credentials.csv` is:

```
<group-name>,<api-key-hash>,<salt>
*,<api-key-hash>,<salt>
*
```

* In the first case, anybody who provides the API key the hash was produced from can publish packages for that group.
* In the second case, the password the hash was created from is a kind of master password: it allows the creation of packages with _any_ group name, except any group that was already handled by then of course.
* The third case means that no API key is required for any (remaining) group(s).

The different scenarios can be mixed:

```
group1,<hash1,<salt1>
group2,<hash2,<salt2>
*,{hash3>,<salt3>
```

This means that one can only publish packages with the group name...

* `<group1>` by using the API key "hash1" was generated from...
* `<group2>` by using the API key "hash2" was generated from...

and anything else by using the API key "hash3" was created from.

Note that `*` or`*,` or `*=` all mean that no API key is required. On its own, it's the same as having no credentials file, but it can be useful together with other group names:

```
<group1>,<hash1>
<group2>,<hash2>
*
```

This is interpreted as "require API keys for the groups `<group1>` and `<group2>` but allow anything else without an API key".

Finally, you can allow anybody to publish packages under a particular group name without providing an API key:

```
<group1>,<hash1>,<email-address>
<group2>,
*,<hash3>
```

This means:

* In order to publish anything to the group "group1" you must provide the API key "hash1" was generated from

* You may publish packages to the group "group2" without an API key 

* For any group name but `<group1>` and `<group2>` you must specify the API key "hash3" was generated from


##### Editing the file "Credentials.csv" 

There is one reason why you might need to change the file `Credentials.csv`: when a group name must be deleted for some reason.

If a new group needs to be added, or a new API key needs to be assigned to an existing group, you must create a file `Credentials.txt`, see above.

##### Comments

The files `Credentials.txt` as well as `Credentials.csv` both allow comment lines: any line that has a `;` as the very first character is regarded a comment.


## Publishing


### Preparing

#### How to structure a package

A Tatin package requires all source code (functions, operators, classes, interfaces and namespace scripts) to be separated from other files (like CSS files, EXEs, DLLs etc.).

Tatin calls the former "source" and the latter "assets". 


#### The package configuration file

The file `apl-package.json` must exist in order to make a folder a package.

What is required and how to create and change a package configuration file is discussed in the document [PackageConfiguration](./PackageConfiguration.html ).


#### The dependency file

The file `apl-dependencies.txt` is only required when a package depends on other packages.

Dependencies may by installed in a package project in different ways:

* By default Tatin assumes a subfolder `packages/` to save dependencies.

* If you manage a package project with Cider, then Tatin will check the properties `dependencies.tatin` and `dependencies_dev.tatin`: if one of them or both define a folder then it will be taken

* If you do not use Cider and prefer a subfolder not named `packages/` for any dependencies, then you must specify them explicitly:

  * The user command `]Tatin.PublishPackage` has a modifier for this: `-dependencies=`
  * The API function `PublishPackage` can be fed with an optional left argument for this

I> In case you specify a dependency that has not (yet) been published, then this has no consequences: the server will not reject such a package. 
I>
I> That might come as a surprise, but there is a reason for this: when a bunch of packages is published then there might well be mutual or worse circular dependencies. Insisting on dependencies already being published would not work then.

Usually, you will specify just a full package ID as a dependency. If you wish you may also specify either a URL following the http[s]:// protocol or a zip file following the file:// protocol. The latter is always a temporary solution, however. 

Notes:

* Specifying a dependency with the file:// protocol means that you won't be able to publish that package to a Tatin server because it would for obvious reasons be rejected with "400 --- bad request".

  That is good enough a reason to use this with care. Only when messing around with packages on your local machine that are not designed to be published on a Tatin server may this be used.

* Using the http[s]:// protocol defeats Tatin's scan strategy: normally when a dependency is required Tatin will scan all defined Registries by their priority, unless the http[s]:// protocol is used. Again this should be used with care.

* When a package is published to a Tatin Registry, any protocols (file:// or http:// or https://) are removed: the dependency is defined just be the package names. 

  When such a package is installed or loaded, Tatin will interrogate all Registries in its search path, with the first hit winning the day.


### Final step

Once the preparation is done the final step is easy. Specify the folder hosting the package:

```
]TATIN.PublishPackage /path2package [tatin]
```

The folder may or may not carry a trailing slash (`/`).

This would attempt to publish the package found in `path2package/` to the principal Tatin Server.

You can also build a new version by calling `]TATIN.BuildPackage` (or its aquivalent, the API-function `BuildPackage`) and specify the resulting ZIP file as an argument to `PublishPackage`:

```
]TATIN.PublishPackage /path2package/group-name-1.2.3.zip [tatin]
```

When a path to a package project is provided rather than a ZIP file then `]PublishProject` would create the ZIP file itself.

Note that both `]PublishPackage` as well as `]BuildPackage` assume that if the package about to be published depends on other packages these packages will be installed in a subfolder `packages/`.

However, if the project is managed by Cider then Tatin investigates the Cider config file. Cider has two properties `dependencies.tatin` and `dependencies_dev.tatin` designed to hold the folder with package dependencies, and if one of them is not empty then Tatin would use it, or question the user if both are set and not empty.

If you do not use Cider but want to establish a non-default subfolder (read: not named `packages/`) as the one holding package dependencies then you must specify the subfolder with the `-dependencies=` flag.


### User command packages

Packages that are user commands are a special case. Here is why:

User commands must have a user command script --- that's what makes them a user command. They can simply be installed as Tatin packages and the job is done. But there is a problem.

The package might look like this:

```
MyUserCommand/
    APLSource/
        MyUserCommand/        ⍝ Contains the code
        TestData/
        TestCases/
        MyUserCommand.dyalog  ⍝ The user command script
    packages/
        ...
    packages_dev/
        ...
    apl-package.json
    cider.config
    LICENSE
    README
```

The package configuration parameter `source` will then read `APLSource/MyUserCommand` because we don't want `TestData/` and `TestCases/` to be part of the installed package.

But that would mean that the script `MyUserCommand.dyalog` would not be installed either, so there is a problem: the script would not make it when the packages are installed. Also, the user command script should live in the root of the package's installation folder, not in a sub folder.

That's why Tatin needs to know that the package is a user command, and where to find its script. This does the trick:

```
userCommandScript: "APLSource/MyUserCommand.dyalog",
```

The fact that the parameter exists and is not empty tells Tatin that it is a user command, and the path allows Tatin to first install everything as usual and then move the script to the root of the package installation folder.

The installed package will then consist of:

* A folder for the `MyUserCommand` package 
* Folders for all dependencies 
* A file `apl-buildlist.json`
* A file `apl-dependencies.txt`
* The user command script: `MyUserCommand.dyalog`

Note that by definition a package must contain some code. If a user command is implemented as a single script file, which is possible and perfectly fine with simple user commands, this would not be the case. For this reason, it is advisable to separate the user command as such (with the necessary `Run`, `List` and `Help` functions) from the "business logic" that does the real work.

The latter one would remain in the package, fulfilling the requirement.


## Deleting packages

Whether you can delete a package once it was published depends on the policy the server operates:

* "Any": You may delete any package
* "JustBetas": You may delete only beta versions
* "None": You cannot delete any packages at all

Note that anything that carries something that is not a digit after the second dot in the version number and before the build separator "`+`" qualifies as a beta version.

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

Or visit its website, for example, <https://tatin.dev>: at the bottom of the home page the server mentions the "delete" policy it operates.

## Development strategies

Let's imagine that you are supposed to develop Tatin packages for your employer, the company "XYZ".

* You run a Tatin server on your local machine, known by the alias `[my]`.

  This is just for you, nobody else. The purpose of this server is to publish packages to it at a very early stage.

  It has the highest priority of all Registries, ensuring that in case a package lives on several Registries it is found on `[my]` first.

* Your team runs a Tatin Server on the Intranet of your company. It carries the alias `[my-team]`.

  This is used to publish beta versions that your team might want to use. This has the second-highest priority.

* Your company also runs a Tatin Server used for productive packages.

* Your packages may depend on packages published on Tatin's principal server, known as `[tatin]`.

  Of the four Registries, this one should have the lowest priority.

* You might also have the test Registry defined in your user settings, but with a priority of `0` so that it will be ignored when Registries are scanned for packages, but you could still use it.

You can now develop a package `Foo` and publish it on `[my]`, probably several times until it is stable.

You would then publish it on `[my-team]`. At the same time, you would either delete the package from `[my]` or, if you want the Registry `[my]` to be ignored altogether, set its priority to zero.

When all is good the beta is promoted to an official release and published to the Tatin company server. At the same time, the package will most likely be deleted from the Team server.


















