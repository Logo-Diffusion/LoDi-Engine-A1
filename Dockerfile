FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

RUN apt update && \
    apt install --no-install-recommends -y build-essential software-properties-common libsndfile1 ffmpeg libpq-dev gcc mediainfo && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt install --no-install-recommends -y python3-distutils python3-pip python3-apt python3-dev python3.10 && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt install fonts-dejavu-core rsync git jq moreutils aria2 wget -y && apt-get clean

RUN --mount=type=cache,target=/cache --mount=type=cache,target=/root/.cache/pip \
  aria2c -x 5 --dir /cache --out torch-2.0.0-cp310-cp310-linux_x86_64.whl -c \
  https://download.pytorch.org/whl/cu118/torch-2.0.0%2Bcu118-cp310-cp310-linux_x86_64.whl && \
  pip install /cache/torch-2.0.0-cp310-cp310-linux_x86_64.whl torchvision --index-url https://download.pytorch.org/whl/cu118


COPY ./requirements_versions.txt ./requirements_versions.txt

RUN --mount=type=cache,target=/root/.cache/pip \
  pip install -r requirements_versions.txt

# RUN --mount=type=cache,target=/root/.cache/pip  \
#   --mount=type=bind,from=xformers,source=/wheel.whl,target=/xformers-0.0.20.dev528-cp310-cp310-manylinux2014_x86_64.whl \
#   pip install /xformers-0.0.20.dev528-cp310-cp310-manylinux2014_x86_64.whl

ENV ROOT=/app

RUN apt-get -y install libgoogle-perftools-dev && apt-get clean


ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all
ENV CLI_ARGS=""

ENV HUGGINGFACE_TOKEN ""
ENV GITHUB_TOKEN ""
ENV COMMAND_LINE_ARGS ""

COPY . .

RUN chmod +x /app/*.sh

RUN useradd -rm -d /app/ -g root -G sudo -u 1001 stable-diffusion

RUN chown stable-diffusion /app/ && \
    chown stable-diffusion /app/* && \
    chown stable-diffusion /app/**/*

USER stable-diffusion


EXPOSE 7860
ENTRYPOINT ["/app/entrypoint.sh"]
