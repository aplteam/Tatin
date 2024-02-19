[parm]:title = 'ListDependencies'


# ListDependencies

## Overview

We neeed a user command that shows a tree structure with all dependencies.

## API function

The API fuction takes a folder with a file `apl-dependencies.txt` and a file `apl-buildlist.json`.

It returns a matrix with these columns:

```
[;1] Depth starting with 0
[;2] <group>
[;3] <name>
[;4] <version>
[;5]
```

## User command



