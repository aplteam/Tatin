#!/bin/bash
# Runs the "tatin" container so that it restarts after a crash, and is started automatically after a reboot
docker start tatin
docker update --restart always tatin
