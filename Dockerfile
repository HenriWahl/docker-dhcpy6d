# base image for build and runtime
FROM alpine:3.23 AS base
LABEL maintainer=henri@dhcpy6d.de

# just updare
RUN apk update &&\
    apk upgrade --no-cache

# install dependencies for runtime - also needed for build,
# but build will add some more which are not needed in runtime
RUN apk add --no-cache python3 \
                       py3-distro \
                       py3-dnspython \
                       py3-mysqlclient \
                       py3-psycopg2

# use base image for build stage
FROM base AS build

# default version, can be overridden at build time
ARG VERSION=1.6.0

# extra packages for bild
RUN apk add --no-cache git \
                       py3-setuptools

# clone the source code, checkout the specified version and install it
RUN git clone https://github.com/HenriWahl/dhcpy6d.git /tmp/dhcpy6d
WORKDIR /tmp/dhcpy6d
RUN git checkout v${VERSION} &&\
    python setup.py install

# remove unneeded packages for runtime, because in final stage we will
# copy the whole site-packages directory where setuptools also reside
RUN apk del py3-setuptools

# final stage for runtime
FROM base

# copy all needed files from build stage to runtime stage
# skipping docs and manpages
COPY --from=build /etc/dhcpy6d.conf /etc/dhcpy6d.conf
COPY --from=build /usr/sbin/dhcpy6d /usr/sbin/dhcpy6d
COPY --from=build /usr/lib/python3.12/site-packages /usr/lib/python3.12/site-packages
COPY --from=build /var/lib/dhcpy6d /var/lib/dhcpy6d
COPY --from=build /var/log/dhcpy6d.log /var/log/dhcpy6d.log

# add group and user
RUN addgroup -S dhcpy6d &&\
    adduser -S dhcpy6d -G dhcpy6d
# set user and group permissions
RUN chown -R dhcpy6d:dhcpy6d /var/lib/dhcpy6d &&\
    chown -R dhcpy6d:dhcpy6d /var/log/dhcpy6d.log

COPY ./docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
