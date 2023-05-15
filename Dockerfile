FROM python:3.10-slim

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt install fonts-dejavu-core rsync git jq moreutils aria2 -y && apt-get clean

RUN --mount=type=cache,target=/cache --mount=type=cache,target=/root/.cache/pip \
  aria2c -x 5 --dir /cache --out torch-2.0.0-cp310-cp310-linux_x86_64.whl -c \
  https://download.pytorch.org/whl/cu118/torch-2.0.0%2Bcu118-cp310-cp310-linux_x86_64.whl && \
  pip install /cache/torch-2.0.0-cp310-cp310-linux_x86_64.whl torchvision --index-url https://download.pytorch.org/whl/cu118


COPY . .

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

RUN chmod +x /app/*.sh

RUN useradd -rm -d /app/ -g root -G sudo -u 1001 stable-diffusion
USER stable-diffusion

EXPOSE 7860
ENTRYPOINT ["/app/entrypoint.sh"]
