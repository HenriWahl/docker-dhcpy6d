# docker-dhcpy6d

Dockerfile and related stuff for https://github.com/HenriWahl/dhcpy6d.

Details will follow - it shall be noted at least that the resulting container makes most sense when being run with parameter `--network host`.

## Some facts, to be ordered

- Work directory inside container is `/dhcpy6d` - the directory `dhcpy6d` is intended to be mounted as volume there.
- `/dhcpy6d/dhcpy6d.conf` has to be configured according to https://github.com/HenriWahl/dhcpy6d/blob/master/doc/dhcpy6d.conf.rst. For a simple test run the network interface should be set.
- As mentioned above - most useful when being run with `--network host`. Otherwise there is no way the client MAC addresses could be transmitted.
