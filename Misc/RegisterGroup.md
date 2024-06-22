[parm]:title = 'Register group'


# Register a group

## Overview

Registering a group implies to get access to an API key. That allows a user to publish to the Tatin Registry.

## Data required

The user must specify:

* A contact name
* An email address
* A second optional email address
* An optional telephone number
* An optional company name
* The mandatorygroup name


## API key

We generate an API key as a password (together with a SALT) and publish it to the user but don't save the API key.


## Captcha

We have to keep the bad guys at bay, and for that we need a kind of captcha.

I suggest to present 5 APL characters 4 of which represent functions and operator but one does not, and we required that one to be identified.

For example:

> Which of the following glyphs represent in APL neither a function nor an operator?
>
> [ ] `↑`
> [ ] `⍴`
> [ ] `⊃`
> [x] `#`
> [ ] `⊣`


