[parm]:title = 'Register group'


# Register a group

## Overview

Registering a group implies to get access to an API key. That allows a user to publish to the Tatin Registry.

## Data required

The user must specify:

* A group name (mandatory)
* A contact name (mandatory)
* An email address (mandatory)
* A second email address (optional)
* An telephone number (optional)
* An company name (optional) 


## API key

An API key is generated as a password (together with a SALT) and published to the user. Just the SALT and the hash are saved.


## Captcha

We have to keep the bad guys at bay, and for that we need a kind of captcha.

I suggest to present 5 APL characters to the user. 4 of them represent functions and operators but one does not, and we require that one to be identified.

For example:

--- 

Which of the following glyphs represent in APL neither a function nor an operator?

[ ] `↑`
[ ] `⍴`
[ ] `⊃`
[x] `#`
[ ] `⊣`

--- 

Functions:

: `⌶%⊢⊣⌷¨⍨/⌿\⍀<≤=≥>≠∨∧-+÷×?∊⍴~↑↓⍳○*⌈⌊∘⊂⊃∩∪⊥⊤|,⍱⍲⍒⍋⍉⌽⊖⍟⌹!⍕⍎⍪≡≢∣⍷⍣`

We don't include any of `@&` in order to avoid confusion.

Non-functions:

: `'⍺⍵_¯[∇(;⍫"#⋄←→⍝)]⎕⍞'`   

We don't include any of `{}` in order to avoid confusion.


## Deleting a registered group

We must be prepared that someone will manage to register a group who shouldn't, because the captcha won't give us perfect protection, though it does require a human to take action.

Therefore, it must be possible to delete a registered group name together with it's "home page" automatically by a REST call with a particular API key.

For that we need to introduce the concept of a super user. Only super users are allowed to delete groups and packages (even when a non-delete policy is operated on a server).


