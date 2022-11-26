[parm]:lang              = en
[parm]:leanpubExtensions = 1
[parm]:title             = 'LeanPub Extensions'
[parm]:width             = 1000
[parm]:collapsibleTOC    = 1
[parm]:toc               = 2 3
[parm]:saveHTML          = 0
[parm]:linkToCSS         = 0



LeanPub Extensions
==================


Overview
--------

LeanPub[^leanPub] is a publishing platform for books, especially for technical books.

The input format for LeanPub is markdown. Now markdown does not have the features that are needed to publish books, therefore they came up with some extensions:

1. You can highlight lines in code blocks so that they stand out.

2. You can insert an aside or text box, often used to discuss issues that are slightly off topic, or to add more complex information for advanced readers etc.

3. Several flavours of messages combined with an icon and separated from the main text by some white space. We refer to this as "specialties".

Since version 3.6 MarkAPL understands the LeanPub extensions and marks up the markdown accordingly. Both style sheets coming with MarkAPL have proper mark-up added.

We are going to discuss all extensions in detail.

1. Highlighting Code
-----------------

Code can be highlighted by injecting `leanpub-start-insert` and `leanpub-end-insert` as shown here:

~~~
life←{↑1 ⍵∨.∧3 4=+/,¯1 0 1∘.⊖¯1 0 1∘.⌽⊂⍵)
\leanpub-start-insert
primeNumbers←{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}100
\leanpub-end-insert
dropLeadingBlanks←{(∨\' '≠⍵)/⍵}
~~~

Note that in the code block above the `leanpub-*-insert` strings both show and have no effect, meaning that they have not been processed. This is because there is an escape character (`\`) in front of them in the document itself.

Without the escape character this would have been the result:

~~~
life←{↑1 ⍵∨.∧3 4=+/,¯1 0 1∘.⊖¯1 0 1∘.⌽⊂⍵)
leanpub-start-insert
primeNumbers←{{⍵/⍨2=+⌿0=⍵∘.|⍵}⍳⍵}100
leanpub-end-insert
dropLeadingBlanks←{(∨\' '≠⍵)/⍵}
~~~


2. Asides or Text Boxes
-----------------------

Note that in the markdown asides need to be surrounded by empty lines, otherwise they won't be recognized.

This is a very simple example for an aside or text box:

~~~
A> Asides offer additional information.
~~~

This shows as:

A> Asides offer additional information.

However, inside an aside you can have everything Markdown offers: headers, code block, lists, whatever.

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
A> In-line mark-up is available, too: **bold**, _italic_, `code`, whatever.
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
A> In-line mark-up is available, too: **bold**, _italic_, `code`, whatever.

Notes:

* In case you specify a level-1 (<h1>) or a level-2 (<h2>) header in an Aside it will be converted to a level-3 header (<h3>) anyway. The reason is that many screenreaders read out all <h1> and all <h2> tags. Therefore the W3C recommends to not use headers of the levels 1 and 2 except they really are such headers.

* Headers defined in an Aside do not make it into the table-of-contents, and therefore they don't show in Meddy's tree view --- representing the TOC --- either.


3. Specialties
--------------

Note that in the markdown all specialties need to be embraced by empty lines, otherwise they won't be recognized.

LeanPub offers special mark-up for several purposes:

* Providing information
* Discussions
* Exercises
* Errors
* Warnings
* Questions

We will discuss them in this order.

A word of warning: making use of the specialties prevents any HTML document created by MarkAPL from being truly stand-alone; the icons have to come from somewhere. However, by default they are referred to as a URL pointing to a web address (see MarkAPL's `leanpubIconsUrl` parameter), so when you have an Internet connection it will work fine.

If you like the general idea but not the icons used you can specify a different location and put your favourite icons there. However, you can **not** change the names of the LeanPub extension icons.

Note that in case you specify a level-1 (<h1>) or a level-2 (<h2>) header in a specialty it will be converted to a level-3 header (<h3>) anyway. The reason is that many screenreaders read out all <h1> and all <h2> tags. Therefore the W3C recommends to not use headers of the levels 1 and 2 except they really are such headers.

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

I> # About Specialties 
I> All specialties share a number of properties:
I>
I> * They all have an icon to make it easier to identify them.
I> * They all have plenty of white space in order to tell them apart from ordinary text.
I>
I> They can have headers and multiple paragraphs, but they can also have all the other stuff Markdown is offering, although you should use them with care.


### Discussions

Simple example:

D> Reserve time for discussions

More complex:

D> # Regarding Discussions
D> * Reserve time for discussions
D> * Start early

### Exercise

Simple Example:

X> Today's exercise

More complex:

X> # Exercises
X> ## First
X> Do this!
X> ## Second
X> Do that! Random text with a couple of words. Random text with a couple of words. Random text with a couple of words. Random text with a couple of words. Random text with a couple of words. 
X> ~~~
X> {(+⌿⍵}÷≢⍵}
X> ~~~

### Errors

Simple example:

E> Errors exists only to be made. Off we go!

More complex:

E> # About Errors
E>
E>  There is so much more to say regarding errors...

### Warning

Simple example:

W> Warnings: don't use the LeanPub extension too often.

More complex:

W> # A word of warning
W> Using the LeanPub extensions heavily it unlikely to be a good idea.

### Questions

Simple example:

Q> Any questions?!

More complex:

Q> # Question can be asked.
Q> However, time is a scarce resource, so don't waste it on asking questions that will advertise you as a moron!


## Behind the scenes

All Leanpub extensions are converted into HTML independently from processing the main document. The resulting HTML then replaces the markdown defining them as a one-line HTML block. If necessary additional empty lines are inserted in order to keep the rows in line with the original ones. 

Because HTML blocks are left alone when the actual markdown is processed that works pretty well. There is one downside however: since empty lines define the end of an HTML block any empty lines within a LeanPub extension are converted into `&nbsp;` which in HTML speak is a non-breakable space.

As a side effect of this technique multi-line code blocks loose their newline characters because the HTML is converted into a single line. For that reason `<br>` tags are inserted to preserve those newlines.

This document refers to version 11.0 of **_MarkAPL_**.

Kai Jaeger ⋄ APL Team Ltd ⋄ 2020-10-31

Last Update: 2021-04-14


[^leanPub]: <http://LeanPub.com>