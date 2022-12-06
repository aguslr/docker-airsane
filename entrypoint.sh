#!/bin/sh

# Launch UDEV
/lib/systemd/systemd-udevd --daemon

# Start AirSane
/usr/local/bin/airsaned "$@"
