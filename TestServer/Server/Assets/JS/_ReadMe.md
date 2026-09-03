This folder holds JavaScript libraries that are served to the browser from the Registry itself rather than from a CDN. That way a Registry without access to the internet still gets working tables.

`datatables-1.12.1.min.js` and the matching `../CSS/datatables-1.12.1.min.css` are one combined download from <https://datatables.net/download>, holding jQuery 3.6.0, DataTables 1.12.1 and Responsive 2.3.0. The exact build can be recreated or updated from:

```
https://cdn.datatables.net/v/dt/jq-3.6.0/dt-1.12.1/r-2.3.0/datatables.min.js
https://cdn.datatables.net/v/dt/jq-3.6.0/dt-1.12.1/r-2.3.0/datatables.min.css
```

Both carry the version number in their names: when they are replaced by a newer version the names change with them, so no browser can serve a stale copy from its cache. `GetDataTableStuff` links the two files, so that is where the names must be changed as well.

All three libraries are published under the MIT license. The combined download itself carries no license files, so they were taken from the repositories of the projects, each at the very version that went into the bundle:

| File | Taken from |
|------|------------|
| `LICENSE-jQuery` | <https://github.com/jquery/jquery> tag 3.6.0 |
| `LICENSE-DataTables` | <https://github.com/DataTables/DataTablesSrc> tag 1.12.1 |
| `LICENSE-Responsive` | <https://github.com/DataTables/Responsive> tag 2.3.0 |

Do not strip the comments at the top of the JavaScript and the CSS file either: that is where the copyright notices live.
