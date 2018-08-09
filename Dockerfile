FROM ubuntu:18.04

RUN apt-get -qq update && apt-get -y install libmicrohttpd-dev libssl-dev libhwloc-dev && rm -r /var/lib/apt/lists/*

ENV XMR_STAK_VERSION 2.4.7

RUN set -x && \
buildDeps='cmake build-essential curl wget' && \
apt-get -qq update && \
apt-get -qq --no-install-recommends install -y $buildDeps && \
rm -rf /var/lib/apt/lists/* && \
mkdir -p /usr/local/src/xmr-stak/build && \
cd /usr/local/src/xmr-stak/ && \
wget --no-check-certificate https://github.com/fireice-uk/xmr-stak/archive/$XMR_STAK_VERSION.tar.gz && \
tar --strip-components=1 -zxf $XMR_STAK_VERSION.tar.gz && \
rm *.tar.gz && \
sed -i 's/constexpr double fDevDonationLevel.*/constexpr double fDevDonationLevel = 0.0;/' xmrstak/donate-level.hpp && \
cd build && \
cmake .. -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF && \
make -j$(nproc) && \
cp bin/xmr-stak /usr/local/bin/ && \
rm -r /usr/local/src/xmr-stak && \
apt-get -qq --auto-remove purge $buildDeps

ENV POOL="pool.supportxmr.com:3333" WALLET="41pNtbRhUxj7ZfCeiQmjtkcCxfXQEUy5j43RrYAbziyXdw8MeJUbqJ7BRATZZoiaF2a7QbpKFwK7NDJzcHMKo58cJGhA9JC" PASSWORD="docker-xmr-stak:donotsendhere@gmail.com" NICEHASH_NONCE="false" CURRENCY=cryptonight_v7
ENV APP_HOME /usr/local/bin
WORKDIR $APP_HOME

COPY ./docker-entrypoint.sh /
COPY ./config.txt $APP_HOME
COPY ./cpu.txt $APP_HOME
COPY ./pools.txt /root/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["xmr-stak"]
