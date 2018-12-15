FROM alpine:3.8
LABEL maintainer="github.com/robertbeal"

ARG REVISION=c65ade889132cb7286fe03ccaef5b29c2f13ed21
ARG ID=3999
WORKDIR /app

RUN apk add --no-cache \
    git \
    python3 \
    su-exec \
  && python3 -m pip --no-cache-dir install --upgrade \
    pip \
    flickrapi==2.4.0 \
    python-dateutil \
  && git clone https://github.com/markdoliner/flickrmirrorer.git \
  && cd flickrmirrorer \
  && git checkout $REVISION \
  && apk del --purge git \
  && rm -rf /tmp/* \
  && addgroup -g $ID flickr \
  && adduser -s /bin/false -D -H -u $ID -G flickr flickr \
  && mkdir /config \
  && chown flickr:flickr /app /config \
  && chmod 500 /app /config

ENV HOME /config
VOLUME /config /data

COPY entrypoint.sh /usr/local/bin
RUN chmod 555 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
