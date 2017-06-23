# What is XMR-Stak-CPU?

XMR-Stak-CPU is a universal Stratum pool miner. This is the CPU-mining version.

## Links

- [Discussion](https://www.reddit.com/r/Monero/comments/5lsfgt/xmrstakcpu_high_performance_open_source_miner/)
- [Source Code](https://github.com/fireice-uk/xmr-stak-cpu)
- [Dockerfile](https://github.com/minecoins/docker-xmr-stak-cpu)

# How to use this image

## Running

Run in background:

```console
docker run --privileged -itd --name xmr-stak-cpu -e "POOL=xmr.mypool.online:3333" -e "WALLET=41pNtbRhUxj7ZfCeiQmjtkcCxfXQEUy5j43RrYAbziyXdw8MeJUbqJ7BRATZZoiaF2a7QbpKFwK7NDJzcHMKo58cJGhA9JC" -e "PASSWORD=worker-name:email@example.com" nyaa/xmr-stak-cpu
```

Use `--privileged` option for large pages support. Large pages need a properly set up OS.

Fetch logs of a container:

```console
$ docker logs xmr-stak-cpu
```

Attach:

```console
$ docker attach xmr-stak-cpu
```

# Donations

Donations for work on dockerizing are accepted at:

- BTC: `1Mrm6SkfeQ9Jri41iEerSVqMN5qbdmtzPb`
- XMR: `41pNtbRhUxj7ZfCeiQmjtkcCxfXQEUy5j43RrYAbziyXdw8MeJUbqJ7BRATZZoiaF2a7QbpKFwK7NDJzcHMKo58cJGhA9JC`
