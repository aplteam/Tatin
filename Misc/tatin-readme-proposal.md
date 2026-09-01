# Making Tatin packages findable: the case for rendering READMEs

## The problem

Google has indexed 22 pages of tatin.dev. It has declined to index 118.

Of those 118, 97 fall under "Crawled – currently not indexed". That category means something specific: Google fetched the page, read it in full, understood it, and decided it was not worth a place in the index. It is not a crawl failure and not an error.

The remaining 21 are minor housekeeping (a handful of 404s, some deliberate `noindex` pages, a redirect or two). They are not the story.

### What is *not* causing this

Before proposing work, it is worth recording what has been ruled out:

- **Not a rendering problem.** tatin.dev uses no JavaScript. Every page is generated server-side and delivered complete.
- **Not a Cloudflare problem.** Googlebot is a verified crawler and receives the full page. This was confirmed directly through Search Console's live URL test: the package listing renders with all rows present.
- **Not a crawl-budget or accessibility problem.** Google crawled all 97 pages. It simply chose not to keep them.
- **Not a markup defect.** The server's HTML is sound.

There is no fault to repair. The pages are working exactly as designed — and the design is the issue.

### What is actually causing it

Two things, both structural.

**1. The pages that carry content carry almost no information.**

The Details page — `/v1/packages/details/aplteam-ADOC-7.1.4` — is the only page type in the registry with substantive content, and what it holds is the package's configuration: a block of key/value pairs (`api`, `date`, `license`, `minimumAplVersion`, `os_lin`, `os_mac`, `os_win`, `source`, `tags`, and so on). Perhaps 150 words, and the great majority of those words are field *names* identical on every Details page in the registry.

The one line describing what the package actually does is the `description` field: a single sentence, often under fifteen words.

From a search engine's perspective these pages are near-indistinguishable from one another. Nothing separates `davin-FilePlus` from any other entry except a name, a date and one short sentence.

**2. Every release generates another near-identical page.**

Tatin treats each major version as a distinct package, which is correct — a breaking change is a different thing. But within a major line, every published release gets its own Details page. `aplteam-ADOC-7` with a dozen releases produces a dozen Details pages differing only by a version string and a timestamp.

Google indexes one or two of them and discards the rest. Given the registry's "delete none" policy, this multiplication only grows over time.

Meanwhile the page that *should* represent the package — `/v1/packages/versions/aplteam-ADOC-7` — is a bare table of links with no content of its own. So the registry offers Google a choice between many pages that are nearly identical and one page that is nearly empty.

### Why this matters

A developer with a problem to solve searches for the problem, not for the registry. Someone who needs to extend component files to use arbitrary component keys searches for that — and does not find `davin-FilePlus`, because the only page describing it holds one sentence buried in a configuration dump.

This is the ordinary discovery path for every other language ecosystem. npm, PyPI, crates.io and pkg.go.dev all rank well for problem-shaped queries, and they do so for one reason: **each package page renders the package's README.** That is where the substance lives — what the package does, how to use it, what the API looks like, why you would choose it.

Tatin has the same packages, the same quality of documentation, and the same authors writing it. That documentation simply lives on GitHub, where nothing points at Tatin, instead of on Tatin, where it would.

The APL community is small, and no amount of this work will make tatin.dev a high-traffic site. But the current situation means a developer who *is* looking for exactly what a Tatin package provides will not find it — a self-inflicted limit on the registry's reach, and on the reach of every author who publishes to it.

## The solution

**Render each package's README on its package page** — `/v1/packages/versions/<name>-<major>` — turning it from an empty index into the substantive page it should always have been.

At publish time the registry fetches the README from the release's Git tag and stores it. The package page shows the README of the newest release in its major line. Details pages are left exactly as they are.

Alongside this, one piece of tidying: point the Details pages at the package page as their canonical URL. This stops the registry's releases competing with each other and consolidates each package into one substantial page.

### Why this is cheap

1. **The data already exists.** Every published package supplies a `project_url`. Nothing new is asked of authors.
2. **The renderer already exists.** MarkAPL converts markdown to HTML5 and is already part of the ecosystem.
3. **The page structure already exists.** Because Tatin treats each major version as its own package, there is already a natural page per package. No new URL scheme is needed.
4. **The fetch is deterministic.** Tatin's release tags follow `v{x}.{y}.{z}`, so the README URL is derivable from the version — no branch detection, no guessing, and each release resolves to the documentation that shipped with it rather than to whatever the repository holds today.

### Coverage

A survey of the registry found that **81 of 121 packages have a README** available at the expected location — roughly two-thirds.

That is lower than one might hope, but the missing third is not a random sample. A package without a README is disproportionately likely to be small, internal, or published once and never revisited. The packages a developer would plausibly search for are heavily concentrated in the 81, so coverage of the pages that matter is higher than the headline figure.

It is also not a fixed ceiling. Once package pages visibly render documentation, an author seeing an empty space where every other package has content is a stronger prompt than any policy could be. Registries that render READMEs tend to see coverage rise on its own.

### What this is not

It is worth being explicit that this proposal does **not** involve hiding text from visitors, stuffing keywords, or any other search-engine manipulation. Those techniques violate Google's spam policies and risk the entire domain being removed from the index.

The proposal is simply to show visitors the documentation the package author already wrote. The search benefit follows from the page becoming genuinely more useful — which is also the only durable kind.

### Secondary benefits

Even setting search aside entirely, this improves the registry:

- A visitor evaluating a package can read its documentation without leaving tatin.dev.
- The package page stops being an empty table and becomes a page worth linking to.
- Because the README is fetched from the release's tag, a dormant major line keeps the documentation that was current when it was maintained — rather than showing its successor's incompatible instructions.
- Package authors get their work presented properly rather than reduced to a config listing.
- The registry gains an outbound link to each project's repository, and a visible attribution line crediting the author.
- Tatin comes closer to parity with the registries APL developers already use in their other languages.

## Effort and risk

The implementation is contained: a fetch step at publish time, one storage field, a sanitising renderer, one template change, and a one-off backfill.

The main risks are ordinary and manageable:

- **README fetch failures must never block a publish.** Fetching is best-effort; a missing README degrades to today's behaviour.
- **Third-party markdown must be sanitised** before rendering into tatin.dev pages.
- **Relative links and images in READMEs must be rewritten** to resolve against the source repository.
- **A tag may not exist yet** if an author publishes to Tatin before pushing the tag. The fetch simply records an absence; the gap closes at the next release.

None of these is novel; every registry that renders READMEs has solved them.

## Recommendation

Proceed. The change is modest, the data and tooling are already in place, and it improves the registry for human visitors whether or not the search results follow.
