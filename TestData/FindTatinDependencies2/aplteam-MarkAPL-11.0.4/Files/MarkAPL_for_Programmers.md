[parm]:toc               = 2 3
[parm]:numberHeaders     = 2 3 4 5 6
[parm]:bookmarkLink      = 6
[parm]:title             = 'MarkAPL for programmers'
[parm]:width             = 1000
[parm]:reportLinks       = 1
[parm]:collapsibleTOC    = 1
[parm]:printCSS          = 'BlackOnWhite_print.css'
[parm]:screenCSS         = 'BlackOnWhite_screen.css'
[parm]:smoothScrolling   = 1
[parm]:saveHTML          = 0
[parm]:linkToCSS         = 0
[parm]:leanpubExtensions = 1




MarkAPL for Programmers
=======================


Overview
--------

This document is of interest only if you use **_MarkAPL_** within an APL application as an APL programmer.

If you use it implicitly, say by editing a Markdown file with Meddy[^meddy], then the cheat cheet and the **_MarkAPL_** reference document should suffice.


How to
------

One way to study how to make use of **_MarkAPL_** is to trace through the method `MarkAPL.Help`. This should clarify the principles.


A> ### The MarkAPL project
A>
A> Another way is to look at the test cases named `Test_Examples_01` etc. in `#.TestCases` in the workspace MarkAPL.DWS. However, in order to be able to do that you need to take a copy of the [MarkAPL project on GitHub](https://github.com/aplteam/MarkAPL).
A> 
A> In order to run those test cases you first need to prepare the test suite:
A>
A> ```
A> )CS #.MarkAPL.TestCases
A> Prepare
A> ```
A> Now you can execute them with:
A> 
A> ~~~
A> T.RunThese 'Examples'
A> ~~~
A>
A> You can execute specific ones:
A>
A> ~~~
A> T.RunThese 'Examples' (1 3)
A> ~~~
A>
A> You can trace through them with
A>
A> ~~~
A> 1 T.RunThese 'Examples'
A> ~~~
A> 
A> The left argument makes sure that the test suite stops just before any test case is executed.


Methods
-------

<<SubTOC>>

Note that all [helpers](#Helpers) are discussed separately.


### `ConvertMarkdownFile`

Takes a filename as right argument. The file is expected to hold Markdown. By default a fully-fledged HTML page is created from that Markdown file with exactly the same filename except that the file extension is `.html` rather than `.md`.

However, instead of accepting the defaults one can create a parameter namespace with:

~~~
parms←MarkAPL.CreateParms
~~~

and then specify different parameters within `parms`. That parameter space `parms` then needs to be passed as left argument to the `ConvertMarkdownFile` method.

Note that `inputFilename` **must not** be specified, otherwise an error is signalled. This is because the input file is already defined by the right argument.


### `CreateParms`

Niladic function that returns a namespace populated with parameters carrying their default values. 

`CreateParms` tries to find for every parameter a value from the command line or environment variables. If it cannot find them it will establish a default value.

The namespace returned by the `CreateParms` method has a built-in method `∆List` which is niladic and will return a matrix with two columns, the parameter name in the first column and the default value in the second column.

Note that a value of `¯1` means that there is not really a default available but a reasonable value will be determined at a later stage, usually depending on the context.


### `CreateHelpParms`

Niladic function that returns a namespace populated with parameters carrying their default values. Internally it calls `CreateParms` and then adds some parameters that are needed by the [`Help`](#) and [`Reference`](#ref_method) methods.
  
    
### `Execute`

This function is used exclusively by test cases.
  
        
### `Help`

The function takes a Boolean right argument: 
* A 0 just views "MarkAPL_CheatSheet.html" with your default browser.
* A 1 forces `Help` to recompile the file "MarkAPL_CheatSheet.md" into 
  "MarkAPL_CheatSheet.html" and then puts it on display with your default browser.

You might specify an optional left argument: a parameter space, typically created by calling the `CreateHelpParms` method. This allows creating a document with non-default parameters. Of course this has only an effect when the right argument is a 1. 

Note that the file "MarkAPL_CheatSheet.html" carries several embedded parameters --- those cannot be overridden by a parameter namespace unless you assign a 1 to `ignoreEmbeddedParms`.

In order to enable `Help` to find the file "Markdown_CheatSheet.html" (in case the defaults don't work) you must create a parameter space and then set `homeFolder` accordingly.

If you specify a 1 as right argument but `Help` can only find the HTML file but not the markdown file it will ignore the right argument and just put the file on display with your default browser.
 
            
### `Init`

Takes a two-item-vector as right argument:

1. A parameter namespace, typically created by calling `CreateParms`.
2. A vector of character vectors: the Markdown.

Returns [The "ns" namespace](#).  

Note that after executing `Init` [`ns.report`](#report) might well carry warnings that are misleading. An example for this are links inside a LeanPub block: because the LeanPub stuff is already converted in `Init` MarkAPL cannot (yet) judge whether the links are okay or not.

Therefore at the end of converting the full document the warnings are investigated again, and any warnigns that are now obsolete are removed.

             
### `MakeHTML_Doc`

Takes HTML, typically created by calling `Process`, and makes it a fully fledged HTML document by adding <body>, <head> --- with <title> --- and <html> with the DocType.
 
    
### `MarkDown2HTML`

This ambivalent function requires some Markdown as right argument.

It returns (since version 1.7.0) a two-item vector (shy):

* The HTML.
* The `ns` namespace. This allows you to check `ns.report` for any problems.

Without an --- optional --- left argument it creates just the HTML from the Markdown.

However, you can also create a parameter space by calling `CreateParms` and set `outputFilename`. In that case it will create a fully-fledged HTML page from the Markdown and write it to that file. The generated page is also returned as result.

Finally one can also set the `inputFilename` parameter. This trumps the right argument: it reads the input file, expecting it to be Markdown, creates HTML5 from it and write it to the output file. Again the HTML is also returned as result.

Internally it calls `Init` & `Process` & `MakeHTML_Doc`. 

Note that in case the parameter `createFullHtmlPage` is `¯1` (the default value which means "undefiend") the default behaviour of `MarkDown2HTML` is defined by the setting of the parameter `outputFilename`: if `outputFilename` is not empty then `createFullHtmlPage` will default to 1, otherwise to 0, and that's what `Markdown2HTML` will take into account.


### `Process`

This function takes --- and returns --- an `ns` namespace which was typically created by calling `Init`. 


### `Reference` {#ref_method}

The function takes a Boolean right argument: 
* A 0 just views "MarkAPL.html" with your default browser.
* A 1 forces it to recompile the file "MarkAPL.md" into "MarkAPL.html" and then puts it on display with your default browser.

You might specify an optional left argument: a parameter space, typically created by calling the `CreateHelpParms` method. This allows creating a help file with non-default parameters. Of course this has only an effect when the right argument is a 1. 

Note that the file "MarkAPL.html" carries several
embedded parameters --- those cannot be overridden by a parameter namespace unless you assign a 1 to `ignoreEmbeddedParms`.

In order to enable `Reference` to find the file "MarkAPL.html" (in case the defaults don't work) you must create a parameter space and then set `homeFolder`.

If you specify a 1 as right argument but `Reference` can only find the HTML file but not the markdown file it will ignore the right argument and just put the file on display with your default browser.
 
### `Version`

Returns the name, the version number --- including the built-ID --- and the version date of **_MarkAPL_**.


Parameters
----------

In order to specify parameters follow these steps:

~~~
      parms←MarkAPL.CreateParms''
      parms.∆List   ⍝ lists all parameters with their defaults
 bookmarkLink                                                    6 
 bookmarkMayStartWithDigit                                       1
 charset                                                     utf-8 
 checkFootnotes                              ⍝ defaults to "debug"
 checkLinks                                  ⍝ defaults to "debug"
 collapsibleTOC                                                  0
 compileFunctions                                                1 
 compressCSS                                                     1
 createFullHtmlPage                                              0
 cssURL                                                         ¯1
 debug                                 ⍝ 0 in Runtime, 1 otherwise
 div_h_tag                                                       1
 enforceEdge                                                     1
 footnotesCaption                                      'Footnotes'
 head                                                           '' 
 homefolder                                                     ¯1
 inputFilename                                         
 lang                                                         "en"
 leanpubExtensions                                               0
 leanpubIconsUrl    'https://download.aplwiki.com/LeanPub/Images/'
 lineNumberOffset                                                0
 linkToCSS                                                       0 
 markdownStrict                                                  0 
 noCSS                                                           0
 numberHeaders                                                   0 
 outputFilename                                        
 printCSS                                        MarkAPL_print.css 
 reportLinks                                                     0
 reportLinksCaption                                  'Link report'
 screenCSS                                      MarkAPL_screen.css
 subTocs                                                         1 
 syntaxSugar                                                     1
 title                                                     MarkAPL 
 toc                                                             0 
 verbose                                                         1 
 width                                                       900px
~~~

The function `∆List` lists all the variables in the parameter space with their corresponding values.

After making amendments the parameter space can be passed as the first argument to the `MarkAPL.Init` function. See [How-to](#) for details. 

The parameters themselves are discussed in the **_MarkAPL_** reference.


Function calls
--------------

It is possible to embed APL function calls in your Markdown document. The simplest way to call a function `#.foo` is:

~~~
This: ⍎⍎#.foo⍎⍎ is the result.
~~~

Given a function `#.foo←{'FOO'}` this will be the result:

~~~
This: FOO is the result.
~~~

The purpose of this feature is to either inject simple text or one or more HTML blocks.

Notes:

* You cannot inject Markdown block elements like lists, code blocks, block quotes, etc: it won't be processed any more when the function is called. However, in-line mark-up (`**`, `_`, `~~` etc) **is** recognized and processed, and so is typographical sugar.
* The function name must always be fully qualified; that means the function 
  cannot live in either a class instance or an unnamed namespace.
* The `ns` namespace is **always** provided as right argument to the function, therefore the function must be either monadic or dyadic.

You may specify something to the right as in this example:

~~~
This: ⍎⍎#.foo 1 2 'hello'⍎⍎ is the result.
~~~

The array `1 2 'hello'` is however passed as **left** argument since `ns` is always passed as the right argument.

The result of such an embedded function must be one of:

* An empty vector.
* Markdown (simple string or nested vector of text vectors).
* An HTML block (nested vector of text vectors).

Note that mixing Markdown and HTML blocks is **not permitted**. 

In case the function returns an HTML block the function call must stand on its own on a line.

If an HTML block is returned then the function is responsible for the correct formatting. In particular a `<pre>` block **must** look like this otherwise you might not get the desired result:

~~~
<pre><code>Line 1
Line 2
Last line
</code></pre>
~~~

Notes:

* If the function returns something that starts with a `<` and ends with a 
  corresponding tag then it is recognized as an HTML block. You can prevent that by adding leading spaces.
* The `<pre><code>` must go onto the same line as the first line of the code; 
  otherwise you end up with a starting empty line.
* If the embedded function returns something with a depth different from 0, 1 
  and 2 an error is thrown.
* Anything that is supposed to be recognized as an HTML block **must not** carry any leading spaces: an HTML block starts by definition with a `<` char.


The `ns` namespace.
-------------------


### Overview{#OV4}

The `ns` namespace is returned (created) by the `Init` method and modified by the `Process` method. It contains both input and output variables.

Before `Process` is run the variables `emptyLines`, `leadingChars`, `markdown`, `markdownLC `and `withoutBlanks` hold data that is extracted from the Markdown. 

`Process` then splits the markdown into appropriate blocks, and processes them one after the other, and removes from these variables. 

At the same time the variable `parms.html` is collecting the resulting html. Other variables (`abbreviations`, `data`, `footnoteDefs`, `headers`, `linkRefs`, `parms`, `subToc` and `toc`) may or may not collect data in the process as well.

The two variables `report` and `lineNumber` are special, see there.


### The ns namespace in detail {#ns_details}

<<SubTOC>>

The namespace contains the following variables:


#### abbreviations

A (possibly empty) vector of two-item-vectors. The first item holds the abbreviation, the second item the explanation or comment. 
  
       
#### emptyLines

A vector of Booleans indicating which lines in `markdown` are empty. Lines consisting of white-space characters only are considered empty.


#### embeddedParms

A matrix with two columns and as many rows as there are embedded parameters.

This document for example carries these embedded parameters:

~~~
      ns.embeddedParms
 toc                            2 3 
 numberHeaders            2 3 4 5 6 
 bookmarkLink                     6 
 viewInBrowser                    1 
 collapsibleTOC                   1 
 title            MarkAPL Reference 
 width                         1100 
 reportLinks                      1 
~~~


#### footnoteDefs

A matrix that carries all footnote definitions found in `markdown`. The matrix has these columns:

1. Running number, starting from 1. 
1. Bookmark name.
1. Caption.


#### headerLineNos

An integer vector that carries the line numbers of `headers`.


#### headers

A matrix that carries all headers defined in `markdown`.

The matrix has three or four columns:

1. The level of the header, starting with 0.
1. The anchor-ready version of the caption.
1. The caption.
1. The tiered number of the header. 

Naturally the last column does not exist in case `numberHeaders` is 0.
 
      
#### html

After having created the `ns` namespace by calling `Init` this variable is empty. By running the `Process` method this variable will be filled up.


#### leadingChars

After having created the `ns` namespace by calling `Init` this variable contains a limited number of characters from `markdown`. Leading white-space is removed. This increases performance for many of the checks to be carried out by `Process`.  


#### lineNumbers

After having created the `ns` namespace by calling `Init` this variable contains a vector of integers representing line numbers in `markdown`. This allows the current line number to be reported in case there is a problem like odd number of double quotes, invalid internal links etc. Note that function calls (See "Embedded APL function calls" in the **_MarkAPL_** reference) can access the line numbers as well.

Note that line numbers refer to the MarkDown rather than the HTML.  

See also the parameter `lineNumberOffset` in the **_MarkAPL_** reference.
  

#### linkRefs

A vector of vectors holding information regarding all link references (see the **_MarkAPL_** reference for details regarding link references):

1. id
1. url
1. alt text or empty
1. special attributes or empty


#### markdown

This variable holds the Markdown to be processed by `Process`.
  
   
#### markdownLC

Same as `markdown` but all in lower case. That speeds things up at the expense of memory.
  
 
#### noOf

The number of lines processed in the next (or current) step.
  
     
#### parms

The parameters that were passed to `Init`.
  
      
#### report

After having created the `ns` namespace by calling `CreateParms` this variable is empty. Both the `Init` and the `Process` method might add remarks to this variable in case it finds something to complain about or comment on. However, you are advised to ignore warnings after having executed just `Init`. 

Some methods print what they assign to `report` also to the session in case the parameter `verbose` is 1.


#### subToc

This is a vector of two-item vectors:

1. The level of the header, starting with 1.
2. The caption of the header as displayed.


#### toc{#ns_toc}

This is a vector of ~~four~~ three-item vectors:

1. The level of the header, starting with 1.
2. The caption of the header as displayed.
3. The internal link name.

Note that prior to version 2.8 there was a forth column (4. The type of the header: 1 = SeText, 2 = ATX.) which was removed then.
  
     
#### withoutBlanks

Same as `markdown` but without any blanks. This speeds things up at the expense of memory.


Helpers
-------

This chapter comprises all methods that help converting APL arrays into Markdown.

<<SubTOC>>


### Matrix2MarkdownList

This helper method takes an APL matrix and converts it to a list definition in Markdown.

Note that the table must have three columns:

1. List type. A 0 defines a bulleted list. Any positive integer starts an ordered list, and defines at the same time the starting point.
2. Nesting level. The first row must start with nesting level 0 or 1.
3. Either a text vector or a vector of text vectors.

Example:

~~~
 m←''
 m,←⊂0 1 'Level 1 a bullet point'
 m,←⊂2 2 'Level 2 a num'
 m,←⊂2 2('Level 2 b num' '' 'Another para' '' '~~~' '{+⌿⍵}' '~~~')
 m,←⊂2 2 'Level 2 c num'
 md←MarkAPL.Matrix2MarkdownList⊃m
 ns←MarkAPL.Init''md
 ns←MarkAPL.Process ns
~~~

leads to this list:

* Level 1 a bullet point  
  2. Level 2 a num 
  2. Level 2 b num 
                   
     Another para  
                   
     ~~~
     {+⌿⍵}         
     ~~~

  2. Level 2 c num 


### Matrix2MarkdownTable

This helper method takes an APL matrix and converts it to a table definition in Markdown.

Without a left argument there are no column headers, and alignment is ruled by data type: strictly numeric columns are right-aligned, everything else is left-aligned:

~~~
      M←('APL' 99 'Really great')('Python' 70 'Nice')('Cobol' 1 'Oh dear')
      ⎕←MarkAPL.Matrix2MarkdownTable M
|-|--|-|
| APL | 99 | Really great |
| Python | 70 | Nice |
| Cobol | 1 | Oh dear |
~~~

This results in this:

| :- | --: | :- |            
| APL | 99 | Really great | 
| Python | 70 | Nice |      
| Cobol | 1 | Oh dear |     

You can specify column headers via the left argument. Naturally the length of the left argument must match the number of columns in the matrix. You can use leading and trailing `:` in order to define column alignment.

Note that any `|` in the matrix is automatically escaped except when it appears in code:

~~~
      ch←'Lang' 'Prod:Rank' ':Comment:'
      M←('APL' 99 'Really great')('Python' 70 'Nice')('Cobol' 1 'Oh|dear')
      ⎕←MarkAPL.Matrix2MarkdownTable M
| Lang | Prod:Rank | Comment |
|-|-|:-:|
| APL | 99 | Really great |
| Python | 70 | Nice `|`|
| Cobol | 1 | Oh\|dear |
~~~

This results in this:

| Lang | Prod:Rank | Comment |
|-|-:|:-:|
| APL | 99 | Really great |
| Python | 70 | Nice `|`|
| Cobol | 1 | Oh\|dear |

Notes:
* The first column is aligned to the left because the column title did not 
  define anything and the data is not strictly numeric, therefore the default takes place which is left-aligned.
* The second column is aligned to the right because the column title did not 
  define anything and the data is numeric.
* The third column is centered because that's what the column header defined.

Problems
-------


### Bugs

Please report any bugs to <mailto:kai@aplteam.com>. I appreciate:

* The input (Markdown)
* Any non-default settings of parameters
* A short description of the problem (not as short as "It did not work!")

  This is particularly important because I have received a number of bug reports where **_MarkAPL_** did _exactly_ what it was supposed to do, so without knowing what the user expected I cannot explain why it did not fulfil the user's expectations, because it _did_ work! 

  One gentleman even insisted that there was nothing to explain because it was a no-brainer. Well, it wasn't.
  
  So please tell me what you expect to see.
  
* The version number of **_MarkAPL_**.


### Unexpected results

Before reporting a bug please check carefully your Markdown. More often than not mistakes in the Markdown are causing the problem.

If you cannot work out why it goes wrong report it to me -- see the previous topic for how to report a problem.

This document refers to version 11.0 of **_MarkAPL_**.

Kai Jaeger ⋄ APL Team Ltd ⋄ 2021-10-12

[^meddy]: The Markdown editor Meddy on GitHub:<<br>><https://github.com/aplteam/Meddy>
[^abandon]: Wikipedia definition of abandonware:<<br>><https://www.wikiwand.com/en/Abandonware>
[^commonmark]: The CommonMark specification:<<br>><http://spec.commonmark.org/> 

*[Abbreviations]: Text is marked up with the <abbr> tag

[cheatsheet]: http://download.aplteam.com/MarkAPL_CheatSheet.htm "The MarkAPL cheatsheet"{target="_blank"}
[commonmark_on_html_blocks]: http://spec.commonmark.org/0.24/#html-blocks "Common mark on HTML blocks"{target="_blank"}
[git]: https://help.github.com/articles/working-with-advanced-formatting/ "GIT's formatting rules"{target="_blank"}
[markdown_extra]: https://www.wikiwand.com/en/Markdown_Extra{target="_blank"}
[pandoc]: http://pandoc.org/README.html{target="_blank"}