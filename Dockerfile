FROM debian:squeeze

ENV VERSION="2.1"

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  echo 'Acquire::Check-Valid-Until "false";' >/etc/apt/apt.conf.d/90ignore-release-date && \
  echo "deb http://archive.debian.org/debian-archive/debian/ squeeze main contrib" > /etc/apt/sources.list && \
  echo "deb http://archive.debian.org/debian-archive/debian/ squeeze-lts main contrib" >> /etc/apt/sources.list && \
  apt-get update && apt-get -y install curl apt-transport-https && \
  curl -k -s https://repo.varnish-cache.org/GPG-key.txt | apt-key add - && \
  echo "deb https://repo.varnish-cache.org/debian squeeze varnish-${VERSION}" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y install varnish && \
  rm -rf /var/lib/apt/lists/*

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV STORAGE_BACKEND malloc
ENV CACHE_SIZE      64m
ENV TELNET_PORT	    6082
ENV LISTEN_PORT	    6086
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600

EXPOSE 6086

COPY start.sh /start.sh
CMD ["/start.sh"]
