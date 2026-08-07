[parm]:toc             = 2 3 4
[parm]:title = 'Tatin & README'



# Implementation plan: rendering package READMEs on tatin.dev

Assumes familiarity with the Tatin server.

Page model this plan assumes (Tatin treats each major version as a distinct package):

| URL | Role | Change |
|---|---|---|
| `/v1/packages/details/<name>-<version>` | One release. Immutable snapshot. | `noindex` |
| `/v1/packages/versions/<name>-<major>` | **The package page.** Currently a bare link table. | Renders the README |
| `/v1/packages/major_versions/<name>` | Disambiguation hub listing major lines. | `noindex`|


## 1. Storage

Add to the **version** record:

| Field | Purpose |
|---|---|
| `readmeMarkdown` | Raw markdown as fetched from the release's tag. Store the source, not the HTML. |
| `readmeSourceUrl` | The `https://github.com/<group>/<repo>/blob/v{x}.{y}.{z}/README.md` URL, for attribution. |
| `readmeStatus` | `ok` / `none` — so gaps are visible. |

`readmeMarkdown` is capped at ~256 KB. Anything larger is almost certainly not a README; we record `none` and move on.

Rendered HTML should be cached.

Only the newest release in each major line is ever rendered (§5).

## 2. Fetching

Trigger: **on publish**, after the release is accepted and stored. Never before — a fetch failure must not affect the publish outcome.

Tatin release tags follow `v{x}.{y}.{z}`, so the URL is derivable:

1. Strip build metadata: take the version string up to `+` (`1.3.0+1` ==> `1.3.0`)
1. Fetch `https://raw.githubusercontent.com/<group>/<repo>/v{x}.{y}.{z}/README.md`
1. On 404, retry once without the leading "v" in the version number (for old packages)
1. On 404 again, record `readmeStatus` = `none` and give up.

Derive `<group>` and `<repo>` from `project_url`, tolerating a trailing `/` and a trailing `.git`.

* No HEAD fallback

  A tag either exists or it does not. Falling back to the default branch would attach the current documentation to a release it does not describe — which on a dormant major line means publishing instructions that potentially do not work. A clean absence is better than a confident error.

  Use `raw.githubusercontent.com`, not the GitHub API: the API imposes a 60 requests/hour unauthenticated limit, the raw host does not, and no token is required.

* Case sensitivity

  GitHub's web interface resolves `readme.md` and `README.md` interchangeably; `raw.githubusercontent.com` does not.

  `README.md` is the correct single candidate. If an unexplained 404 rate appears later, this is the first thing to check.

* Timeouts and failure

  Hard timeout of a few seconds per attempt. Any failure records `none`, logs, and continues. (The package is already published by then anyway)


## 3. Sanitising

The markdown is third-party content being rendered into Tatin's pages. Before the MarkAPL conversion:

* Strip all HTML tags from the markdown.
* Demote headings by one level --- a README's `#` becomes `<h2>`, so it does not compete with the page's own `<h1>`.
- Add `rel="nofollow noopener"` to outbound links from README content.


## 4. Rewriting relative paths

READMEs use paths relative to the repository. Left alone, every image 404s against tatin.dev.

For any `src` or `href` that is not absolute and does not begin with `#`, resolve against the same tag the README came from --- not the default branch, so images stay consistent with the documentation:

- **Images** → `https://raw.githubusercontent.com/<group>/<repo>/v{x}.{y}.{z}/<path>`
- **Links** → `https://github.com/<group>/<repo>/blob/v{x}.{y}.{z}/<path>`


## 5. Page changes

### 5a. Package page — `/v1/packages/versions/<name>-<major>`

This page currently has no content of its own. It gains the README of the **newest release in this major line**.

Suggested order — distinctive content before boilerplate:

1. Package name and description
1. **README section** (new, collapsible)
1. Existing table of releases (as now)

Note that this needs no update logic. The newest release in a line changes only when something is published to that line, and that publish is what fetched the README. A deprecated line simply stops changing, and correctly retains the documentation that was current when it was maintained.

### 5b. Attribution line

Adjacent to the rendered README we add:

```
README from <readmeSourceUrl>
```

This credits the author and gives visitors a route to the source. Because the URL contains the tag, it also makes the version it describes explicit.

### 5c. Fallback

If `readmeStatus` is not `ok`, or the markdown renders to fewer than ~200 characters of text, we omit the section entirely. No empty heading, no "no README available" notice.

### 5d. Details pages

Unchanged, apart from the canonical tag in §6. They remain configuration snapshots.


## 6. Canonical tags

On each Details page, we add to `<head>`:

```html
<link rel="canonical" href="https://tatin.dev/v1/packages/versions/<name>-<major>">
```

This tells Google the releases are variants and consolidates them onto the package page. 

On `major_versions/<name>` — a pure index with no content of its own and no prospect of any — we add:

```html
<meta name="robots" content="noindex,follow">
```

Visitors still reach it; Google follows the links out of it and stops trying to index an index.

`versions/<name>-<major>` should be left free of both. It is the page we want indexed.


## 7. Retrofit

Run this once:

1. Enumerate distinct `<name>-<major>` combinations
1. For each, find the newest version record
1. Run the §2 fetch for it
1. Rate-limit to roughly one request per second as courtesy to raw.githubusercontent.com (not a hard requirement)
1. Save `ok` or `none`

Because the fetch keys on the release's own tag, historical releases backfill just as accurately as new ones --- there is no need to distinguish current from dormant lines.

Roughly two-thirds will succeed (81 of 121 packages in the survey). We should review the `none` entries once: most will be genuine absences, but a cluster sharing a group may indicate a tagging convention worth accommodating.


## 8. Refresh

There is none, and none is needed.

The one useful admin operation is a **manual re-fetch for a single version**, to fill a record whose tag was pushed after the Tatin publish. Even that will fix itself when the next version of the packafe is published.


## 9. Sitemap

There are good reasons to have a sitemap that lists `versions/<name>-<major>` pages and omits Details pages. 

This topic is discussed in its own document, see there.


## 10. Verification

After deployment:

1. View a package page's HTML source; confirm the README is present, visible and sanitised.
1. Check a package with two major lines. Confirm each page shows its own line's documentation, not the newer line's.
1. Confirm the canonical tag on a Details page points at the right `versions/<name>-<major>` URL.
1. In Search Console, run *URL Inspection ==> Test live URL ==> View tested page ==> HTML* on one package page. Confirm the README text is in what Google receives.
1. Wait. Re-indexing is measured in weeks. 

   Check the Pages report after a month: expect "Crawled – currently not indexed" to fall and "Alternate page with proper canonical tag" to rise correspondingly. That shift is the intended outcome.

Do not use "Request Indexing" for more than a couple of spot checks — it handles individual URLs, not site-wide changes.


## Order of work

1. Sitemap (§9)
1. Storage field (§1)
1. Fetch logic + backfill script (§2, §7) — run the backfill and inspect results before touching templates
1. Sanitise + path rewriting (§3, §4)
1. Package page rendering (§5)
1. Canonical and `noindex` tags (§6)

Steps 2–5 deliver the entire user-facing benefit. Steps 6+7 are what make the search side work, and can follow later without rework.

