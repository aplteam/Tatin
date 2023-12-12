[parm]:toc             = 2 3 4 5 6
[parm]:numberHeaders   = 2 3 4 5 6
[parm]:bookmarkLink    = 6
[parm]:title           = 'MarkAPL CheatSheet'
[parm]:width           = 1000
[parm]:saveHTML        = 1
[parm]:smoothScrolling = 1


MarkAPL Cheatsheet
==================

This document comes with examples for most of the features offered by `MarkAPL`. The documentation is however **not** comprehensive: it provides just enough information to get you going.  

For a comprehensive documentation refer to <http://download.aplteam.com/MarkAPL.html> or, if you use `MarkAPL` within an APL workspace, call the function `MarkAPL.Reference 0`.

Note that all the features related to the so-called LeanPub extensions are discussed in a separate document.

## Headers

These are the standard ways to markup headers:

~~~
# Level 1
## Level 2
### Level 3
#### Level 4
##### Level 5
###### Level 6
~~~

Note that headers may contain only text and code but nothing else.

Headers of level 1 and 2 can also be produced with `=` and `-`:

~~~
This is a level 1 header
========================

This is a level 2 header
------------------------

~~~

Note that before and after such a header a **blank line is required**.

## APL code

APL code can be presented to the reader either as a code block or as inline markup, meaning that the APL code is embedded into a paragraph or cell etc.

Note that [Code blocks](#) and [In-line code](#inlinecode2) are different in many respects.

## Tables

~~~
|Name     |Remark     |No. of users|
|:--------|:---------:|-----------:|
| APL     | Brilliant |        800 |
| Cobol   |       Old |      14000 |
| F#      |      Newer|       3400 |
| Haskell |       New |       3400 |
| Java    |       Just|         74 |
|=========|===========|============|
|Total    |           |      21674 |
~~~

Result:

|Name|Remark|No. of users|
|:---| :-: |---:|
|APL|Brilliant|800|
|Cobol|Old|14000|
|F#|Newer|3400|
|Haskell|New|3400|
|Java|Just|74|
|=|=|=|
|Total|| 21674 |

Simplest possible table: one column, no header, no alignment, no footer:

~~~
--|
10|
20|
30|
~~~

Result:

--|
10|
20|
30|

Notes:

* Leading and closing `|` are optional except for a one-column table.
* A table without a header is possible.
* The (optional) `:` in the line after the header defines the column alignment.

## Lists

List may start right after a paragraph. They break at two empty lines.

### Ordered lists

~~~
2. Second
2. Third
~~~

Result:

2. Second
2. Third

### Unordered lists

~~~
* This
* That
~~~

Result:

* This
* That

### Nested lists

Note that indentation defines what belongs to what.

~~~
* This
* That
  
  A para belonging to `<That>`

  10. Ten
  1.  Eleven
  
      A para belonging to `<Eleven>`
  
  Another para belonging to `<That>`

* More
~~~

Result:

* This
* That
  
  A para belonging to `<That>`

  10. Ten
  1.  Eleven
  
      A para belonging to `<Eleven>`
  
  Another para belonging to `<That>`

* More

Lists may contain paragraphs, code blocks, sub lists and, since version 3.0, tables, blockquotes and images.

## Blockquotes

~~~
> This is a blockquote. Note that a blockquote may contain anything: paragraphs, lists, code blocks, tables, headers, definition lists and even blockquotes.
~~~

Result:

> This is a blockquote. Note that a blockquote may contain anything: paragraphs, 
lists, code blocks, tables, headers, definition lists and even blockquotes.

~~~
> > Nested Blockquote.
~~~

Result:

> > Nested Blockquote.


## Code blocks

Code blocks can be marked up in two different ways:

### Standard markdown fencing

This requires 3 tilde characters:

```
~~~
{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}
~~~
```

Result:
```
{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}
```

You can mention the programming language after the opening fence as shown here:

```
~~~language-apl
{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}
~~~
```

This might be used for syntax highlighting.

### Info string and special attributes
A code block may have an info string or special attributes or both; see the full `MarkAPL` reference for details.


### "Git" style fencing

This requires 3 backticks:

~~~
```
{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}
```
~~~

The result is the same as before.


## Check boxes

You may add check boxes with either `[ ] ` (the space between the two brackets is required to make it an un-ticked check box) or `[x] ` or `[X] `. A line must start with either of them but might also have up to three leading spaces.

```
[X] APL
[ ] Cobol
 [ ] Rust
   [ ] Go
```

leads to this:


[X] APL
[ ] Cobol   
[ ] Rust 
   [ ] Go
    

## Collapsibles and accordions

A collapsible must start with a single line marked up with `!> ` and at least one line marked up with `=> `, but may have more such lines:

```
!> What is the most productive programming language?
=> APL!
```

This leads to:

!> What is the most productive programming language?
=> APL!


### Accordions 

Accordions are just two or more collapsibles in succession. Those are styled differently, making them appear as a single object.

For example, this:

```
!> What can go into a Collapsible?
=> For a start, ordinary paragraphs like this one.
!> What else can go into a Collapsible?
=> Pretty much everything: lists, citations, headers, code blocks...
```

leads to this:

!> What can go into a Collapsible?
=> For a start, ordinary paragraphs like this one.
!> What else can go into a Collapsible?
=> Pretty much everything: lists, citations, headers, code blocks...


## Definition list

~~~
APL
: Best programming language ever

COBOL
: Oh dear
~~~

Result:

APL
: Best programming language ever

COBOL
: Oh dear

## Footnotes

Footnotes can be defined anywhere in the document. They cannot contain anything but paragraphs.

The format of the definition:

~~~
[^footnote]: A multi-line definition.
  As long as the following paras are indented by two spaces they are considered 
  part of the footnote.

  Even an empty line doesn't interrupt the definition, although two do. In-line 
  formatting **is** of course supported.
~~~

Notes:

* The footnote identifiers must be ASCII characters.
* You can refer to this footnote with `[^footnote]` in your document.

## Horizontal lines

~~~
---
~~~

Result:

---

## Paragraphs

Everything that is not identified as something else is considered a paragraph.

## In-line markup

### Bold and italic

The examples use the terms "bold" and "italic" though strictly speaking this is about getting `<em>` and `<strong>` into the HTML. How `<em>` and `<strong>` are actually displayed depends on the CSS styling, though the default styles of all browser make `<em>` look *italic* and `<strong>` **bold**, but you might well change this.

Examples

This:

~~~
A para can contain **bold**, *italic* and **_bold and italic_**.
~~~

result in this:

A para can contain **bold**, *italic* and **_bold and italic_**.

`**` and `__` are interchangeable, and so are `*` and `_` with the exception that `*` and `**` can be used to highlight letters within a word while `_` and `__` cannot:

* `In*si*de ma**rku**p` results in "In*si*de ma**rku**p"
* `In_si_de ma__rku__p` results in "In_si_de ma__rku__p"

### In-line code{#inlinecode2}

In-line code can be marked up by enclosing the code with backticks:

~~~
This `{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}` is an example.
~~~

Result:

This `{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}` is an example.

However, there is much more to this than that once you need to include one or more backticks _inside_ the code; in short you have to enclose any code block between one more backticks then you want to show. For example, if you want to show two backticks:

```
``` These are two (``) backticks```
```

This results in ``` These are two (``) backticks```

Refer to the full documentation for details and other possible complications.

### Strike-through

~~~
This feature ~~is not available~~ was introduced in version x.y
~~~

This feature ~~is not available~~ was introduced in version x.y

### Syntactical sugar

Available options:

| Input  | Outcome | Comment
|--------|---------|--------
| `---`  | ---     | m-dash
| `--`   | --      | n-dash
| `(c)`  | (c)     | copyright
| `(tm)` | (tm)    | trade mark
| `...`  | ...     | ellipses
| `<<`   | <<      | Guillemets
| `>>`   | >>      | Guillemets
| `==>`  | ==>     | Right arrow
| `<==`  | <==     | Left arrow
| `<==>` | <==>    | Left-and-right arrow


### Double quotes

~~~
Pairs of double-quotes (\") are exchanged against their typographically correct equivalents "like here".
~~~

Result:

Pairs of double-quotes (\") are exchanged against their typographically correct equivalents "like here".

Note that Germany, Austria and Switzerland use different characters. `MarkAPL` looks at the HTML parameter `lang` in order to decide which to choose. See the `MarkAPL` reference for details.

Note that a double-quote can --- like any other character --- be escaped by a `\` character. However, escaping is an issue more complex than you might think. Please refer to the reference for details.

### Special HTML characters: <&>

~~~
Since Markdown is a writing format it is easy to write about `<html>` & use tags.
~~~

Result:

Since Markdown is a writing format it is easy to write about `<html>` & use tags.

### Links

#### External links

~~~
External links with 
[The APLTree library on GitHub](https://github.com/aplteam/apltree)
and without link text: 
[](https://github.com/aplteam/apltree)
~~~

Result:

External links with 
[The APLTree library](https://github.com/aplteam/apltree)
and without link text: 
[](https://github.com/aplteam/apltree)

Note that you must specify a protocol ("http://", "https://", "ftp://" etc), otherwise it is not going to be converted. However, if the link contains a `@` characters it is assumed
to be an email address, and the link is converted to a "mailto:" link, so there is no need to specify anything but just the email address.

You can add a title as well as [Special attributes](#) to an external link:

~~~
[The APLTree project on GitHub](https://github.com/aplteam/apltree "This link brings you to the APL wiki"{target="_blank"})
~~~

This is the result:

[The APLTree project on GitHub](https://github.com/aplteam/apltree "This link brings you to the APL wiki"{target="_blank"})

The title is shown when you hover with your mouse over the link.

#### Automated links

A special version of an external link is the so-called automated link. Such a link is suitable only in case the url as such is going to be the link text:

~~~
<https://github.com/aplteam/apltree>
~~~

Note that such a link must specify a protocol like "http://", "https://", "ftp://" etc. The exception is when there is a `@` part of the link: in that case it is converted to a "mailto:" link in any case.

#### Internal links

Since `MarkAPL` assigns automatically anchors to all headers you can establish a link with

~~~
[{Link text}]({Caption})
~~~

You can link to such a header in the current document with a simplified syntax in case the link text **is exactly** the caption:

~~~
Link to the [headers](#) section.
~~~

Do not use this `MarkAPL`-specific feature if your document will be rendered by other means than `MarkAPL`, most notably GitHub and the likes (ReadMe.md!) because that would not work.

Link to the [Headers](#) section.

Naturally it is important that every single header has a unique ID in order to make this work. Therefore `MarkAPL` converts any header to an ID. `MarkAPL` has quite a complex set of rules for how to do this. See [`MarkAPL`'s full documentation](http://download.aplteam.com/MarkAPL.html) for details.

If `MarkAPL` encounters the same header again then it will add a number to it in order to tell them apart.  It will report this on 
[`ns.report`](http://download.aplteam.com/MarkAPL.html#report{target="_blank"})

In such cases --- which should be rare, really --- it is a better idea to assign a unique ID via [Special attributes](#). Of course you must then use this ID when linking to that header, so the simplified syntax is not an option in such cases.

Sometimes the header text does not really fit as link text. Overcome this by specifying:

~~~
Link to the [headers](# "Link text") section.
~~~

#### Link references

Link references consist of two parts:

1. The definition of a link ID together with its URL.
1. References to the link ID.

The definition of such a reference can go anywhere in the document but usually they go to the bottom.

Examples for definitions:

~~~
[1]:      https://aplwiki.com
[git]:    https://github.com "Linus' brain child"{target="_blank"}
[vector]: http://vector.co.uk "The well-respected Journal of the British APL Association"
~~~

You can use the IDs to inject the links into, say, a paragraph:

~~~
This paragraph links to [][1], [][git] and [the APL Journal][vector].
~~~

This paragraph links to [][1], [][git] and [The APL Journal][vector].

Note that [Special attributes](#) can be defined in the definition part but not the link part.

## Images

~~~
![Dots](http://download.aplteam.com/APL_Team_Dots.png "APL Team's dots")
~~~

![Dots](http://download.aplteam.com/APL_Team_Dots.png "APL Team's dots")

## Special attributes

Sometimes one wants to assign special attributes to a certain element. Typical candidates are images, links and tables, although special attributes can assigned to most tags.

This can be achieved by specifying those attributes by putting them to the right of the object in question, enclosed by curly brackets.

For example, in order to specify width and height for an image, add a description and center both, image and description:

~~~
![](http://download.aplteam.com/APL_Team_Dots.png {height="70" width="60" style="display:block;margin:auto;"})
_The logo_ {style="text-align:center;font-size:70%;padding-top:0;margin-top:-5px;"}
~~~

![](http://download.aplteam.com/APL_Team_Dots.png {height="70" width="70" style="display:block;margin:auto;"})

_The logo_ {style="text-align:center;font-size:60%;padding-top:0;margin-top:-5px;"}

Note that the first set of special attributes is assigned to the image as such, while the second set is assigned to the paragraph that comprises "The logo".

You can also assign class and ID to an object via this syntax:

~~~
The logo 
{#logo .center .red}
~~~

This is how the resulting HTML code would look like:

~~~
<p id="logo" class="center red">The logo</p>
~~~

Note that with links any special attributes must be part of the link definition. That means they must be specified to the left of the closing glyph, be it a `>` or a `)`.

## Helpers

There are helper methods available that are designed to help an APL programmer to convert data in a workspace into Markdown.

### Matrix2MarkdownList

If you have a matrix in APL then you can easily convert this into Markdown by calling the method `Matrix2MarkdownList`.

Note that the matrix must have three columns:

1. List type. A 0 defines a bulleted list. Any positive integer starts an ordered list, and defines at the same time the starting point.
2. Nesting level. The first row must start with nesting level 0 or 1.
3. Either a text vector or a vector of text vectors.

This is an example:

~~~
 m←''
 m,←⊂0 1 'Level 1 a bull'
 m,←⊂2 2 'Level 2 a num'
 m,←⊂2 2('Level 2 b num' '' 'Another para' '' '~~~' '{+⌿⍵}' '~~~')
~~~

### Matrix2MarkdownTable

If you have a matrix in APL then you can easily convert this into Markdown by calling the method `Matrix2MarkdownTable`.

Defaults:
* There are no column headers.
* Purely numeric columns are right-aligned.
* All other columns are left-aligned.

Note that via the left argument column headers can be specified. You can use leading and/or trailing colons to define column alignment.

Examples:

~~~
      m←3 3⍴'Kai' 1000 'Remark' 'Thomas' 20 'Blah' 'Max' ¯1 'Foo'
      ch←'Name' 'Points' ':Comments:'
      ⎕←⍪ch #.MarkAPL.Matrix2MarkdownTable m
Name|Points|Comments 
:-|-:|:-:            
Kai|1000|Remark      
Thomas|20|Blah       
Max|¯1|Foo           
~~~

Name|Points|Comments 
:-|-:|:-:            
Kai|1000|Remark      
Thomas|20|Blah       
Max|¯1|Foo 

## Inject data

You can inject key/value pairs into a Markdown document with this syntax:

~~~
[data]:name='Kai Jaeger'
[data]:dob=19310231
~~~

`MarkAPL` itself does not take advantage of such data but you can by referring to it via `ns.data`. 

For details refer to the [`MarkAPL` reference document](http://download.aplteam.com/MarkAPL.html#embedding-parameters-with).

## Inject parameters

With this syntax you can inject key/value pairs into a Markdown document representing parameters:

~~~
[parm]:toc=1 2 3
[parm]:title='My own title'
~~~

Such lines must be the first ones in any document.

`MarkAPL` will use these parameters to overwrite any defaults or settings via a parameter namespace.

For details refer to the [`MarkAPL` reference document](http://download.aplteam.com/MarkAPL.html#embedding-parameters-with).

## Version

This document refers to version 12.0 of `MarkAPL`.<br>
Kai Jaeger ⋄ Last update 2023-12-06

⍝ The link references:
[1]:      https://aplwiki.com
[git]:    https://github.com "Linus' brain child"{target="_blank"}
[vector]: https://sites.google.com/site/baavector/ "The once well-respected Journal of the British APL Association"









