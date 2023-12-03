# Deep Learning Environment Setups

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![enUS](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/liux2/DL_env_Setups/blob/main/README.md)
[![zhCN](https://img.shields.io/badge/lang-zh-red.svg)](https://github.com/liux2/DL_env_Setups/blob/main/README.zh.md)

This repo contains my ways of setting up various project environment setups.
Please suggest more easy-to-use piplines and DL dev tips.

* [中文](https://github.com/liux2/DL_env_Setups/blob/main/README.zh.md)

* [TODO](#todo)
* [Docker Setups](#docker-setups)
* [Conda Setups](#conda-setups)
* [LLM API Setups](#llm-api-setups)
  * [FastChat](#fastchat)
* [Dataset Preparation](#dataset-preparation)
  * [Google Drive Downloader](#google-drive-downloader)
  * [Kaggle Dataset Downloader](#kaggle-dataset-downloader)
  * [Huggingface Dataset Downloader](#huggingface-dataset-downloader)
* [Tips](#tips)
  * [Environmental Variable Setups](#environmental-variable-setups)

## TODO

* [x] Add Kaggle downloader for opensource datasets downloading.
* [ ] Add conda setups.

## Docker Setups

This setup contains a way of setting up an exprimenting env with docker.
The environment was based on [Nvidia NGC Docker Pytorch images](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch).

There are many advantages of using this method:

1. You don't have to setup nvcc, cuDNN, etc.
2. You can fire up an env without messing up the Windows system. The only
thing you need is docker-desktop.
3. This setup is developed and maintained by Nvidia themselves.

The only thing you need is a proper Nvidia GPU driver, and nvidia-container-toolkit
based on you system setting. Here is a [guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
if you need to setup nvidia-container-toolkit in Linux.

To use this setup, you have to:

1. Specify all the required packages you need in the `requirement.txt`.
2. Replace the desired base image in `./exp_container/Dockerfile`.
3. Give a proper name and tag for your image. For example `liux2/app-framework-experiment:exp`.
And build the docker image with:

    ```bash
    bash exp_container/build_docker.sh
    ```

4. Change the flags in `./exp_container/env_docker.sh` based on your needs.
And finally, fire up the conatiner with `bash exp_container/env_docker.sh`.

Tips:

1. The `-it` flag in the build docker command will start an interactive terminal
for you. From here, you can choose to start a Jupyter-lab environment with:

    ```bash
    bash exp_container/start_jupyter.sh
    ```

2. The `-v` flag with the path specified
will attach your current dir into docker container.
3. After the Jupyter-lab env been setup, you can choose to use the Jupyter kernal
from VS code if you prefer local IDE setups.
4. If you decide to migrate this env to another machine, use

    ```bash
    docker save -o {{backup_file.tar}} {{image_name:tag}}
    ```

    to save your image to a tar file with name and tag preserved. And use:

    ```bash
    docker load -i {{backup_file.tar}}
    ```

    to load it on the target machine.

## Conda Setups

## LLM API Setups

This section provides various ways of serving LLM APIs.

### FastChat

This setup contains a way of setting up an OpenAI-style API for your desired LLM
based on [fastchat](https://github.com/lm-sys/FastChat).

To use this setup, you have to:

1. Download the checkpoints from your LLM source repo into `LLM_fastchat_api/`.
2. Specify your LLM requirements in `requirements.txt`.
3. Change any necessary params in the `docker-compose.yml`.
4. Fireup the API with `docker compose up` and shut it down with `docker compose down`.

Tips:

1. You can choose to change the backend to vLLM for faster experience with this
[tutorial](https://github.com/lm-sys/FastChat/blob/main/docs/vllm_integration.md).

## Dataset Preparation

### Google Drive Downloader

Google drive is an easy-to-use dataset storing and sharing application. To download files
from Goole drive to your server with exploiting the high bandwidth:

1. Prepare your dataset as a compressed file, and click share file.
2. Get your user id by requiring a Link, the id will be a long hash in the middle
that looks like `https://drive.google.com/file/d/a-long-hash/view?usp=sharing`.
3. Put the hash and the file name in the `scripts/gd-downloader.sh`
4. Run with:

    ```bash
    bash scripts/gd-downloader.sh
    ```

### Kaggle Dataset Downloader

To download datasets from Kaggle, you need to:

1. Go to your Kaggle account, get an API key in the API section. And download the JSON file.
2. Open a terminal and run:

    ```bash
    pip install -q kaggle
    pip install -q kaggle-cli
    mkdir -p ~/.kaggle
    cp "your/path/to/kaggle.json" ~/.kaggle/
    cat ~/.kaggle/kaggle.json 
    chmod 600 ~/.kaggle/kaggle.json

    # For competition datasets
        kaggle competitions download -c dataset_name -p download_to_folder
    # For other datasets
    kaggle datasets download -d user/dataset_name -p download_to_folder
    ```

    Replace:

    * your `/path/to/kaggle.json` with your path to `kaggle.json` on drive.
    * `download_to_folder` with the folder where you’d like to store the downloaded dataset.
    * `dataset_name` and/or `user/dataset_name`.

source: [https://towardsdatascience.com/a-quicker-way-to-download-kaggle-datasets-in-google-collab-abe90bf8c866](https://towardsdatascience.com/a-quicker-way-to-download-kaggle-datasets-in-google-collab-abe90bf8c866)

### Huggingface Dataset Downloader

Huggingface `datasets` package provides a way of loading datasets easily from their Hub.

* [Homepage](https://huggingface.co/docs/datasets/index)

The tutorials and use cases can be found from their homepage.

## Tips

This section recommends tips for software developing.

### Environmental Variable Setups

You can use `dotenv` to load system variables. It can protect your keys and passwords from
leaking. To install in Python with pip, use `pip install python-dotenv`.
To use this package:

1. Prepare an `.env` file, an example can be

    ```env
    OPENAI_API_KEY = "sk-xxx"
    ```

2. Example Python script usage:

    ```python
    import os
    from dotenv import load_dotenv
    env_path = "scripts/secrets.env"
    load_dotenv(dotenv_path=env_path, verbose=True)
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    ```

3. Example Jupyter Notebook usage:

    ```python
    import os
    from dotenv import load_dotenv
    %load_ext dotenv
    %dotenv ./scripts/secrets.env
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    ```
