#!/bin/bash

mkdir -p /app/extensions/sd-webui-controlnet/models/
mkdir -p /app/models/Stable-diffusion/

echo "Token: "$HUGGINGFACE_TOKEN

if [ ! -f /app/models/Stable-diffusion/LoDi_Sports_v1_sd15_noema_fp16.safetensors ]; then
  wget --header="Authorization: Bearer $HUGGINGFACE_TOKEN" https://huggingface.co/Artifice-ArtHouse/LoDi_Sports/resolve/main/LoDi_Sports_v1_sd15_noema_fp16.safetensors -O /app/models/Stable-diffusion/LoDi_Sports_v1_sd15_noema_fp16.safetensors --content-disposition
fi

wget  https://huggingface.co/lllyasviel/ControlNet-v1-1/blob/main/control_v11p_sd15_canny.pth -P /app/extensions/sd-webui-controlnet/models/  --content-disposition
wget  https://huggingface.co/lllyasviel/ControlNet-v1-1/blob/main/control_v11p_sd15_canny.yaml -P /app/extensions/sd-webui-controlnet/models/  --content-disposition

wget  https://huggingface.co/lllyasviel/ControlNet-v1-1/blob/main/control_v11p_sd15_scribble.pth -P /app/extensions/sd-webui-controlnet/models/  --content-disposition
wget  https://huggingface.co/lllyasviel/ControlNet-v1-1/blob/main/control_v11p_sd15_scribble.yaml -P /app/extensions/sd-webui-controlnet/models/  --content-disposition

if [ ! -f /app/models/Stable-diffusion/3dmodel2_6624.safetensors ]; then
  wget --header="Authorization: Bearer $HUGGINGFACE_TOKEN" https://huggingface.co/Artifice-ArtHouse/3dlook.v1.0/resolve/main/3dmodel2_6624.safetensors -O /app/models/Stable-diffusion/3dmodel2_6624.safetensors --content-disposition
fi

if [ ! -f /app/models/Stable-diffusion/3dmodel2_6624.yaml ]; then
  wget --header="Authorization: Bearer $HUGGINGFACE_TOKEN" https://huggingface.co/Artifice-ArtHouse/3dlook.v1.0/resolve/main/3dmodel2_6624.yaml -O /app/models/Stable-diffusion/3dmodel2_6624.yaml --content-disposition
fi