FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y language-pack-ja
ENV LANG ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8

RUN mkdir -p /docker_build/base/
ADD base.sh /docker_build/base/
ADD id_rsa.pub /docker_build/base/

RUN /bin/bash /docker_build/base/base.sh

CMD ["/usr/local/bin/supervisord"]
