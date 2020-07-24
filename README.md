# docker-dhcpy6d

Dockerfile and related stuff for https://github.com/HenriWahl/dhcpy6d.

Because the main feature of *dhcpy6d* is its access to the requesting clients MAC addresses,
it makes no sense to run inside an own container network.

## How to use it

The work directory inside container is `/dhcpy6d` - the directory `dhcpy6d` is intended to be mounted as volume there.
It should at least contain the file `dhcpy6d.conf`, which has to be configured according to https://github.com/HenriWahl/dhcpy6d/blob/master/doc/dhcpy6d.conf.rst.
For a simple test run the network interface should be set.

If SQLite is choosen as storage for the client leases the delivered `/dhcpy6d/volatile.sqlite` might be used.

To really deliver addresses to clients the option `really_do_it` has to be set to `yes`.

As mentioned above - most useful when being run with `--network host` parameter or `network_mode: host` in `docker-compose.yml` file.
Otherwise there is no way the client MAC addresses could be transmitted.

### docker run

A very simple call might be something like

```
# docker build -t dhcpy6d .
Sending build context to Docker daemon  197.1kB
...
Successfully tagged dhcpy6d:latest
# docker run -dit --rm --name dhcpy6d --network host -v $PWD/dhcpy6d:/dhcpy6d dhcpy6d:latest
2020-07-24 12:45:32,501 dhcpy6d INFO Starting dhcpy6d daemon...
2020-07-24 12:45:32,501 dhcpy6d INFO Server DUID: 000100015f1ad7ec02006649e70d
2020-07-24 12:45:32,510 dhcpy6d INFO Running as user dhcpy6d (UID 999) and group dhcpy6d (GID 999)
2020-07-24 12:45:32,511 dhcpy6d INFO Listening on interfaces: eth0
...
```

### docker-compose

Even simpler is the use of `docker-compose`:

```
# docker-compose up
Building dhcpy6d
...
Creating dhcpy6d ... done
Attaching to dhcpy6d
dhcpy6d    | 2020-07-24 12:46:59,366 dhcpy6d INFO Starting dhcpy6d daemon...
dhcpy6d    | 2020-07-24 12:46:59,366 dhcpy6d INFO Server DUID: 000100015f1ad84302006649e70d
dhcpy6d    | 2020-07-24 12:46:59,376 dhcpy6d INFO Running as user dhcpy6d (UID 999) and group dhcpy6d (GID 999)
dhcpy6d    | 2020-07-24 12:46:59,382 dhcpy6d INFO Listening on interfaces: eth0
...
```