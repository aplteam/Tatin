[parm]:lang              = en
[parm]:leanpubExtensions = 1
[parm]:title             = 'LeanPub Extensions'
[parm]:width             = 1000
[parm]:toc               = 2 3
[parm]:saveHTML          = 1



LeanPub Extensions
==================


Overview
--------

LeanPub[^leanPub] serves as a publishing platform primarily designed for technical books.

The input format for LeanPub is Markdown. However, Markdown lacks certain features required for publishing books. As a solution, LeanPub introduced extensions to Markdown:

Code Highlighting

: You can emphasize lines within code blocks.

Asides or Text Boxes

: Used to discuss tangential topics or provide advanced information.

Specialties

: Distinct message types combined with icons for various purposes.

Starting from version 3.6, `MarkAPL` has incorporated support for LeanPub extensions, enhancing Markdown with proper markup in all `MarkAPL` style sheets.

Let's explore these extensions in detail.


1. Highlighting Code
-----------------

Code highlighting involves using leanpub-start-insert and leanpub-end-insert tags as illustrated here:

~~~
life←{↑1 ⍵∨.∧3 4=+/,¯1 0 1∘.⊖¯1 0 1∘.⌽⊂⍵)
\leanpub-start-insert
primeNumbers←{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}100
\leanpub-end-insert
dropLeadingBlanks←{(∨\' '≠⍵)/⍵}
~~~

Note that the leanpub-*-insert strings in the code block above are visible but have no effect due to an escape character (\) before them in the document itself. 

Without the escape character, the result would be:

~~~
life←{↑1 ⍵∨.∧3 4=+/,¯1 0 1∘.⊖¯1 0 1∘.⌽⊂⍵)
leanpub-start-insert
primeNumbers←{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}100
leanpub-end-insert
dropLeadingBlanks←{(∨\' '≠⍵)/⍵}
~~~

On the screen the line in question is highlighted by colour; when printed it is bold.


2. Asides or Text Boxes
-----------------------

Asides require empty lines around them in Markdown to be recognized. A simple example:

~~~

A> Asides offer additional information.


~~~

This appears as:

A> Asides offer additional information.

Inside an aside, Markdown features like headers, code blocks, lists etc. are available:

~~~
A> ### This offers information about asides
A>
A> Asides can hold everything that's available in Markdown.
A>
A> #### Examples:
A>
A> ~~~
A> {(+⌿⍵}÷≢⍵}
A> ~~~
A>
A> * List item 1
A> * List item 2
A>
A> > Asides are great.
A>
A> Inline markup is available, too: **bold**, _italic_, `code`, whatever.
~~~

This shows as:

A> ### This offers information about asides
A>
A> Asides can hold everything that's available in Markdown.
A>
A> #### Examples:
A>
A> ~~~
A> {(+⌿⍵}÷≢⍵}
A> ~~~
A>
A> * List item 1
A> * List item 2
A>
A> > Asides are great.
A>
A> Inline markup is available, too: **bold**, _italic_, `code`, whatever.

Notes:

* In case you specify a level-1 (`<h1>`) or a level-2 (`<h2>`) header in an Aside on the first line it will be converted to a level-3 header (`<h3>`) anyway. The reason is that many screenreaders read out all `<h1>` and all `<h2>` tags. Therefore the W3C recommends to not use headers of the levels 1 and 2 except they really are such headers.

  However, later headers are not changed, so you are in charge to give them the correct level.

* Headers defined in an Aside do not make it into the table-of-contents, and therefore they don't show in Meddy's tree view --- representing the TOC --- either.


3. Specialties
--------------

Specialties are embraced by empty lines in Markdown. LeanPub offers special markup for various purposes:

* Information
* Discussions
* Exercises
* Errors
* Warnings
* Questions

Detailed examples of each specialty are provided in the text.

~~A word of warning: making use of the specialties prevents any HTML document created by `MarkAPL` from being truly stand-alone; the icons have to come from somewhere. However, by default they are referred to as a URL pointing to a web address (see `MarkAPL`'s `leanpubIconsUrl` parameter), so when you have an Internet connection it will work fine.~~

With version 12.0 the PNGs used as icons were converted into SVGs; they will be injected into the document if required, so the document is truly stand-alone even when LeanPub icons are used.


### Information

This:

```
~~~
I> A piece of information.
~~~
```

leads to this:

I> A piece of information.

Here is a more complex example:

```
~~~
I> # About Specialties 
I> All specialties share a number of properties:
I>
I> * They all have an icon to make it easier to identify them.
I> * They all have plenty of white space around them in order to tell them apart from ordinary text.
I>
I> They can have headers and multiple paragraphs, but they can also have all the other stuff Markdown is offering, although it is not recommended to use them.
~~~
```

This is the result:

I> ### About Specialties 
I> All specialties share a number of properties:
I>
I> * They all have an icon to make it easier to identify them.
I> * They all have plenty of white space in order to tell them apart from ordinary text.
I>
I> They can have headers and multiple paragraphs, but they can also have all the other stuff Markdown is offering, although you should use them with care.


### Discussions

This:

```
D> Reserve time for discussions
```

results in:

D> Reserve time for discussions

More complex:

D> # Regarding Discussions
D> * Reserve time for discussions
D> * Start early

### Exercise

This:

```
X> Today's exercise
```

results in:

X> Today's exercise

More complex:

X> ### Exercises
X> #### First
X> Do this!
X> #### Second
X> Do that! Random text with a couple of words. Random text with a couple of words. Random text with a couple of words. Random text with a couple of words. Random text with a couple of words. 
X> ~~~
X> {(+⌿⍵}÷≢⍵}
X> ~~~

### Errors

This:

```
E> Errors exists only to be made. Off we go!
```

results in:

E> Errors exists only to be made. Off we go!

More complex:

E> # About Errors
E>
E>  There is so much more to say regarding errors...

### Warning

This:

```
W> Warnings: don't use the LeanPub extension too often.
```

results in:

W> Warnings: don't use the LeanPub extension too often.

More complex:

W> # A word of warning
W> Using the LeanPub extensions heavily it unlikely to be a good idea.

### Questions

This:

```
Q> Any questions?!
```

results in:

Q> Any questions?!

More complex:

Q> # Question can be asked.
Q> However, time is a scarce resource, so don't waste it on asking questions that will advertise you as a moron!


### Tips

This:

```
T> Use the debugger for this.
```

results in:

T> Use the debugger for this.

More complex:

T> # Finding bugs
T> Using the debugger is an invaluable resource for identifying the cause of bugs.


Behind the scenes
-----------------

All Leanpub extensions are converted into HTML independently from processing the main document. The HTML then replaces the Markdown as a one-line HTML block. If necessary additional empty lines are inserted in order to keep the rows in line with the original ones. 

Because HTML blocks are left alone when the actual Markdown is processed that works pretty well. There is one downside however: since empty lines define the end of an HTML block, any empty lines within a LeanPub extension are converted into `&nbsp;` which in HTML speak is a non-breakable space.

As a side effect, multi-line code blocks loose their newline characters because the HTML is converted into a single line. For that reason `<br>` tags are inserted to preserve those newlines.

This document refers to version 12.0 of `MarkAPL`.

Kai Jaeger ⋄ 2020-10-31

Last Update: 2023-12-10


[^leanPub]: <http://LeanPub.com>







