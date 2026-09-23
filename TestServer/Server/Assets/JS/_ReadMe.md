This folder holds the JavaScript of the Registry's web pages. It is all written for Tatin: no library is used, there is nothing to build, and the Registry serves the files itself, so a Registry without access to the internet works just as well.

Every page is complete without JavaScript. The scripts only add tools, and the markup a script needs is written with `hidden` set, so without JavaScript it simply does not show.

| File | Page | What it adds |
|------|------|--------------|
| `package-list.js` | Packages (`/v1/packages`) | The filter, "Include tags in the filter", the sort switch and the note shown for a tag link like `?tag=files`; "/" jumps into the filter and Esc clears it |
| `package-page.js` | A major version of a package | "Show all N releases"; the copy button of the install command is an inline script made by `GetJavaScriptForCopyButton` |
| `tag-list.js` | Tags (`/v1/tags`) | The filter; "/" and Esc as on the package list |
| `tabs.js` | Usage data (`/v1/usage-data`) | Turns the sections into tabs; the tab shown can be named after "#" in the address |

Each file says at the top which markup it relies on. The functions that write that markup are named there as well, so a change on one side can be matched on the other.
