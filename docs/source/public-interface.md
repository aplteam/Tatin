---
title: "Public interfaces"
description: "How to control which objects of a Tatin package are exposed as its public interface"
<!-- keywords: api, interface, package -->
---
# Public interface to a package

!!! abstract "How to control which objects of a Tatin package are exposed to its users"


## Why define a public interface?

By default, when a package is loaded, its public interface is all its top-level objects:

    ⎕NL 2 3 4 9

For a small package this is often perfectly fine. But as a package grows, it typically develops internal helpers, utilities, configuration namespaces, and other objects that are not intended for consumers. Exposing everything means:

- consumers see a cluttered surface that makes it hard to understand what the package actually offers
- you cannot safely rename or reorganise internal objects without risking that consumers are relying on them
- there is no clear contract between the package and its users

Defining a public interface addresses all three concerns. You expose only what you intend to support, and the rest remains an implementation detail free to change.


## The API space

The public interface is defined by an **API space**: a namespace whose contents are references to and functions calling objects in the package. When the package is loaded, its handle points to this API space rather than to the package namespace directly.

!!! detail "The API space acts as a filter: referring to anything other than the exposed names signals an error."

For example, MarkAPL has an API space called `API`:

```apl
      #.MarkAPL
#._tatin.aplteam_MarkAPL_13_1_0.API
```

The default name for the API space is `API`, and there are few reasons to change that. (You can specify a different name for the API space by setting `api` in the [package configuration](package-configuration.md#standard-settings).)



## Let Tatin establish the API

Establishing an API (or populating an API space) is surprisingly complex. Whether the object you want to expose is a tfn or a dfn, a namespace, class, interface or script, niladic or not, all of this makes a difference: all these objects need to be treated differently.

Luckily Tatin offers a function that will establish the API for you: [`CreateAPIfromCFG`](api.md#create-api-from-cfg).


`CreateAPIfromCFG` looks in the package for a constant `Public` (a niladic function or a variable) that lists the names to expose as a vector of strings. It creates the API space as a child of the source namespace with the name specified in the configuration (which defaults to `API`) and populates it with references to or dfns calling those objects, whatever is appropriate.

Along the way it handles shy results, ambivalent and niladic functions accordingly.


## When to call `CreateAPIfromCFG`

Call it as part of your build process before you call `BuildPackage`.

## Restrictions

### Scripted namespaces

`CreateAPIfromCFG` cannot create a child namespace inside a scripted namespace. Therefore it cannot establish an API.

### A package that comprises just a single function (or operator)

If your package comprises just a single function or operator, you cannot make an API, but there is no need for an API anyway.