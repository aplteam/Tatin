# Make the usage data configurable

## The question

Should the usage-related stuff be configurable? The data is wanted for <https://tatin.dev>,
but certainly not for <https://test.tatin.dev>.

Yes — and there is a bit more to it than a switch, because there is no separate collector to
switch off.

## What "the usage-related stuff" actually is

Usage data is a by-product of the ordinary application log. `OnHouseKeeping.aplf:43` calls
`Logs.ProcessLogFile` **unconditionally**, every housekeeping tick, which reads `app-log.txt`,
keeps the `GET 200 /<package-id>` lines, aggregates them and writes `usage-data-*.csv` plus
`.zip` into `LOGGING:Folder`. Three other places expose it:

- `GetFooter.aplf:9` — the "Usage data" link on every page
- `Handle_GET_REST_Version1.aplf:64` — the `/v1/usage-data` page and the JSON `?list` / `?download=` API
- `Handle_GET.aplf:21` — serving the ZIPs themselves

So test.tatin.dev is producing and publishing usage data right now, and
`]Tatin.UsageData https://test.tatin.dev` will happily list and hand out those files.

The only existing mitigation is `Client.AddTestFlag` → `(test)` in the log line → filtered in
`ProcessLogData`. That covers requests the **test suite's own client** makes (which is what
keeps test runs out of tatin.dev's numbers — worth keeping). It does nothing for a browser, a
crawler or a manual `]Tatin.Install` pointed at the test server.

`LOGGING:Log = 0` is not a usable off switch: it kills the app-level log wanted for diagnosing
the test server, and `ProcessLogFile` does an unguarded `raw←⊃⎕NGET filename 1`, so a server
with no log file would throw inside housekeeping's `:Trap 0` and end up at `⎕SIGNAL 11`.

## What to add

One flag in `[CONFIG]`, alongside `Sitemap`, `NoIndexing`, `X_Robots_Tag` and `SpecialCommands`
— the family of "this is a test server" toggles that already exists:

```
UsageData = 1   ; 0=don't aggregate usage data, and don't publish it; for test servers
```

Absent should mean **1**, not 0 (unlike `Sitemap`), so existing installations keep collecting
across an upgrade.

Gate all four call sites, not just the aggregation. Skipping only `ProcessLogFile` would leave
the endpoint serving whatever ZIPs are already in the log folder. The client side needs no
change at all: `UsageDataGetList.aplf` already treats a 404 as `'Command is not available'`.

Two flags — collect versus publish — is the obvious alternative (an in-house registry that wants
numbers but no public page), but the split is better left until somebody asks for it; an INI
cannot be uncomplicated later.

## Loose ends

- The ZIPs already sitting in test.tatin.dev's log folder want deleting once by hand.
- The `CONFIG` table in `docs/source/install-server.md` needs a row.
- `docs/source/user-commands.md` § Usage data needs a line saying a registry may have it
  switched off.
