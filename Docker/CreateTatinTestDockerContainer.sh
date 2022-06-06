#!/bin/bash

# Creates a container for the *** Tatin Test server *** that is potentially RIDEable because 4503 is exposed.
# Whether a Ride is possible or not is ruled by the Tatin INI file.
# Note that the port specified with the -p flag for a Ride must match the port specified in the Tatin INI file.
# Note that this does NOT start the container.

docker create -it --name tatin-test --mount type=bind,source="/var/tatin/test",target=/app -p 127.0.0.1:9091:9091 --user 1001  --log-driver local -e RIDE=4503 -p 4503:4503 tatin/v8

