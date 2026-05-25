---
title: 'Tatin public interfaces'
description: 'How to control which objects of a Tatin package are exposed as its public interface'
keywords: api, apl, dyalog, interface, package, tatin
---
# Public interface to a package

!!! abstract "How to control which objects of a Tatin package are exposed to its users"

<!-- 
FIXME What?
These cover functions are one-line dfns that call the function with the same name one level above. Because they are one-liners the Tracer will ignore them: it is not possible to trace into a one-line dfn. Most of the time this is a blessing, but sometimes it is a curse.
 -->
By default, the public interface of your package is all its _top-level objects_:

    ⎕NL 2 3 4 9

!!! detail inline end ""

    The API space serves as a filter:
    referring to anything but the exposed names signals an error.

You can instead select objects to expose
by specifying an **API space**: a namespace with references only to the exposed objects.
Then when the package is loaded into the workspace, the contents go into the package cache,
and its handle points to its API namespace.

For example, MarkAPL has an API space (called `API`) with references to its exposed functions.
```apl
      #.MarkAPL
#._tatin.aplteam_MarkAPL_13_1_0.API
```
You can define an API space for your package, or Tatin can create one for you.
The `api` setting in the package config tells Tatin how to use it.


## Define an API space

Suppose package APkg consists of a single scripted namespace `Core` with multiple variables, functions, and operators of which only `Encode` and `Decode` should be exposed
– as `#.APkg.Encode` and `#.APkg.Decode`.

In the `Core` script you could create this structure
```
#.APkg
#.APkg.Core
  ... ⍝ vars, fns and oprs
#.APkg.Core.API
#.APkg.Core.API.Encode
#.APkg.Core.API.Decode
```
with these definitions
```apl
API.Decode←{⍺ ##.Decode ⍵}
API.Encode←{⍺ ##.Encode ⍵}
```
then have the config `api` setting specify `Core.API`.
The two functions would be exposed as `#.APkg.Decode` and `#.APkg.Encode`
– and nothing else would.
<!-- FIXME Could you, though? -->

Suppose you had reason _not_ to modify the `Core` script.
Just include a second namespace in your package:
```apl
:Namespace API
    Decode←{⍺ ##.Core.Decode ⍵}
    Encode←{⍺ ##.Core.Encode ⍵}
:EndNamespace
```
then have the config `api` setting specify `API`.
The effect would be the same.

An API can use multiple sources.
Suppose you have a third namespace: `More`.
```apl
:Namespace API
    Decode←{⍺ ##.Core.Decode ⍵}
    Encode←{⍺ ##.More.Encode ⍵}
:EndNamespace
```


## Create an API from the config

For many packages, Tatin can create the API space for you, at build or load time.
Specify the API space in the `api` setting of the [package config](package-configuration.md#standard-settings) and list what is to be exposed in it.

Function [`CreateAPIfromCFG`](api.md#create-api-from-cfg) creates the API space as a child of the source namespace and populates it with references to the exposed ojects.

!!! tip inline end ""

    You can substitute for this list (or override it) with an optional left argument.

It looks in the package for a constant `Public` that names the objects to expose.
This list of strings can name functions, operators, variables, interfaces, classes and namespaces, both simple and scripted.
The objects must all be children (or, with dot syntax, grandchildren) of a single source namespace.


You can create the API by calling `CreateAPIfrom CFG`

-   at **load time** from a function specified as the package’s [`lx` setting](package-configuration.md#standard-settings)
-   at **build time**, incorporating the API into the built package


??? warning "If your source is a single scripted namespace, you cannot use `CreateAPIfromCFG`"

    The function cannot create a child space of a scripted namespace.

    Instead, define an API space directly: see above.

<!-- 
You don’t need a function `Public` here.
Its only purpose is to be called by `CreateAPIfromCFG` and here the job is done instead by you.
 -->

<!-- 
FIXME Move down the page
!!! warning "A function or operator cannot be the API"

    If your package exposes just a single function or operator,
    make its parent workspace the API space.

    The restriction helps avoid confusion, but there is also a technical issue.
    Tatin creates a reference to the API space.
    Although in Dyalog APL one can (sort of) create references
    to monadic, ambivalent, and dyadic functions,
    it is not possible for operators or niladic functions.
 -->

## Some scenarios

To expose from your package APkg (as e.g. `#.APkg.Hello`)

object/s from                 | api   | CreateAPIfromConfig
------------------------------|-------|--------------------------
a single namespace `Foo`      | `Foo` | :fontawesome-solid-check:
a single scripted namespace   | `API` | :fontawesome-solid-xmark:
a single class `Foo`[^access] | `Foo` | :fontawesome-solid-xmark:
multiple namespaces           | `API` | :fontawesome-solid-xmark:

[^access]: In a class, use `:Field` and `:Access` declarations to expose objects.


<!-- 
FIXME This seems like a terrible idea.
Why install in the workspace root and then access through a namespace?
##### Restricting what's "public"

The user might want to expose only a subset of functions/operators of a namespace (classes have such an interface anyway: `:Public Shared`), and in that case, the user must not only specify `api`, but also structure her code accordingly.

If the name of the package is `pkgName`, and it is loaded into `#`, and you want to expose only the functions `Run` and `CreateParmSpace`, then the recommended way of doing this is to create a sub-namespace with the name (say) `MyAPI` and populate it with two functions:

* `Run`:

  ```
  Run←{⍺←⊢ ⋄ ⍺ ##.Run ⍵}
  ```

  (Assumes that `Run` takes an optional left argument)

* `CreateParmSpace`:

  ```
  CreateParmSpace←{##.CreateParmSpace ⍵}
  ```

  (Assumes that `CreateParmSpace` does not accept a left argument)

Finally, you need to specify `api: "MyAPI"` in the package config file.

Calling the function `Run` (after loading the package) would then require:

```
      #.PkgName.Run
```

To the outside world, only two functions are visible:

```
      #.PkgName.⎕nl ⍳16
#.Foo.Run
#.Foo.CreateParmSpace
```

Similarly, if `PkgName` consists of the two namespaces `Boo` and `Goo`, and `Run` and `CreateParmSpace` live in `Boo`, then you could also have a sub-namespace `Boo.API` that hosts `Run` and `CreateParmSpace`, and `api` would be `Boo.API`, while calls are still `PkgName.Run` and `PkgName.CreateParmSpace`.

 -->