#!/bin/bash


[[ "${DOWNLOAD_MODELS}" == "true" ]] && /app/loadData.sh

/app/webui-docker.sh $COMMAND_LINE_ARGS