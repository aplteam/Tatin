# Initializing Tatin

## Overview

Note that you need to worry about this only if you use version 18.0: with version 19.0 or later Tatin will be available in `⎕SE` after a standard installation anyway.

Otherwise there are two different scenarios:

* You may establish Tatin in `⎕SE` via a script `setup.dyalog` in your `MyUCMDs\` folder.

  * If that script does not yet exist you may create it and add a Tatin-specific line to it.

  * If there is already such a script you may add a Tatin-specific line to it.

  `setup.dyalog` is executed at a very early stage when Dyalog APL is instanciated. As a result Tatin is already loaded into `⎕SE` when you gain control over the session.

  The disadvantage of this approach is that Tatin will always be loaded, no matter whether you need it or not.

* Instead you may force Tatin's initialization by executing any Tatin user command: it will realize that Tatin as such has not been established in `⎕SE` yet, and do that for you. 

  The disadvantage of this approach is that the Tatin API is only available after having executed any Tatin user command.

## On `setup.dyalog`

⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹⌹