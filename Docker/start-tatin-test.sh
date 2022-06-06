#!/bin/bash

# Starts the "tatin-test" container so that it restarts after a crash, and is started automatically after a reboot

docker start tatin-test
docker update --restart always tatin-test
