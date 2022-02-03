# docker build -t trixing/pgpy/db .
#
FROM postgres:14

MAINTAINER Jan Dittmer <jdi@l4x.org>

RUN apt-get update 
RUN apt-get -y install python3 postgresql-plpython3-14 python3-requests

RUN  apt-get clean && \
     rm -rf /var/cache/apt/* /var/lib/apt/lists/*

COPY *.sh /docker-entrypoint-initdb.d/
