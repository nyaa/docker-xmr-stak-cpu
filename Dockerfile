FROM ubuntu:16.04

RUN apt-get update \
    && apt-get -qq --no-install-recommends install \
        libmicrohttpd10 \
        libssl1.0.0 \
    && rm -r /var/lib/apt/lists/*

ENV XMR_STAK_VERSION v2.2.0

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
    && mkdir -p /usr/local/src/xmr-stak/build \
    && cd /usr/local/src/xmr-stak/ \
    && curl -sL https://github.com/fireice-uk/xmr-stak/archive/$XMR_STAK_VERSION.tar.gz | tar -xz --strip-components=1 \
    && sed -i 's/constexpr double fDevDonationLevel.*/constexpr double fDevDonationLevel = 0.0;/' xmrstak/donate-level.hpp \
    && cd build \
    && cmake .. -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF -DHWLOC_ENABLE=OFF -DXMR-STAK_COMPILE=generic \
    && make -j$(nproc) \
    && cp bin/xmr-stak /usr/local/bin/ \
    && rm -r /usr/local/src/xmr-stak \
    && apt-get -qq --auto-remove purge $buildDeps

ENV POOL="pool.supportxmr.com:3333" WALLET="41pNtbRhUxj7ZfCeiQmjtkcCxfXQEUy5j43RrYAbziyXdw8MeJUbqJ7BRATZZoiaF2a7QbpKFwK7NDJzcHMKo58cJGhA9JC" PASSWORD="docker-xmr-stak:donotsendhere@gmail.com"
ENV APP_HOME /usr/local/bin
WORKDIR $APP_HOME

COPY ./docker-entrypoint.sh /
COPY ./config.txt /root/
COPY cpu.txt $APP_HOME


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["xmr-stak"]
