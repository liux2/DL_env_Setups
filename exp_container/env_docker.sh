#!/bin/bash

# The following options are two different network options
# for the following docker command
# It runs docker image with repo attached
# flag option 1: use host network and proxy to download
# --net=host -it --rm \
# --env http_proxy="http://127.0.0.1:7890" \
# --env https_proxy="http://127.0.0.1:7890" \
# --env all_proxy="socks5://127.0.0.1:7891" \
# option 2: production deploy
# --restart always --detach \
# another host:
# --net=chatglm3_api_default -it --rm \


docker run --gpus all --ipc=host -p 8888:8888 \
    -it --rm \
    --ulimit nofile=65535:65535 --ulimit nproc=65535:65535 \
    -v "$PWD":/workspace liux2/app-framework-experiment:exp
