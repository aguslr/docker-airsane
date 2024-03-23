#!/bin/sh

# Install drivers
if find /opt/drivers -type f -name '*.deb' 2>/dev/null | grep -q . ; then
	dpkg -i /opt/drivers/*.deb || {
		apt-get update && \
		env DEBIAN_FRONTEND=noninteractive \
		apt-get install -y --fix-broken --no-install-recommends \
		-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
		apt-get clean && rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/*
	}
fi

# Launch UDEV
/lib/systemd/systemd-udevd --daemon

# Start AirSane
/usr/local/bin/airsaned "$@"
