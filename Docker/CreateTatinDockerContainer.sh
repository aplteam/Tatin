#!/bin/bash

# Creates a container for the *** Tatin production server *** that is potentially RIDEable because 4502 is exposed.
# Whether a Ride is possible or not is ruled by the Tatin INI file.
# Note that the port specified with the -p flag for a Ride must match the port specified in the Tatin INI file.
# Note that this does NOT start the container.

docker create -it --name tatin --mount type=bind,source="/var/tatin/prod",target=/app -p 127.0.0.1:9090:9090 --user 1001 --log-driver local -p 4502:4502 tatin/v8
