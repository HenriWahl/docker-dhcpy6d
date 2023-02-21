FROM python:3.9-slim
LABEL maintainer=henri@dhcpy6d.de

ARG VERSION=1.2.3
RUN apt -y update && \
    apt -y upgrade
RUN apt -y install gcc \
                   git \
                   libmariadb-dev-compat \
                   libpq-dev

RUN pip install distro \
                dnspython \
                mysqlclient \
                psycopg2

RUN cd /tmp && \
    git clone https://github.com/HenriWahl/dhcpy6d.git
RUN cd /tmp/dhcpy6d && \
    git checkout v${VERSION} && \
    python ./setup.py install

# cleaning unneeded packages
RUN rm -rf /tmp/dhcpy6d
RUN apt -y purge gcc \
                 git \
                 libmariadb-dev-compat \
                 libpq-dev
RUN apt -y autoremove

RUN useradd --system --user-group dhcpy6d

COPY ./docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

WORKDIR /dhcpy6d

ENTRYPOINT ["/docker-entrypoint.sh"]
