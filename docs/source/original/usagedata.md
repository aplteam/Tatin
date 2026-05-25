---
title: 'Tatin: Usage Data'
description: ''
keywords: 
---
# Usage Data

## Overview

It is natural to assume that package authors would like to know how many people are interested in their packages, or how often a package was downloaded. 


Tatin tries to deliver that information, but there is an obstacle one has to be aware of:

Tatin uses a machine-specific cache when downloading a package in order to save bandwidth and CPU resources in case a package is requested again by either the same user or a different user on the same machine.

So a single download can testify only so much: it might just be an attempt to give a package a try and then forget about it, or it might be used in several different applications, and by multiple users, all but the first one served by the cache. You can't know.

Tatin's test suite requests packages from both the Tatin Server and the Test server, but these requests are flagged as part of a test and ignored when the usage data is compiled.


## What Tatin is doing

With the arrival of a new month, Tatin collects all the data of the current year except the new month and saves them as a CSV file. It then compresses the file and makes it available for download.

The name of the file is `usage-data-<YYYY>-<MM>`. For example, in May 2022 it would save `usage-data-2022-04`, and it would also delete the file `usage-data-2022-03`.

So the filename `usage-data-2022-04` means _all data from 2022 up to and including April_.

Once a year, in January, Tatin collects the data from last year and saves it in a file `usage-data-<YYYY>`. It also deletes any files `usage-data-<YYYY>-<MM>`.

For example, in January 2023 it would create a file `usage-data-2022`, and it would delete all files `usage-data-2022-*`.


## How to retrieve the data


### Web interface

A [Tatin server offers a page](https://tatin.dev/v1/usage-data "Link to the principal Tatin server`s Usage Data page") dedicated to the usage data. The page shows some of the data and also offers links for downloading the data.

### User command

There is a command `]Tatin.UsageData` available for listing and downloading usage data.

Enter `]Tatin.UsageData -??` for details.

### API

There are no API functions available for retrieving usage data.



