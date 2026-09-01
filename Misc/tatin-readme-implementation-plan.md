# Implementation plan: rendering package READMEs on tatin.dev

Assumes familiarity with the Tatin server. No SEO knowledge required.

**Page model this plan assumes** (Tatin treats each major version as a distinct package):

| URL | Role | Change |
|---|---|---|
| `/v1/packages/details/<name>-<version>` | One release. Immutable snapshot. | Canonical tag only |
| `/v1/packages/versions/<name>-<major>` | **The package page.** Currently a bare link table. | Renders the README |
| `/v1/packages/major_versions/<name>` | Disambiguation hub listing major lines. | `noindex` only |

---

## 1. Storage

Add to the **version** record:

| Field | Purpose |
|---|---|
| `readmeMarkdown` | Raw markdown as fetched from the release's tag. Store the source, not the HTML. |
| `readmeSourceUrl` | The `https://github.com/<group>/<repo>/blob/v{x}.{y}.{z}/README.md` URL, for attribution. |
| `readmeStatus` | `ok` / `none` — so gaps are visible. |

Cap `readmeMarkdown` at ~256 KB. Anything larger is almost certainly not a README; record `none` and move on.

Rendered HTML can be cached separately or generated on request — MarkAPL is fast and the input is bounded and immutable.

Only the newest release in each major line is ever rendered (§5), but storing per version costs little and leaves the option open to render on Details pages later.

---

## 2. Fetching

Trigger: **on publish**, after the release is accepted and stored. Never before — a fetch failure must not affect the publish outcome.

Tatin release tags follow `v{x}.{y}.{z}`, so the URL is derivable rather than guessable:

1. Strip build metadata: take the version string up to `+` (`1.3.0+1` → `1.3.0`).
2. Fetch `https://raw.githubusercontent.com/<group>/<repo>/v{x}.{y}.{z}/README.md`
3. On 404, retry once as `.../{x}.{y}.{z}/README.md` — older tags predate the `v` convention.
4. On 404 again, record `readmeStatus` = `none` and stop.

Derive `<group>` and `<repo>` from `project_url`, tolerating a trailing `/` and a trailing `.git`.

**No HEAD fallback.** A tag either exists or it does not. Falling back to the default branch would attach the current documentation to a release it does not describe — which on a dormant major line means publishing instructions that do not work. A clean absence is better than a confident error.

Use `raw.githubusercontent.com`, not the GitHub API: the API imposes a 60 requests/hour unauthenticated limit, the raw host does not, and no token is required.

**Case sensitivity:** GitHub's web interface resolves `readme.md` and `README.md` interchangeably; `raw.githubusercontent.com` does not. `README.md` is the correct single candidate. If an unexplained 404 rate appears later, this is the first thing to check.

**Timeouts and failure:** hard timeout of a few seconds per attempt. Any failure records `none`, logs, and continues. The publish succeeds regardless.

---

## 3. Sanitising

The markdown is third-party content being rendered into your pages. Before or after MarkAPL conversion:

- **Strip** `<script>`, `<style>`, `<iframe>`, `<object>`, `<embed>`, `<form>` and their contents.
- **Strip** all `on*` attributes (`onclick`, `onerror`, `onload`, …).
- **Strip** `javascript:` and `data:` URI schemes from `href` and `src`.
- **Demote headings by one level** — a README's `#` becomes `<h2>`, so it does not compete with the page's own `<h1>`. Cascade downward, clamping at `<h6>`.
- **Namespace anchor IDs** — prefix heading IDs generated from the README (e.g. `readme-installation`) so they cannot collide with IDs your template already emits.
- Add `rel="nofollow noopener"` to outbound links from README content.

The simplest robust approach is an allow-list of permitted tags and attributes applied to MarkAPL's output, rather than blocklisting markdown constructs on the way in.

---

## 4. Rewriting relative paths

READMEs use paths relative to the repository. Left alone, every image 404s against tatin.dev.

For any `src` or `href` that is not absolute and does not begin with `#`, resolve against **the same tag the README came from** — not the default branch, so images stay consistent with the documentation:

- **Images** → `https://raw.githubusercontent.com/<group>/<repo>/v{x}.{y}.{z}/<path>`
- **Links** → `https://github.com/<group>/<repo>/blob/v{x}.{y}.{z}/<path>`

Leave in-page anchors (`#section`) alone — they resolve correctly once IDs are namespaced (§3).

Badge images (shields.io and similar) are absolute URLs and need no handling.

---

## 5. Page changes

### 5a. Package page — `/v1/packages/versions/<name>-<major>`

This page currently has no content of its own. It gains the README of the **newest release in this major line**.

Suggested order — distinctive content before boilerplate:

1. Package name and description
2. Install command
3. **README section** (new)
4. Existing table of releases (as now)

Note that this needs no update logic. The newest release in a line changes only when something is published to that line, and that publish is what fetched the README. A line demoted by a new major version simply stops changing, and correctly retains the documentation that was current when it was maintained.

### 5b. Attribution line

Adjacent to the rendered README:

```
README from <readmeSourceUrl>
```

This credits the author and gives visitors a route to the source. Because the URL contains the tag, it also makes the version it describes explicit.

### 5c. Fallback

If `readmeStatus` is not `ok`, or the markdown renders to fewer than ~200 characters of text, omit the section entirely. No empty heading, no "no README available" notice.

### 5d. Details pages

Unchanged, apart from the canonical tag in §6. They remain configuration snapshots.

---

## 6. Canonical tags

On each Details page, add to `<head>`:

```html
<link rel="canonical" href="https://tatin.dev/v1/packages/versions/<name>-<major>">
```

This tells Google the releases are variants of one package and consolidates them onto the package page. It hides nothing; Details pages remain fully accessible to visitors.

On `major_versions/<name>` — a pure index with no content of its own and no prospect of any — add:

```html
<meta name="robots" content="noindex,follow">
```

Visitors still reach it; Google follows the links out of it and stops trying to index an index.

Leave `versions/<name>-<major>` free of both. It is the page you want indexed.

---

## 7. Backfill

One-off script:

1. Enumerate distinct `<name>-<major>` combinations.
2. For each, find the newest version record.
3. Run the §2 fetch for it.
4. Rate-limit to roughly one request per second — a courtesy to raw.githubusercontent.com, not a hard requirement.
5. Log the tally of `ok` / `none`.

Because the fetch keys on the release's own tag, historical releases backfill just as accurately as new ones — there is no need to distinguish current from dormant lines.

Expect roughly two-thirds success (81 of 121 packages in the survey). Review the `none` entries once: most will be genuine absences, but a cluster sharing a group may indicate a tagging convention worth accommodating.

Optionally backfill every version rather than only the newest per line. Nothing renders them today, but the data is correct and costs little.

---

## 8. Refresh

**There is none, and none is needed.**

Every README is tied to a Git tag, and tags do not move. A release's README is correct the moment it is fetched and stays correct forever. New documentation reaches tatin.dev with the next release, which is also when the package page's newest-release lookup picks it up.

The one useful admin operation is a **manual re-fetch for a single version**, to fill a record whose tag was pushed after the Tatin publish.

---

## 9. Sitemap

If tatin.dev serves a sitemap, ensure it lists `versions/<name>-<major>` pages and **omits** Details pages. If it does not serve one, generating a simple sitemap of package pages is a small addition worth doing at the same time.

---

## 10. Verification

After deployment:

1. View a package page's HTML source; confirm the README is present, visible and sanitised.
2. Check a package with two major lines. Confirm each page shows its own line's documentation, not the newer line's.
3. Confirm the canonical tag on a Details page points at the right `versions/<name>-<major>` URL.
4. In Search Console, run **URL Inspection → Test live URL → View tested page → HTML** on one package page. Confirm the README text is in what Google receives.
5. Wait. Re-indexing is measured in weeks. Check the Pages report after a month: expect "Crawled – currently not indexed" to fall and "Alternate page with proper canonical tag" to rise correspondingly. That shift is the intended outcome, not a regression.

Do not use "Request Indexing" for more than a couple of spot checks — it handles individual URLs, not site-wide changes.

---

## Order of work

1. Storage field (§1)
2. Fetch logic + backfill script (§2, §7) — run the backfill and inspect results before touching templates
3. Sanitise + path rewriting (§3, §4)
4. Package page rendering (§5)
5. Canonical and `noindex` tags (§6)
6. Sitemap (§9)

Steps 1–4 deliver the entire user-facing benefit. Steps 5–6 are what make the search side work, and can follow later without rework.
