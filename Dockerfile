FROM ubuntu:16.04

RUN apt-get update \
    && apt-get -qq --no-install-recommends install \
        libmicrohttpd10 \
        libssl1.0.0 \
    && rm -r /var/lib/apt/lists/*

ENV XMR_STAK_CPU_VERSION v1.2.0-1.4.1

RUN set -x \
    && buildDeps=' \
        ca-certificates \
        cmake \
        curl \
        g++ \
        libmicrohttpd-dev \
        libssl-dev \
        make \
    ' \
    && apt-get -qq update \
    && apt-get -qq --no-install-recommends install $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    \
    && mkdir -p /usr/local/src/xmr-stak-cpu/build \
    && cd /usr/local/src/xmr-stak-cpu/ \
    && curl -sL https://github.com/fireice-uk/xmr-stak-cpu/archive/$XMR_STAK_CPU_VERSION.tar.gz | tar -xz --strip-components=1 \
    && sed -i 's/constexpr double fDevDonationLevel.*/constexpr double fDevDonationLevel = 0.0;/' donate-level.h \
    && cd build \
    && cmake .. \
    && make -j$(nproc) \
    && cp bin/xmr-stak-cpu /usr/local/bin/ \
    && cp ../config.txt /root/ \
    && rm -r /usr/local/src/xmr-stak-cpu \
    && apt-get -qq --auto-remove purge $buildDeps

ENV POOL="xmr.mypool.online:3333" WALLET="41pNtbRhUxj7ZfCeiQmjtkcCxfXQEUy5j43RrYAbziyXdw8MeJUbqJ7BRATZZoiaF2a7QbpKFwK7NDJzcHMKo58cJGhA9JC" PASSWORD="docker-xmr-stak-cpu:donotsendhere@gmail.com"

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["xmr-stak-cpu", "/usr/local/etc/config.txt"]
