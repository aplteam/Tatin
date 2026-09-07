---
title: "Search engines"
description: "How a Tatin registry presents itself to search engines, and what to configure"
keywords: 
---
# Search engines

This page is about a registry that is meant to be found on the web. It explains what Tatin does about that, and why each measure is there. No prior knowledge is assumed: the vocabulary is introduced as it comes up.

If your registry is private, read [Keeping a registry out](#keeping-a-registry-out) and skip the rest.


## Why a package registry is a hard case

A search engine looks for pages that answer a question. A registry is close to the opposite: a great many pages that resemble one another, each carrying a table of version numbers and dates and very little prose. Left to itself it gives a search engine almost nothing to tell one page from the next, and almost nothing to match against what somebody typed.

Everything below follows from that. Give the pages content, say which page of a near-identical set is the one that counts and keep crawlers away from the pages that are pure machinery.


## Crawling, indexing and ranking

These three are easily confused, and the confusion leads to measures that achieve the opposite of what was intended. They happen in that order:

Crawling
: Fetching the page. A crawler follows links and asks the server for URLs.

Indexing
: Deciding to keep the page as a possible answer, and storing what it says.

Ranking
: Choosing, among the pages already indexed, which to show for a particular search.

The consequence that matters: **`robots.txt` controls crawling, not indexing.** A URL disallowed there can still appear in results if other pages link to it, because being listed and being read are different things.

Hence the trap. If a page carries `<meta name="robots" content="noindex">` *and* is disallowed in `robots.txt`, the crawler never fetches it, so it never sees the `noindex`, so the page is never dropped. To get a page out of an index you have to let the crawler in. The two mechanisms do not add up, they interfere.


## The page model

Tatin treats each major version as a distinct package, so one package name produces three kinds of page. They are treated quite differently:

| URL | What it is | How it is treated |
|---|---|---|
| `/v1/packages/versions/<name>-<major>` | **The package page**: description, install command, README, list of releases | Listed in the sitemap. This is the page meant to be found |
| `/v1/packages/details/<package-id>` | One release and its configuration | Carries a canonical link to the package page |
| `/v1/packages/major_versions/<name>` | A list of the major version lines | `noindex` |

The rest of this page explains how each of those is arranged.


## robots.txt

`robots.txt` sits at the root of a site and tells crawlers which paths not to fetch. Tatin serves it automatically. It disallows three paths of no use to a searcher:

```
Disallow: /v1/tags
Disallow: /v1/credential-report
Disallow: /v1/version-information
```

It also carries `Crawl-delay: 10`, a request to wait ten seconds between fetches. Google ignores it; Bing, Yandex and Yahoo honour it.

With a sitemap switched on, `robots.txt` points at it.


## sitemap.xml

A sitemap lists the pages you would like a crawler to know about, with the date each was last changed. It makes nothing rank. It makes pages easier to discover, which matters for pages that little else links to.

Set `CONFIG:Sitemap = 1` to serve one. Without it `/sitemap.xml` returns a 404.

Tatin lists the home page, the package list, the deprecated list, the group list, the licences page when there is one and **one page per major version line**, which is to say the package pages. It leaves out the `details` and `major_versions` pages deliberately: there is no sense inviting a crawler to spend its time on pages you have just asked it not to index.

!!! danger "Behind a reverse proxy, set `CONFIG:BaseURL`"

    A sitemap must give absolute URLs, and a server behind a proxy cannot work out what the outside world sees: the proxy normally speaks plain HTTP to Tatin even while serving HTTPS itself, so Tatin would write `http://` into every entry and the whole sitemap would be wrong.

    Either set `CONFIG:BaseURL` to the public URL, `https://tatin.dev` for example, or configure the proxy to send `X-Forwarded-Proto`. See [Reverse proxy](secure-server.md#reverse-proxy).


## One title per page

The `<title>` is the strongest single statement a page makes about itself. It is the heading of the entry in a list of search results, and the text in a browser tab.

Every Tatin page has its own, made of what the page is about followed by the registry's title:

```
aplteam-HttpCommand-5 - Tatin Registry
```


## A description per package

A package page carries the `description` from the package's own configuration as a `<meta name="description">`.

Be clear about what this achieves. **It has no effect on ranking.** It is the paragraph shown underneath the heading of a result, so it bears on whether somebody clicks, not on whether they are offered the page at all. Search engines often write their own snippet instead, particularly when the description is short. That is not a failure: a snippet drawn from the page text is frequently a better answer to the question that was actually asked.


## The README on the package page

This is the substantial one. It carries the package's README, fetched from GitHub. That gives the page prose written by the person who knows the package, describing what it does in the words a searcher would use. It also gives the page something no other page has, which is what makes it worth indexing at all.

A package page covers one major version line, and shows the README of the newest release in that line. It is fetched from that release's own tag rather than from the default branch, so the documentation belongs to the release it describes. [Maintenance](maintenance.md) covers the files this creates and how to force a re-fetch.


## Canonical links

Every release has a `details` page of its own. A package with forty releases therefore has forty pages differing in a version number and a date, and a search engine reasonably treats them as copies of one another. Faced with copies it picks one to keep, or keeps none of them, which is what Google Search Console reports as "Crawled - currently not indexed".

A canonical link is how a site says which page of such a set is the real one:

```html
<link rel="canonical" href="https://tatin.dev/v1/packages/versions/aplteam-HttpCommand-5">
```

Every `details` page carries one pointing at the package page for its major version line. The standing of forty near-identical pages is thereby consolidated onto the single page that has the README on it.

Two things are worth knowing. It hides nothing: `details` pages stay reachable, stay linked and are served exactly as before, to people and crawlers alike. And it is a hint rather than an instruction, so a search engine may decide otherwise, and occasionally does.


## noindex on the major-versions pages

`/v1/packages/major_versions/<name>` lists the major version lines of a package. It is a list of links with no content of its own and no prospect of any, so it carries:

```html
<meta name="robots" content="noindex">
```

`noindex` on its own still permits the links to be followed, `follow` being the default, so a crawler passes through it to the package pages and merely stops trying to index an index.

Note that this page is *not* disallowed in `robots.txt`, and that is deliberate: see the trap in [Crawling, indexing and ranking](#crawling-indexing-and-ranking).


## Telling search engines at once: IndexNow

Everything above is passive. A sitemap says "here are my pages, come when you like", and then you wait. Publish a package at noon and its page may not be looked at for days.

IndexNow turns that round: the site announces a URL that has changed. Bing and Yandex run it, and Seznam, Naver and Yep take part. **Google does not**, so this makes discovery quicker on some search engines rather than on all of them. It is worth rather more than that sounds, because Bing's index is what DuckDuckGo and Ecosia serve from and what several AI assistants search.

Two INI entries switch it on:

`CONFIG:IndexNowKey`
: Any hex string of 8 to 128 characters. Empty means off.

`CONFIG:BaseURL`
: Required as well. IndexNow wants absolute URLs, and the announcement is made in the background where there is no request to work the public host out from.

Nothing else needs setting up. The protocol proves that whoever announces a URL controls the site by asking for a file named after the key, holding the key; Tatin serves that from the INI entry, so there is no file to create and the two can never disagree. With a key of `a1b2c3`, `https://your.registry/a1b2c3.txt` returns `a1b2c3`.

What is announced, and when: after something has been published, the package page of every major version line published since the last announcement, plus the home page and the package list, which both show what is new. The first run after switching this on announces nothing - it notes the time and stops - so that turning it on does not fire off one URL per package in the Registry.


## Keeping a registry out

A registry on the internet that is not meant to be found, a test or staging server or one serving a single company, should say so rather than trust that nobody links to it.

`CONFIG:NoIndexing = 1`
: Puts `<meta name="robots" content="noindex">` on every HTML page.

`CONFIG:X_Robots_Tag = 'noindex'`
: Does the same for what is not HTML. A `<meta>` tag can only live in an HTML page, so ZIPs and other files need the instruction in the HTTP header instead; this sends `X-Robots-Tag: noindex` with them.

A server that should disappear entirely needs both. Neither prevents access: they ask search engines not to list what they find.



## Settings

| INI entry | Default | What it does |
|---|---|---|
| `CONFIG:Sitemap` | `0` | 1 serves `/sitemap.xml` and points `robots.txt` at it |
| `CONFIG:BaseURL` | `''` | The URL the outside world uses. Needed for a correct sitemap behind a proxy |
| `CONFIG:NoIndexing` | `0` | 1 puts `noindex` on every HTML page |
| `CONFIG:X_Robots_Tag` | `''` | Set to `noindex` to keep non-HTML resources out as well |
| `CONFIG:IndexNowKey` | `''` | A key switches IndexNow on; needs `CONFIG:BaseURL` as well |

