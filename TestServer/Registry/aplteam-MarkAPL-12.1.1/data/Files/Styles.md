[parm]:width             = 1000
[parm]:lang              = en
[parm]:leanpubExtensions = 1
[parm]:title             = 'Styles'
[parm]:toc               = 2 3 4 5 6
[parm]:numberHeaders     = 6
[parm]:saveHTML          = 1





# MarkAPL Styles

## Overview

`MarkAPL` comes with several sets of style sheets:

* Dark_screen.css and Dark_print.css (default since 12.0)
* MarkAPL_screen.css and MarkAPL_print.css (default until 12.0)
* BlackOnWhite_screen.css and BlackOnWhite_print.css

All sets include style definitions required by the LeanPub extensions.

The screen style sheets have roughly 1000 lines, while the print style sheets contain have roughly 500 lines. The difference arises mainly from the inclusion of the "Normalize" project[^normalyze] in the screen definition, ensuring a consistent appearance across browsers.

When embedding style definitions into the HTML, comments and white spaces are removed, resulting in two lines for each style sheet. Combined, both style definitions occupy less than 12KB.


## Replace the MarkAPL style sheets

You have two options for using your own style sheets:

* Copy one of the provided style sheet sets and make necessary changes.
* Create a new style sheet, add your changes and additions, then add it to either `screenCSS` or `printCSS`: these parameters might point to a single file, but they can also  point to multiple, comma-separated files. Ensure your style sheet is the last one so that in wins in case of a conflict.

For a completely different layout, choose the first option. For amendments or additions, use the second option.


## Suggestions for developing a new style sheet

### General suggestions

While you can use a media query for all media types in one CSS file, separate files for "print" and "screen" are recommended for easier debugging. 

To test changes, open your HTML document with the required parameters:

I> MarkAPL's own reference (MarkAPL.html) is a good choice for this because it takes advantage of all features of MarkAPL, therefore missing or ill-defined styles will quickly become apparent.
I>
I> Just ensure that you save it with linked CSS files rather than embedding the CSS.
I>
I> However, linking style sheets means that some embedded parameters would be ignored. An example is `width`.

Set the following parameters in the first lines of the HTML document you want to use for the development:

~~~
[parm]:linkToCSS    = 1
[parm]:screenCSS    = '/pathToMyStyleSheetFolder/MySyles_screen.css'
[parm]:printCSS     = '/pathToMyStyleSheetFolder/MySyles_print.css'
~~~

Note that `cssURL` is not defined and therefor empty because a) that's the default and b) both `screenCSS` as well as `printCSS` carry a full path.

You can achieve the same _with_ `cssURL`:
~~~
[parm]:linkToCSS    = 1
[parm]:cssURL       = 'file:///pathToMyStyleSheetFolder'
[parm]:screenCSS    = 'MySyles_screen.css'
[parm]:printCSS     = 'MySyles_print.css'
~~~

Don't forget that all `[parm]` lines must be defined at the top of the document in order to be recognized as a parameter definition lines starting with an APL lamp symbol (`⍝`) do not count).

When you now make changes to the CSS file then --- after pressing Ctrl+F5 --- the changes are reflected in the "Preview" area of Meddy, Microsoft's WebBrowser control, which is used for the preview, but that comes with a number of limitations, most importantly it does not offer access to the developer tools all modern browsers are offering.

1. Select "View HTML in default browser" from Meddy's "Edit" menu (or press F10).
1. Fire up your favourite CSS editor and start changing the CSS file. 
1. Force the browser to reflect your changes by pressing F5 (Refresh) when appropriate.

All modern browsers will give you access to their development tools, usually invoked via F12 or with a right-click on a particular area on the screen and then selecting "Inspect" or something similar. That gives you invaluable support when something does not work as you expect it to.

W> Note that this will only work when the HTML is saved on disk with the Markdown

### "Print" style sheets

In case something is not going to your liking the development tools all modern browsers come with are of great help, but when it comes to printing they are pretty useless: even Chrome, the only browser which offers a "Print Preview", does not allow you to invoke them on the print preview, at least not in a useful way.

Having two different files for the CSS allows you to use the print style sheet temporarily for display purposes (screen) as shown here:

~~~
[parm]:linkToCSS
leanpub-start-insert
[parm]:screenCSS='/pathToMyStyleSheetFolder/print.css'
leanpub-end-insert
[parm]:printCSS='/pathToMyStyleSheetFolder/print.css'
~~~

Now you can check the impact of your print style sheet, and you can also take advantage of the browser's development tools.


## Helpers

There is a function `CreateDoc` available that is designed to help in the process of changing/debugging/creating a style sheet.

It requires a right argument for quick access, but in case this is empty the user will be interrogated regarding which document to create and which style sheet set to use.

It links the CSS style sheet to the HTML file, making debugging way easier.

## Styling

There are a few `<div>`s injected into the HTML and CSS classes assigned to HTML tags which are not really necessary but make styling their contents much easier.

Some HTML tags get class names or IDs assigned. Others can be addressed via the CSS child selector.

There are also some CSS classes available that can be used for common tasks by simply assigning them as special attributes in your Markdown.

### `<div>`s injected into the HTML by MarkAPL

Most `<div>`s that are injected into the HTML by `MarkAPL` get either a class name or an ID name assigned.

#### Footnotes

| ID names                |
|-------------------------|
|div#external_link_report |   
|div#footnotes_div        |

* All external (=non-bookmark) links in a document are printed at the end of the document --- but above any footnotes --- as a list under the header "Link report". They are embraced by a `<div>` with the class `external_link_report`.

* Footnotes go to the very end of a document. They are embraced by a `<div>` with the class `footnotes_div`.

#### Link report

If `reportLinks` is 1, all links are listed at the very end of the document (but before any footnotes) with their URLs and link text. These are embraced by a single `<div>` with the ID "external_link_collection". 

`MarkAPL`'s own style sheets define styles for the contents of those `<div>`s, but you might have different ideas.

### Class names and IDs assigned by `MarkAPL`

There are a few HTML elements that get a class name assigned by `MarkAPL` in order to make styling them easy:

* All footnote links in the document get the class "footnote_link" assigned . 
  These are the links pointing to the list of footnotes at the very end of the document.
* All footnote anchors get the class "footnote_anchor" assigned. 
  These anchors are positioned at the very end of the document.
* All anchors automatically injected around headers get the class name "autoheader_anchor" assigned.
* All bookmark links created by the user via the `[header](#)` syntax get a 
  class name "bookmark_link" assigned.
* All external links get the class name "external_link" assigned.
* All "mailto" links get the class name "mailto_link" assigned.
* If `toc` is 1 then `MarkAPL` injects a table-of-contents into the HTML. The toc is embraced by a `<nav>` tag which, in order to make it styleable, and gets the id "main_nav" assigned.

Naturally you must not use these class names for different purposes when defining your own CSS.


### CSS styles available for assigning as special attributes

|Class name          |Domain|Meaning                                |
|--------------------|------|---------------------------------------|
|`.center`           |both  |Centers text                           |
|`.left`             |both  |Aligns text to the left                |
|`.right`            |both  |Aligns text to the right               |
|`.hide`             |screen|Prevent the element from showing.      |
|`.no_print`         |print |Prevent the element from printing.     |
|`.avoid_page_break` |print |Avoid page breaks if possible          |
|`.page_break_before`|print |Enforce a page break before current tag|
|`.red`              |both  |Sets "colour" to "red"                 |

The "Domain" column explains in which style sheet a class is defined.

I> Why do tables not avoid page breaks by default? Because it could well be that as a result very little would go onto the page where the table would start without avoiding page breaks, something that would be particularly ridiculous in case the table needs to break anyway because of its size.
I>
I> It's therefore better to assign the class `avoid_page_break` when appropriate. That's far from perfect but then CSS is not for print.


### Special cases

There are a number of special cases which usually means that `<div>`s are added for easier styling.

#### Collapsibles

* Any collapsible is embraced by a `<div>` with the class "collapsible"
* Anything after the `<summary>` tag is also embraced by a `<div>` with the class "collapsible-content"

Example:

```
<div class="collapsible">
    <details>
        <summary>
            <p>...</p>
        </summary>
        <div class="collapsible-content">
            <hr>
            <p>...</p>
        </div>
    </details>
</div>
```


#### Accordions

Accordions are collapsibles defined in succession.

Examples:

```
<div class="accordion">
    <div>
        <details>
            <summary>
                <p>...</p>
            </summary>
            <div class="accordion-content">
                <p>...</p>
            </div>
        </details>
    </div>
    <div>
        <details>
            <summary>
                <p>...</p>
            </summary>
            <div class="accordion-content">
                <p>...</p>
            </div>
        </details>
    </div>
</div>
```

### Examples

Let's assume that there is a table in your Markdown that should not show on screen but rather be 
printed without a page break, and the table should be centered; this can be easily achieved:

~~~
| Language | Comment |{.hide .avoid_page_break .center}
|----------|------------------|
| APL      | Excellent choice |
| COBOL    | Oh dear          |
~~~

This would do the trick. 

| Language | Comment          |{.avoid_page_break .center}
|----------|------------------|
| APL      | Excellent choice |
| COBOL    | Oh dear          |


| Language | Comment          |{.avoid_page_break .center}
|----------|:----------------:|
| APL      | Excellent choice |
| COBOL    | Oh dear          |

You cannot see the table on screen but when you select "View HTML in default browser" from Meddy's "Edit" menu (or just press F10) in order to view this page and then do a print preview (at the time of writing this is a Chrome-only feature) you will actually see this table making an appearance.

Note that assigning `.center` to the table is inherited by the table cells, there cell content is centered as well. If you do not want this you need to specify it per column. Watch out for the `:` in the row after the column headers:

~~~
| Language | Comment |{.no_display .avoid_page_break .center}
|:----------|:------------------|
| APL      | Excellent choice |
| COBOL    | Oh dear          |
~~~


## Assigned classes

There are classes assigned automatically to some tags. This is caused by the fact that there is no selector available to catch them.

### `<p>` in the first `<dd>` of a `<dll>`

There is no selector available at the time of writing (2018-02) that allows one to style the `<p>` in the first `<dd>` child of a `<dl>` (definition list).

For that reason the class "first_dd" is assigned.

Example:

~~~
<dl>
    <td>Foo</dt>
    <dd class="first_dd"><p>This</p></dd>
    <dd><p>This</p></dd>
</dl>
~~~

### Collapsibles

Collapsibles have a `<summary>` and a `<details>` tags.

Both are embraced by a `<div class="collapsible">` tag.

The `<details>` tag starts with an `<hr>` (inserted by `MarkAPL`) followed by whatever the user specified as details. All this (including the `<hr>`) is embraced by a `<div class="collapsible-content">`.


### Accordions

Accordions are a collection of at least two Collapsibles.

The Collapsibles are embraced by a ` <div class="accordion">` tag.

Every collapsible inside the accordion is embraced by a `<div>` without an assigned class. 

The `<details>` tags start with an `<hr>` (inserted by `MarkAPL`) followed by whatever the user specified as details. All this (including the `<hr>`) is embraced by a `<div class="accordion-content">`.


[^normalyze]: The "Normalize" project<br><https://necolas.github.io/normalize.css/>







