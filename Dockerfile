FROM python:3.7
LABEL maintainer=h.wahl@ifw-dresden.de

ARG VERSION=1.0

RUN apt -y update &&\
    apt -y upgrade &&\
    apt -y install git

RUN pip install distro \
                dnspython \
                mysqlclient \
                psycopg2

RUN cd /tmp && git clone https://github.com/HenriWahl/dhcpy6d.git
RUN cd /tmp/dhcpy6d &&\
    git checkout v${VERSION} &&\
    python ./setup.py install

RUN useradd --system --user-group dhcpy6d

WORKDIR /dhcpy6d

CMD dhcpy6d --config dhcpy6d.conf --user dhcpy6d --group dhcpy6d
