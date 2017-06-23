#!/bin/bash
set -e

if [ ! -f /usr/local/etc/config.txt ]; then
  echo "Generating default /usr/local/etc/config.txt"
  if [[ $POOL =~ .*nicehash.com.* ]]; then
    echo "Nicehash pool, set nicehash_nonce to true"
    NICEHASH_NONCE=true
  else
    NICEHASH_NONCE=false
  fi
  sed -r \
    -e "s/^(\"pool_address\" : ).*,/\1\"$POOL\",/" \
    -e "s/^(\"wallet_address\" : ).*,/\1\"$WALLET\",/" \
    -e "s/^(\"pool_password\" : ).*,/\1\"$PASSWORD\",/" \
    -e "s/^(\"nicehash_nonce\" : ).*,/\1$NICEHASH_NONCE,/" \
    -e "s/^null/[\nREPLACE\n]/" \
    /root/config.txt > /usr/local/etc/config.txt
    if [ -z "${CORES}" ]; then
      CORES=`grep -c processor /proc/cpuinfo`
    fi
    echo "Set $CORES threads"
    REPLACE=""
    for ((n=0;n<CORES;n++))
    do
      REPLACE+="{ \"low_power_mode\" : false, \"no_prefetch\" : true, \"affine_to_cpu\" : $n },\n"
    done
    sed -i -e "s/REPLACE/$REPLACE/" /usr/local/etc/config.txt
fi

exec "$@"
