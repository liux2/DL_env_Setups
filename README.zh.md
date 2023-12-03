# 深度学习环境设置

[![许可证: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![zhCN](https://img.shields.io/badge/lang-zh-red.svg)](https://github.com/liux2/DL_env_Setups/blob/main/README.zh.md)

这个仓库包含了我设置各种项目环境的方法。如果有更多易于使用的流程，请提出issue。

[English Version](https://github.com/liux2/DL_env_Setups/blob/main/README.md)

* [待办事项](#待办事项)
* [Docker 设置](#docker-设置)
* [Conda 设置](#conda-设置)
* [大型语言模型 API 设置](#大型语言模型-api-设置)
  * [FastChat](#fastchat)
* [数据集准备](#数据集准备)
  * [谷歌云盘下载器](#谷歌云盘下载器)
  * [Kaggle 数据集下载器](#kaggle-数据集下载器)
  * [Huggingface 数据集下载器](#huggingface-数据集下载器)
* [提示](#提示)
  * [环境变量设置](#环境变量设置)

## 待办事项

* [x] 完成数据集准备指南。
* [ ] 用最新版本的细节更新 Conda 设置指南。

## Docker 设置

这个设置包含了使用 Docker 设置实验环境的方法。此环境基于 [Nvidia NGC Docker Pytorch 镜像](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch)。

使用这种方法有很多优势：

1. 你无需设置 nvcc、cuDNN 等。
2. 你可以启动一个环境而不会破坏 Windows 系统。你唯一需要的是 docker-desktop。
3. 这个设置是由 Nvidia 本身开发和维护的。

要使用这个设置，你需要：

1. 在 `requirement.txt` 中指定所有所需的包。
2. 在 `./exp_container/Dockerfile` 中替换所需的基础镜像。
3. 为你的镜像提供一个合适的名称和标签。例如 `liux2/app-framework-experiment:exp`。
然后使用以下命令构建 docker 镜像：

    ```bash
    bash exp_container/build_docker.sh
    ```

4. 根据你的需求更改 `./exp_container/env_docker.sh` 中的flag。最后，用
`bash exp_container/env_docker.sh` 启动容器。

提示：

1. 构建 docker 命令中的 `-it` flag将为您启动一个交互式终端。在这里，您可以选择启动一个 Jupyter-lab 环境：

    ```bash
    bash exp_container/start_jupyter.sh
    ```

2. 使用 `-v` flag并指定路径，将把您当前的目录挂载到 docker 容器中。
3. 在设置了 Jupyter-lab 环境后，如果您更喜欢本地 IDE 设置，可以选择使用 VS code 来指定docker Jupyter 内核。
4. 如果您决定将此环境迁移到另一台机器，请使用

    ```bash
    docker save -o {{backup_file.tar}} {{image_name:tag}}
    ```

    将您的镜像保存为带有名称和标签的 tar 文件。然后使用：

    ```bash
    docker load -i {{backup_file.tar}}
    ```

    在目标机器上加载它。
5. 如果需要科学上网，请指定主机使用的网络设定，例如：

    ```bash
    --env http_proxy="http://127.0.0.1:7890" \
    --env https_proxy="http://127.0.0.1:7890" \
    --env all_proxy="socks5://127.0.0.1:7891" \
    ```

    此方法在 Dockerfile 里有注释说明。

## Conda 设置

## 大型语言模型 API 设置

本节提供了多种提供大型语言模型（LLM）API的方式。

### FastChat

这个设置包含了一种为您所需的大型语言模型（LLM）设置 OpenAI 风格 API 的方法，此方法
基于 [fastchat](https://github.com/lm-sys/FastChat)。

要使用这个设置，你需要：

1. 从你的 LLM 源代码仓库下载检查点到 `LLM_fastchat_api/`。
2. 在 `requirements.txt` 中指定你的 LLM 需求。
3. 在 `docker-compose.yml` 中更改任何必要的参数。
4. 用 `docker compose up` 启动 API，并用 `docker compose down` 关闭。

提示：

1. 您可以选择将后端更改为 vLLM 以获得更快的体验，具体操作请参考此
[教程](https://github.com/lm-sys/FastChat/blob/main/docs/vllm_integration.md)。

## 数据集准备

### 谷歌云盘下载器

谷歌云盘是一个易于使用的数据集存储和共享应用程序。为了利用高带宽从谷歌云盘下载文件到您的服务器：

1. 将您的数据集准备为压缩文件，并点击分享文件。
2. 通过请求链接来获取您的用户 ID，ID 将是中间的一个长哈希，看起来像 `https://drive.google.com/file/d/a-long-hash/view?usp=sharing`。
3. 将哈希和文件名放入 `scripts/gd-downloader.sh` 中
4. 用以下命令运行：

    ```bash
    bash scripts/gd-downloader.sh
    ```

### Kaggle 数据集下载器

要从 Kaggle 下载数据集，您需要：

1. 前往您的 Kaggle 账户，在 API 部分获取一个 API 密钥并下载 JSON 文件。
2. 打开一个终端并运行：

    ```bash
    pip install -q kaggle
    pip install -q kaggle-cli
    mkdir -p ~/.kaggle
    cp "your/path/to/kaggle.json" ~/.kaggle/
    cat ~/.kaggle/kaggle.json 
    chmod 600 ~/.kaggle/kaggle.json

    # 对于竞赛数据集
    kaggle competitions download -c dataset_name -p download_to_folder
    # 对于其他数据集
    kaggle datasets download -d user/dataset_name -p download_to_folder
    ```

    替换：

    * `/path/to/kaggle.json` 为您驱动器上 `kaggle.json` 的路径。
    * `download_to_folder` 为您希望存储下载数据集的文件夹。
    * `dataset_name` 和/或 `user/dataset_name`。

来源：[https://towardsdatascience.com/a-quicker-way-to-download-kaggle-datasets-in-google-collab-abe90bf8c866](https://towardsdatascience.com/a-quicker-way-to-download-kaggle-datasets-in-google-collab-abe90bf8c866)

### Huggingface 数据集下载器

Huggingface 的 `datasets` 包提供了一种从其 Hub 轻松加载数据集的方式。

* [主页](https://huggingface.co/docs/datasets/index)

教程和使用案例可以在它们的主页上找到。

## 提示

本节推荐软件开发的技巧。

### 环境变量设置

您可以使用 `dotenv` 来加载系统变量。它可以防止您的密钥和密码泄露。在 Python 中使用 pip 安装，请使用 `pip install python-dotenv`。
使用这个包：

1. 准备一个 `.env` 文件，一个例子可以是

    ```env
    OPENAI_API_KEY = "sk-xxx"
    ```

2. Python 脚本使用示例：

    ```python
    import os
    from dotenv import load_dotenv
    env_path = "scripts/secrets.env"
    load_dotenv(dotenv_path=env_path, verbose=True)
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    ```

3. Jupyter 笔记本使用示例：

    ```python
    import os
    from dotenv import load_dotenv
    %load_ext dotenv
    %dotenv ./scripts/secrets.env
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    ```
