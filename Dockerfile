FROM ubuntu:trusty
MAINTAINER Radiilabs <sales4radii@gmail.com>

ARG GITHUB_TOKEN

ENV REPO "radii1web/pagekit"
ENV FILE "pagekit.zip"
ENV VERSION "v0.0.1"   
RUN apt-get update && \
    apt-get -y install \
    nginx \
    unzip \
    wget \
    ca-certificates \
    php5 php5-fpm php5-cli php5-json php5-mysql php5-curl 

ENV PAGEKIT_VERSION 1.18.3
RUN mkdir /pagekit
WORKDIR /pagekit
VOLUME ["/pagekit/storage", "/pagekit/app/cache"]


RUN wget https://github.com/radii1web/pagekit/releases/download/$PAGEKIT_VERSION/pagekit-$PAGEKIT_VERSION.zip -O /pagekit/pagekit.zip && \
    unzip /pagekit/pagekit.zip && rm /pagekit/pagekit.zip
ADD nginx.conf /etc/nginx/nginx.conf

RUN chown -R www-data: /pagekit && \
    apt-get autoremove wget unzip -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["sh", "-c", "service php5-fpm start && nginx"]
