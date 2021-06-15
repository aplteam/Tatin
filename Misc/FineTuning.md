# Tatin Fine Tuning

This document proposes a couple of changes discussed in the meeting that took place on 2020-02-16, and rejects others.


## `api`

It was discussed to change the API so that it is a _single name_ of either a _class_ or a _namespace_ but nothing else. A package that is just a single function must "deliver" that function then in a namespace that contains nothing but that function.

After pondering over this for a while I realized that indeed that would make things simpler and more consistent without giving anything up.

It must allow a dotted path however, something like this:

```
api: "MyPackage.API"
```

Also, `api` can be left empty in many cases because of changes to `source` we already agreed on. In fact unless a dotted path is specified, `api` will usually be empty.

I propose to change Tatin accordingly.


## `source`

In the future the user _must set_ `source`, and it must be one of:

* The name of a class script
* The name of a namespace script
* The name of a folder that holds files with APL code



## Names

Adam has critized the names in the package config file, in particular `project_url`. 

Couple of remarks:

* It's a bit late to start discussing names at this stage. That should have been done a year ago.

* I still think  that `project_url` is sufficiently clear, and so does Gil.

* `info_url` was suggested as an alternative. I asked Anne (my guinea pig for this kind of things) what comes to her mind, and she said "documentation". Conclusion: `project_url` might not be perfect, but neither is `info_url`, and it is already used in many projects.

It was also critized that the JSON file does not give any hints on what certain pieces of information are used for. True that may be, but we are addressing programmers, not end-users. I expect a programmer to look up the documentation.

If we really want to provide something user friendly for this then it is probably better to put the data into HTMLRenderer-GUI. That could provide all sorts of additional information and also perform checks.


## `dyalog`

I propose to add a property `dyalog` which can take these values:

```
dyalog: "18.0"          ⍝ Works with any version 18.0 or better
dyalog: "18.0.39845"    ⍝ Works with any version 18.0.39845 or better
dyalog: "=18.0"         ⍝ Works only with version 18.0
```


## Conclusion

I have already published a significant number of packages, and I am using Tatin now for most of my work,  and I am constantly converting the remaing tools and applications. It works fine.

It's probably not a good strategy to try to produce something pefect. "Very useful" should be sufficient.

Besides, not matter what names and structure we choose, people will critizise it anyway.