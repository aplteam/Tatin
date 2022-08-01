# What is this project good for?

The file `apl-buildlist.json` contains a package that was loaded from a Registry that is **not** on the Tatin Registry search path.

There is a test case that checks whether this is handled correctly: Cider should not even try to scan Registries for better versions in such a case.