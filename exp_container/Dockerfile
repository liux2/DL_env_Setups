FROM nvcr.io/nvidia/pytorch:23.06-py3
RUN pip install --upgrade pip
RUN pip install git+https://github.com/huggingface/transformers

#RUN apt update && apt install -y --no-install-recommends \

COPY requirements.txt ./
RUN pip install -r /requirements.txt
