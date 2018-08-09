#!/bin/bash
set -e

if [ ! -f /usr/local/bin/pools.txt ]; then
  echo "Generating default /usr/local/bin/pools.txt"

  sed -r \
    -e "s/POOL/$POOL/" \
    -e "s/WALLET/$WALLET/" \
    -e "s/PASSWORD/$PASSWORD/" \
    -e "s/NICEHASH_NONCE/$NICEHASH_NONCE/" \
    -e "s/CURRENCY/$CURRENCY/" \
    /root/pools.txt > /usr/local/bin/pools.txt
  if [ -z "${CORES}" ]; then
    CORES=`grep -c processor /proc/cpuinfo`
  fi
  echo "Set $CORES threads"
  REPLACE=""
  for ((n=0;n<CORES;n++))
  do
    REPLACE+="{ \"low_power_mode\" : false, \"no_prefetch\" : true, \"affine_to_cpu\" : $n },\n"
  done
  sed -i -e "s/CPU/$REPLACE/" /usr/local/bin/cpu.txt
fi

exec "$@"
