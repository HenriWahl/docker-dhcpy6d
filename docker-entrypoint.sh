#!/bin/sh

# set user dhcpy6d as owner of all dhcpy6d-related files
chown -R dhcpy6d:dhcpy6d /dhcpy6d

# run daemon
/usr/sbin/dhcpy6d --config dhcpy6d.conf --user dhcpy6d --group dhcpy6d