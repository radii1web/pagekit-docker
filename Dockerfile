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

ENV PAGEKIT_VERSION 1.0.2
RUN mkdir /pagekit
WORKDIR /pagekit
VOLUME ["/pagekit/storage", "/pagekit/app/cache"]



RUN wget -q --auth-no-challenge --header='Accept:application/octet-stream' \
  https://$GITHUB_TOKEN:@api.github.com/repos/$REPO/releases/assets/`curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3.raw"  -s https://api.github.com/repos/$REPO/releases/download/$PAGEKIT_VERSION/pagekit-$PAGEKIT_VERSION.zip | jq ". | map(select(.tag_name == \"$VERSION\"))[0].assets | map(select(.name == \"$FILE\"))[0].id"` \
  -O /pagekit/$FILE && \
    unzip /pagekit/$FILE && rm /pagekit/$FILE
ADD nginx.conf /etc/nginx/nginx.conf

RUN chown -R www-data: /pagekit && \
    apt-get autoremove wget unzip -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["sh", "-c", "service php5-fpm start && nginx"]
