[parm]:title             = 'MarkAPL Quick Intro'
[parm]:enforceEdge       = 1
[parm]:leanpubExtensions = 1
[parm]:printCSS          = 'BlackOnWhite_print.css'
[parm]:screenCSS         = 'BlackOnWhite_screen.css'
[parm]:linkToCSS         = 0
[parm]:saveHTML          = 0


Quick introduction to MarkAPL
=============================

By now you probably know that MarkAPL converts Markdown to HTML5.

All you need is the class `MarkAPL` and the namespace script `APLTreeUtils`.


Quick start
----------


Let's assume you have some Markdown:

~~~
      MyMarkdown←'# MarkAPL' 'All about **_MarkAPL_**'
~~~

There are two possible scenarios:


### Convert some Markdown into HTML

All you need to do is to call the `Markdown2HTML` method:

~~~
      (html ns)←MarkAPL.Markdown2HTML MyMarkdown
      50↑∊html
<a id="markapl" class="autoheaderlink"><h1>MarkAPLstrong></p>
~~~

Note that not only the HTML but also a namespace `ns` is returned which, among other stuff, has a variable `report` that might carry warnings and error reports. Ideally `report` is empty.

This way of calling `Markdown2HTML` relies entirely on defaults. If you are not happy with those you must specify parameters in one of two ways:

* Create a parameter space (typically by calling `MarkAPL.CreateParms`), make amendments and pass the namespace via the left argument to `Markdown2HTML`. The next topic explains how to do that.
* Embedd the parameters you need to be different from the defaults into your Markdown. The next but one topic explains how to do that.


### Create a fully fledged HTML page with a parameter space

In order to make **_MarkAPL_** create a complete HTML page you can either specify `outputFilename` or set the `createFullHtmlPage` flag to 1:

~~~
      parms←MarkAPL.CreateParms
      parms.createFullHtmlPage←1
      (html ns)←parms MarkAPL.Markdown2HTML MyMarkdown
      ⍪4↑html
 <!DOCTYPE html>        
 <html>                 
 <head>                 
 <meta charset="utf-8"> 
~~~

Setting `outputFilename` has the additional benefit of writing the HTML to that file. 

Note that `parms` is a namespace that holds variables with default values. You can list them by calling `parms.∆List`.


### Create a fully fledged HTML page with embedded parameters

In order to make **_MarkAPL_** create a complete HTML page you can _embed_ either `outputFilename` or `createFullHtmlPage` into the markdown:

~~~
      (html ns)←MarkAPL.Markdown2HTML (⊂'[parm]:createFullHtmlPage=1'),MyMarkdown
      ⍪4↑html
 <!DOCTYPE html>        
 <html>                 
 <head>                 
 <meta charset="utf-8"> 
~~~


Documentation
------------

Call `MarkAPL.Help 0` in order to view the cheat sheet.

Call `MarkAPL.Reference 0` in order to view the comprehensive documentation.

Note that this requires the files MarkAPL_CheatSheet.html and MarkAPL.html respectively to be found either in the current directory or in a folder `files\` in the current directory.

If those assumptions don't work you must tell `Help` (or `Reference`) where to find the file in question:

~~~
      parms←MarkAPL.CreateHelpParms
      parms.homeFolder←'C:\Where_MarkAPL_HTML_lives'
      parms MarkAPL.Help 0
~~~


The workspace
-------------

The workspace contains not only the two scripts `APlTreeUtils` and `MarkAPL` but also the test suite. To run them execute `#.MarkAPL.MarkAPL.TestCases.Run`. 

For further information regarding the test suite consult the script `#.Tester` in the workspace.


Misc
----

Please send comments, suggestions and bug reports to kai@aplteam.com.   

Kai Jaeger ⋄ APL Team Ltd ⋄ 2016-02-17

Last update: 2019-10-11