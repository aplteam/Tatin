This folder contains scripts useful for:
 
* Creating a Docker image that can run a Tatin Server
* Creating containers for a production server and a test server
* Starting the tatin containers so that they are restarted automatically in case of a crash or a reboot

Most potential adaptions can be done in the Tatin INI file - there should be no
need for any changes in this file except the versions of Dyalog APL 
(The version of .NET is not of interest anymore because from 0.68.0 onwards Tatin does not rely
on .NET on non-Windows platforms)

What the scripts are doing:

1. Call  ./BuildImage.sh for creating the image
2. Check CreateTatinDockerContainer.sh
3. Call  CreateTatinDockerContainer.sh
4. Call  start-tatin.sh - this ensures that the container is restarted after a crash or a reboot

 Kai Jaeger - kai@aplteam.com
