# Deep Learning Environment Setups

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repo contains my ways of setting up various project environment setups.
Please suggest more easy-to-use piplines.

- [TODO](#todo)
- [Docker Setups](#docker-setups)
- [LLM API Setups](#llm-api-setups)
- [Google Drive Downloader](#google-drive-downloader)

## TODO

- [x] Add Google drive downloader for downloading data from Google drive.
- [ ] Add Kaggle/Huggingface downloader for opensource datasets downloading.
- [ ] Add conda setups.

## Docker Setups

This setup contains a way of setting up an exprimenting env with docker. The
environment was based on [Nvidia NGC Docker Pytorch images](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch).
The advantage of using this setup is that you don't have to setup nvcc, cuDNN,
etc. The only thing you need is a proper Nvidia GPU driver, and nvidia-container-toolkit
based on you system setting. Here is a [guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
if you need to setup nvidia-container-toolkit in Linux.

To use this setup, you have to:
1. Specify all the required packages you need in the `requirement.txt`.
2. Replace the desired base image in `./exp_container/Dockerfile`.
3. Give a proper name and tag for your image. For example `liux2/app-framework-experiment:exp`.
And build the docker image with `bash exp_container/build_docker.sh`.
4. Change the flags in `./exp_container/env_docker.sh` based on your needs.
And finally, fire up the conatiner with `bash exp_container/env_docker.sh`.

The `-it` flag in the build docker command will start an interactive terminal
for you. From here, you can choose to start a Jupyter-lab environment with
`bash exp_container/start_jupyter.sh`. The `-v` flag with the path specified
will attach your current dir into docker container.

After the Jupyter-lab env been setup, you can choose to use the Jupyter kernal
from VS code if you prefer local IDE setups.

## LLM API Setups

This setup contains a way of setting up an OpenAI-style API for your desired LLM
based on [fastchat](https://github.com/lm-sys/FastChat).

To use this setup, you have to:
1. Download the checkpoints from your LLM source repo into `LLM_fastchat_api/`.
2. Specify your LLM requirements in `requirements.txt`.
3. Change any necessary params in the `docker-compose.yml`.
4. Fireup the API with `docker compose up` and shut it down with `docker compose down`.

## Google Drive Downloader

Google drive is an easy-to-use dataset storing and sharing application. To download files
from Goole drive to your server with exploiting the high bandwidth:

1. Prepare your dataset as a compressed file, and click share file.
2. Get your user id by requiring a Link, the id will be a long hash in the middle
that looks like `https://drive.google.com/file/d/a-long-hash/view?usp=sharing`.
3. Put the hash and the file name in the `scripts/gd-downloader.sh`
4. Run with `bash scripts/gd-downloader.sh`.