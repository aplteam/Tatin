[parm]:title             = 'Tatin Syntax Reference'
[parm]:toc               = 2 3 
[parm]:collapsibleTOC    = 1
[parm]:leanpubExtensions = 1

# Tatin Syntax Reference

## User Commands

Every user command comes with at least two and some with three levels of help:

1. `-?` shows a brief description and the syntax
2. `-??` shows a detailed description of the command and its arguments and options
3. `-???` shows examples (only available for some commands)

If the third level is available then `-??` shows this at the bottom:

```
]{API-Function-name} -??? ⍝ Enter this for examples                                        
```

If you want to get everything in a single HTML document then call the API function

```
⎕SE.Tatin.CreateUserCommandsReference ''
```

This function creates an HTML document compiled from all help pages of all of the Tatin user commands.

If the right argument is empty then the file with the fixed name 
"Tatin-User-Command-Syntax.HTML"
is created in the temp folder of your operating system. 

If the right argument is not empty then it is expected to be the folder where the file with the fixed name 
"Tatin-User-Command-Syntax.HTML"
is going to be created. 

The full name of the HTML file is returned as result of the function.


## API

**_Not ready yet_**