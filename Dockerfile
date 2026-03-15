FROM python:3.14-alpine AS build
LABEL maintainer=henri@dhcpy6d.de

ARG VERSION=1.6.0

RUN apk update &&\
    apk upgrade --no-cache
#
#RUN apt -y update && \
#    apt -y upgrade


#RUN apk add --no-cache git \
#                       mariadb-dev \
#                       postgresql18-dev

RUN apk add --no-cache git \
                       py3-distro \
                       py3-dnspython \
                       py3-mysqlclient \
                       py3-psycopg2 \
                       py3-setuptools

RUN git clone https://github.com/HenriWahl/dhcpy6d.git /tmp/dhcpy6d
WORKDIR /tmp/dhcpy6d
RUN git checkout v${VERSION} &&\
    python setup.py install

RUN useradd --system --user-group dhcpy6d

COPY ./docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

WORKDIR /dhcpy6d

ENTRYPOINT ["/docker-entrypoint.sh"]
