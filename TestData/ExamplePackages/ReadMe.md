The files and the workspace are useful for creating the package examples.
This is about what to specify on "source" and "api".

All projects are to be found in `Projects/`

The workspace ExamplesSourceAndAPIs.dws contains a number of useful functions:

* `∆MakePackages` takes all projects found in `Projects/` and transforms them in packages by zipping them into `Packages/`

* `∆PublishOnTatinTestServer` takes all ZIP files found in `Packages/` and published them on     the Tatin Test server
  
* `∆LoadPackagesin` deletes `#._tatin` and then loads all packages from `Packages/` into the WS

⍝ * `∆CreateMarkdown` returns markdown from the packages found in the workspace. The markdown can then be injected into the documentation.  (Do we actually need this?)