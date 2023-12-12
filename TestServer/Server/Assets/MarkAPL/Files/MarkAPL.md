[parm]:toc             = 2 3 4 5 6
[parm]:numberHeaders   = 1 2 3 4 5 6
[parm]:bookmarkLink    = 6
[parm]:title           = 'MarkAPL Reference'
[parm]:width           = 1000
[parm]:reportLinks     = 1
[parm]:smoothScrolling = 1
[parm]:saveHTML        = 1


# MarkAPL Reference

## Overview

This document provides a user-centric perspective on `MarkAPL`. If you're approaching it from a programmer's standpoint, you should check out the "MarkAPL for Programmers" guide.


### This document is too long for me!

Okay, got it. There is also a [cheat sheet][cheatsheet] available. 


### What is Markdown?

Markdown, more readable and maintainable than HTML, can be transformed into HTML. 

Because of its advantages over HTML and because the rules are easy to learn, Markdown became ubiquitous: many big names are using it now. Examples are Stack Overflow, Git, SourceForge and Trello. Wiki engines have also started to adopt the concept.


### Is there a Markdown standard?

Yes and no. The original implementation by John Gruber had no specification at all, just a Perl script and test cases. Unfortunately, it was also quite buggy. Gruber has not put work into developing his brainchild. Some consider the original Markdown therefore abandonware[^abandon].

Because of the bugs, some ambiguities and the lack of much-needed features, several flavours of an enhanced Markdown evolved, the most important ones being [Git-flavoured Markdown][git], [Markdown Extra][markdown_extra] and [PanDoc's Markdown][pandoc].


### What is MarkAPL?

`MarkAPL` is an APL program that converts (extended) Markdown into valid HTML5.


### MarkAPL, Markdown, Markdown Extra and CommonMark

 
CommonMark [^commonmark] is an attempt to establish a standard for Markdown.

`MarkAPL` aims to implement the original Markdown specification with few exceptions. It also aims to implement most --- but not all --- of the Markdown Extra enhancements. 

Finally it also aims to follow the CommonMark specification as far as it seems reasonable. That means that `MarkAPL` does not seek to restrict itself to what CommonMark defines.

Additionally, `MarkAPL` offers enhancements tailored for APLers.

For example, lines that start with an APL lamp symbol (`⍝`) are considered comment lines (except when they are part of a code block); they won't appear in the output.

For a complete list see the next chapter.


### Preconditions 

`MarkAPL` needs Dyalog APL Unicode version 18.0 or better.

Compatibility, features, bugs
----------------------------------


### Standard compliance


#### Intentional differences

* Code blocks are identified solely by fencing. Any lines indented
  by 4 characters **do not** define a code block in `MarkAPL`.
  
* In front of the fencing characters there might be zero or up to three space characters. However, when a code block is part of a list item then those space characters have special meaning, and there might also be more than just three of them.

* HTML blocks that must end with a closing tag should **not have** anything after 
  the closing `>` on that very line: it would be ignored.

* Note that `\` is considered an escape character **only** when there is 
  something to escape to the right of the backslash character, otherwise the `\` will survive untouched. 

  However, escaping is a more complex issue than you might expect; see [Escaping](#) for details

* For defining attributes a pair of double quotes must be used. Single 
  quotes have no effect. (This contradicts the original Markdown documentation but due to a bug it did not work with the original Markdown implementation either)

* `MarkAPL` does not have the concept of "loose list items". In 
  CommonMark, the contents of any list item that is followed by a space line is called a "loose" list item and wrapped into an additional `<p>` tag. 

  This is of little value and complicates matters enormously. Therefore `MarkAPL` simply ignores a single empty line between list items. 

  You still get a `<p>` tag around something that actually belongs to the list item but only **after** the initial text. This is called a sub-paragraph. See [Lists](#) for details.

* According to the Markdown specification a list following a paragraph must be 
  separated from the paragraph by a blank line. The reason for this rule is probably that in  rare circumstances one might start a list accidentally.
  
  Experience has shown however that users are way more likely to wonder why a list they intended to start straight after the end of a paragraph doesn't. For that reason `MarkAPL` does **not** require a blank line between the end of a paragraph and the first list item of a list.

* According to the original Markdown standard two spaces at the end of a line 
  are converted into a line break by replacing the two spaces by `<br>`. This was actually implemented in version 1.0 of `MarkAPL`. 

  However, more than once a bug was reported regarding unintentional line breaks which were accidentally caused by adding two spaces at the end of a paragraph or a list item. Therefore with version 1.3 this ill-designed feature was removed from `MarkAPL`.

  Note that there are other --- and better --- ways to achieve the same goal: see [Line breaks](#) for details.

* [Special attributes](#) are partly implemented with a syntax that differs slightly from Markdown Extra, and with good reasons.

* ~~A colon (`:`) in a [footnote](#Footnotes) is replaced by `:<br>`. This can be switched off by setting [markdownStrict](#) to 1.~~

  This was a bad idea and got removed from `MarkAPL` with version 6.0.0. Simply use `<br>` if you want/need a line break.

* An APLer is used to double any quotes inside a text vector. That does _not_ work for backticks! If you need to show backticks in inline code see [Inline code (verbatim)](#) for details.

* Until version 12.0 HTML tags within paragraphs etc. survived untouched. Since version 12.0 `MarkAPL` is fully compliant with the "standard" in this respect, meaning that in order to write about HTML you must put the HTML code between backticks (making it inline code) or mark it as a code block with fencing.

#### Not implemented

* Markdown inline markup inside an HTML block is ignored. Most of the time you can get around this by making the opening and closing HTML tag independent blocks; that would allow everything in between to be marked up like any other piece of Markdown.

* All types of HTML blocks but one can, according to the CommonMark 
  specification, interrupt a paragraph. There are no plans to implement this.

* According to the CommonMark specification a tag like `<div>` can have a line 
  break in between and will still be recognized as a tag. Not only seems this to have very little value, it decreases readability. Therefore this is not implemented in `MarkAPL`.

* A list item can contain paragraphs, code blocks and sub-lists but nothing else.
  
* A definition list (also called description list) can only contain keys --- `<dt>` --- and definitions (or descriptions) --- `<dd>` --- but nothing else. In particular it cannot contain any block level elements like lists and code blocks.


### Enhancements

* By default for every header an anchor is created automatically. See [Headers 
  and bookmarks](#) for details. In short every header gets an anchor with both ID and HREF set. 
  That allows the automated generation of a table of contents (TOC) as well as making any header the first 
  line by simply clicking at it.

* Bookmark links have a special simplified syntax; see [Internal links (
  bookmarks)](#) for details.

* `MarkAPL` can optionally insert a table of contents generated from the headers 
  into a document. See [toc (table of contents)](#) for details.

* With `<<SubTOC>>` one can insert sub-tables of contents anywhere in the 
  document. See [Sub topics](#) for details.

* Headers can be numbered. By setting `numberHeaders` (which defaults to 0) to 
  1 one can force `MarkAPL` to number all or some headers. See [numberHeaders](#) for details. 

  This was implemented because numbering with CSS does not really work at the time of writing (2017).

* Calling APL functions (APL programmers only).

  Something like `⍎⍎FnsName⍎⍎` calls an APL function `FnsName` which gets the `ns` namespace as right argument. See the document "MarkAPL for Programmers" for details.

* Typographical sugar. This can be switched off by setting [`syntaxSugar`](#) to 0. For details see [Syntax sugar](#).

  | Input | Result | Remark
  |------|---------|------
  | `(c)`  |  (c) | Copyright
  | `(tm)`  |  (tm) | Trademark
  | `...`  |  ... | Ellipsis
  | `<<`  |  << | Guillemets 
  | `>>`  |  >> | Guillemets 
  | `--`  |  -- | n-dash
  | `---`  |  --- | m-dash
  | `==>`  |  ==> |
  | `<==`  |  <== |
  | `<==>`  |  <==> |
  | `""`  |  "" | Depends on the "lang" parameter

* Assigning ID names, class names and attributes to certain elements as in:\
  `{#foo .my_class .another_class style="display:none;" target="_blank"}`\
  is implemented for most though not all elements. This idea was taken from Markdown Extra but with a slightly different syntax, and with good reason.
  
  See [Special attributes](#) for details.

* [Abbreviations](#).

* A `<br>` tag can be inserted into paragraphs, lists and table cells with `<<br>>`.

  However, this is now deprecated because since version 12.0 there is no need for this anymore, you can now simply put `<br>` into your Markdown straight away.

* Comments: any line that starts with a `⍝` (the APL symbol used to indicate a 
  comment) and is **not** situated within a code block will be ignored, no matter what else is found on that line.

  ~~~
  ⍝ This demonstrates a comment. Useful to leave stuff in a Markdown file 
  ⍝ but prevent it from making it into any resulting HTML document.
  ~~~

* Defining data: any line that starts with `[data]:` defines a key-value pair 
  of data. See [Data](#) for details. This has all sorts of applications; for example, this can be used to specify meta tags (name, content).
  
* If your are using `MarkAPL` as an APL programmer: there are helpers available that convert APL arrays into Markdown. There is a document available discussing those: "MarkAPL for Programmers".

* `MarkAPL` parameters can be embedded into a document - see [embedded 
  parameters](#Embedding parameters with `[parm]:`) for details.

* Using `*` and `**` inside words. While `_` and  `__` are ignored when part of a word, you can use `*` and `**` inside a word. This was introduced in version 7.0.0

  Examples: `As*ter*isks` leads to As*ter*isks and `Un_der_scores` to Un_der_scores while `As**ter**isks` leads to As**ter**isks and `Un__der__scores` to Un__der__scores.

* Check boxes

  `[ ] ` and `[x] ` and `[X]` are converted to check boxes.

   See [Check boxes](#) for details.

* Collapsibles and accordions

  * Any two lines that start with `!> ` and `=> ` respectively define a collapsible. These are converted into the HTML tags `<details>` and `<summary>`. 

  * Two ore more collapsibles in succession become an _accordion_. An accordion is styled so that the collapsibles are styled as if they were one object.

  For details refer to [Collapsibles and accordions](# "Collapsibles and accordions").

* A LeanPub encoding directive like `{:: encoding="utf-8" /}` needs to go into the first line of any Markdown document. `MarkAPL` ignores such a line, meaning that any `[parms]:` definitions (see [embedded parameters](#Embedding parameters with `[parm]:`)) are unaffected by this althouh they are expected to start at the top of any Markdown document as well.

  Note that this directive has nothing to do with the so-called LeanPub extensions which are discussed next. A encoding directive is useful only when you want to publish on the [LeanPub publishing platform](https://https://leanpub.com/) and need to specify the encoding explicitly.
  
* LeanPub extensions
  
  Since version 3.6 `MarkAPL` recognizes and processes the so-called LeanPub extension which are discussed in a separate document. These extensions allow the author to imphasize particular lines in code blocks and inject asides as well as messages: errors, warnings, tips and more.
  
  The set of CSS style sheets `MarkAPL` is coming with rules for these extensions, but this can of course be changed to your liking by using a tailor-made style sheet. 

  LeanPub extensions can be useful in a document whether you want to publish on the LeanPub platform or not.

  Note that there is a separate document available that discusses style sheets in detail.


### Known bugs

See <https://github.com/aplteam/MarkAPL/issues>


## Reference{.page_break_before}

<<SubTOC-1>>

### Markup

<<SubTOC-1>>

#### Overview{#markup-overview}
 
The following table categorizes the different markups into "Original", "Extra", "Pandoc" and "MarkAPL". A single line might carry more than one X in case it got enhanced. 

| Name                      | Original  | Extra   | Pandoc    | MarkAPL |{.page_break_before}
|:--------------------------|:---------:|:-------:|:---------:|:-------:|
| Abbreviations             |           |         |    X      |    X    |
| Automated links           |   X       |   X     |    X      |    X    |
| Blockquotes               |   X       |   X     |    X      |    X    |
| Calling APL functions     |           |         |           |    X    |
| Code blocks (indented)    |   X       |   X     |    X      |  Never! |
| Code blocks (fenced)      |           |   X     |    X      |    X    |
| Definition lists          |   X       |   X     |    X      |    X    |
| Footnotes                 |   X       |   X     |    X      |    X    |
| Headers                   |   X       |   X     |    X      |    X    |
| HTML blocks               |   X       |   X     |    X      |    X    |
| HR (horizontal rule)      |   X       |   X     |    X      |    X    |
| Images                    |   X       |   X     |    X      |    X    |
| Inline markup             |   X       |   X     |    X      |    X    |
| Line breaks (two spaces)  |   X       |   X     |    X      |  Never! |
| Line breaks    (`\`)      |           |         |    X      |    X    |
| Links                     |   X       |   X     |    X      |    X    |
| Link references           |   X       |   X     |    X      |    X    |
| Lists                     |   X       |   X     |    X      |    X    |
| Loose/tight lists         |   X       |   X     |    X      |         |
| Markdown inside HTML      |           |   X     |    X      |         |
| Paragraphs                |   X       |   X     |    X      |    X    |
| Tables                    |   X       |   X     |    X      |    X    |
| Table footers             |           |         |           |    X    |
| Table of contents (TOC)   |           |         |    X      |    X    |
| Sub TOCs                  |           |         |           |    X    |
| Smart typography          |           |         |    X      |    X    |
| Special attributes        |           |   X     |    X      |    X    |
| LeanPub extensions        |           |         |           |    X    |
| Check boxes               |           |         |           |    X    |
| Collapsibles              |           |         |           |    X    |
| Accordions                |           |         |           |    X    |

Notes: 

* Both "Code blocks (indented)" and "Line breaks (two spaces)" don't carry an X in the "MarkAPL" column because they are deliberately not implemented in `MarkAPL`.

* The implementation of [Definition lists](#) comes with some restrictions; see there. 

* Special attributes got introduced by Extra Markdown, and they are partly supported in Pandoc but they are not part of the CommonMark specification. However, they are recognized by `MarkAPL` with a syntax that is slightly different from other implementations. This makes it much less probable that the user needs to escape any `{` and `}` characters at the cost of compatability.

* Regarding the LeanPub extension see the separate document "LeanPubExtensions.html".

#### Check boxes

Note that for readability the examples here show the `⎵` character to represent a space character.

You may add check boxes with either `[⎵]⎵` (the space between the two brackets is required to make it an un-ticked check box) or `[x]⎵` or `[X]⎵`.

A line must start with either of them but might also have up to three leading spaces.

Apart from the check box such a line is an ordinary  paragraph.

Examples --- this:

```
[X] APL
[x] K
[⎵] Cobol
⎵[⎵] Rust `⍝ Up to three...`
⎵⎵[⎵] F# `⍝ ...leading spaces...`
⎵⎵⎵[⎵] Go `⍝ ...don't hurt...`
⎵⎵⎵⎵[⎵] Pascal   `... but four or more do`
```

leads to this:


[X] APL
[x] K
[ ] Cobol   
[ ] Rust `⍝ Up to three...`
  [ ] F# `⍝ ...leading spaces...`
   [ ] Go `⍝ ...don't hurt...`
    [ ] Pascal   `... but four or more do`
    
Note that `MarkAPL` adds `<div>`s in order to make styling easier. Refer to the document `Styles.html` for details.


#### Collapsibles and accordions

Two lines marked up with `!> ` and `=> ` are converted into a collapsible:

```
!> What is the most productive programming language?
=> APL!
```

This leads to this:

!> What is the most productive programming language?
=> APL!

A collapsible must start with a single line that starts with `!>⎵` and at least one line that starts with `=>⎵`, but may have more such lines. The `⎵` character represents a space here.

In fact almost anything might go into those lines: lists, code blocks, definition lists, headers, horizontal rulers but no collapsibles. The summary on the other hand only accepts headers and inline markup.

Accordions are just two or more collapsibles in succession. Those are styled slightly differently, making them appear as a single object.

For example, this:

```
!> What can go into a Collapsible?
=> For a start, ordinary paragraphs like this one.
!> What else can go into a Collapsible?
=> Pretty much everything: lists, citations, headers, code blocks...
=> 
=> Collapsibles can hold everything that's available in Markdown.
=> 
=> #### Examples:
=> 
=> ~~~
=> {(+⌿⍵}÷≢⍵}
=> ~~~
=> 
=> * List item 1
=> * List item 2
=> 
=> > Collapsibles are great.
=> 
=> Of cource inline markup is available, too: **bold**, _italic_, `code`, ~~deprecated~~, whatever.
```

leads to this:

!> What can go into a Collapsible?
=> For a start, ordinary paragraphs like this one.
!> What else can go into a Collapsible?
=> Pretty much everything: lists, citations, headers, code blocks...
=> 
=> Collapsibles can hold everything that's available in Markdown.
=> 
=> #### Examples:
=> 
=> ~~~
=> {(+⌿⍵}÷≢⍵}
=> ~~~
=> 
=> * List item 1
=> * List item 2
=> 
=> > Collapsibles are great.
=> 
=> Of cource inline markup is available, too: **bold**, _italic_, `code`, ~~deprecated~~, whatever.

For printing purposes all collapsibles are expanded.

#### Comments

Any line that starts with an APL lamp symbol (`⍝`) is ignored. That means that the line won't make it into the resulting HTML at all.

This is true for any line that is not part of a code block, including lines that are part of a paragraph. 

Example:

~~~
Start of a para that contains
⍝ Ignored
a comment line.
~~~

This is the resulting HTML:

     `<p>Start of a para that contains a comment line.</p>`


#### Abbreviations

Abbreviations can be defined anywhere in the document. This is the syntax:

~~~
*[HTML] Hyper Text Markup Language
~~~

All occurrences of "HTML" within the Markdown document --- except those marked as code --- are then marked up like this:

`<abbr title="Hyper Text Markup Language">HTML</abbr>`

Therefore this:

~~~
*[Abbreviations]: Text is marked up with the `<abbr>` tag
~~~

should show the string "Text is marked up with the `<abbr>` tag" when you hover over the word "Abbreviations".

Notes:

* You may have more than just one word between the `[` and the `]` bracket. 
  However, any leading and trailing spaces will be removed.
* Any leading and trailing spaces in the title will be removed.
* What is within the square brackets is case sensitive.
* You may use any Unicode characters belonging to the Unicode "letter" 
  category plus `+-_= /&` (plus, minus, underscore, equal, space, slash and ampersand).


#### Blockquotes 

Markdown --- and therefore `MarkAPL` --- uses the `>` character for block quoting. If you’re familiar with quoting parts of text in an email message then you know how to create a block quote in Markdown. It looks best if you hard wrap the text and put a `>` before every line:

~~~
> This is a blockquote with one paragraph. Lorem ipsum dolor sit amet,
> consec tetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
> Vestibulum enim wisi, _viverra_ nec, fringilla **in** risus.
> 
> Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` semper ipsum sit amet velit. Suspendisse
> id sem consectetuer libero luctus adipiscing.
> 
> > Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` semper ipsum sit amet velit. Suspendisse
> id sem consectetuer libero luctus adipiscing.
~~~

Note that the third --- and last --- paragraph has two leading `>`, making it a blockquote within a blockquote.

This is the result:

> This is a blockquote with one paragraph. Lorem ipsum dolor sit amet,
> consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
> Vestibulum enim wisi, viverra nec, fringilla **in** risus.
> 
> Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` semper ipsum sit amet velit. Suspendisse
> id sem consectetuer libero luctus adipiscing.
> 
> > Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` semper ipsum sit amet velit. Suspendisse
> id sem consectetuer libero luctus adipiscing.

However, `MarkAPL` allows you to be lazy and only put the > before the first line of a paragraph:

~~~
> This is a **lazy** blockquote with two paragraphs. Lorem ipsum dolor sit amet,
consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.

> Second para.
~~~

This is the result:

> This is a **lazy** blockquote with two paragraphs. Lorem ipsum dolor sit amet,
consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
Vestibulum enim wisi, viverra nec, fringilla **in**.

> Second para.

Note that blockquotes are not restricted in any respect: they may contain anything like paragraphs, tables, lists, headers, definition lists and blockquotes. However, headers are not numbered and do not have anchors attached, and any `<<SubTOC>>` directives within a blockquote are ignored.


#### Code blocks

<<SubTOC>>

According to the original Markdown specification any lines indented by 4 characters were considered a code block. Apart from not being particularly readable this caused problems with nested lists and code blocks within such lists. Therefore later a convention called "fencing" was introduced. 

`MarkAPL` goes a step further: to avoid confusion indenting is **not** supported for marking up code blocks.

Code blocks can be marked up in two different ways, fencing or by injecting a `<pre>` as well as a `</pre>` tag. We discuss one after the other.


##### Fencing

You can use the "Git" style with three --- or more --- backticks as shown here:

<pre>
```
This is a block ...
of code!
```
</pre>

Alternatively you can use the Markdown Extra specification with three --- or more --- tildes:

<pre>
~~~
This is a another block ...
of code!
~~~
</pre> 

You don't have to have empty lines around fenced code blocks but you might find that such lines help to improve readability.

Notes:

* The fencing lines may have up to three leading space characters. These will just be ignored except that the number of spaces specified in the opening line defines the number of spaces that are actually removed from the code itself, though only if 
  those columns carry nothing but space characters.

  This rule does **not** apply when a code block is part of a list since the number of spaces is then 
  used to determine the level of nesting.
* After the initiating fencing characters one may specify an info string. This is usually used for syntax highlighting, though it may have other applications as well. An example for APL:

  ```
  ~~~language-apl
  +⌿
  ~~~
  ```

  This results in this HTML code:

  ~~~
  <pre class="language-apl"><code>+⌿</code></pre>
  ~~~
* The closing fence must carry at least as many fencing characters as the opening line did.
* Code blocks may also (after any info string) have [Special attributes](#); see there for details.
* You cannot mix ```` ``` ```` and `~~~`: when a code block is opened with three backticks then it can be closed only by three backticks.

  But that also means that you can put three tilde characters on display within a code block that was opened with three backticks, and vice versa.
* By default all code blocks come with a "Copy-to-clipboard" button. If you don't want this you can switch this off by setting `coptToClipboardBtn` to 0. However, setting this parameter always effects **all** code blocks in a document.


##### Code: the `<pre>` tag

You can also mark a block of text with the HTML `<pre>` tag. This is particularly useful in order to show the fencing characters as part of the code.

If you need to assign an ID or a class or any styling stuff to the `<pre>` tag of a code block you can do this

~~~
<pre id="foo" class="my">
...
</pre>
~~~

There is no other way since assigning a [special attribute](#Special-attributes) to a fenced block as shown here:

<pre>
~~~{#foo}
...
~~~
</pre>

This assigns the attributes _not_ to the `<pre>` tag but to the inner `<code>` tag:

~~~
<pre><code id="foo">
...
</code></pre>
~~~

Notes:

* `MarkAPL` requires a `<code>` tag within any `<pre>` tag. (Even if you do 
  not specify the `<code>` tag yourself in an HTML `<pre>` block `MarkAPL` will insert it for you anyway.)
* `MarkAPL` will remove any line breaks between `<pre><code>` and the 
  first line of your code block. If you need an initial (empty) line or an empty line as the last one you must add it as shown here:

~~~
<pre><code>

Second line
Last but one line

</code></pre>
~~~


#### Definition lists (description lists)

Definition lists are made of terms and definitions of these terms, much like a dictionary. If there is a blank line between the term and the definition then the definition is enclosed between a `<p>` tag. However, if there are sub-definitions (see below) then all definitions are enclosed by `<p>` tags.

A definition can span more than one paragraph, but they must be indented by as many spaces as there are in front of the ":" (maximum of three) plus two for the colon itself and the following space to be recognized as being a definition. Such sub-definitions are always enclosed between `<p>` tags.

Definition lists break at two consecutive empty lines or anything that is neither a term and not indented according to the rules that define a definition. Having the two empty lines in place to break a definition list is recommended because it's faster and more readable.

Between the left margin and the colon there may be up to 3 spaces. After the colon there must be exactly one space. 

Simple example:

~~~
Term
: The definition
~~~

This is the result:

Term
: The definition


The resulting HTML:
~~~
<dl>
<dt>Term</dt>
<dd>The definition</dd>
</dl>
~~~

There are no `<p>` tags here because there is no blank line between the term and its definition.

A more complex example:
~~~
Term 1

   : The definition

   : More information
     that spans over
     three lines
     but only in the Markdown

Term 2
    : Another definition

    : Additional information
~~~

This is the result:

Term 1

   : The definition

   : More information
     that spans over
     three lines
     but only in the Markdown

Term 2
   : Another definition

   : Additional information


The resulting HTML:
~~~
<dl>
<dt>Term 1</dt>
<dd><p>The definition</p></dd>
<dd><p>More information that spans over three lines but only in the Markdown</p></dd>
<dt>Term 2</dt>
<dd>Another definition</dd>
<dd><p>Additional information</p></dd>
</dl>
~~~

Restrictions:
* A term must be exactly one line.
* A definition may not contain anything but paragraphs.


#### Footnotes

Footnotes can be referenced by something like `[^1]` or `[^foo]`. The footnotes `1` and `foo` can be defined anywhere in the document although it seems to be a good idea to collect them at the bottom of the Markdown document. Footnotes cannot contain anything but paragraphs: no code blocks, lists, blockquotes or tables. Inline markup will be processed.

Note that the `^` character is the caret, **not** the APL symbol for logical AND.

The format of the definition `[^footnote]`:

~~~
[^single]: The definition of a single-line footnote.

[^footnote]: A multi-line definition.
  As long as the following paras are indented by two spaces they are considered part of the footnote.
  
  Even an empty line doesn't interrupt the definition, although two do. Inline formatting **is** of course supported. 
~~~

Notes:

* Two empty lines end a footnote. 
* As soon as something is not indented by two spaces a footnote definition ends.
* The footnote identifiers must start with an upper case or lower case ASCII character or a digit and may contain 
  any upper case and lower case characters, digits and the underscore (`_`) but nothing else.
* The footnotes (= the ordered list) are wrapped in a 
  `<div id="footnotes_div">` tag to make them styleable with CSS. 
* Footnotes always go to the very end of the HTML document.


#### Headers

<<SubTOC>>

There are two ways to markup headers, and both are part of the original Markdown specification:


##### The "=" and "-" syntax (SeText)

With this syntax you can only define headers of level 1 and 2.

A line that looks like this:

~~~
Main caption
============
~~~

is converted into a header of level 1.

Note that it does not matter how many `=` chars are used. 

As long as the first character on a line is a `=` and there are no other characters or they are all spaces it will be recognized as a level-1 header.

Similarly a line that looks like this:

~~~
Header of level 2
-----------------
~~~

is converted into a header of level 2.

Again it does not matter how many hyphens are used. As long as the first character on a line is a hyphen and there are no other characters or they are all spaces it will be recognized as a level-2 header.

However, since a single `-` can also start a bulleted list it is **strongly** recommended to use at least two hyphens.

Note that the definition of a header might well span several lines like this:

~~~
This is a 
level 1
header
=====
~~~

Generally no blank line is required either before or after such a header, but because a SeText header cannot interrupt a paragraph it is necessary to have a blank line between the end of a paragraph and a SeText header. 


##### The "pound" syntax (ATX)

A line that looks like this:

~~~
# My caption
~~~

is converted into a header of level 1 while a line that looks like this:

~~~
###### My caption
~~~

is converted into a header of level 6. You cannot have headers of level 7 or higher (HTML does not allow this), and it is probably not a good idea to use levels beyond 4 anyway, except perhaps in technical documentation.

Many Markdown implementations do not require a space between the last `#` and the content (= the header as such). However, the space was required even by the original Markdown specification. The CommonMark specification points out that this was actually a good idea because without the space these two lines would be rendered as headers:

~~~
#5 bolt
~~~

~~~
#hashtag
~~~

For that reason `MarkAPL` requires a space between the `#` and the header as such.

Note that you may have trailing `#` characters as well, but they are simply ignored.


##### ATX versus SeText syntax

* The SeText syntax is contributing to the readability of a document.
* The ATX syntax makes it easier for an author to search for a specific header.

  However, that does not matter in case you edit your Markdown with an editor that allows walking the Markdown via the TOC. 

##### Headers and bookmarks 

By default `MarkAPL` automatically embraces headers (`<h\{number\}>`) by bookmark anchors. Use `parms.bookmarkLink` (default: 6 = all levels) to change this: setting this to 0 suppresses this feature altogether. You can also assign a number lesser than 6. For example, assigning 3 means that all headers of level 1, 2 and 3 are embraced by bookmark anchors while headers of level 4, 5 and 6 are not.

Note that both ID and HREF are assigned the same value. That allows the user to make any header the first line by just clicking at it.

Though the `<a>` tag surrounding any `<h1>` etc. tag is useful it also poses a problem: assigning `page-break: avoid` to any `<h{number}>` tag in the CSS might not prevent an unwanted break because it will then break after the `<a>` tag which is not any better from a user's point of view.

For that reason headers and their associated `<a>` tags are surrounded by `<div class="h_tag"`. That way the `page-break: avoid` can be assigned to the `<div>` which will prevent the unwanted page break. If you don't want that `<div>` for some reason you can achieve that by assigning 0 to the [div_h_tag](#) parameter.


The names of the bookmarks are constructed automatically according to this set of rules:

* Remove all formatting, links, etc.
* Remove everything between `<>`, `()` and `[]`, including the brackets.
* Remove all punctuation, except underscores, hyphens and periods.
* Remove backticks around code.
* Remove HTML entities; those might have been injected into the document by recursive calls to `MarkAPL`, for example in order to process a blockquote.
* Replace all spaces and newlines with hyphens.
* ~~Convert all alphabetic characters to lower case.~~

  With version 3.9 this was changed. The reason is that although CSS selectors are case insensitive, HTML attributes **are not**!
* Remove everything from the left until the first digit or ASCII letter or `∆` 
  or `⍙` is found (identifiers may not begin with a hyphen).
* If nothing is left by then, use the identifier `section`.

If you need to link to such headers from within the document it is probably best to assign an ID (via [Special attributes](#)) and to use that ID in the link.

Example:

The caption "`Second level-2 "Header!"`" becomes "`second-level-2-header`".

This is the result with `parms.bookmarkLink←1`:

~~~
<a id="second-level-2-header" class="autoheader_anchor" 
<h2>Second level-2 "Header!"</h2> 
</a>
~~~

Note that the class `autoheader_anchor` is automatically assigned to all bookmark links. This allows the link to be styled via CSS.

With `parms.bookmarkLink←0` however it is just this:

~~~
<h1>Second level-2 "Header!"</h1>
~~~

##### Headers and special attributes

Note that assigning [Special attributes](#) has special rules:

* If an ID is defined then it is assigned to the anchor (`<a>`) rather than the `<h{number}>` tag.
* All other special attributes are assigned to the `<h{number}>` tag.
* If however automated bookmarks are suppressed (see [bookmarkLink](#)) then all special attributes go onto the `<h{number}>` tag - there is no anchor!



##### Headers and links/images

A Markdown header can only be simple text and/or code. In particular you cannot make an image or a link part of a header.

Although it would be possible to implement this it would defeat the purpose of Markdown (keep the syntax simple, much simpler than HTML) because nesting those elements in Markdown would result in a different but still complex syntax. 

If you need a link or an image in a header specify an HTML block for it - see [HTML blocks](#).

Note that `MarkAPL`'s ability to inject a table-of-contents is not harmed by an HTML block injecting a header. However, its ability to number headers **is** harmed.


##### Headers with leading spaces

No matter how you defines headers, they may have between zero and up to three leading spaces.


#### HTML blocks

It is perfectly legal to have HTML blocks in a Markdown document, but be aware that this is way more complex a topic than it seems to be at first glance. 

For details refer to [][commonmark_on_html_blocks].

Beginning with version 12.0 of `MarkAPL` you can inject HTML tags anywhere in you Markdown, rendering HTML blocks far less important than before that. It might still have its uses because Markdown markup *within* an HTML block is not converted by `MarkAPL`.

An HTML block must start with a `<` in the first column. In other words, a line that starts with a space character can never become an HTML block.

This can be used to prevent something that starts with a `<` character from starting an HTML block.

In the following example the leading space tells that the second paragraph should not be treated as an HTML block:

~~~
<p>HTML block</p>

 <p>NO HTML block</p>
~~~

There are four different kinds of HTML blocks:

* `<script>` and `<style>`
  
  They are special because they cannot be nested.

* `<pre>`
  
  This one preserves spaces. The special features of `<pre>` blocks are discussed in detail at [Code: the `<pre>` tag](#).

* `<!--`

  An HTML comment. Note that HTML comments _make it into the final document_, although they are only visible via the "View page source" context menu command.

* Everything else. 

All HTML blocks but `<pre>`, `<script>`, HTML comments and `<style>` **must** be surrounded by blank lines except when an HTML block is placed at the top of a document or ends at the bottom of the document.

An HTML comment must have a blank line before the opening tag (`<!--`) but no empty line is required after the closing tag. For that reason this is a prefectly legal Markdown document with an HTML comment:

```
# Overview

<!-- This is a comment --> will be ignored
This is a paragraph
```

However, note that "will be ignored" will _not_ make it into the final document.

Until version 12, the most important syntax is when you want to have an opening tag like a `<div>` and a corresponding `</div>` around some Markdown stuff. For simplicity let's assume that it is just a paragraph with a single word: "foo" in bold.

An HTML block must always start with either `<` or `</`:

~~~
# Example demonstrating HTML blocks

<div id="123" class="myClass">

**foo**

</div>

Another paragraph.
~~~

Notes:

1. This example comprises **two** (!) HTML blocks.

1. The beginning of a block is defined by an empty line followed by a line 
  that starts with either  `<` or `</` followed by a tag name. That means that the leading space is important because it prevents a line from being recognized as an HTML block.

1. The end of each HTML block (except `<pre>`, `<script>`, `<style>`) is 
  defined by an empty line which therefore is essential.

1. Because `**foo**` is an ordinary paragraph located **between** two HTML 
   blocks it will be converted into `<strong>foo</strong>`.

   Without the two empty lines around the paragraph it would be just **one** HTML block. As a side effect the paragraph would show "\*\*foo\*\*" rather than "**foo**" because within an HTML block no inline Markdown is processed.

The `<pre>` blocks are different in so far as there is no Markdown processing done to anything between `<pre>` and `</pre>` anyway; therefore you can have just one block without any disadvantages. 

#### Horizontal rulers

You can create a horizontal ruler by following these rules:

1. After an empty line there must be a line that starts with either a hyphen (`-`) or an 
   asterisk (`*`) or an underscore (`_`).
1. There must be at least three such characters on the line.
1. There might be zero to a maximum of three space characters to the 
   left of the characters defining the ruler.
1. There are no other characters but spaces allowed, with the exception of [
   Special attributes](#).

So these lines will all create a ruler:

~~~
---
* * * * * *
_ _    _
   ***
   ***{style="max-width: 50%; border-top: 20px solid green; border-radius: 5px;"}
~~~

The result:

---
* * * * * *
_ _    _
   ***

   ***{style="max-width: 50%; border-top: 20px solid green; border-radius: 5px;"}

It is a common mistake to forget the empty line required **before** the definition of a ruler which might well create a [SeText header](#The “=” and "-" syntax (SeText)).


#### Images

Images are implemented so that an image can be included into a paragraph, a list, a blockquote and table cells. If you want an image outside such an element then you are advised to insert it as [HTML block](#HTML-blocks) with an `<img>` tag.

The original Markdown syntax for images was of limited value because there was no way to specify either height or width. In `MarkAPL` however one can get around this limitation with [Special attributes](#).

The full syntax:

~~~
![Alt Text](/url "My title")
~~~

Because the title is optional this is a valid specification as well:

~~~
![Alt Text](/url)
~~~

Finally the "alt" text is optional as well, so this would do:

~~~
![](/url)
~~~

Note that if you specify "alt" but not "title" or "title" but not "alt" then the undefined bit will show the same contents as the defined one.

In order to add [Special attributes](#) use this syntax:

~~~
![Alt Text](/url "My title" {#foo .myclass style="color:red;"})
~~~

Example:

~~~
![Dots](http://download.aplteam.com/APL_Team_Dots.png "aplteam dots" {height="70" width="70" style="background: silver;"})
~~~

![Dots](http://download.aplteam.com/APL_Team_Dots.png "aplteam dots" {height="70" width="70" style="background: silver;"})

Note that you can use `<br>` between an image and some text and assign [Special attributes](#) to both, the image and the text. For example, this:

~~~
![](MyPic.png){.Picture15em} <br> Figure 3. Random {.caption .right}
~~~

results in this HTML:

~~~
<p class="caption right"><img src="MyPic.png" class="Picture15em"/><br> Figure 3. Random</p>
~~~


#### Inline markup

<<SubTOC>>

First of all, all inline markup does **not** touch code, be it inline code or a code block.

Inline markup can be used in paragraphs, lists, table cells, blockquotes, definition lists and headers but also in the link text, the alt text and the title of [Links](#).

Note that you cannot assign [Special attributes](#) to inline markup.

##### Emphasize with `<em>` and `<strong>`

Some rules apply for `<em>` and `<strong>` alike:

* When any of the characters, like `*`, is surrounded by spaces they have no effect. Therefore this: ` * not italic * ` survives verbatim:  * not italic * 

* You cannot spread it over several lines: it would then not be interpreted as inline mar-kup, therefore

  ```
  _
  Not italic
  _
  ```

  survives verbatim:

  _
  Not italic
  _

Within a word, inline markup with `_` is ignored while `*` is honoured. This is because `_` may well appear in words but `*` won't.
Therefore `Not i_tali_c` survives verbatim (Not i_tali_c) while `I*tali*c` results in Ii*tali*c. Same for `St__ro__ng` (St__ro__ng) and `St**ro**ng` (St**ro**ng).

With the aforementioned exception all examples that use `*` are valid for `_`, and for `__` and `**` accordingly.

Note that you can always escape either `*` or `_` with a backslash, therefore `\___Word__\_` results in \___Word__\_ (the underscores are not emphasized) while `__\_Word\___` would result in __\_Word\___ (the underscores are both emphasized; note that this might not be obvious depending on the font or font size).

###### Emphasize with `<em>`

To mark some text as `<em>` you can enclose that text either with `**` or with `__` (two underscores).

Therefore the following two lines have the same effect:

~~~
This is an **ordinary** paragraph.
This is an __ordinary__ paragraph.
~~~

This is the result in both cases:

This is an **ordinary** paragraph.


###### Emphasize with `<strong>` {#emphasize-with-strong}

To mark some text as `<strong>` you can enclose that text either with `*` or with `_` (single underscore).

Therefore the following two lines have the same effect:

~~~
This is an *ordinary* paragraph.
This is an _ordinary_ paragraph.
~~~

This is the result in both cases:

This is an *ordinary* paragraph.

Note that underscores within words are not considered markup directives.

If you need a leading underscore as part of a name then you must escape the underscore with a backslash. This:

~~~
\_VarsName
~~~

leads to this:

\_VarsName


##### Strike-through with `<del>`

To mark some text with `<del>` you can enclose that text with `~~`:

~~~
This ~~is~~ was an ordinary paragraph.
~~~

This is the result:

This ~~is~~ was an ordinary paragraph.

Note that to the right of any opening `~~` and to the left of any closing `~~` there must be a non-space character for them to be accepted as markup.


##### Line breaks

There are two different ways to enforce a line break (= inserting a `<br>` tag) within paragraphs, lists, footnotes and table cells:

* Have a backslash character (`\`) at the end of a line. This has the disadvantage that you cannot use it in table cells - there is no "end of line" in those.
* Insert `<br>`. This is the recommended way: it is readable and can be used in table cells as well. 
 
Having two spaces at the end of a paragraph or list item is according to the Markdown implementation --- and also the early versions of `MarkAPL` --- designed to inject a line break. This caused bug reports by people who accidentally added two spaces to the end of a line without realizing and then started to wonder where exactly the line break was coming from. It seemed to be a bad idea from the start; therefore this feature was removed from `MarkAPL` in version 1.3.0.


##### Inline code (verbatim)

You can insert code samples into paragraphs, blockquotes, lists, cells and footnotes by putting backticks around them:

~~~
This: `is code`
~~~

Note that in order to show a backtick within code you need to double the backticks that indicate the start and end of the code:

~~~
`` A backtick: ` ``
~~~

This results in `` A backtick: ` ``

In general the number of backticks that define start and end of the code must be one more than the longest sequence of backticks you want to show within the code. So in order to show 4 backticks:

```
`````Four (````) backticks`````
```

This results in `````Four (````) backticks`````

If you want to show a backtick at the start and/or the end of the code then you must inject additonal space characters, because otherwise it would not be possible to tell whether the backtick should show or is part of the opening sequence.

~~~
`` `tablespace` ``
~~~

This results in `` `tablespace` ``

The number of backticks in a paragraph (list, cell,...) should be even. If that's not the case then since version 8.0.0 the last backtick (or group of backticks) survives verbatim. In earlier versions a closing backtick was added but that violated the specification.

Therefore this:

```
Code: `{+/≢¨⍵}` and (`) a single backtick that is not code.
```

leads to: Code: `{+/≢¨⍵}` and (`) a single backtick that is not code.

An error in the number of opening and closing backticks therefore leads to no code at all. For example, if you want to embrace code with 4 backticks and display two consecutive backticks inside the code but by mistake the closing group carries only 3 rather than 4 backticks as shown here:

~~~
```` {+/⍳≢⍵} `` ⌹ ```
~~~

This is the outcome: ```` {+/⍳≢⍵} `` ⌹ ``` --- no inline code at all.


##### Syntax sugar

`MarkAPL` converts a number of shortcuts:

* Pairs of double-quotes (`"`) are exchanged against their typographically correct equivalents "like here" while the [`lang`](#) parameter decides what's going to be the opening and what's the closing one: Germany/Austria/Switzerland have different ideas in this respect from the rest of the world.     
    
  Note also that this means that mentioning a single double-quote requires it to be put between backticks or escaped with a `\` character when there are also pairs of double-quotes in the same paragraph, cell, list item, blockquote or header because otherwise `MarkAPL` cannot decide what is an opening and what is a closing one and which one is supposed to survive verbatim.

  A single double quote (") however is simply shown as is.

* Three dots (`...`) are exchanged against an ellipses: ...
* Three hyphens (`---`) are exchanged against ---.
    
  This is called an em dash: a dash with the length of the character `m`.

* Two hyphens (`--`) are exchanged against --.
    
  This is called an en dash: a dash with the length of the character `n`.
        
* `(c)` is exchanged against (c).
* `(tm)` is exchanged against (tm).
* `<<` and `>>` are converted into <<Guillemets>>. 
    
     Note that because of the special meaning of [`<<SubTOC>>`](#subTocs) you cannot have this string between Guillemets defined by `<<` and `>>`. 
* `==>`, `<==` and `<==>` are converted into arrows: ==>, <== and <==>.

If you don't want syntax sugar at all for some reason then you can switch this off entirely by setting the [syntaxSugar](#) parameter to 0.

Note that in case you want to have syntax sugar switched on but in a particular case you don't want something to be converted then you must put it between backticks in order to make it code: escaping is not supported for syntax sugar.


#### Links

<<SubToc>>


##### External links

Generally an external link looks like this:

~~~
[`MarkAPL` on GitHub](https://github.com/aplteam/MarkAPL "Link to MarkAPL on GitHub")
~~~

The result is a link like this one: [`MarkAPL` on GitHub](https://github.com/aplteam/MarkAPL "Link to MarkAPL on GitHub")

When you hover with the mouse over the link the title (that's the stuff between the double-quotes) is displayed.

Notes

* The way the title is used is different for external links and bookmark links.
* You cannot use inline markup (bold, italic, del,...) in the URL.

The title is optional, therefore the link can also be written as:

~~~
[`MarkAPL` on GitHub](https://github.com/aplteam/MarkAPL)
~~~

If you want the URL to become the link text then this would suffice:

~~~
[](https://github.com/aplteam/MarkAPL)
~~~

That would result in [](https://github.com/aplteam/MarkAPL)

See also the next topic (AutoLinks). 


##### Automated links (Autolinks)

Because external links are often injected "as is" --- meaning that they actually have no link text and no link title --- Markdown has a special syntax for this:

~~~
<https://github.com/aplteam/MarkAPL>
~~~

That results is this link: <https://github.com/aplteam/MarkAPL>: the link text and the URL are identical.

Note that you **must** specify a protocol (http://, https://, ftp://...), here, otherwise it is **not** treated as an automated link.

There is one exception: since version 5.0.0 you can use this for "mailto:" links. Since the `@` character makes it an email address no protocol needs to be specified, therefore this:

~~~
<kai@aplteam.com>
~~~

creates this HTML:

~~~
<a href="mailto:kai@aplteam.com" class="mailto_link">
    kai@aplteam.com
</a>
~~~


##### Internal links (bookmarks)

Bookmark links are defined by a leading `#`. This character tells that the link points to somewhere in the same document.

The text of a bookmark link must be compiled of one or more of `⎕D,⎕A,⎕C ⎕A`: All digits and all letters of the ASCII characters set, lowercase or uppercase.

Notes:

* In HTML5 an ID may start with a digit. This is the default in `MarkAPL` as well. However, you can change this by setting [bookmarkMayStartWithDigit](#) to 0.
* Strictly speaking URLs are case sensitive, and bookmarks are just that: URLs. 

  Because some big shots (among them [MkDocs](https://www.mkdocs.org/ "Link to the MkDocs website")) convert internal URLs into lowercase, `MarkAPL` does the same. This affects both "href" and "id" but not "data-id". External links are not affected.

  You can switch this off with the parameter `lowercaseID`.

An example of a bookmark link:

~~~
[Link text](#Anchor)
~~~

The most common internal (or bookmark) link is a link to a header. Since `MarkAPL` establishes anchors automatically for all headers by default you might expect an easy way to link to them, and you would be right.

Given this header:
~~~
## This is (really) chapter 5-2
~~~

`MarkAPL` transforms this automatically into

~~~ 
this-is-really-chapter-5-2
~~~

according to the set of rules explained at [Headers and bookmarks](#).

To link to this header you can therefore say:

~~~
[Link to chapter 5-2](#this-is-really-chapter-5-2)
~~~

and that would work indeed.

Instead you could use just the chapter title and specify a `#` in order to let `MarkAPL` know that this is an internal link:

~~~
[This is (really) chapter 5-2](#)
~~~

That will result in a bookmark link as well.

Note that this is a `MarkAPL`-only feature.

Do not use this feature if your document will also be rendered by other means than `MarkAPL`, most notably GitHub and the likes (ReadMe.md!) because that would not work.

There are times when the actual title of the header you are linking to does not fit as a link text. In that case you can specify an alternative link text:

~~~
[This is (really) chapter 5-2](#"Alt text")
~~~

This would create a link to the header _This is (really) chapter 5-2_ but it would show "Alt text" as link text. 

Note that external and internal links differ in how they make use of a string between double quotes.


##### Link references

Link references are defined by `[ID]: url "alt text"`. Note that "alt text" is optional and therefore may be empty or even absent. You may also add [Special attributes](#): `[ID]: url "alt text"{target:"_blank"}`. There might be a space between the colon and the URL or not. 

Such definitions can appear anywhere in the document. 

IDs must consist of one or more characters of:

* The ASCII character set, lower case as well as upper case.
* Digits.
* The underscore (`_`) character.
* The hyphen (`-`) character. 

Other characters are not permitted.

If the alt text is specified and not empty then any link that makes use of this reference and has no link text on its own will use the alt text as link text while in the absence of both an alt text and a link text the URL as such would become the link text.

First example:

~~~
[markapl_on_github]: https://github.com/aplteam/MarkAPL
~~~

In the document you can refer to this with:

~~~
[`MarkAPL` on GitHub][markapl_on_github]
~~~

The text between the first pair of square brackets is the link text, the text between the second pair of square brackets is the ID of the link reference.

This would suffice however:

~~~
[][markapl_on_github]
~~~

In the former case "MarkAPL on GitHub" would become the link text while in the latter case it would be "https://github.com/aplteam/MarkAPL" because the link reference has no alt text.

Second example:

~~~
[fire]: https://github.com/aplteam/Fire "Fire's home page on GitHub"
~~~

If we refer to this definition with:

~~~
[][fire]
~~~

then "Fire's home page on GitHub" would become the link text.

Notes: 

* In case of a typo in the link definition --- meaning that `MarkAPL` cannot find a corresponding 
  link reference --- the text will appear "as is" in the final document but the failing reference 
  will also be reported on `ns.report` (APL programmers only).
* [Special attributes](#) can be assigned to the link reference definition but not to the link itself.


##### Links containing code

Note that this works:

~~~
[`FunctionName`](#)
~~~

This on the other hand does **not** work:

~~~
`[FunctionName](#)`
~~~

The reason is simple:

* In the first expression the backticks are removed before the contents between `[` 
  and `]`, and the remaining content is converted into a link but also still marked up with `<pre>` and `<code>`.
* The second statement is treated like code. No links then: it is taken 
  verbatim.


##### Links and special attributes

[Special attributes](#) can be assigned to all links but references to link references:

* `<https://github.com/aplteam/MarkAPL{#foo1}>`   
* `[BookMark Link](# {#foo2})`
* `[MarkAPL on GitHub](https://github.com/aplteam/MarkAPL {#foo3})`
* `[](https://github.com/aplteam/MarkAPL {target="_blank"})`

Note that special attributes for links (and images) are different from other special attributes: normally special attributes are recognized as such only at the end of a line. A link might or might not occur at the end of a line; if it doesn't then there would be no way to assign special attributes to a link. That's probably the reason that other Markdown dialects do not support special attributes for links.

`MarkAPL` gets around this: you just need to specify the special attributes **within** the link definition. That means to the left of the closing `>` or `)` respectively.


#### Lists

<<SubTOC>>

Lists look simple, but when they are nested and/or contain sub-paragraphs, images, tables, blockquotes and code blocks then things can get quite complicated. 

If your lists comprise just short single sentences then you will find lists easy and intuitive to use; otherwise you are advised to read the list of rules carefully. 


##### General rules

1. Lists start with a line were the first non-space character is either one of `-+*` for a bulleted list or a digit followed either by a dot (`.`) or a parenthesis (`)`) and a space for an ordered list. This is called the list marker.

   However, in case [`markdownStrict`](#) is 1 (default is 0) then a list requires a blank line before the first line that 
   will become the first list item.
   
1. If a list follows a paragraph no blank line is needed between the paragraph and the list.

   Note that this makes life often easier because pretty much everybody assumes that one can start a list straight away after
   a paragraph. 

   Watch out, this can backfire: if your insert line breaks into a paragraph by pressing the `<enter>` key, and a line within a paragraph happens to start with a number followed by a dot and a space then this **starts a list**. Same for a line that starts with an asterisk followed by a space.
   
   In real life however this a) happens rarely and b) people are way more likely to want to start a list when it doesn't. That's why `MarkAPL` is taking this approach.
 
1. A list definition --- including all sub lists --- breaks at two consecutive 
   empty lines.
 
1. A list definition --- including all sub lists --- also breaks when after an 
   empty line something is detected that does not carry a list marker **and** is not indented at all.

1. A change of the list marker for bulleted lists (from `+` to `*` for 
   example) starts a new list.

1. Lists can be nested.

1. The number of leading space characters between the left margin and the list marker (in case of a list item itself) or content 
   (in case of a sub-paragraph or a code block) defines the level of nesting.
 
   That means that any content that is supposed to belong to a particular list item must be indented by the number of space characters to the left and to the right of the list marker plus the characters for the list marker itself: one for bulleted lists and at least two for numbered lists.

1. Between a list marker and the content there might be any number of white 
   space characters.

1. A list item can contain nothing but:
   * text (sometimes called initial list item content)
   * paragraphs 
   * code blocks
   * sub-lists
   
   and since version 3.0:
   * tables
   * images
   * blockquotes 

1. If a list item contains a code block or a paragraph then there **must** be 
   an empty line before the code block or paragraph respectively. 

1. A stand-alone code block may have zero or up to three leading spaces. This rule **does not apply** for code blocks that are part
   of a list item since spaces are used as the means to work out which list level the code block belongs to.
 
1. Single empty lines between list items and sub-paragraphs / code blocks 
  belonging to a list item are ignored.
 
1. There is no concept of "loose" or "tight" lists. As a consequence the 
   initial contents of a list item is never wrapped in a `<p>` tag.

   Note that this is a `MarkAPL` restriction.

1. Closing `</li>` tags are optional according to the W3C HTML5 
   specification. However, `MarkAPL` adds **always** a closing `</li>` tag starting with version 2.0.
 
Note that these rules differ from the original Markdown specification (which are inconsistent) and CommonMark (which are consistent but very complex). 

Originally `MarkAPL` attempted to implement the CommanMark rules. However, the first bug reports all referred to list problems, and only one was a true bug. Everything else was caused by misunderstanding those very complex rules. Therefore, starting with version 1.3.0, `MarkAPL` now has its own ---  simpler and still consistent --- set of rules. With these easier to understand rules everything can be achieved but wrapping the content of a list item into a `<p>` tag.  

**A word of warning:** getting the number of space characters wrong --- in particular for sub-paragraphs, images, tables, blockquotes and/or code blocks --- is the most common reason for unexpected results. You are advised to use a monospace font since this makes it much easier to spot such problems, or to avoid them in the first place. 


##### Bulleted lists

Bulleted --- or unordered --- lists can be marked by an asterisk (`*`), a plus (`+`) or a minus (`-`). There might by zero to three space characters between the left margin and the list marker. There might be any number of space characters between the list marker and the beginning of the contents.

Note that for nesting you need to have at least one more space to the left of the list marker per additional level. Although you can choose the number of spaces freely items that are supposed to end up on the same level must have the same number of leading spaces, otherwise results become unpredictable.

It is recommended to indent with readability in mind.

Example:

~~~
* First line
* Second line
  * Yellow
  * Brown 
    * Light brown
    * Medium brown
  * Magenta
* Third line              

~~~

This results in this:

* First line
* Second line
  * Yellow
  * Brown 
    * Light brown
    * Medium brown
  * Magenta
* Third line                


##### Ordered lists

An ordered list must start with a digit followed by a dot (`.`) or a parentheses (`)`) and one or more space characters. The digit(s) in the first row define the starting point. For the remaining rows any digit will do. Note that some browsers cannot deal with more than 9 digits, so that's the limit. 

There might by zero to three space characters between the left margin and the list marker. There might be any number of space characters between the list marker and the beginning of the contents.

Example:

~~~
5. First line
5. Second line
   1) Yellow
   2) Brown 
   3) Magenta
1. Third line                          
~~~

This results in this:

5. First line
5. Second line
   1) Yellow
   1) Brown 
   1) Magenta
1. Third line 


##### List item contents

You may want to inject line breaks for readability, or you may not and be lazy, and you may add blanks or not. 

An example for the lazy approach:
~~~
* This is a list item with plenty of words.  Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus. Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` semper ipsum sit amet velit. Suspendisse id sem consectetuer libero luctus adipiscing.
* ...
~~~

The same with some line breaks:

~~~
* This is a list item with plenty of words.  Lorem ipsum dolor sit amet, consectetuer
adipiscing elit. Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi, viverra
nec, fringilla in, laoreet vitae, risus. Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` 
semper ipsum sit amet velit. Suspendisse id sem consectetuer libero luctus adipiscing.
* ...
~~~

The same nicely formatted:

~~~
* This is a list item with plenty of words.  Lorem ipsum dolor sit amet,
  consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus. 
  Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.
  Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` semper ipsum sit amet
  velit. Suspendisse id sem consectetuer libero luctus adipiscing.
* ...
~~~

However, this would work as well:

~~~
* This is a list item with plenty of words.  Lorem ipsum dolor sit amet,
 consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
     Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae,risus.
  Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` semper ipsum sit amet
  velit. Suspendisse id sem
            consectetuer libero luctus adipiscing.
* ...
~~~

In all cases this would be the result:

---
* This is a list item with plenty of words.  Lorem ipsum dolor sit amet,
 consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
     Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae,risus.
  Donec sit amet nisl. Aliquam `(+/⍵)÷⍴,⍵` semper ipsum sit amet
  velit. Suspendisse id sem
            consectetuer libero luctus adipiscing.
* ...

---

Notes:
* Line breaks can be injected anywhere, even within links, but not in code (anything between two backticks).
* Indentation matters only in the first line of any list item and 
  sub-paragraph as well as for the fencing lines of any code blocks.
* The end of the contents of a list item (but not necessarily a list!) is defined by one of:
  * An empty line, including lines that comprise nothing but spaces.
  * A line (with or without any leading space) that starts with a list 
    marker.


##### Paragraphs and code blocks in list items

The fencing lines of code blocks as well as the first line of paragraphs that belong to a list item need to be indented by the same number of spaces as the list item they belong to. They **must** be separated from the initial list item contents or any earlier sub-paragraph or code block by an empty line.  

Note that the number of leading space characters (indentations) of any paragraphs must match the number of any space characters _and_ the list marker(s) from the left margin to the beginning of the content of the list item the paragraph or code block is supposed to belong to.

~~~
1. First line
1. Second line
   * Yellow
     This is **not** a paragraph.

     This **is** a paragraph.

     ~~~
       {+/⍳⍴⍵}
     ~~~

   This is a paragraph that belongs to "Second line".
   * Brown 
   * Magenta
1. Third line                          
~~~

This results in this:

1. First line
1. Second line
   * Yellow
     This is **not** a paragraph.

     This **is** a paragraph.

     ~~~
       {+/⍳⍴⍵}
     ~~~

   This is a paragraph that belongs to "Second line".
   * Brown 
   * Magenta
1. Third line                                   

Note that the code block has two leading spaces **within the fence**. These two spaces make it into the output while the other leading spaces defining just the indentation don't.


##### Lists and special attributes

When [Special attributes](#) are assigned to the very first item on any list then that definition is assigned to the **list** (`<ul>` or `<ol>`) rather than the list item itself.

This implies that you cannot assign special attributes to list items.


#### Paragraphs

Any text between two lines that is either empty or is considered special Markdown syntax and has not any leading character(s) recognized as Markdown directives will result in a single paragraph. The only exception is a definition list: Although the term part looks like any ordinary paragraph, the `: ` on the next non-empty line makes it rather a definition.

Within a paragraph you can use inline markup; see there.

You may insert NewLine characters (by pressing the `<return>` key) into a long paragraph in order to improve readability. These NewLine characters won't make it into the output. You don't have to worry about space characters at the end of a line (or at the beginning of the next line) because `MarkAPL` is taking care of this for you.

If you want to have a line break at the end of a line add a backslash to that line. 

Alternatively you can insert `<br>` anywhere into a paragraph in order to enforce a line break; see [Line breaks](#) for details.

Note that the original Markdown syntax for line breaks (having two spaces at the end of a line) is **not** supported by `MarkAPL`, and for good reasons: hard to spot (if at all), likely to be inserted by accident and therefore likely to cause confusion. 

You can assign [Special attributes](#) to a paragraph. With a multi-line paragraph, the special attribute must go into the **last line** as shown in this example:

~~~

 Simple
 paragraph {#author}

~~~

This results in this HTML:

~~~
<p id="author">Simple paragraph</p>
~~~

There is of course a small chance that something is interpreted as a special attribute definition that is meant to be part of the paragraph. In that case you need to escape the curly brackets with `\{` and/or `\}`. 


#### Tables

<<SubTOC>>


##### Overview{#ov2}

A table must be separated from other stuff by empty lines.

Table rows are defined by having at least one un-escaped pipe symbol. You may however add a leading and/or a trailing pipe symbol if you wish so. Many consider this to be more readable. 

Note that this is a `MarkAPL` enhancement: in ordinary Markdown the definition of a table also requires a header and a devider between the header and the data rows. Therefore this is a minimum table in ordinary Markdown:

```
Col a   | Col b
--------|--------
data 1a | data 1b
```

This is a minimum table in `MarkAPL`:

```
--------|--------
data 1a | data 1b
```

Note that one-column tables can only be constructed with either a leading or a trailing un-escape pipe symbol, or both:

```
One Col|
-------|
First  |
Second |
```

This results in this table:

One Col|
-------|
First  |
Second |

`MarkAPL` goes beyond the standard:

1. According to the Markdown specification you **must** have a second row with a hyphen ("`-`") and the appropriate number of pipe symbols and zero, one or two colons (`:`) per column but `MarkAPL` doesn't require this: if there is no such row it assumes that the first row is not a row with column headers but an ordinary one.
2. In `MarkAPL` a table can have a footer.
3. If a column has no `:` in its column title for defining alignment then the contents is still right-aligned in case the column contains nothing but numeric values in **all** its rows.

Notes:
* Leading and trailing spaces are removed from all cells.
* Automated alignment detection based on the data type of a column can be slow 
  with very large tables (at least several thousands of lines). You are advised to specify the alignment yourself for such tables to avoid a performance penalty.


##### Constructing tables

A valid table definition looks like this: 

~~~
Name | Meaning  {style="margin-left:auto;margin-right:auto;" .avoid_page_break}
-|-
 APL  | Great
 Cobol| Old
 PHP| Oh dear
~~~

This results in this table:

Name        | Meaning  {style="margin-left:auto;margin-right:auto;" .avoid_page_break}
 -----------|-
 APL        | Great 
 Cobol      | Old   
 PHP        | Oh dear

If you wonder about `{style="margin-left:auto;margin-right:auto;" .avoid_page_break}`: this is a simplified syntax for assigning IDs, class name(s) and attributes. This is discussed under [Special attributes](#).

Here it is used to style the table with CSS so that it will be centered, and it prevents page breaks when printed.

Another example which you might find more readable:

~~~
| Name  | Meaning |
|-------|---------|
| APL   | Great   |
| Cobol | Old     |
| PHP   | Oh dear |
~~~

This results in this table:

|Name | Meaning|  {.avoid_page_break}
|-----|--------|
| APL  | Great |
| Cobol| Old   |
| PHP| Oh dear |

Without the `|-----|--------|` row:

~~~
|Name | Meaning|
| APL  | Great |
| Cobol| Old   |
| PHP| Oh dear |
~~~

we get this: 

|Name | Meaning|  {.avoid_page_break}
| APL  | Great |
| Cobol| Old   |
| PHP| Oh dear |


##### Column alignment

Note the colons in row two of the following example: they define the alignment of all cells in that column.

~~~~
|Name | Meaning| Numbers |
|:-   |  :-:   |       -:|
| Left| Center | Right   |
| A   | B      | 1.00    |
| C   | D      | -99.12  | 
~~~~

This results in:

|Name | Meaning| Numbers |  {.avoid_page_break}
|:-   |  :-:   |       -:|
| Left| Center |   Right |
| A   | B      |  1.00 |
| C   | D      | -99.12 |     

If you want a table without column titles but with alignment:

~~~
|:-   |:------:|--------:|
| Left| Center |   Right |
| A   | B      |  1.00 |
| C   | D      | -99.12 |     
~~~

|:----|:------:|--------:| {.avoid_page_break}
| Left| Center |   Right |
| A   | B      |  1.00 |
| C   | D      | -99.12 |     


##### Footers

~~~~
| Product | Price |
|---------|------:|
| Foo     |  1.12 |
| Goo     | 10.50 | 
|=========|=======|
| Total   | 11.62 |
~~~~

This results in:

|Product |Price  |  {.avoid_page_break}
|--------|------:|
| Foo    |  1.12 |
| Goo    | 10.50 | 
|========|=======|
| Total  | 11.62 |

Note that `MarkAPL` does not recognize footers in case [`markdownStrict`](#) is 1; the default is 0.


##### Inline markup in cells

Cells can use inline markup as shown here:

~~~
|First name            |Last Name   |No.        |Code                 |
|:---------------------|:-----------|-------:|:----------------------:|
|Kai                   | Jaeger     | 1      |`{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}` |
| Johann-Wolfgang      | von Goethe | 1923   |`{(⍴,⍵)÷+/,⍵}`         |
| <https://aplwiki.com>| **bold**   | 123.23 |  `fns ⍣a=b⊣123`       |
| _Italic_             | ~~Strike~~ |        |   \|                  |
| line<br>break             | |        |          |
| Last line |
~~~

This is the result:

|First name            |Last Name   |No.        |Code       |  {.avoid_page_break}
|:---------------------|:-----------|-------:|:------------:|
|Kai                   | Jaeger     | 1      |`{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}` |
| Johann-Wolfgang      | von Goethe | 1923   |`{(⍴,⍵)÷+/,⍵}`|
| <https://aplwiki.com>| **bold**   | 123.23 |  `fns ⍣a=b⊣123` |
| _Italic_             | ~~Strike~~ |        |  \|            |
| line<br>break             | |        |          |
| Last line |

Note that one cell contains a pipe symbol (`|`); normally that would confuse the parser but not in this case because it is escaped with a backslash character: `\|`.

You can have a table with just column headers:

~~~
|First name |Last Name|
|-|-|
~~~

This is the result:

|First name |Last Name|  {.avoid_page_break}
|-|-|


### Misc

<<SubTOC>>


#### Escaping

These characters can, depending on the context, have a special meaning in Markdown: `"_*|<~{}(```. They can be escaped with a `\` character which takes the special meaning away from that character.

It means that these characters can be escaped but at the same time `C:\Temp\MyFoo.txt` becomes just C:\Temp\MyFoo.txt: there is no need to double the backslashes.
  
Note that there is an edge case however: if `\"` has a preceding (opening) `"` then it is **not** considered an escape character.

This has two effects:
  
  1. `"C:\Temp\"` results in `“C:\Temp\”` which will almost certainly be 
     appreciated.
  1. `"This: \" is an escaped double quote"` will result in "This: \" is an 
     escaped double quote" which is certainly not appreciated.
  
However, the first case is something you will come across frequently while the second one is unlikely to ever cause a headache, unless there is a `~` character part of the path. Watch this:

```
C:\~\myfile
```

That results in 

C:\~\myfile

because `~` is an "escapable" character, and therefore it consumes the backslash to the left. You need to double it:

```
C:\\~\myfile
```

That results in 

C:\\~\myfile 

#### Reserved names (CSS)

There are a few HTML elements that get a class name assigned by `MarkAPL` in order to tell them apart from other HML elements for easier styling. However, this is discussed in a separate document "Styles.html".


#### Special attributes

One can add special attributes --- that is an ID, class name(s) and other attributes --- to many elements:

* Code blocks
* Definition lists
* Headers
* Horizontal rulers
* Images
* Links (but not references to link references)
* Lists
* Paragraphs
* Tables
* Block quotes
* `<<SubTOC>>`

Notes:

* Special attributes can only be defined at the end of a line with the notable 
  exceptions of links, images and paragraphs. See [Images](#) for an example.
* If you assign an ID to a header then the ID is not actually assigned to the 
  header itself but the associated anchor (bookmark link). Since such an anchor embraces the header tag, the header can be styled via the anchor child selector. 
* If an attempted definition of a special attribute fails due to an error like a
  missing `=` or an odd number of `"` etc. then it's not going to become a special attribute definition but ordinary data; that means it will show in the document.
* Although for ordinary links special attributes can be assigned, for links 
  using a link reference this is not supported. However, for the link reference definition as such special attributes *can* be assigned.
* For sub-TOCs the syntax is `<<SubTOC {.centerin}>>`. The space is redundant.


##### Assigning a class name

The name of a class can be assigned by just mentioning the name:

~~~
{.classname}
~~~

The leading dot tells `MarkAPL` that it is a class name. 

Of course you can specify more than just one class name:

~~~
{.foo .goo}
~~~


##### Assigning an ID

An ID can be assigned by just mentioning the name:

~~~
{#id}
~~~

The leading `#` tells `MarkAPL` that it is an ID.


##### Styling

CSS styling directives are possible as well:

~~~
{style="color:red;line-height:1.4;"}
~~~


##### Quotes and special attributes

It is of course possible to put it all together:

~~~
* list item {#myid style="font-family:'APL385 Unicode'" .class1 .class2 target="_blank"}'
~~~

Note that you cannot put double-quotes around the name of the font family here because double-quotes are already used to determine the definition of the "style" attribute. Therefore you *must* use single quotes in this instance.  


##### Paragraphs and special attributes

Naturally a paragraph that runs over several lines in the Markdown must define any special attributes at the very end of the paragraph rather than the end of the first line.

It is recommended that special attributes are defined on the last line of a paragraph, standing on their own. However, they will be recognized when put at the end of the last line without standing on their own.

Note that there is a chance for content being mistaken as a special attribute, but this chance is very small indeed. If that happens just escape the curlies with a backslash character:

~~~

This is a paragraph with curlies at the end: \{\}.

~~~


#### Data

You can inject key-value pairs of data into a Markdown document.

`MarkAPL` itself does not make use of such variables. It is up to other applications to take advantage of these pieces of data. 

See <https://github.com/aplteam/PresentAPL> for an example: this is software that generates a slide show from a single Markdown document.

It uses this feature to allow the author to set variables like "author", "company" and "title" which are then used to populate slides and meta tags.  
  
Example:  

~~~
[Data]:author='Kai Jaeger'
[DATA]:copies=2
[data]:sequence=1 2 3
[data]:company=Dyalog Ltd
~~~

This establishes the key-value pairs as ordinary variables in the namespace 
`ns.data` (APL Programmers only).

The statements shown will create this:

~~~
      Display ⊃ns.data
┌→────────────────────────┐
↓ ┌→─────┐   ┌→─────────┐ │
│ │author│   │Kai Jaeger│ │
│ └──────┘   └──────────┘ │
│ ┌→─────┐                │
│ │copies│   2            │
│ └──────┘                │
│ ┌→───────┐ ┌→────┐      │
│ │sequence│ │1 2 3│      │
│ └────────┘ └~────┘      │
│ ┌→──────┐  ┌→─────────┐ │
│ │company│  │Dyalog Ltd│ │
│ └───────┘  └──────────┘ │
└∊────────────────────────┘
~~~

Notes:

* The keyword ("data") is case insensitive.
* `[data]:` can appear anywhere in the document.
* There may be any number of space characters between "[data]:" and the 
  name.
* The name must consist of nothing but ASCII characters or digits.
* If the value is not enclosed by quotes `MarkAPL` attempts to establish 
  it as numeric value. If that fails however it will establish it as text.
* If an entry is invalid the value is empty. For example, in 
  `[data]:invalid='text 1 2 3` the closing quote is missing, therefore the expression is invalid. 
* Problems are reported on `ns.report` (APL programmers only).
* `MarkAPL` does **not** support a key to be defined more than once. In case 
  there are several definitions for the same name the last one wins.


#### Sub topics

By inserting `<<SubTopic>>` (case insensitive) one can insert a table of contents for a sub topic. This can be useful in order to avoid overloading the principle table of contents. Note that this document has several such SubTOCs embedded.

You can only insert SubTOCs when the [`toc`](#toc) parameter is 1.

SubTOCs can have [Special attributes](#) assgined to them.

##### Restricting depth

Typically SubTOCs are inserted into a Markdown document right after a header; this header is called a parent header. By default all headers that are children of the parent header are going to become part of the SubTOC.

You can change this by specifying the maximum depth. For example, if the SubTOC should only carry headers that are children or grandchildren of the parent header specify `<<SubTOC-2>>`.


#### Embedding parameters with `[parm]:`

With version 2.6 a mechanism was introduced to embed `MarkAPL` parameters within a Markdown document: by using `[parm]:` you can tell `MarkAPL` that this defines a key/value pair as a `MarkAPL` parameter, meaning that this is a `MarkAPL`-only feature.

This can be useful to create an HTML file from a Markdown file with `MarkAPL` without setting any parameters because the document itself "knows" what parameters are best for it.

For example, this document carries the following lines:

~~~
[parm]:toc            = 2 3
[parm]:numberHeaders  = 2 3 4 5 6
[parm]:bookmarkLink   = 6
[parm]:title          = 'MarkAPL Reference'
[parm]:width          = 1000
[parm]:reportLinks    = 1
~~~

This defines parameters specific to this document.

Rules:

* The part of the document that is considered to embed parameters ends with either two consecutive empty lines or a line that does not start with neither `[parm]:` or `⍝`.
* It follows that you may inject single blank lines and any number of lines that start with the APL lamp (`⍝` meaning "Comment") symbol without breaking the parameter definition.

Notes:
* Such definitions must be placed at the top of the document with the important exception that a LeanPub encoding directive (something like `{:: encoding="utf-8" /}`) which must be the first line in any Markdown document that is going to be published on the [LeanPub publishing platform)[https://leanpub.com/] and therefore does not count when `MarkAPL` looks for any `[parm]:` definitions.
* Those definitions take precedence over standard (or default) parameters; 
  therefore they cannot be overwritten unless you set the [ignoreEmbeddedParms](#"`ignoreEmbeddedParms`") parameter to 1.
* The `[parm]` part is case insensitive.
* All embedded parameters are collected on `ns.embeddedParms` (APL programmers only).
* You cannot have comments on a line defining an embedded parameter but you might have comment lines between `[parm]:` definition lines.


### Parameters


<<SubTOC>>

This document lists _all_ parameters available (read: honoured by **_Mark_APL_**). However, you cannot set all of them with the `[parm]:<name>=<value>` technique: some of them can only be specified programmatically.

If you use Meddy[^meddy] for editing a Markdown document it is easy to find out what can be injected into the document by selecting the "Inject parameters..." command from the context menu of the Markdown pane.

 
#### bookmarkLink

Defaults to 6. That means that all headers of level 1 to 6 are going to be embraced by anchors (bookmarks). See [Headers and bookmarks](#) for details.

Set this to 0 to suppress the insertion of automated bookmark links altogether.

There is not really a good reason for suppressing this except `MarkAPL` calling itself recursively for, say,  blockquotes. Those blockquotes might contain headers, but you don't want them anchored or numbered -- they might interfere with your real headers. 


#### bookmarkMayStartWithDigit

Boolean that defaults to 1: in HTML5 an ID (= bookmark) may indeed start with a digit.

However, sometimes it might be appropriate to avoid this, for example when `MarkAPL` creates a Sub-Topic. In such --- quite special --- circumstances it may well be appropriate to set this to 0.


#### charset

Defaults to "utf-8".


#### checkFootnotes

This parameter is of interest only to APL programmers.

Boolean. The default depends on `debug`. For example, if this is 1 the `Process` method checks all footnotes and reports any problems on `ns.report`. 


#### checkLinks 

This parameter is of interest only to APL programmers.

Boolean. The default depends on `debug`. If this is 1 the `Process` method checks the internal (bookmark) links and reports any problems on `ns.report` (APL programmers only).


#### collapsibleTOC

This was removed in version 12.0. If its defined it has no effect.

With version 12.0 every main TOC is collapsible.

#### compressCSS

This parameter is of interest only to APL programmers.

Boolean that defaults to 1. This does the following things:

* Remove all comments
* Remove multiple blanks
* Convert the CSS into just two lines, one for the screen and the other one for print.

This saves a significant amount of space. You are advised to set this to 0 only for making it possible to change the CSS on the fly in order to check out certain things, otherwise this should always be 1.

Note that this parameter has an effect only when the CSS is injected.

Changing/debugging CSS can be cumbersome. `MarkAPL` offers help, refer to the "Styles" document for details.


#### createFullHtmlPage

This parameter is of interest only to APL programmers.

This parameter is `¯1` by default (undefined).

It can be set to either 0 or 1:

* A 0 means that the given Markdown is converted into an HTML snippet, no 
  matter whether `outputFilename` is empty or not.
* A 1 means that the given Markdown is converted into a fully fledged HTML 
  page, no matter whether `outputFilename` is empty or not.

For what happens when it is `¯1` see the [outputFilename](#) parameter.

#### cssURL

Holds the web address or folder that is expected to host the two CSS files needed for screen and print.

Defaults to `homeFolder`, but when `screenCSS` is not found there then it defaults to a folder `Files` in the `homeFolder`.


#### debug

This parameter is of interest only to APL programmers.

Boolean that defaults to 1 in development and 0 otherwise.

Note that this parameter influences the defaults of a number of other parameters: `checkLinks` and `checkFootnotes` are examples.


#### div_h_tag

Headers (`<h1>` to `<h6>` tags) are surrounded by an `<a>` tag. That allows a user to make a particular header the first line in its window by simply clicking at it. 

It has an unwanted effect as well: assigning `page-break: avoid` to any `<h{number}>` tag might not prevent a break because it will then break after the `<a>` tag, and because there is no parent selector in CSS we cannot style the `<a>` so that is does not do this when part of a header.

For that reason headers are surrounded by a `<div>` tag with class="h_tag". That allows to define `page-break: avoid` for the `<div>`, and it will all work as expected.

However, there are situations when you might not want this div. By setting `div_h_tag` --- which defaults to 1 --- to 0 you can prevent this from happening.


#### enforceEdge

This defaults to:

~~~
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
~~~

This will become the very first `<meta>` tag in the header.

This should only have an effect when the page created by `MarkAPL` is displayed by Microsoft's Webbrowser COM (or ActiveX) control. This control uses the oldest version of IE on any given machine by default. Instead one can specify any IE or even Edge, Microsoft's latest browser at the time of writing, and that's exactly what the above statement does.


#### footnotesCaption

String that defaults to "Footnotes". This is placed above the footnotes section.


#### head

If you want to add additional meta tags to the `<head>` part of a document (just an example) you can assign them to `head`. They will then be added to the `<head>` section. This can be a simple string (representing `<title>` for example) or a vector of simple text vectors (several meta tags for example).

Note that any tags added by the `head` parameter are injected **after** any sub tags of `<head>` that are injected by `MarkAPL`. This makes it possible not only to add stuff but also to overwrite earlier definitions like "title", or to add a CSS file that overwrites earlier CSS definitions.


#### homeFolder


This points to the folder where MarkAPL.html and MarkAPL_CheatSheet.html and the default CSS files live. If this is not set then `MarkAPL` tries to find it:

1. First it checks whether `MarkAPL` was loaded as a Tatin package. If that's the case then the parent space's name is `_tatin`, and it carries a variable `∆HOME` that points to where the `files/` folder lives which contains the documents required.
1. Next it tries to find the two HTML files in the current directory. 
1. Next it tries to find them in a sub-folder `Files\` within the current 
   directory.
1. Next it investigates whether `MarkAPL` was loaded with SALT. If so it 
   tries to find those files from the folder SALT has loaded the script from.
1. Finally it tries to find them in a sub-folder `Files\` within the SALT 
   source folder.
1. If that fails `homefolder` is set to the current directory. However, that means that some functionality might not work.
   It might be better to set `homeFolder` in such cases.

Note that with version 9.3 the search strategy for the home folder has changed: now `MarkAPL` first checks whether `MarkAPL` is a [Tatin](https://github.com/aplteam/Tatin "Link to Tatin on GitHub") package.

#### ignoreEmbeddedParms

Boolean that defaults to 0. If you want to overrule any embedded parameters then you must set this to 1. See [Embedding parameters with `[parm]:`](#) for details.


#### imageURL

No default. If you load all your images from the same folder on the same host then rather specifying these bits of information over and over again for all images you can specify the URL they are going to be loaded from just once on `imageURL`. The images can then refer just the the image name as such.

You may still define an image as a full URL, pointing either to a resource on the web or a local file, in which case `imageuRL` would be ignored.


#### inputFilename

If the Markdown you want to process lives in a file rather than the workspace then you can pass an empty vector as right argument to the `Process` method and specify `parms.inputFilename` instead. 


#### javaScript

Boolean that defaults to 1. If this is 0 no JavaScript is injected into the HTML document. 

Of course this means that neither the "Show/Hide" button in the main TOC nor the "Copy" button in code blocks will appear since both require JavaScript in order to carry out their action.

Also, accordions do not close any already opened collapsible when another one is opened.


#### lang

This defaults to `en` for "English". `lang` is added to the `<html>` tag if it is not empty. If you wish so you can specify a different language.

Specifying the correct language may have benefits you cannot possibly think of when writing the page; that's why it is now considered important, and the W3C HTML validator will issue a warning if it is missing.

An example for this information being essential: it allows screen readers to choose the correct pronunciation when reading out.

This parameter makes also a difference when it comes to deciding what is an opening and what is a closing double quote: Germany, Austria and Switzerland differ in this respect from the rest of the world.


#### leanpubExtensions

Flag that defaults to 0. In case this is 1 certain shortcuts like `A>` are recognized and marked up accordingly. The LeanPub extensions are discussed in a separate document.


#### leanpubIconsUrl

Retired with version 12.0. May exist but is ignored. Will be removed from this document in a future release.

Prior to version 12.0 these icons were downloaded from the given host, but now the icons are injected into the document as SVGs, making it independent from an Internet connection.


#### lineNumberOffset

Defaults to 0. Set this only in case `MarkAPL` is called recursively. Allows `MarkAPL` to adjust line numbers to be reported as having a problem.


#### linkToCSS

Boolean that defaults to 0. This means that CSS for screen and print is injected into the resulting HTML page. If this is 1 a `<link>` tag for the CSS file(s) is added to the header. Naturally `cssURL`, `screenCSS` and `printCSS` must carry reasonable content then.

Note that certain parameters have no effect when `linkToCSS` is 1.

Linking rather than embedding can be useful in order to perform experiments on the CSS used by `MarkAPL`.

If you wish to use this parameter for other purposes than playing with CSS then the default CSS files need modifying: ~~take a copy and watch out for everything that is embraced by `<<` and `>>`: before `MarkAPL` injects the CSS it replaces all such strings. We could call this a dynamic approach. For a static approach you need to change those placeholders by reasonable values.~~ Since version 3.6.1 the style sheets carry reasonable defaults. The associated comment still allows `MarkAPL` to replace this with certain settings, but the style sheets are now fine as they are at delivery time.


#### lowercaseID

By default both the `id` and `href` parameters are now lowercased in case they point to an internal anchor (`#`). You can prevent this by setting the parameter `lowercaseID` to 1.


#### markdownStrict

Note: prior to version 3.4.0 this flag was associated with the processing of syntactical sugar; see [`syntaxSugar`](#) for details.

With 3.4 the meaning of the `markdownStrict` flag has changed: when set to 1 (default is 0) it now prevents `MarkAPL` from carrying out operations that are `MarkAPL` specific enhancements. This is a comprehensive list of what's involved:

* Lists **must** start with an empty line.
* Table footers are not recognized.
* Collapsibles are not available.

In short, if you want the Markdown to be interpreted according to the standard by any other parser then you should set this flag to 1. However, note that more and more parsers allow lists to start without a blank line.

Enhancements that require specific code in the Markdown are **not** affected:

* Short bookmark links
* `\` at the end of lines for lines breaks
* Embedded parameters: `[parm]:`
* Embedded data: `[data]:`
* Embedded calls to APL functions
* Special attributes assigned to links and images

There is also the special case of lines that start with the APL lamp symbol (`⍝`) outside of code: such lines don't make it into the final HTML document. This is not affected by the `markdownStrict` parameter.


#### noCSS

Boolean that defaults to 0. If you don't want to have any CSS at all the set this to 1. This is most likely used in test cases only.


#### numberHeaders

An integer or integer vector that defaults to 0, meaning that headers are not numbered.

* Setting this to 3 means that all headers of level 1 to 3 will be numbered.
* Setting this to 2 3 4 will number all headers of level 2, 3 and 4.
* In order to number only a single level, say 2, you need to specify the 2 twice (`2 2`) because a single 2 would be interpreted as "number all headers _up to_ 2".
  

#### outputFilename

Note that this is relevant only to APL Programmers.

Defaults to an empty vector. If specified the HTML will be written to this file by the `MarkDown2HTML` method; refer to the "MarkAPL for progammers" document for details.

Note that in case [`createFullHtmlPage`](#) is not a Boolean but `¯1` (that's the default value which stands for "undefined") then the setting of `outputFilename` defines what is created from the Markdown:

* In case `outputFilename` is empty an HTML snippet is created.
* In case `outputFilename` is not empty a fully fledged HTML page is created.


#### printCSS

The name of the CSS file (or several CSS files separated by commata) for printing. Defaults to ~~`MarkAPL_print.css`~~ `Dark_print.css` since version 12.0. If this is empty no CSS for printing purposes is injected or linked to.


#### reportLinks

Boolean that defaults to 0. If this is set to 1 then a list of all links together with the associated link text is added to the end of the document but before the footnotes (if any).

Note however that this list is not available on the screen, it's only printed. This list is the only way for a user to actually see any links that have a link text when a document is printed.

When printed, links are not exactly useful. The only thing we can do is to make sure that the user can at least recognize them as links. With the default CSS, internal links are marked up with a leading arrow while external links show a `🔗` character, and the text of both types of links is shown in italic. 

However, the user does not have the means to see the URL of any external link. `reportLinks` tries to ease the problem: all links are printed at the very end of the document together with their link text. 


#### reportLinksCaption

String that defaults to "Link report:". This is placed above the list of all links (see `reportLinks`).


#### saveHTML

Note that this parameter is special insofar as it is not a `MarkAPL` but a Meddy parameter, meaning that `MarkAPL` just ignores it.

However, the Markdown editor [Meddy](https://github.com/aplteam/Meddy "Link to Meddy on GitHub") would take it into account if the value is **not** `¯1`.

These are the possible values:

|Value| Action | Comment |
|----:|:--------------------------|:----------|
|`¯1` |Meddy ignores the parameter| (default) |
|`1`  |Save HTML whenever the Markdown is saved | |
|`0`  |**Do not** save HTML        | |
|`2`  |Ask user whether the HTML should be saved or not| |

If specified this parameter overwrites the user's preferences in Meddy.


#### screenCSS

The name of the CSS file (or several CSS files separated by commata) for the screen. Defaults to ~~`MarkAPL_screen.css`~~ `Dark_screen.css` since version 12.0. If this is empty no CSS for viewing purposes is injected or linked to.

#### subTocs

Boolean that defaults to 1. If you want to suppress sub TOCs no matter whether there are any included in the Markdown or not then set this to 0. 

When set to 0 then any strings `<<SubTOC>>` are removed from the Markdown before processing it. This is mainly needed in order to suppress SubTOCs in blockquotes: those are processed by `MarkAPL` recursively, and you don't want to have any SubTocs injected into a blockquote.

Notes: a `<<SUBTOC>>` definition must ...
* stand in its own.
* start at the left edge

Note that in case [toc](#) is 0 then no sub topics are inserted, no matter what the actuall setting of `subTocs` is.


#### syntaxSugar

Boolean that defaults to 1. Set this to 0 if you don't want `MarkAPL` carry out the operations that are associated with syntactical sugar. That means not exchanging...

* `...` by ellipses.
* `---` by em-dashes. You may or you may not have blanks around them. 
* `--` by en-dashes. You may or you may not have blanks around them.
* straight quotes by curly quotes.
* It does not replace `(c)` by the copyright symbol.
* It does not replace `(tm)` by the trade-mark symbol. 
* It does not replace `<<` and `>>` by Guillemets.
* Neither `==>` nor `<=-` nor `<==>` are replaced by arrows.

Note that prior to version 3.4 this was called [`markdownStrict`](#).


#### title

In case the document has exactly one level-1 header then `title` defaults to this header. Otherwise it defaults to "MarkAPL". 

Defines the `<title>` tag in the `<head>` section of the resulting HTML page.


#### toc (table of contents){#toc}

An integer or integer vector that defaults to 0, meaning that no table of contents is injected into a document created by `MarkAPL`.

You can change this by setting the parameter `toc` to ...

* a single integer like 3. That is interpreted as "up to 3": a TOC is compiled from the headers of level 1, 2 and 3 and injected into the HTML document. 

* a vector of integers. For example, 2 3 4 5 would mean that just these levels are used for creating the TOC.

* In order to have just one level in your TOC (say level 2) you cannot just specify `toc=2`  because that is interpreted as "all levels up to two" --- it has to be a vector. Specify `toc=2 2` instead; that does the trick.

Note that `bookmarkLink`must have at least the same value as `toc`.

You can specify your own caption with [tocCaption](#).

Notes:

* The main TOC's `<nav>` tag is embraced by a `<div>` that gets the ID `main_nav` assigned to it. 

* You can insert [subTocs](# "sub topics") only if `toc` is not 0.


#### tocCaption

Defaults to "Table of contents". Set this to any character vector you want to appear as header of the TOC. `tocCaption` will be ignored in case `toc` is 0.

Note that this parameter has an effect only when the CSS is injected. Linked CSS must be prepared accordingly.


#### verbose

This parameter is of interest only to APL programmers.

Boolean that defaults to `debug`. If this is 1 then the `Process` method will print the content of `ns.report` to the session.  


#### width

This defaults to `900px`. You can specify this either as a character vector or a numeric value. However, a numeric value always becomes `px` while a character value allows you to specify not only a value but also a different metric, for example `80em`.

Notes:

* This is injected into the screen CSS only. The print CSS uses "auto" for this, allowing to take full advantage of the size of the paper.
* The parameter has an effect only when the CSS is injected. Linked CSS must be prepared properly.


## Problems


### Crashes

When `MarkAPL` crashes the most likely reason is an invalid definition. Check the variable `ns.markdown`: that tells you how far `MarkAPL` got in processing the Markdown. 

However, since `MarkAPL` should not crash and always produce a document it is appreciated when you report any crashes. See the next topic for how to report a crash.


### Bugs

Please report any bugs to <mailto:kai@aplteam.com>. I appreciate:

* The input (Markdown)
* Any non-default settings of parameters
* A short description of the problem (not as short as "It did not work!")

  This is particularly important because I have received a number of bug reports where `MarkAPL` did _exactly_ what it was supposed to do, so without knowing what the user expected I cannot explain why it did not fulfil the user's expectations, because it _did_ work! One gentleman even insisted that there was nothing to explain because it was a no-brainer. Well, it wasn't.
  
  So please tell me what you expect to see.
  
* The version number of `MarkAPL`.


### Unexpected results

Before reporting a bug please check carefully your Markdown. More often than not mistakes in the Markdown are causing the problem.

If you cannot work out why it goes wrong report it to me -- see the previous topic for how to report a problem.


Version information
-------------------

This document refers to version 12.0 of `MarkAPL`.

Kai Jaeger ⋄ 2023-12-10

⍝ Footnotes:
[^meddy]: The Markdown editor Meddy on GitHub:<br><https://github.com/aplteam/Meddy>
[^abandon]: Wikipedia definition of abandonware:<br><https://www.wikiwand.com/en/Abandonware>
[^commonmark]: The CommonMark specification:<br><http://spec.commonmark.org/> 

*[Abbreviations]: Text is marked up with the `<abbr>` tag

⍝ Links:
[cheatsheet]: http://download.aplteam.com/MarkAPL_CheatSheet.htm "The MarkAPL cheatsheet"{target="_blank"}
[commonmark_on_html_blocks]: http://spec.commonmark.org/0.24/#html-blocks "Common mark on HTML blocks"{target="_blank"}
[git]: https://help.github.com/articles/working-with-advanced-formatting/ "GIT's formatting rules"{target="_blank"}
[markdown_extra]: https://www.wikiwand.com/en/Markdown_Extra{target="_blank"}
[pandoc]: http://pandoc.org/README.html{target="_blank"}


















