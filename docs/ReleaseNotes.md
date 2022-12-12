[parm]:title             = 'Release Notes'
[parm]:toc               = 3
[parm]:collapsibleTOC    = 1
[parm]:leanpubExtensions = 1
[parm]:numberHeaders     = 2 3 4 5 6




# Release Notes

Release notes only contain information regarding actions that need to be executed before a new version can be used. This regards almost exclusively the server.


## Version 0.81.0

### Server

#### The INI entry [CONFIG]base

This is a **Breaking Change*!

Until version 0.81.0 this was something like `https://tatin.dev` -- that's wrong!

The protocol and the port are both defined by their own properties in the INI file, to "base" should be just the domain name.

Therefore the INI entry must be checked and changed:

From `https://tatin.dev` to `tatin.dev`


#### New INI property "MaintenancePath"

With this version a new INI entry got introduced: `MaintenancePath`. This entry **must be added** to the INI file.

This defines a folder that is designed to contain `*.aplf` files. Such files are loaded by the server, the code is executed and then the file(s) are renamed from, say, `foo.aplf` to `foo.aplf.executed`.

The purpose is to provide an easy way to massage the data in the Registry. The original application was the need to polish tags for many packages.

`MaintenancePath` usually points to a path within the Server's own directory, so `{home}` can be used.

For example:

```
MaintenancePath='{home}\Maintenance\'
```