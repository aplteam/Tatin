# Implementation plan: a sitemap for tatin.dev

Independent of the README work. Can be implemented and deployed on its own, and there is a good argument for doing so first --- see §6.

---

## 1. Why

A sitemap is a discovery aid: it tells a search engine which URLs exist. That is *not* why tatin.dev needs one --- every page is already reachable from the package list, and Google has demonstrably crawled all of them. Three other benefits apply.

* It makes the Search Console report legible

  Once a sitemap is submitted, the Pages report gains a filter: *All known pages* versus *All submitted pages*. The second view shows only the URLs the site declares as mattering. Today's "22 indexed / 118 not indexed" becomes something closer to "150 submitted, most indexed", because the Details pages --- which were never meant to be indexed --- drop out of view. This is a permanent improvement to the site's own diagnostics, not a cosmetic one: it means future problems are visible instead of buried under expected noise.

* It provides a recrawl signal

  The `lastmod` date gives Google a reason to re-fetch a page. In steady state this matters little. It matters a great deal exactly once --- when a site-wide content change ships and a hundred pages become substantially different from what Google has cached. A sitemap with honest `lastmod` values is the clean way to signal that, rather than clicking "Request Indexing" a hundred times.

* It states which URLs are canonical

  A second, unambiguous declaration consistent with any `<link rel="canonical">` tags. It does not replace them.

## 2. Costs and risks

* It must stay correct 

  A sitemap listing URLs that 404, redirect, or carry canonical tags pointing elsewhere sends contradictory signals and is worse than having none. Generating it from live data (§4) removes this risk.
* `lastmod` must be honest

   If every entry always reads "today", Google learns to ignore the field, and the recrawl benefit above is lost.


## 3. Contents

Include:

- The home page
- `/v1/packages` (the package list)
- Every `/v1/packages/versions/<name>-<major>` page
- Documentation, licence, and any static pages

Exclude:

- `/v1/packages/details/<name>-<version>` --- one per release; these are exactly the pages that should not be indexed
- `/v1/packages/major_versions/<name>` --- a pure index with no content of its own
- Anything served under a `noindex` tag

At present this yields roughly 150 URLs. The format's limits are 50,000 URLs and 50 MB uncompressed per file, so a single file suffices indefinitely at Tatin's scale --- no sitemap index needed.

## 4. Generation

To be served dynamically at `https://tatin.dev/sitemap.xml`, generated on request from the same data that drives the package list. It is a small amount of work, and it can never fall out of step with reality.

Set `Content-Type: application/xml`.

## 5. Format

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://tatin.dev/</loc>
    <lastmod>2026-08-07</lastmod>
  </url>
  <url>
    <loc>https://tatin.dev/v1/packages</loc>
    <lastmod>2026-08-06</lastmod>
  </url>
  <url>
    <loc>https://tatin.dev/v1/packages/versions/aplteam-ADOC-7</loc>
    <lastmod>2026-05-14</lastmod>
  </url>
  <url>
    <loc>https://tatin.dev/v1/packages/versions/aplteam-ADOC-6</loc>
    <lastmod>2024-11-02</lastmod>
  </url>
</urlset>
```

Rules:

* `<loc>` must be absolute

   It must match the URL actually served --- same scheme, same host, same trailing-slash treatment. A mismatch causes the entry to be ignored.
* XML-escape the URLs

  `&` becomes `&amp;`. Package names are unlikely to contain such characters, but the encoder should handle it rather than assume.
* `<lastmod>` is `YYYY-MM-DD`
  (or a full W3C datetime). For a package page, use the publish date of the newest release in that major line --- data the registry already holds. For the package list, the most recent publish date across the registry.
* Omit `<changefreq>` and `<priority>` entirely

  Google ignores both.

## 6. Ordering relative to the README work

There is a case for shipping the sitemap first, on its own.

Doing so establishes a baseline: with the *All submitted pages* filter in place, we get a clear reading of how the pages we care about are performing **before** any content changes. When the README work lands afterwards, its effect is measurable rather than inferred.

It also means the `lastmod` mechanism is already in place and already trusted by the time it is genuinely needed --- the day the README change makes 121 pages substantially different.

## 7. Deployment

1. Serve `/sitemap.xml`.
2. Add to `robots.txt`:
   ```
   Sitemap: https://tatin.dev/sitemap.xml
   ```
3. Submit it once in Search Console under **Indexing → Sitemaps**. Enter `sitemap.xml` and submit.

Step 3 is not optional. The robots.txt reference lets crawlers find the file, but the Pages report filter described in §1 only appears for sitemaps submitted through Search Console.

## 8. Verification

1. Fetch `https://tatin.dev/sitemap.xml` and confirm it is well-formed XML served as `application/xml`.
2. Spot-check three `<loc>` values by opening them: each must return 200, with no redirect.
3. Confirm no `details/` or `major_versions/` URL appears.
4. Confirm `lastmod` values vary and look plausible --- a dormant major line should show an old date, not today's.
5. In Search Console → Sitemaps, confirm the status reads *Success* and the discovered URL count roughly matches what was generated. A large discrepancy means parse errors worth investigating.
6. A few days later, open the Pages report and switch the filter to *All submitted pages*. This is the view worth keeping.

Allow a week or two before reading anything into the numbers.

## 9. Maintenance

None, if generated dynamically per §4. New packages and new releases appear automatically.

The one thing to revisit: if new page types are added to the registry later, decide explicitly whether they belong in the sitemap. The default answer for any page type generated per release is no.

